//
//  SBCoverSplitView.m
//  Submariner
//
//  Created by Rafaël Warnault on 12/12/11.
//  Copyright (c) 2011 OPALE. All rights reserved.
//

#import "SBCoverSplitView.h"

@implementation SBCoverSplitView

- (void)awakeFromNib {
    [self setDelegate:self];
}

- (NSRect)splitView:(NSSplitView *)splitView additionalEffectiveRectOfDividerAtIndex:(NSInteger)dividerIndex {
    return [handleView convertRect:[handleView bounds] toView:splitView];
}

- (BOOL)splitView:(NSSplitView *)splitView canCollapseSubview:(NSView *)subview {
    return NO;
}

- (BOOL)splitView:(NSSplitView *)splitView shouldHideDividerAtIndex:(NSInteger)dividerIndex {
    return YES;
}

/*
 * Controls the minimum size of the left subview (or top subview in a horizonal NSSplitView)
 */
- (CGFloat)splitView:(NSSplitView *)splitView constrainMinCoordinate:(CGFloat)proposedMinimumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
    return proposedMinimumPosition + 180;
}

/*
 * Controls the minimum size of the right subview (or lower subview in a horizonal NSSplitView)
 */
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
    return proposedMaximumPosition - 40;
}

- (void)splitView:(NSSplitView *)splitView resizeSubviewsWithOldSize:(NSSize)oldSize {
    
    NSView *topView = [[self subviews] objectAtIndex:0];
    NSView *bottomView = [[self subviews] objectAtIndex:1];
    
    NSRect topRect = topView.frame;
    NSRect bottomRect = bottomView.frame;
    
    // resize top rect
    topRect.size.width = self.frame.size.width;
    topRect.size.height = self.frame.size.height - self.frame.size.width;
    
    bottomRect.size.width = self.frame.size.width;
    //bottomRect.size.height = bottomRect.size.width;
    bottomRect.origin.y = self.frame.origin.y + self.dividerThickness + bottomRect.size.height - 40;
    
    [topView setFrame:topRect];
    [bottomView setFrame:bottomRect];
    
    [self adjustSubviews];
}


@end
