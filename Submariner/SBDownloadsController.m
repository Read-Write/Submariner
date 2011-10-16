//
//  SBDownloadsController.m
//  Submariner
//
//  Created by Rafaël Warnault on 16/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBDownloadsController.h"
#import "SBSubsonicDownloadOperation.h"
#import "SBOperationActivity.h"




@interface SBDownloadsController (Private)
- (void)subsonicDownloadStarted:(NSNotification *)notification;
- (void)subsonicDownloadFinished:(NSNotification *)notification;
@end




@implementation SBDownloadsController

+ (NSString *)nibName {
    return @"Downloads";
}



@synthesize downloadActivities;
@synthesize activitiesController;



- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super initWithManagedObjectContext:context];
    if (self) {
        downloadActivities = [[NSMutableArray alloc] init];
        
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(subsonicDownloadStarted:) 
                                                     name:SBSubsonicDownloadStarted 
                                                   object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(subsonicDownloadFinished:) 
                                                     name:SBSubsonicDownloadFinished
                                                   object:nil];
    }
    return self;
}


- (void)dealloc {
    [downloadActivities release];
    [super dealloc];
}


- (void)loadView {
    [super loadView];
}



- (void)subsonicDownloadStarted:(NSNotification *)notification {

    SBOperationActivity *activity = [notification object];
    
    [self.activitiesController performSelectorOnMainThread:@selector(addObject:) 
                                                withObject:activity 
                                             waitUntilDone:YES];
}

- (void)subsonicDownloadFinished:(NSNotification *)notification {

    SBOperationActivity *activity = [notification object];
    
    [self.activitiesController performSelectorOnMainThread:@selector(removeObject:) 
                                                withObject:activity 
                                             waitUntilDone:YES];
}

@end
