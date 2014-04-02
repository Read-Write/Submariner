//
//  SBUserViewController.m
//  Submariner
//
//  Created by Rafaël Warnault on 13/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import "SBServerUserViewController.h"
#import "SBPrioritySplitViewDelegate.h"
#import "SBSubsonicParsingOperation.h"
#import "SBServer.h"
#import "SBChatMessage.h"




#define LEFT_VIEW_INDEX 0
#define LEFT_VIEW_PRIORITY 0
#define LEFT_VIEW_MINIMUM_WIDTH 100.0

#define MAIN_VIEW_INDEX 1
#define MAIN_VIEW_PRIORITY 1
#define MAIN_VIEW_MINIMUM_WIDTH 250.0




@interface SBServerUserViewController (Private)
- (void)subsonicChatMessageAdded:(NSNotification *)notification;
- (void)subsonicNowPlayingUpdated:(NSNotification *)notification;
- (void)subsonicCoversUpdatedNotification:(NSNotification *)notification;
- (void)synchronizeChatMessages;
- (void)clearUnreadMessages;
- (void)startRefreshChatTimer;
- (void)startRefreshNowPlayingTimer;
- (void)refreshAll;
@end



@implementation SBServerUserViewController

@synthesize nowPlayingSortDescriptors;



+ (NSString *)nibName {
    return @"ServerUsers";
}


- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context {
    self = [super initWithManagedObjectContext:context];
    if (self) {
        NSSortDescriptor *descr = [NSSortDescriptor sortDescriptorWithKey:@"minutesAgo" ascending:YES];
        nowPlayingSortDescriptors = [[NSArray arrayWithObject:descr] retain];
        
        
        // timers
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"autoRefreshChat"])
            [self startRefreshChatTimer];
        
        if([[NSUserDefaults standardUserDefaults] boolForKey:@"autoRefreshNowPlaying"])
            [self startRefreshNowPlayingTimer];
    }
    return self;
}


- (void)dealloc {
    
    [chatMessagesController removeObserver:self forKeyPath:@"content"];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:SBSubsonicChatMessageAddedNotification 
                                                  object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self 
                                                    name:SBSubsonicNowPlayingUpdatedNotification 
                                                  object:nil];
    
    [nowPlayingSortDescriptors release];
    [splitViewDelegate release];
    [refreshChatTimer release];
    [refreshNowPlayingTimer release];
    [super dealloc];
}


- (void)loadView {
    [super loadView];
    
    
    // split view
    splitViewDelegate = [[SBPrioritySplitViewDelegate alloc] init];

    [chatSplitView setPosition:[chatSplitView frame].size.width-MAIN_VIEW_MINIMUM_WIDTH
              ofDividerAtIndex:0];
    
    [splitViewDelegate setPriority:LEFT_VIEW_PRIORITY forViewAtIndex:LEFT_VIEW_INDEX];
	[splitViewDelegate setMinimumLength:LEFT_VIEW_MINIMUM_WIDTH forViewAtIndex:LEFT_VIEW_INDEX];
    
	[splitViewDelegate setPriority:MAIN_VIEW_PRIORITY forViewAtIndex:MAIN_VIEW_INDEX];
	[splitViewDelegate setMinimumLength:MAIN_VIEW_MINIMUM_WIDTH forViewAtIndex:MAIN_VIEW_INDEX];
    
    [chatSplitView setDelegate:splitViewDelegate];
    
    
    // add chat content observer
    [chatMessagesController addObserver:self
                             forKeyPath:@"content" 
                                options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                                context:nil];
    
    // add add subsonic observers
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(subsonicChatMessageAdded:)
                                                 name:SBSubsonicChatMessageAddedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(subsonicNowPlayingUpdated:)
                                                 name:SBSubsonicNowPlayingUpdatedNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(subsonicCoversUpdatedNotification:) 
                                                 name:SBSubsonicCoversUpdatedNotification
                                               object:nil];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"autoRefreshChat"
                                               options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                                               context:nil];
    
    [[NSUserDefaults standardUserDefaults] addObserver:self
                                            forKeyPath:@"autoRefreshNowPlaying"
                                               options:(NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld)
                                               context:nil];

}


- (void)viewDidLoad {
    [self refreshAll];
    [self clearUnreadMessages];
}





#pragma mark -
#pragma mark IBActions

- (IBAction)refreshChat:(id)sender {
    
    
    // get last message date
    NSFetchRequest *fetchRequest1 = [[NSFetchRequest alloc] init];
    NSError *error = nil;
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"ChatMessage" inManagedObjectContext:[self managedObjectContext]];
    
    [fetchRequest1 setEntity:entity];
    
    NSSortDescriptor *dateSort = [[NSSortDescriptor alloc] initWithKey:@"date" ascending:NO];
    [fetchRequest1 setSortDescriptors:[NSArray arrayWithObject:dateSort]];
    [dateSort release], dateSort = nil;
    
    [fetchRequest1 setFetchLimit:1];
    
    SBChatMessage *latest = (SBChatMessage *)[[[self managedObjectContext] executeFetchRequest:fetchRequest1 error:&error] lastObject];
    [fetchRequest1 release], fetchRequest1 = nil;
    
    if(latest) {
        [server getChatMessagesSince:latest.date];
    } else {
        NSDate *lastWeek  = [[NSDate date] addTimeInterval:-1209600.0];
        [server getChatMessagesSince:lastWeek];
    }
}

