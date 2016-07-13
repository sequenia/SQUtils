//
//  FileManager.m
//  Domopult
//
//  Created by Nikolay Kagala on 17/05/16.
//  Updated by Tabriz Dzhavadov on 06/07/16.
//  Copyright © 2016 sequenia. All rights reserved.
//

#import "SQFileManager.h"
#import "SQCategories.h"

static NSString* kDocsFolder = @"Documents";

static NSString* kUnclompetedDocsFolder = @"UncompletedDocuments";

@interface SQFileManager () <NSURLSessionDelegate>

@property (copy, nonatomic) SQFileManagerDownloadCompletion downloadCompletion;

@property (strong, nonatomic) NSURLSession* session;

@property (strong, nonatomic) NSURLSessionDownloadTask* downloadTask;

@end

@implementation SQFileManager

#pragma mark - Init

+ (instancetype) sharedManager {
    static SQFileManager* instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

- (instancetype) init {
    self = [super init];
    if (self) {
        NSURLSessionConfiguration* configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
        self.session = [NSURLSession sessionWithConfiguration: configuration
                                                     delegate: self
                                                delegateQueue: [NSOperationQueue mainQueue]];
    }
    return self;
}

#pragma mark - Helpers

- (BOOL) needShowAlert: (NSURL *) url {
    NSURL* existedFileURL = [self fileURLforURL: url];
    if (existedFileURL){
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - Downloading

- (void) downloadFile: (NSURL*) url
             fileName: (NSString*) fileName
           completion: (SQFileManagerDownloadCompletion) completion {
    
    NSURL *nsurl = ([url isKindOfClass:[NSURL class]]) ? url : [NSURL URLWithString:url];
    
    if (!nsurl) {
        if (completion) { completion(nil, [self validURL: nsurl]); }
        return;
    }
    NSURL* existedFileURL = [self fileURLforURL: nsurl];
    if (existedFileURL){
        if (completion) { completion(existedFileURL, nil); }
        return;
    }
    
    self.downloadCompletion = completion;
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: nsurl];
    NSData* resumeData = [self resumeDataForURL: nsurl];
    NSURLSessionDownloadTask* task = nil;
    if (resumeData){
        task = [self.session downloadTaskWithResumeData: resumeData];
    } else {
        task = [self.session downloadTaskWithRequest: request];
    }
    [task resume];
    self.downloadTask = task;
}

- (void) downloadFile: (NSURL*) url
           completion: (SQFileManagerDownloadCompletion) completion {
    [self downloadFile: url fileName: url.lastPathComponent
            completion: completion];
}

- (void) cancelDownloading {
    [self.downloadTask cancelByProducingResumeData:^(NSData * _Nullable resumeData) {
        NSURL* url = self.downloadTask.originalRequest.URL;
        [self saveResumeData: resumeData forURL: url];
    }];
}

#pragma mark - File size

- (void) getFileSize: (NSURL*) url
          completion: (SQFileManagerSizeCompletion) completion; {
    if (!url) {
        if (completion) { completion(0.0, [self validURL: url]); }
        return;
    }
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL: url];
    [request addValue:@"" forHTTPHeaderField:@"Accept-Encoding"];
    [request setHTTPMethod: @"HEAD"];
    
    [[self.session dataTaskWithRequest: request
                     completionHandler:
      ^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
#warning GET FILE SIZE - DOESN'T RETURN AN ACTUAL FILE SIZE / ASK ABOUT HEADER "Content-Length"
          long long size = [response expectedContentLength];
          if (completion) { completion(size, error); }
      }] resume];
}

#pragma mark - Validation

- (NSError*) validURL: (NSURL*) url {
    return url ? nil : [NSError applicationErrorWithDescription: @"The file url can't be nil"];
}

#pragma mark - NSURLSessionTaskDelegate

- (void)URLSession:(NSURLSession *)session
              task:(NSURLSessionTask *)task
didCompleteWithError:(nullable NSError *)error {
    if (!error){ return; }
    NSData* resumeData = error.userInfo[NSURLSessionDownloadTaskResumeData];
    [self saveResumeData: resumeData forURL: task.originalRequest.URL];
    if (self.downloadCompletion){
        self.downloadCompletion(nil, error);
    }
}

