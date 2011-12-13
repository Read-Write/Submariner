//
//  DXSplitView.m
//  Sub
//
//  Created by nark on 14/05/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBSplitView.h"



@interface SBSplitView (Private) 
- (void)collapseViewAtIndex:(NSInteger)index;
- (void)uncollapseViewAtIndex:(NSInteger)index;
@end


@implementation SBSplitView





#pragma mark -
#pragma mark Action

- (void)toggleViewAtIndex:(NSInteger)index {
	BOOL rightViewCollapsed = [self isSubviewCollapsed:[[self subviews] objectAtIndex:index]];
	if (rightViewCollapsed) {
		[self uncollapseViewAtIndex:index];
	} else {
		[self collapseViewAtIndex:index];
	}
}






#pragma mark -
#pragma mark Private

- (void)collapseViewAtIndex:(NSInteger)index {
	NSView *right = [[self subviews] objectAtIndex:index];
	NSView *left  = [[self subviews] objectAtIndex:index-1];
    NSRect leftFrame = [left frame];
    NSRect rightFrame = [right frame];
        
    [right setHidden:YES];
    [left setFrameSize:NSMakeSize(leftFrame.size.width+[self dividerThickness]+rightFrame.size.width, 
                                  leftFrame.size.height)];
	[self display];
}


-(void)uncollapseViewAtIndex:(NSInteger)index {

    [self setPosition:[self frame].size.width-220 ofDividerAtIndex:index-1];
	[self display];
}





#pragma mark -
#pragma mark NSSplitView Overwrite

//- (CGFloat)dividerThickness {
//    return 1.0f;
//}

- (NSColor *)dividerColor {
    return [NSColor grayColor];
}


- (BOOL)mouseDownCanMoveWindow {
    return YES;
}

- (BOOL)acceptsFirstMouse:(NSEvent *)theEvent {
    return YES;
}



- (void)drawDividerInRect:(NSRect)aRect {
    [super drawDividerInRect:aRect];
    
//    if([self isVertical]) {
//        NSRect lightRect = NSMakeRect(aRect.origin.x+1, aRect.origin.y-1, 0.5, aRect.size.height+1);
//        [[NSColor colorWithDeviceWhite:0.8 alpha:1.0] setFill];
//        NSFrameRect(lightRect);
//    } else {
//        NSRect lightRect = NSMakeRect(aRect.origin.x, aRect.origin.y+1, aRect.size.width, 0.5);
//        [[NSColor colorWithDeviceWhite:0.8 alpha:1.0] setFill];
//        NSFrameRect(lightRect);
//    }
}


- (void)mouseUp:(NSEvent *)theEvent {
    if ([NSCursor currentCursor]==[NSCursor resizeLeftCursor] 
        || [NSCursor currentCursor]==[NSCursor resizeRightCursor]
        || [NSCursor currentCursor]==[NSCursor resizeLeftRightCursor]) {
        [super mouseUp:theEvent];
    } 
    
    if ([NSCursor currentCursor]==[NSCursor resizeUpCursor] 
        || [NSCursor currentCursor]==[NSCursor resizeDownCursor]
        || [NSCursor currentCursor]==[NSCursor resizeUpDownCursor])
    {
        [super mouseUp:theEvent];
    }
}


@end
