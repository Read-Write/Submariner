//
//  DXOperationActivity.m
//  DicomX
//
//  Created by nark on 18/03/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBOperationActivity.h"


@implementation SBOperationActivity

@synthesize operationName;
@synthesize operationInfo;
@synthesize operationPercent;
@synthesize operationCurrent;
@synthesize operationTotal;
@synthesize indeterminated;

- (id)init {
    self = [super init];
    if (self) {
        operationPercent   = [[NSNumber numberWithInt:0] retain];
        operationTotal      = [[NSNumber numberWithInt:0] retain];
        operationCurrent    = [[NSNumber numberWithInt:0] retain];
        indeterminated      = NO;
    }
    return self;
}


- (void)dealloc {
    [operationName release];
    [operationInfo release];
    [operationTotal release];
    [operationCurrent release];
    [operationPercent release];
    [super dealloc];
}


@end
