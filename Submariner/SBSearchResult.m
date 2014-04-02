//
//  SBSearchResult.m
//  Submariner
//
//  Created by Rafaël Warnault on 25/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "SBSearchResult.h"

@implementation SBSearchResult


@synthesize query;
@synthesize tracks;


- (id)init
{
    self = [super init];
    if (self) {
        tracks = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (id)initWithQuery:(NSString *)aQuery
{
    self = [self init];
    if (self) {
        query = [aQuery retain];
    }
    
    return self;
}


- (void)dealloc {
    [tracks release];
    [query release];
    [super dealloc];
}


@end
