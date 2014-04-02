//
//  SBAddServerPlaylistController.h
//  Submariner
//
//  Created by Rafaël Warnault on 11/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBSheetController.h"

@class SBServer;

@interface SBAddServerPlaylistController : SBSheetController {
    SBServer *server;
    NSArray *trackIDs;
    
    IBOutlet NSTextField *playlistNameField;
}

@property (readwrite, retain) NSArray *trackIDs;
@property (readwrite, retain) SBServer *server;

@end
