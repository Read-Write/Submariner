//
//  SCLoginViewController.m
//  SCTestApp
//
//  Created by Gernot Poetsch on 16.09.10.
//  Copyright 2010 Gernot Poetsch. All rights reserved.
//

#if TARGET_OS_IPHONE

#import "SCSoundCloudAPIAuthentication.h"
#import "SCSoundCloudAPIConfiguration.h"

#import "SCLoginViewController.h"


@interface SCLoginTitleBar: UIView {
}
@end


#pragma mark -

@implementation SCLoginViewController


#pragma mark Lifecycle

- (id)initWithURL:(NSURL *)anURL authentication:(SCSoundCloudAPIAuthentication *)anAuthentication;
{
    if (!anURL) return nil;
    
    self = [super init];
    if (self) {
        
		showReloadButton = NO;
        
        if ([self respondsToSelector:@selector(setModalPresentationStyle:)]){
            [self setModalPresentationStyle:UIModalPresentationFormSheet];
        }
                
        authentication = [anAuthentication retain];
        URL = [anURL retain];
        resourceBundle = [[NSBundle alloc] initWithPath:[[NSBundle mainBundle] pathForResource:@"SoundCloud" ofType:@"bundle"]];
        NSAssert(resourceBundle, @"Please move the SoundCloud.bundle into the Resource Directory of your Application!");
        self.title = @"SoundCloud";
        self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithTitle:@"Close"
                                                                                  style:UIBarButtonItemStyleBordered
                                                                                 target:self
                                                                                 action:@selector(close)] autorelease];
    }
    return self;
}

- (void)dealloc;
{
	[titleBarButton release];
    [resourceBundle release];
    [titleBarView release];
    [authentication release];
    [activityIndicator release];
    [URL release];
    [webView release];
    [super dealloc];
}


#pragma mark Accessors

@synthesize showReloadButton;

- (void)setShowReloadButton:(BOOL)value;
{
	showReloadButton = value;
	[self updateInterface];
}


#pragma mark UIViewController

- (void)viewDidLoad;
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.9 alpha:1.0];
    
    titleBarView = [[SCLoginTitleBar alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 28.0)];
    titleBarView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleBottomMargin);
    [self.view addSubview:titleBarView];
    
    CGRect logoRect;
    CGRect connectRect;
    CGRect closeRect;
    CGRectDivide(titleBarView.bounds, &logoRect, &connectRect, 45.0, CGRectMinXEdge);
    CGRectDivide(connectRect, &closeRect, &connectRect, connectRect.size.height, CGRectMaxXEdge);
    
    logoRect.origin.x += 6.0;
    logoRect.origin.y += 4.0;
    connectRect.origin.y += 9.0;
    
    UIImageView *cloudImageView = [[UIImageView alloc] initWithFrame:logoRect];
    UIImage *cloudImage = [UIImage imageWithContentsOfFile:[resourceBundle pathForResource:@"cloud" ofType:@"png"]];
    cloudImageView.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin);
    cloudImageView.image = cloudImage;
    [cloudImageView sizeToFit];
    [titleBarView addSubview:cloudImageView];
    [cloudImageView release];
    
    UIImageView *titleImageView = [[UIImageView alloc] initWithFrame:connectRect];
    UIImage *titleImage = [UIImage imageWithContentsOfFile:[resourceBundle pathForResource:@"cwsc" ofType:@"png"]];
    titleImageView.autoresizingMask = (UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin);
    titleImageView.image = titleImage;
    [titleImageView sizeToFit];
    [titleBarView addSubview:titleImageView];
    [titleImageView release];
    
	titleBarButton = [[UIButton buttonWithType:UIButtonTypeCustom] retain];
	titleBarButton.frame = closeRect;
	titleBarButton.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin);
	titleBarButton.showsTouchWhenHighlighted = YES;
	[titleBarButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
	UIImage *closeImage = [UIImage imageWithContentsOfFile:[resourceBundle pathForResource:@"close" ofType:@"png"]];
	[titleBarButton setImage:closeImage forState:UIControlStateNormal];
	titleBarButton.imageView.contentMode = UIViewContentModeCenter;
	[titleBarView addSubview:titleBarButton];
	
	activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
	activityIndicator.center = CGPointMake(CGRectGetMidX(self.view.bounds), CGRectGetMidY(self.view.bounds));
	activityIndicator.autoresizingMask = (UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin);
	activityIndicator.hidesWhenStopped = YES;
	[self.view addSubview:activityIndicator];
    
    NSURL *URLToOpen = [NSURL URLWithString:[[URL absoluteString] stringByAppendingString:@"&display_bar=false"]];
    
    webView = [[UIWebView alloc] initWithFrame:self.view.bounds];
    webView.autoresizingMask = (UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight);
    webView.backgroundColor = nil;
    webView.opaque = NO;
    webView.delegate = self;
    [webView loadRequest:[NSURLRequest requestWithURL:URLToOpen]];
    [self.view addSubview:webView];
    	
    [self updateInterface];
}

