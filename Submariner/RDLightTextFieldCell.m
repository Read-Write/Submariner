//
//  DXShadowTextFieldCell.m
//  DicomX
//
//  Created by nark on 09/05/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "RDLightTextFieldCell.h"


static NSShadow *kShadow = nil;


@implementation RDLightTextFieldCell

+ (void)initialize
{
    kShadow = [[NSShadow alloc] init];
    [kShadow setShadowColor:[NSColor colorWithCalibratedWhite:1.0f alpha:1.0f]];
    [kShadow setShadowBlurRadius:0.f];
    [kShadow setShadowOffset:NSMakeSize(0.f, -1.f)];
}

- (id)init {
    self = [super init];
    if (self) {
        [self setBackgroundStyle:NSBackgroundStyleRaised];
    }
    return self;
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [kShadow set];
    [super drawInteriorWithFrame:cellFrame inView:controlView];
}

@end
