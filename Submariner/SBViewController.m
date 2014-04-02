//
//  SBViewController.m
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "SBViewController.h"


@implementation SBViewController

@synthesize managedObjectContext;


#pragma mark -
#pragma mark Class Methods

+ (NSString *)nibName {
    return nil;
}



#pragma mark -
#pragma mark Lifecycle

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super initWithNibName:[[self class] nibName] bundle:nil];
    if (self) {
        managedObjectContext = [context retain];
    }
    return self;
}

- (void)dealloc
{
    [managedObjectContext release];
    [super dealloc];
}

@end
