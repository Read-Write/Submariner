//
//  SBDownloadsController.h
//  Submariner
//
//  Created by Rafaël Warnault on 16/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "SBViewController.h"


@interface SBDownloadsController : SBViewController {
    NSArrayController *activitiesController; 
    NSMutableArray *downloadActivities;
}

@property (assign) IBOutlet NSArrayController *activitiesController; 
@property (readwrite, retain) NSMutableArray *downloadActivities;

@end
