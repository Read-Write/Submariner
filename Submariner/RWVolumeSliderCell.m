//
//  RWVolumeSlider.m
//  iPlay
//
//  Created by Rafaël Warnault on 21/02/11.
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

#import "RWVolumeSliderCell.h"
#import "NSBezierPath+PXRoundedRectangleAdditions.h"

@implementation RWVolumeSliderCell

- (BOOL)_usesCustomTrackImage
{
	return YES;
}

- (void)drawKnob:(NSRect)knobRect {
	
	if([self isEnabled]) {
		
		// resize knob
		knobRect.size.height = (knobRect.size.height/2);
		knobRect.size.width = (knobRect.size.width/2);
		// replace knob
		knobRect.origin.x = (knobRect.origin.x+knobRect.size.width/2);
		knobRect.origin.y = (knobRect.origin.y+knobRect.size.height/2);
		
		// draw knob
		NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:knobRect cornerRadius:knobRect.size.width];
		NSGradient *gradient = [[[NSGradient alloc] initWithColorsAndLocations:
                                 [NSColor colorWithCalibratedWhite:0.7f alpha:1.0f], 0.0f,
                                 [NSColor colorWithCalibratedWhite:0.6f alpha:1.0f], 1.0f, 
                                 nil] autorelease];
		
		[gradient drawInBezierPath:path angle:0];
	}
}

-(NSRect)knobRectFlipped:(BOOL)flipped
{
	return [super knobRectFlipped:flipped];
}


- (void)drawBarInside:(NSRect)frame flipped:(BOOL)flipped {
    
    frame.size.height = frame.size.height/2 +2;
    frame.origin.y = frame.origin.y + (frame.size.height/2) -2;
    
    frame.size.width -= 10;
    frame.origin.x += 5;
    
    NSBezierPath *backPath = [NSBezierPath bezierPathWithRoundedRect:frame cornerRadius:frame.size.width];
    
    if([NSApp isActive]) {
		NSGradient *backGradient = [[[NSGradient alloc] initWithColorsAndLocations:
									 [NSColor colorWithCalibratedWhite:0.1f alpha:1.0f], 0.0f,
                                     [NSColor colorWithCalibratedWhite:0.2f alpha:1.0f], 0.8f,
									 [NSColor darkGrayColor], 1.0f, 
									 nil] autorelease];
		
		[backGradient drawInBezierPath:backPath angle:90];
		
		[[NSColor colorWithCalibratedWhite:0.75f alpha:1.0f] set];
		NSBezierPath *offsetPath = [NSBezierPath bezierPathWithRoundedRect:NSOffsetRect(frame, 0, 0) cornerRadius:frame.size.width];
		[offsetPath stroke];
    } else {
        NSGradient *backGradient = [[[NSGradient alloc] initWithColorsAndLocations:
									 [NSColor colorWithCalibratedWhite:0.8f alpha:1.0f], 0.0f,
									 [NSColor lightGrayColor], 1.0f, 
									 nil] autorelease];
		
		[backGradient drawInBezierPath:backPath angle:90];
		
		[[NSColor colorWithCalibratedWhite:0.65f alpha:1.0f] set];
		NSBezierPath *offsetPath = [NSBezierPath bezierPathWithRoundedRect:NSOffsetRect(frame, 0, 0) cornerRadius:frame.size.width];
		[offsetPath stroke];
    }
    
}

@end