#pragma mark - NSURLSessionDownloadDelegate

- (void)URLSession:(NSURLSession *)session
      downloadTask:(NSURLSessionDownloadTask *)downloadTask
didFinishDownloadingToURL:(NSURL *)location {
    NSURL* fileURL = [self saveDocument: location
                                    url: downloadTask.originalRequest.URL];
    if (self.downloadCompletion){
        self.downloadCompletion(fileURL, nil);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
      didWriteData:(int64_t)bytesWritten
 totalBytesWritten:(int64_t)totalBytesWritten
totalBytesExpectedToWrite:(int64_t)totalBytesExpectedToWrite {
    float progress = (float)totalBytesWritten/totalBytesExpectedToWrite;
    if (self.progressBlock) {
        self.progressBlock(progress);
    }
}

- (void)URLSession:(NSURLSession *)session downloadTask:(NSURLSessionDownloadTask *)downloadTask
 didResumeAtOffset:(int64_t)fileOffset
expectedTotalBytes:(int64_t)expectedTotalBytes {
    NSLog(@"didResumeAtOffset: %2.f", (float)fileOffset/expectedTotalBytes);
}

#pragma mark - File managing

- (NSString*) directory {
    NSString *cacheDirectory = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    return cacheDirectory;
}

- (NSString*) directoryWithFolder: (NSString*) folder {
    NSString* directoryPath = [self.directory stringByAppendingPathComponent: folder];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    NSError* error = nil;
    if (![fileManager createDirectoryAtPath: directoryPath
                withIntermediateDirectories: YES
                                 attributes: nil
                                      error: &error]){
        NSLog(@"Create directory error: %@", error);
    }
    return directoryPath;
}

#pragma mark -- Resume data

- (NSString*) unclompetedDocsDirectory {
    return [self directoryWithFolder: kUnclompetedDocsFolder];
}

- (NSData*) resumeDataForURL: (NSURL*) url {
    NSString* item = url.lastPathComponent;
    if (!item) { return nil; }
    
    NSString* path = [self.unclompetedDocsDirectory stringByAppendingPathComponent: item];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath: path]){
        return nil;
    }
    
    NSURL* fileURL = [NSURL fileURLWithPath: path];
    NSError* error = nil;
    NSData* data = [NSData dataWithContentsOfURL: fileURL
                                         options: NSDataReadingMappedIfSafe
                                           error: &error];
    if (error){
        NSLog(@"Error reading file %@: %@", fileURL, error.localizedDescription);
    }
    return data;
}

- (BOOL) saveResumeData: (NSData*) data forURL: (NSURL*) url {
    NSString* item = url.lastPathComponent;
    if (!data || !item) { return NO; }
    
    NSString* path = [self.unclompetedDocsDirectory stringByAppendingPathComponent: item];
    BOOL success = [data writeToFile: path atomically: YES];
    if (!success){
        NSLog(@"Create file for resume data failed (url: %@)", url);
    }
    return success;
}

#pragma mark -- Documents

- (NSString*) docsDirectory {
    return [self directoryWithFolder: kDocsFolder];
}

- (NSURL*) saveDocument: (NSURL*) location url: (NSURL*) url {
    NSString* item = url.lastPathComponent;
    if (!location) { return nil; }
    
    NSString* path = [self.docsDirectory stringByAppendingPathComponent: item];
    NSError* error = nil;
    NSFileManager* fileManager = [NSFileManager defaultManager];
    BOOL success = [fileManager copyItemAtPath: location.path
                                        toPath: path
                                         error: &error];
    if (!success){
        NSLog(@"Saving file faled (url: %@): %@", url, error);
        return nil;
    } else {
        return [NSURL fileURLWithPath: path];
    }
}

- (NSURL*) fileURLforURL: (NSURL*) url {
    NSString* item = url.lastPathComponent;
    if (!item) { return nil; }
    
    NSURL* fileURL = nil;
    NSString* path = [self.docsDirectory stringByAppendingPathComponent: item];
    NSFileManager* fileManager = [NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath: path]){
        fileURL = [NSURL fileURLWithPath: path];
    }
    return fileURL;
}

@end