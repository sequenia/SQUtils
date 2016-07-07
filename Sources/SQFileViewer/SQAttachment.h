//
//  SQAttachment.h
//  Pods
//
//  Created by Tabriz Dzhavadov on 06/07/16.
//
//

#import <Foundation/Foundation.h>
#import <QuickLook/QuickLook.h>

@protocol SQAttachment <NSObject>

@required

- (NSURL *) fileUrl;

- (NSString *) fileName;

- (void) setFileUrl: (NSURL *)url;

@end
