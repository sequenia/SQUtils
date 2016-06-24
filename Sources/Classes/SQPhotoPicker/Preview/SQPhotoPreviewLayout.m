//
//  SQPhotoPreviewLayout.m
//  PhotoTest
//
//  Created by Sequenia on 22/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#import "SQPhotoPreviewLayout.h"

@implementation SQPhotoPreviewLayout

- (id)init{
    self = [super init];
    if(self){
        [self initialize];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if(self){
        [self initialize];
    }
    return self;
}

- (void) initialize{
    self.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.minimumLineSpacing = 6;
    self.minimumInteritemSpacing = 6;
    self.sectionInset = UIEdgeInsetsMake(6, 6, 6, 6);
    
}

@end
