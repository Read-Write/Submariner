//
//  SBViewController.m
//  Sub
//
//  Created by nark on 17/05/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "SBServerViewController.h"
#import "SBServer.h"

@implementation SBServerViewController



@synthesize clientController;
@synthesize server;


#pragma mark -
#pragma mark Instance Methods


- (id)initWithServer:(SBServer *)aServer context:(NSManagedObjectContext *)context {
    self = [super initWithManagedObjectContext:context];
    if (self) {
        server = aServer;
    }
    return self;
}



@end
