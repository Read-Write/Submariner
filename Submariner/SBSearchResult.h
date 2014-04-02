//
//  SBSearchResult.h
//  Submariner
//
//  Created by Rafaël Warnault on 25/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SBSearchResult : NSObject {
    NSString *query;
    NSMutableArray *tracks;
}

@property (readwrite, retain) NSString *query;
@property (readwrite, retain) NSMutableArray *tracks;

- (id)initWithQuery:(NSString *)aQuery;

@end
