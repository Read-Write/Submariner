//
//  SBEditServerController.h
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBSheetController.h"

@class SBServer;

@interface SBEditServerController : SBSheetController <NSControlTextEditingDelegate> {
@private
    SBServer *server;
    BOOL editMode;
    
    IBOutlet NSTextField *descriptionTextField;
    IBOutlet NSTextField *urlTextField;
    IBOutlet NSTextField *usernameTextField;
    IBOutlet NSTextField *passwordTextField;
}

@property (readwrite, retain) SBServer *server;
@property (readwrite) BOOL editMode;

@end
