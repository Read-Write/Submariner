//
//  RWPlayerSliderCell.m
//  Play
//
//  Created by nark on 12/02/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "SBPlayerSliderCell.h"
#import "NSGradient+SourceList.h"
#import "NSBezierPath+PXRoundedRectangleAdditions.h"

@implementation SBPlayerSliderCell


- (BOOL)_usesCustomTrackImage
{
	return YES;
}


- (void)drawKnob:(NSRect)knobRect {
	
	if([self isEnabled]) {
		// resize knob
        knobRect.size.height = (knobRect.size.height/2)-2;
        knobRect.size.width = [self trackRect].size.width * [self intValue] / 100;
        knobRect.origin.x = [self trackRect].origin.x+2;
        knobRect.origin.y = (knobRect.origin.y+knobRect.size.height/2)+2;
        
		// draw knob
        if([NSApp isActive]) {
            [[NSColor grayColor] setStroke];
            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:knobRect cornerRadius:knobRect.size.width];
            [path stroke];

            NSGradient *gradient = [NSGradient sourceListSelectionGradient:[NSApp isActive]];
            
            [gradient drawInBezierPath:path angle:90];
            
            [[NSColor colorWithDeviceWhite:1.0f alpha:0.05f] setStroke];
            [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(knobRect, 2.5f, 2.5f) 
                                             xRadius:knobRect.size.width 
                                             yRadius:knobRect.size.width] stroke];
            
        } else {
            [[NSColor grayColor] setStroke];
            NSBezierPath *path = [NSBezierPath bezierPathWithRoundedRect:knobRect cornerRadius:knobRect.size.width];
            [path stroke];
            
            NSGradient *gradient = [NSGradient sourceListSelectionGradient:[NSApp isActive]];
            
            [gradient drawInBezierPath:path angle:90];
            
            [[NSColor colorWithDeviceWhite:1.0f alpha:0.05f] setStroke];
            [[NSBezierPath bezierPathWithRoundedRect:NSInsetRect(knobRect, 2.5f, 2.5f) 
                                             xRadius:knobRect.size.width 
                                             yRadius:knobRect.size.width] stroke];
        }
	}
}



-(NSRect)knobRectFlipped:(BOOL)flipped {
    
	return [super knobRectFlipped:flipped];
}



- (void)drawBarInside:(NSRect)frame flipped:(BOOL)flipped {
    
    frame.size.height = frame.size.height/2 +2;
    frame.origin.y = frame.origin.y + (frame.size.height/2) -2;
    
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
                                    [NSColor colorWithCalibratedWhite:0.5f alpha:1.0f], 0.0f,
                                    [NSColor colorWithCalibratedWhite:0.5f alpha:1.0f], 0.8f,
                                    [NSColor colorWithCalibratedWhite:0.5f alpha:1.0f], 1.0f, 
                                    nil] autorelease];
		
		[backGradient drawInBezierPath:backPath angle:90];
		
		[[NSColor colorWithCalibratedWhite:0.75f alpha:1.0f] set];
		NSBezierPath *offsetPath = [NSBezierPath bezierPathWithRoundedRect:NSOffsetRect(frame, 0, 0) cornerRadius:frame.size.width];
		[offsetPath stroke];
    }

}
@end
