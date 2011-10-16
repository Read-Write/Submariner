//
//  RDDarkITextFieldCell.m
//  Red
//
//  Created by Rafaël Warnault on 24/09/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "RDDarkTextFieldCell.h"

@implementation RDDarkTextFieldCell

static NSShadow *kShadow = nil;

+ (void)initialize
{
    kShadow = [[NSShadow alloc] init];
    [kShadow setShadowColor:[NSColor colorWithCalibratedWhite:0.0f alpha:1.0f]];
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
