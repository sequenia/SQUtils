//
//  LocalizeHeader.h
//  PhotoTest
//
//  Created by Sequenia on 23/06/16.
//  Copyright © 2016 Sequenia. All rights reserved.
//

#ifndef LocalizeHeader_h
#define LocalizeHeader_h

#define LOCALIZE(key) [[NSBundle bundleForClass:[self class]] localizedStringForKey:(key) value:@"" table:@"SQPhotoPickeLocalize"]

#endif /* LocalizeHeader_h */
