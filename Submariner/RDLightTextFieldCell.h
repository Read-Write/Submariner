//
//  DXShadowTextFieldCell.h
//  DicomX
//
//  Created by nark on 09/05/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define baseColor [NSColor colorWithCalibratedWhite:1.0f alpha:1.0f]

@interface RDLightTextFieldCell : NSTextFieldCell {
@private
    NSColor *shadowColor;
    CGFloat  shadowRadius;
}

@property (readwrite, retain) NSColor *shadowColor;
@property (readwrite) CGFloat shadowRadius;

@end
