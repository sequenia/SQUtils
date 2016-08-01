//
//  FileViewer.h
//  Domopult
//
//  Created by Nikolay Kagala on 16/05/16.
//  Updated by Tabriz Dzhavadov on 06/07/16.
//  Copyright © 2016 sequenia. All rights reserved.
//
//    iWork documents
//
//    Microsoft Office documents (Office ‘97 and newer)
//
//    Rich Text Format (RTF) documents
//
//    PDF files
//
//    Images
//
//    Text files whose uniform type identifier (UTI) conforms to the public.text type (see Uniform Type Identifiers Reference)
//
//    Comma-separated value (csv) files

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "SQFileManager.h"
#import "SQAttachment.h"

@protocol SQFileViewerDelegate <NSObject>
@optional
- (void) fileDownloadedBy:(CGFloat) progress;
- (void) fileViewerDidDismiss;
@end

typedef void(^SQFileViewerCompletion)(UIViewController* fileViewerController, NSError* error);
typedef void(^SQFileViewerProgressCompletion)(CGFloat progress);

@interface SQFileViewer : NSObject

@property (copy, nonatomic) SQFileViewerCompletion completion;

@property id <SQFileViewerDelegate> delegate;

@property NSString *title;

@property NSString *cancel;

@property UIColor *preferredColor;

+ (SQFileViewer*) fileViewerWithFileAttachments: (NSArray<id<SQAttachment>>*) attachments
                                       delegate: (id <SQFileViewerDelegate>) delegate
                                 preferredColor: (UIColor *)color;

- (void) openFileAt:(NSInteger)index
         controller:(UIViewController *)controller
         downloaded: (SQFileViewerProgressCompletion) downloaded
         completion: (SQFileViewerCompletion) completion;

- (void) pauseDownloading;

- (SQFileManager*) fileManager;

- (BOOL)isFileExist: (id <SQAttachment>) file;

@end

@interface SQFileItem : NSObject <QLPreviewItem>

- (instancetype) initWithURL: (NSURL*) url;

@end
