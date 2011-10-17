//
//  SCLoginViewController.h
//  SCTestApp
//
//  Created by Gernot Poetsch on 16.09.10.
//  Copyright 2010 Gernot Poetsch. All rights reserved.
//

#if TARGET_OS_IPHONE

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SCSoundCloudAPIAuthentication;

@interface SCLoginViewController : UIViewController <UIWebViewDelegate> {
    SCSoundCloudAPIAuthentication *authentication;
    NSURL *URL;
    UIWebView *webView;
    UIActivityIndicatorView *activityIndicator;
    UIView *titleBarView;
    NSBundle *resourceBundle;
	
	UIButton *titleBarButton;
	BOOL showReloadButton;
}

- (id)initWithURL:(NSURL *)anURL authentication:(SCSoundCloudAPIAuthentication *)authentication;

/*
 * Replaces the close ('X') button in the top bar with a reload button
 * Default - NO
 */
@property (nonatomic,assign) BOOL showReloadButton;

- (void)updateInterface;

- (IBAction)close;
- (IBAction)reload;

@end

#endif
