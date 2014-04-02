//
//  SBMovieViewController.m
//  Submariner
//
//  Created by Rafaël Warnault on 10/12/11.
//  Copyright (c) 2011 Read-Write.fr. All rights reserved.
//

#import "SBMovieViewController.h"

@implementation SBMovieViewController

+ (NSString *)nibName {
    return @"MovieView";
}


@synthesize movie;


- (void)awakeFromNib {
    [self addObserver:self
           forKeyPath:@"movie" 
              options:NSKeyValueObservingOptionNew 
              context:nil];
}

- (void)dealloc {
    [movie release];
    [super dealloc];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if(object == self && [keyPath isEqualToString:@"movie"]) {
        if (self.movie != nil) {
            [movieView setMovie:self.movie];
        }
    }
}

@end
