//
//  SBCoverSplitView.m
//  Submariner
//
//  Created by Rafaël Warnault on 12/12/11.
//  Copyright (c) 2011 OPALE. All rights reserved.
//

#import "SBCoverSplitView.h"


#define MAX_HEIGHT 190

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
    return self.bounds.size.height - MAX_HEIGHT;
}

/*
 * Controls the minimum size of the right subview (or lower subview in a horizonal NSSplitView)
 */
- (CGFloat)splitView:(NSSplitView *)splitView constrainMaxCoordinate:(CGFloat)proposedMaximumPosition ofSubviewAt:(NSInteger)dividerIndex;
{
    return proposedMaximumPosition - handleView.bounds.size.height;
}

- (void)splitView:(NSSplitView *)splitView resizeSubviewsWithOldSize:(NSSize)oldSize {
    
    NSView *topView = [[self subviews] objectAtIndex:0];
    NSView *bottomView = [[self subviews] objectAtIndex:1];
    
    NSRect topRect = topView.frame;
    NSRect bottomRect = bottomView.frame;
    
    // resize top rect
    topRect.size.width = self.frame.size.width;
    if(topRect.size.height < MAX_HEIGHT) {
        topRect.size.height = self.frame.size.height - self.frame.size.width;
    } else {
        topRect.size.height = self.bounds.size.height - MAX_HEIGHT;
    }
        
    bottomRect.size.width = self.frame.size.width;
    if(topRect.size.height < MAX_HEIGHT) {
        bottomRect.origin.y = self.frame.origin.y + self.dividerThickness + bottomRect.size.height - handleView.bounds.size.height;
    } else {
        bottomRect.origin.y = MAX_HEIGHT;
    }
    
    [topView setFrame:topRect];
    [bottomView setFrame:bottomRect];
    
    [self adjustSubviews];
}


@end
