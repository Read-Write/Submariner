//
//  SBtopBorderView.m
//  Submariner
//
//  Created by Rafaël Warnault on 13/06/11.
//
//  Copyright (c) 2011-2014, Rafaël Warnault
//  All rights reserved.
//
//  Redistribution and use in source and binary forms, with or without
//  modification, are permitted provided that the following conditions are met:
//
//  * Redistributions of source code must retain the above copyright notice, this
//  list of conditions and the following disclaimer.
//
//  * Redistributions in binary form must reproduce the above copyright notice,
//  this list of conditions and the following disclaimer in the documentation
//  and/or other materials provided with the distribution.
//
//  * Neither the name of the Read-Write.fr nor the names of its
//  contributors may be used to endorse or promote products derived from
//  this software without specific prior written permission.
//
//  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
//  AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
//  IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
//  DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
//  FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
//  DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
//  SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
//  CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
//  OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
//  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

#import "SBTopBorderView.h"
#import "NSBezierPath+PXRoundedRectangleAdditions.h"

#define COLOR_KEY_START [NSColor colorWithDeviceRed:0.659 green:0.659 blue:0.659 alpha:1.00]
#define COLOR_KEY_END [NSColor colorWithDeviceRed:0.812 green:0.812 blue:0.812 alpha:1.00]
#define COLOR_KEY_BOTTOM [NSColor colorWithDeviceRed:0.318 green:0.318 blue:0.318 alpha:1.00]

#define COLOR_NOTKEY_START [NSColor colorWithDeviceRed:0.851 green:0.851 blue:0.851 alpha:1.00]
#define COLOR_NOTKEY_END [NSColor colorWithDeviceRed:0.929 green:0.929 blue:0.929 alpha:1.00]
#define COLOR_NOTKEY_BOTTOM [NSColor colorWithDeviceRed:0.600 green:0.600 blue:0.600 alpha:1.00]

#define CORNER_CLIP_RADIUS 4.0



@implementation SBTopBorderView

- (id)initWithFrame:(NSRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (void)drawRect:(NSRect)dirtyRect
{
    BOOL key = [[self window] isKeyWindow];
    NSRect drawingRect = [self bounds];
    drawingRect.size.height -= 1.0; // Decrease the height by 1.0px to show the highlight line at the top
    
    NSColor *startColor = key ? COLOR_KEY_START : COLOR_NOTKEY_START;
    NSColor *endColor = key ? COLOR_KEY_END : COLOR_NOTKEY_END;
    NSBezierPath *clipPath = [NSBezierPath bezierPathWithRoundedRect:drawingRect cornerRadius:CORNER_CLIP_RADIUS inCorners:(OSTopLeftCorner | OSTopRightCorner)];
    
    
    [NSGraphicsContext saveGraphicsState];
    [clipPath addClip];
    NSGradient *gradient = [[NSGradient alloc] initWithStartingColor:startColor endingColor:endColor];
    [gradient drawInRect:drawingRect angle:90];
    [NSGraphicsContext restoreGraphicsState];
    
    //NSColor *topColor = key ? COLOR_KEY_BOTTOM : COLOR_NOTKEY_BOTTOM;
    NSRect topRect = NSMakeRect(0.0, NSMaxY(drawingRect), NSWidth(drawingRect), 1.0);
    [[NSColor grayColor] setFill];
    NSRectFill(topRect);
    
    NSRect topHighlightRect = NSMakeRect(0.0, NSMaxY(drawingRect)-1, NSWidth(drawingRect), 1.0);
    [[NSColor colorWithDeviceWhite:0.9 alpha:1.0] setFill];
    NSRectFill(topHighlightRect);
}

@end
