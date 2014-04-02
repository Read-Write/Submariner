//
//  SBViewController.h
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SBViewController : NSViewController {
@protected
    NSManagedObjectContext *managedObjectContext;
}
@property (nonatomic, retain, readwrite) NSManagedObjectContext *managedObjectContext;

+ (NSString *)nibName;
- (id)initWithManagedObjectContext:(NSManagedObjectContext *)context;

@end
