//
//  NSGradient+SourceList.m
//  Submariner
//
//  Created by Rafaël Warnault on 20/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "NSGradient+SourceList.h"

@implementation NSGradient (SourceList)

+ (NSGradient *)sourceListSelectionGradient:(BOOL)isKey {
    
    NSGradient *result = nil;
    
    if (isKey) {
        NSColor *topColor = [NSColor colorWithCalibratedRed:0.3452 green:0.6284 blue:0.8694 alpha:1.0000];
        NSColor *endColor = [NSColor colorWithCalibratedRed:0.1701 green:0.4463 blue:0.7877 alpha:1.0000];
        
        return [[[NSGradient alloc] initWithStartingColor:topColor endingColor:endColor] autorelease];
    }
    
    NSColor *topColor = [NSColor colorWithCalibratedRed:0.6850 green:0.7288 blue:0.8332 alpha:1.0000];
    NSColor *endColor = [NSColor colorWithCalibratedRed:0.5441 green:0.5949 blue:0.7257 alpha:1.0000];
    
    result = [[[NSGradient alloc] initWithStartingColor:topColor endingColor:endColor] autorelease];
    
    return result;
}

@end
