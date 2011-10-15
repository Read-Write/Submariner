//
//  PrioritySplitViewDelegate.h
//  ColumnSplitView
//
//  Created by Matt Gallagher on 2009/09/01.
//  Copyright 2009 Matt Gallagher. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface SBMainSplitViewDelegate : NSObject <NSSplitViewDelegate>
{
	NSMutableDictionary *lengthsByViewIndex;
	NSMutableDictionary *viewIndicesByPriority;
    NSMutableDictionary *collapsableByIndex;
    NSSplitView *synchronizedSplitView;
    NSView *accessoryView;
}

- (void)setMinimumLength:(CGFloat)minLength forViewAtIndex:(NSInteger)viewIndex;
- (void)setPriority:(NSInteger)priorityIndex forViewAtIndex:(NSInteger)viewIndex;
- (void)setCollapsable:(BOOL)collapsable forViewAtIndex:(NSInteger)viewIndex;

- (void)setAccessoryView:(NSView *)view;
- (void)setSynchronizedSplitView:(NSSplitView *)splitview;

@end
