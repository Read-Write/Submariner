//
//  RWVolumeSlider.m
//  iPlay
//
//  Created by nark on 21/02/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

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
