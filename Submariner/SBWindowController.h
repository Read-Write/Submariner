//
//  SBWindowController.h
//  Sub
//
//  Created by nark on 14/05/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>


@interface SBWindowController : NSWindowController {
@protected
    NSManagedObjectContext *managedObjectContext;
    NSView *blankingView;
}
@property (nonatomic, retain, readwrite) NSManagedObjectContext *managedObjectContext;

+ (NSString *)nibName;

- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;
- (void)showVisualCue;
- (void)hideVisualCue;

@end
