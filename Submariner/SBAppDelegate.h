//
//  SubmarinerAppDelegate.h
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SBPreferencesController;
@class SBDatabaseController;


@interface SBAppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSPersistentStoreCoordinator *__persistentStoreCoordinator;
    NSManagedObjectModel *__managedObjectModel;
    NSManagedObjectContext *__managedObjectContext;

    SBPreferencesController *preferencesController;   
    SBDatabaseController *databaseController;
    
    NSMutableArray *tmpPaths;
}

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (retain, readwrite) NSMutableArray *tmpPaths;

+ (id)sharedInstance;

- (NSURL *)applicationFilesDirectory;
- (NSString *)musicDirectory;
- (NSString *)coverDirectory;

- (IBAction)openAudioFiles:(id)sender;
- (IBAction)saveAction:(id)sender;
- (IBAction)openPreferences:(id)sender;
- (IBAction)zoomDatabaseWindow:(id)sender;
- (IBAction)toogleTracklist:(id)sender;
- (IBAction)newPlaylist:(id)sender;
- (IBAction)newServer:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextTrack:(id)sender;
- (IBAction)previousTrack:(id)sender;
- (IBAction)showWebsite:(id)sender;

@end
