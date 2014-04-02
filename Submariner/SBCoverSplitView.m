//
//  SBCoverSplitView.m
//  Submariner
//
//  Created by Rafaël Warnault on 12/12/11.
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
