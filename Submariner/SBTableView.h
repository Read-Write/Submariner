//
//  SBTableView.h
//  Sub
//
//  Created by nark on 25/05/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Foundation/Foundation.h>


extern NSString *SBDeleteKeyPressedOnRowsNotification;
extern NSString *SBEnterKeyPressedOnRowsNotification;


@interface SBTableView : NSTableView {
@private
    
}

@end



@protocol SBTableViewDelegate <NSTableViewDelegate>

- (NSMenu *)tableView:(SBTableView *)tableView menuForEvent:(NSEvent *)event;
- (void)tableViewEnterKeyPressedNotification:(NSNotification *)notification;
- (void)tableViewDeleteKeyPressedNotification:(NSNotification *)notification;

@end