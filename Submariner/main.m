//
//  main.m
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 Read-Write.fr. All rights reserved.
//

#import <Cocoa/Cocoa.h>

int main(int argc, char *argv[])
{
//    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
//    
//    // check expiration date
//    NSString *version = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
//    NSURL *url = [NSURL URLWithString:@"http://www.read-write.fr/subapp/beta.plist"];
//    NSDictionary *betas = [NSDictionary dictionaryWithContentsOfURL:url];
//    NSDate *expirationDate = nil;
//    
//    if(betas != nil) {
//        expirationDate = [betas valueForKey:version];
//        if(expirationDate != nil) {
//            if([expirationDate isGreaterThanOrEqualTo:[NSDate date]]) {
//                [pool release];
//                return NSApplicationMain(argc, (const char **)argv);
//            } else {
//                NSString *title = [NSString stringWithFormat:@"Expired Beta Version : %@", version];
//                NSString *message = [NSString stringWithFormat:@"This beta version reached its expiration date (%@). You need to upgrade Submariner to a new version.", expirationDate];
//                CFUserNotificationDisplayNotice(0, 
//                                                kCFUserNotificationPlainAlertLevel, 
//                                                NULL, 
//                                                NULL, 
//                                                NULL, 
//                                                (CFStringRef)title, 
//                                                (CFStringRef)message, 
//                                                CFSTR("OK"));
//            }
//        } else {
//            NSLog(@"Unknow version : %@", expirationDate);
//        }
//        
//    } else {
//        NSLog(@"Corrupted Version : %@", expirationDate);
//    }
//    
//    [pool release];
//    
//    
//    return 0;
    
    return NSApplicationMain(argc, (const char **)argv);
}
