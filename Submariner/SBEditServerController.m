//
//  SBEditServerController.m
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBEditServerController.h"
#import "SBWindowController.h"
#import "SBServer.h"

#import "EMKeychainItem.h"


@implementation SBEditServerController

@synthesize server;
@synthesize editMode;

- (void)closeSheet:(id)sender {
    [super closeSheet:sender];
    
    if([self.managedObjectContext hasChanges]) {
        [self.managedObjectContext commitEditing];
        [self.managedObjectContext save:nil];
    }
    [((SBWindowController *)[parentWindow windowController]) hideVisualCue];
}

- (void)cancelSheet:(id)sender {
    [super cancelSheet:sender];
    
    if(self.server != nil && !editMode) {
        [self.managedObjectContext deleteObject:self.server];
        [self.managedObjectContext processPendingChanges];
    }
    [((SBWindowController *)[parentWindow windowController]) hideVisualCue];
}


- (void)controlTextDidEndEditing:(NSNotification *)obj {
    // decompose URL
    NSURL *anUrl = [NSURL URLWithString:self.server.url];
    // protocol scheme
    uint protocol = kSecProtocolTypeHTTP;
    if([[anUrl scheme] rangeOfString:@"s"].location != NSNotFound) {
        protocol = kSecProtocolTypeHTTPS;
    }
    // url port
    NSNumber *port = [NSNumber numberWithInteger:80];
    if([anUrl port] != nil) {
        port = [anUrl port];
    }
    
    EMInternetKeychainItem *keychainItem = [EMInternetKeychainItem internetKeychainItemForServer:[anUrl host]
                                                                                    withUsername:[passwordTextField stringValue]
                                                                                            path:@"/"
                                                                                            port:[port integerValue] 
                                                                                        protocol:protocol];
    
    if(keychainItem == nil) {
        // add internet keychain
        NSLog(@"add internet keychain");
        [EMInternetKeychainItem addInternetKeychainItemForServer:[anUrl host] 
                                                    withUsername:[usernameTextField stringValue]
                                                        password:[passwordTextField stringValue]
                                                            path:@"/"
                                                            port:[port integerValue] 
                                                        protocol:protocol];   
    } else {
        NSLog(@"edit internet keychain");
        if([obj object] == usernameTextField) {
            keychainItem.username = [usernameTextField stringValue];
        } else if([obj object] == passwordTextField) {
            keychainItem.password = [passwordTextField stringValue];
        } else if([obj object] == urlTextField) {
            keychainItem.server = [anUrl host];
        }
    }
    
}

@end
