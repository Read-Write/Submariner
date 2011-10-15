//
//  SBPodcastViewItem.m
//  Submariner
//
//  Created by Rafaël Warnault on 24/08/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBPodcastViewItem.h"
#import "SBPodcastItemView.h"


@implementation SBPodcastViewItem

- (void)setSelected:(BOOL)flag
{
    [super setSelected:flag];
    [(SBPodcastItemView*)[self view] setSelected:flag];
    [(SBPodcastItemView*)[self view] setNeedsDisplay:YES];
}

@end
