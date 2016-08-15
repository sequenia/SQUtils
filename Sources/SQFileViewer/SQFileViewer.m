//
//  FileViewer.m
//  Domopult
//
//  Created by Nikolay Kagala on 16/05/16.
//  Updated by Tabriz Dzhavadov on 06/07/16.
//  Copyright © 2016 sequenia. All rights reserved.
//

#import "SQFileViewer.h"
#import "SQCategories.h"

//static NSInteger kSmallFileSizeB = 1024 * 10;

@interface SQFileItem () <QLPreviewItem>

@property(readwrite, nonatomic) NSURL * previewItemURL;

@property(readwrite, nonatomic) NSString * previewItemTitle;

@end

@implementation SQFileItem

- (instancetype) initWithURL: (NSURL*) url {
    if (self = [super init]){
        self.previewItemURL = url;
    }
    return self;
}

- (NSURL *)previewItemURL {
    return ([_previewItemURL isKindOfClass:[NSURL class]]) ? _previewItemURL : [NSURL URLWithString:_previewItemURL];
}

@end

@interface SQFileViewer () <QLPreviewControllerDataSource, QLPreviewControllerDelegate>

@property (strong, nonatomic) NSArray<id <SQAttachment>>* attachments;

@property (strong, nonatomic) NSArray<SQFileItem*>* items;

@property (strong, nonatomic) QLPreviewController* previewController;

@property (strong, nonatomic) UIAlertController *alert;

@end

@implementation SQFileViewer

+ (void) initialize {
    if ([self class] == [SQFileViewer class]){
        
    }
}

#pragma mark - Init

+ (SQFileViewer*) fileViewerWithFileAttachments: (NSArray<id<SQAttachment>>*) attachments
                                       delegate: (id<SQFileViewerDelegate>)delegate
                                 preferredColor: (UIColor *)color {
    return [[self alloc] initWithAttachments: attachments
                                    delegate: delegate
                              preferredColor: color];
}

- (instancetype) initWithAttachments: (NSArray<id<SQAttachment>>*) attachments
                            delegate: (id<SQFileViewerDelegate>)delegate
                      preferredColor: (UIColor *)color {
    if (self = [super init]){
        self.delegate = delegate;
        self.attachments = attachments;
        self.preferredColor = color;
        [self commonInit];
    }
    return self;
}

- (void) commonInit {
    [self reloadItems: self.attachments];
    self.previewController = [[QLPreviewController alloc] init];
    self.previewController.dataSource = self;
    self.previewController.delegate = self;
    [[UINavigationBar appearanceWhenContainedIn: [QLPreviewController class], nil]
     setTintColor: [UIColor whiteColor]];
    [[UINavigationBar appearanceWhenContainedIn: [QLPreviewController class], nil]
     setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    [[UINavigationBar appearanceWhenContainedIn: [QLPreviewController class], nil]
     setBarStyle: UIStatusBarStyleLightContent];
}

- (void) reloadItems: (NSArray <id<SQAttachment>>*) attachments {
    self.items = [attachments sq_map:^SQFileItem*(id<SQAttachment> attachment) {
        
        SQFileItem* item = [[SQFileItem alloc] initWithURL: attachment.fileUrl];
        item.previewItemTitle = attachment.fileName;
        BOOL isFile = item.previewItemURL.isFileURL;
        BOOL can = [QLPreviewController canPreviewItem: item];
        
        if (can && isFile){
            return item;
        } else {
            return nil;
        }
    }];
    [self.previewController reloadData];
}

#pragma mark - Public

- (SQFileManager*) fileManager {
    return [SQFileManager sharedManager];
}

- (void) openFileAt:(NSInteger)index
         controller:(UIViewController *)controller
         downloaded: (SQFileViewerProgressCompletion) downloaded
         completion: (SQFileViewerCompletion) completion {
    [self openFileAtIndex: index
               controller: controller
               downloaded: downloaded
               completion: completion];
}

- (BOOL)isFileExist: (id <SQAttachment>) file {
    return ![self needShowAlert:[file fileUrl]];
}

#pragma mark - Private

- (void) openFileAtIndex: (NSInteger) index
              controller: (UIViewController *)controller
              downloaded: (SQFileViewerProgressCompletion) downloaded
              completion: (SQFileViewerCompletion) completion {
    id <SQAttachment> attachment = [self.attachments sq_objectAtIndexOrNil: index];
    
    if (!attachment){
        NSString* message = [NSString stringWithFormat: @"Can't find an attachment at index: %ld", index];
        if (completion) { completion(nil, [NSError applicationErrorWithDescription: message]); }
        return;
    }
    
    
    if (!self.delegate) {
        self.alert = [self alertController];
        if ([self needShowAlert:attachment.fileUrl])
            [controller presentViewController:self.alert animated:YES completion:nil];
    }
    
    [self.fileManager downloadFile: attachment.fileUrl
                          fileName: attachment.fileName
                        completion:^(NSURL *fileURL, NSError *error) {
                            
                            if (!completion) { return; }
                            if (fileURL){
                                attachment.fileUrl = fileURL;
                                [self reloadItems: @[attachment]];
                                completion(self.previewController, error);
                            } else {
                                completion(nil, error);
                            }
                            
                        }];
    
    self.fileManager.progressBlock = ^(float progress) {
        downloaded(progress);
        if (self.delegate) {
            if ([self.delegate respondsToSelector:@selector(fileDownloadedBy:)])
                [self.delegate fileDownloadedBy: progress];
        } else {
            self.alert.message = [NSString stringWithFormat:@"Loading... %.0f %%", progress * 100];
            if (progress >= 1.0f) {
                [self.alert dismissViewControllerAnimated:YES completion:nil];
            }
        }
    };
}

- (void) pauseDownloading {
    [self.fileManager cancelDownloading];
}

- (BOOL) needShowAlert:(NSURL *) url {
    return [self.fileManager needShowAlert:url];
}

- (UIAlertController *)alertController {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:(self.title) ? self.title : @"Please, wait..."
                                        message:@"Loading..."
                                 preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:(self.cancel) ? self.cancel : @"Cancel"
                                              style:UIAlertActionStyleCancel
                                            handler:^(UIAlertAction * _Nonnull action) {
                                                [self.fileManager cancelDownloading];
                                            }]];
    return alert;
}

#pragma mark - QLPreviewControllerDataSource

- (NSInteger)numberOfPreviewItemsInPreviewController:(QLPreviewController *)controller {
    return self.items.count;
}

- (id <QLPreviewItem>)previewController:(QLPreviewController *)controller previewItemAtIndex:(NSInteger)index {
    return [self.items sq_objectAtIndexOrNil: index];
}

#pragma mark - QLPreviewControllerDelegate
- (void) previewControllerDidDismiss:(QLPreviewController *)controller {
    if (self.delegate)
        [self.delegate fileViewerDidDismiss];
}

@end
