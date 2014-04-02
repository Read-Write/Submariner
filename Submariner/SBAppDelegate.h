//
//  SubmarinerAppDelegate.h
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class SBPreferencesController;
@class SBDatabaseController;
@class DDHotKeyCenter;

@interface SBAppDelegate : NSObject <NSApplicationDelegate, NSMenuDelegate> {
@private
    // Core Data
    NSPersistentStoreCoordinator *__persistentStoreCoordinator;
    NSManagedObjectModel *__managedObjectModel;
    NSManagedObjectContext *__managedObjectContext;

    // Controllers
    SBPreferencesController *preferencesController;   
    SBDatabaseController *databaseController;
        
    // Status Menu
    NSStatusItem *statusItem;
    IBOutlet NSMenu *statusMenu;
    
    // Manage Shortcuts
    DDHotKeyCenter *hotKeyCenter;
}

@property (nonatomic, retain, readonly) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic, retain, readonly) NSManagedObjectModel *managedObjectModel;
@property (nonatomic, retain, readonly) NSManagedObjectContext *managedObjectContext;
@property (retain, readwrite) DDHotKeyCenter *hotKeyCenter;

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
- (IBAction)playTrackForMenuItem:(id)sender;

@end