- (IBAction)refreshNowPlaying:(id)sender {
    
    
    // clean existing now playing objects
    NSFetchRequest * allCars = [[NSFetchRequest alloc] init];
    [allCars setEntity:[NSEntityDescription entityForName:@"NowPlaying" inManagedObjectContext:self.managedObjectContext]];
    [allCars setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * cars = [self.managedObjectContext executeFetchRequest:allCars error:&error];
    [allCars release];
    //error handling goes here
    for (NSManagedObject * car in cars) {
        [self.managedObjectContext deleteObject:car];
        //[nowPlayingController removeObject:car];
    }
    
    // process changes inside CD graph
    [self.managedObjectContext processPendingChanges];
    
    // request new now playing objects
    [server getNowPlaying];
}


- (IBAction)clearChat:(id)sender {
    [chatTextView setString:@""];
    
    NSFetchRequest * request = [[NSFetchRequest alloc] init];
    [request setEntity:[NSEntityDescription entityForName:@"ChatMessage" inManagedObjectContext:self.managedObjectContext]];
    [request setIncludesPropertyValues:NO]; //only fetch the managedObjectID
    
    NSError * error = nil;
    NSArray * messages = [self.managedObjectContext executeFetchRequest:request error:&error];
    [request release];
    
    for (NSManagedObject * message in messages) {
        [self.managedObjectContext deleteObject:message];
    }
}


- (void)refreshAll {
    [self refreshChat:nil];
    [self refreshNowPlaying:nil];
}



#pragma mark -
#pragma mark Observers

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if([keyPath isEqualToString:@"content"]) {
        [self synchronizeChatMessages];
    } else if([keyPath isEqualToString:@"autoRefreshChat"]) {
        [self startRefreshChatTimer];
    } else if([keyPath isEqualToString:@"autoRefreshNowPlaying"]) {
        [self startRefreshNowPlayingTimer];
    }  
}





#pragma mark -
#pragma mark Subsonic Notifications

- (void)subsonicChatMessageAdded:(NSNotification *)notification {
    [self refreshChat:nil];
}

- (void)subsonicNowPlayingUpdated:(NSNotification *)notification {
    
}

- (void)subsonicCoversUpdatedNotification:(NSNotification *)notification {
    [nowPlayingController rearrangeObjects];
    [nowPlayingCollectionView setNeedsDisplay:YES];
}



#pragma mark -
#pragma mark Private

- (void)synchronizeChatMessages {
    // sort messages by date
    NSSortDescriptor *descriptor =[NSSortDescriptor sortDescriptorWithKey:@"date" ascending:NO];
    NSArray *chatMessages = [[chatMessagesController arrangedObjects] sortedArrayUsingDescriptors:[NSArray arrayWithObject:descriptor]];
    
    // clean ciew
    [chatTextView setString:@""];
    
    // add messages
    for(SBChatMessage *message in chatMessages) {
        NSDictionary *usernameAttrs = [NSDictionary dictionaryWithObject:[NSFont boldSystemFontOfSize:12.0f] forKey:NSFontAttributeName];
        NSString *usernameString = [NSString stringWithFormat:@"%@ : ", message.username];
        NSAttributedString *attrUsernameString = [[NSAttributedString alloc] initWithString:usernameString attributes:usernameAttrs];
        
        [[chatTextView textStorage] appendAttributedString:attrUsernameString];
        
        NSString *messageString = [NSString stringWithFormat:@"%@\n", message.message];
        NSAttributedString *attrMessageString = [[NSAttributedString alloc] initWithString:messageString];
        
        [[chatTextView textStorage] appendAttributedString:attrMessageString];
        
        [attrUsernameString release];
        [attrMessageString release];
    }
}


- (void)clearUnreadMessages {
    NSArray *messages = [chatMessagesController arrangedObjects];
    for(SBChatMessage *message in messages) {
        if([message.unread boolValue])
            [message setUnread:[NSNumber numberWithBool:NO]];
    }
    [[NSApp dockTile] setBadgeLabel:nil];
}



- (void)startRefreshChatTimer {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"autoRefreshChat"]) {

        refreshChatTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f
                                                        target:self
                                                      selector:@selector(refreshChat:)
                                                      userInfo:nil
                                                       repeats:YES];
    } else {
        if(refreshChatTimer) {

            [refreshChatTimer invalidate];
        }
    }
}

- (void)startRefreshNowPlayingTimer {
    if([[NSUserDefaults standardUserDefaults] boolForKey:@"autoRefreshNowPlaying"]) {
        
        refreshNowPlayingTimer = [NSTimer scheduledTimerWithTimeInterval:30.0f
                                                            target:self
                                                          selector:@selector(refreshNowPlaying:)
                                                          userInfo:nil
                                                           repeats:YES];
    } else {
        if(refreshNowPlayingTimer) {
            
            [refreshNowPlayingTimer invalidate];
        }
    }
}


#pragma mark -
#pragma mark NSTextField Delegate

- (void)controlTextDidEndEditing:(NSNotification *)obj {
    NSString *string = [[obj object] stringValue];
    
    if(string && [string length] > 0) {
        [[obj object] setStringValue:@""];
        [server addChatMessage:string];
    }
}



@end
