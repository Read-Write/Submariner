//
//  SBMusicSearchController.h
//  Submariner
//
//  Created by Rafaël Warnault on 22/08/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SBViewController.h"

@interface SBMusicSearchController : SBViewController {
    IBOutlet NSTableView *tracksTableView;
    IBOutlet NSArrayController *tracksController;
}

- (IBAction)trackDoubleClick:(id)sender;
- (void)searchString:(NSString *)query;

@end
