//
//  FileManager.h
//  Domopult
//
//  Created by Nikolay Kagala on 17/05/16.
//  Update by Tabriz Dzhavadov on 06/07/16.
//  Copyright © 2016 sequenia. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^SQFileManagerSizeCompletion) (long long size, NSError* error);

typedef void(^SQFileManagerDownloadCompletion) (NSURL* fileURL, NSError* error);

typedef void(^SQFileManagerDownloadProgress) (float progress);

@interface SQFileManager : NSObject

@property (copy, nonatomic) SQFileManagerDownloadProgress progressBlock;

@property (strong, nonatomic) NSDictionary *customHTTPHeaders;

+ (instancetype) sharedManager;

- (BOOL) needShowAlert: (NSURL *) url;

- (void) downloadFile: (NSURL*) url
           completion: (SQFileManagerDownloadCompletion) completion;

- (void) downloadFile: (NSURL*) url
             fileName: (NSString*) fileName
           completion: (SQFileManagerDownloadCompletion) completion;

- (void) cancelDownloading;

- (void) getFileSize: (NSURL*) url
          completion: (SQFileManagerSizeCompletion) completion;

@end
