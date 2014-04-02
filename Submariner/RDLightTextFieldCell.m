//
//  DXShadowTextFieldCell.m
//  DicomX
//
//  Created by nark on 09/05/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "RDLightTextFieldCell.h"


static NSShadow *kShadow = nil;


@implementation RDLightTextFieldCell

+ (void)initialize
{
    kShadow = [[NSShadow alloc] init];
    [kShadow setShadowColor:baseColor];
    [kShadow setShadowBlurRadius:0.f];
    [kShadow setShadowOffset:NSMakeSize(0.f, -1.f)];
}


@synthesize shadowColor;
@synthesize shadowRadius;


- (id)init {
    self = [super init];
    if (self) {
        [self setBackgroundStyle:NSBackgroundStyleRaised];
        shadowColor = [baseColor retain];
        shadowRadius = 0.0f;
    }
    return self;
}

- (void)dealloc {
    [shadowColor release];
    [super dealloc];
}

- (void)drawInteriorWithFrame:(NSRect)cellFrame inView:(NSView *)controlView
{
    [NSGraphicsContext saveGraphicsState];
    [kShadow setShadowColor:shadowColor];
    [kShadow setShadowBlurRadius:shadowRadius];
    [kShadow set];
    [super drawInteriorWithFrame:cellFrame inView:controlView];
    [NSGraphicsContext restoreGraphicsState];
}

@end