- (void)viewDidUnload;
{
    [titleBarView release]; titleBarView = nil;
    [activityIndicator release]; activityIndicator = nil;
    [webView release]; webView = nil;
}

- (void)updateInterface;
{    
    CGRect contentRect;
    
    CGRect titleBarRect;
    CGRectDivide(self.view.bounds, &titleBarRect, &contentRect, 27.0, CGRectMinYEdge);
    titleBarView.frame = titleBarRect;
    webView.frame = contentRect;
    	
	[titleBarButton removeTarget:nil action:NULL forControlEvents:UIControlEventAllEvents];
	if (!showReloadButton) {
		[titleBarButton addTarget:self action:@selector(close) forControlEvents:UIControlEventTouchUpInside];
		UIImage *closeImage = [UIImage imageWithContentsOfFile:[resourceBundle pathForResource:@"close" ofType:@"png"]];
		[titleBarButton setImage:closeImage forState:UIControlStateNormal];
	} else {
		[titleBarButton addTarget:self action:@selector(reload) forControlEvents:UIControlEventTouchUpInside];
		UIImage *reloadImage = [UIImage imageWithContentsOfFile:[resourceBundle pathForResource:@"reload" ofType:@"png"]];
		[titleBarButton setImage:reloadImage forState:UIControlStateNormal];
	}
    
}

#pragma mark WebView Delegate

- (void)webViewDidStartLoad:(UIWebView *)webView;
{
    [activityIndicator startAnimating];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView;
{
    [activityIndicator stopAnimating];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType;
{
    if (![request.URL isEqual:URL]) {
		BOOL hasBeenHandled = NO;
		
		NSURL *redirectURL = authentication.configuration.redirectURL;
		if ([[request.URL absoluteString] hasPrefix:[redirectURL absoluteString]]) {
	        hasBeenHandled = [authentication handleRedirectURL:request.URL];
			if (hasBeenHandled) {
				[self close];
			}
			return NO;
		}
	}
    
	if (![[request.URL absoluteString] hasPrefix:[authentication.configuration.authURL absoluteString]]) {
		[[UIApplication sharedApplication] openURL:request.URL];
		return NO;
	}
	
	return YES;
}

#pragma mark Private

- (IBAction)close;
{
    [authentication performSelector:@selector(dismissLoginViewController:) withObject:self];
}

- (IBAction)reload;
{
    [webView reload];
}

@end


#pragma mark -

@implementation SCLoginTitleBar

- (void)drawRect:(CGRect)rect;
{
    CGRect topLineRect;
    CGRect gradientRect;
    CGRect bottomLineRect;
    CGRectDivide(self.bounds, &topLineRect, &gradientRect, 0.0, CGRectMinYEdge);
    CGRectDivide(gradientRect, &bottomLineRect, &gradientRect, 1.0, CGRectMaxYEdge);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGGradientRef gradient = CGGradientCreateWithColorComponents(colorSpace,
                                                                 (CGFloat[]){1.0,0.40,0.0,1.0,  1.0,0.21,0.0,1.0},
                                                                 (CGFloat[]){0.0, 1.0},
                                                                 2);
    CGContextDrawLinearGradient(context, gradient, gradientRect.origin, CGPointMake(gradientRect.origin.x, CGRectGetMaxY(gradientRect)), 0);
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    CGContextSetFillColor(context, (CGFloat[]){0.0,0.0,0.0,1.0});
    CGContextFillRect(context, topLineRect);
    
    CGContextSetFillColor(context, (CGFloat[]){0.52,0.53,0.54,1.0});
    CGContextFillRect(context, bottomLineRect);
}

@end

#endif
