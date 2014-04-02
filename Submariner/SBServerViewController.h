//
//  SBViewController.h
//  Sub
//
//  Created by nark on 17/05/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBViewController.h"

@class SBServer;
@class SBClientController;

@interface SBServerViewController : SBViewController {
@protected
    SBServer *server;
    SBClientController *clientController;
}

@property (readwrite, retain) SBClientController *clientController;
@property (readwrite, retain) SBServer *server;

- (id)initWithServer:(SBServer *)server context:(NSManagedObjectContext *)context;

@end
