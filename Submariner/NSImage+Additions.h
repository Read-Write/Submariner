//
//  NSImage+Additions.h
//  Submariner
//
//  Created by Rafaël Warnault on 11/12/11.
//  Copyright (c) 2011 OPALE. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSImage (Additions)

- (NSImage *)imageTintedWithColor:(NSColor *)tint;
- (NSImage*)imageCroppedToRect:(NSRect)rect;

@end
