//
//  DXShadowTextFieldCell.m
//  DicomX
//
//  Created by nark on 09/05/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBShadowTextFieldCell.h"


static NSShadow *kShadow = nil;


@implementation SBShadowTextFieldCell

+ (void)initialize
{
    kShadow = [[NSShadow alloc] init];
    [kShadow setShadowColor:[NSColor colorWithCalibratedWhite:0.80f alpha:1.0f]];
    [kShadow setShadowBlurRadius:0.f];
    [kShadow setShadowOffset:NSMakeSize(1.f, 1.f)];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [kShadow set];
    [super drawInteriorWithFrame:cellFrame inView:controlView];
}

@end
