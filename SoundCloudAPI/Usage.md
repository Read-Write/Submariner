# How to use the SoundCloud API Wrapper

### The Basics

You only need to `#import "SCAPI.h"` to include the wrapper headers.

The object you should be most interested in is `SCSoundCloudAPI`. It is the main interface for everything SoundCloud. All the magic that happens in the OAuth2Client is well hidden from you.

Therefore it has two delegates: The `SCAPIDelegate` and the `SCAPIAuthenticationDelegate`. The main idea is as follows: In more complex applications, you may want to have different instances of the API, but there should still be one spot where everything concerning Authentication is decided. In many cases, those two delegates point to the same singleton object, though.


### Instantiating the API object

It is recommended that you have one central instance of the `SCSoundCloudAPI` object. You may keep it in a controller object that lives as a [singleton](http://cocoawithlove.com/2008/11/singletons-appdelegates-and-top-level.html) in your application. You can use this controller as a central place to build your API requests, too.

To create an instance of `SCSoundCloudAPI` you can use the following code.

	SCSoundCloudAPIConfiguration *scAPIConfig = [SCSoundCloudAPIConfiguration configurationForProductionWithClientID:CLIENT_KEY
																	                                    clientSecret:CLIENT_SECRET
																		                                 redirectURL:[NSURL URLWithString:REDIRECT_URL]];
	// scAPI is a instance variable
	scAPI = [[SCSoundCloudAPI alloc] initWithDelegate:self
							   authenticationDelegate:authDelegate
									 apiConfiguration:scAPIConfig];

You will get your App's _Client Key_, it's _Client Secret_ from [the SoundCloud page where you registered your App](http://soundcloud.com/you/apps). There you should register your App with it's name and a _Redirect URL_. That _Redirect URL_ should comply to a protocol that is handled by your app. See [this page](http://iphonedevelopertips.com/cocoa/launching-your-own-application-via-a-custom-url-scheme.html) on how to set up the protocol in your App. For the curious: in the wrapper we're using _Redirect URL_ instead of _Redirect URI_ because the underlying type is of `NSURL`.

You may now ask the `scAPI` variable for the authentication status with `scAPI.isAuthenticated`. If you want to start the authentication flow you need to do a call to `[scAPI requestAuthentication]`. If it's not already authenticated, it will start the authentication flow with your *authentication delegate*.


### The Authentication Delegate (The easy way)

You should have one instance of this in your code (for example your app delegate could be your authentication delegate). This delegate receives callbacks when a connection to SoundCloud was established (i.e. when your app receives an access token), when the connection was lost or when there was an error while receiving the access token.

In most cases, **you do not need to implement anything for showing the Login ViewController**. This is true in the case that your App requires iOS4, and thus `UIApplication` has a `rootViewController` property and you use it. In this case, the API Wrapper will display the `SCLoginViewController` automagically.

Here's some sample code for using all the other neat things the `SCAuthenticationDelegate` might provide:

    #pragma mark SCSoundCloudAPIAuthenticationDelegate
    	
    - (void)soundCloudAPIDidAuthenticate;
    {
        // big cheers!! the user sucesfully signed in
    }
	
    - (void)soundCloudAPIDidResetAuthentication;
	{
		// the user did signed off
	}
	
    - (void)soundCloudAPIDidFailToGetAccessTokenWithError:(NSError *)error;
	{
		// inform your user and let him retry the authentication
	}

### The Authentication Delegate (The "a little bit more manual, but still easy" way)

There are however some situations where you might want to implement more stuff in the Auth Flow.

* In iOS 3, there is no `rootViewController` for the application. The API Wrapper uses this to present and dismiss the LoginViewController as a modal ViewController. So if you want iOS3 compatibility, you need to do this manually by implementing `-soundCloudAPIDisplayViewController:` and `-soundCloudAPIDismissViewController:` in your Authentication delegate. In these methods, you usually just trigger the `-presentModalViewController:animated:` and the `-dismissModalViewControlerAnimated:` methods of the desired ViewController.

* Depending on your App, you might want to have either a close button in the top right corner or a reload button. You can customize that with `SCLoginViewController`'s `showReloadButton` property in the `-soundCloudAPIWillDisplayViewController:` delegate method.

* If you're on the Desktop OS X, or you don't like the easy way, and for some reason want to do the OAuth/WebView stuff yourself, there's `-soundCloudAPIPreparedAuthorizationURL:`. If you implement this method, **all the automatic SCLoginViewController magic described above won't happen**.

This method is invoked when `[scAPI requestAuthentication]` is called on `SCSoundCloudAPI` object which is not yet authorized. If you passed an redirect URL with your API configuration while instantiating the API object you'll receive an authorization URL. Open this in an external browser or a web view inside your app. It's important to understand the idea behind OAuth: The user leaves his credentials in a known environment. Ideally in a browser of his trust.

	- (void)soundCloudAPIPreparedAuthorizationURL:(NSURL *)authorizationURL;
	{
		// example for iOS
		// One could also open a UIWebView and load the URL inside the app.
		[[UIApplication sharedApplication] openURL:authorizationURL]; // you should warn the user before doing this
	}

The user will be able to log in at SoundCloud and give your application access. Once this is done your redirect URL is being triggered. Make sure to implement the corresponding method in you application delegate. On the Desktop use the analogous methods.

	- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url;
	{
		return [scAPI handleOpenRedirectURL:url];
	}
	
	// AND / OR
	
	- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions;
	{
		NSURL *launchURL = [launchOptions objectForKey:UIApplicationLaunchOptionsURLKey];	
		return [scAPI handleOpenRedirectURL:launchURL];
	}

As an alternative to authenticating using a browser you can also implement `-soundCloudAPIPreparedAuthorizationURL:` as follows to use the *user credentials flow*:

	- (void)soundCloudAPIPreparedAuthorizationURL:(NSURL *)authorizationURL;
	{
		// open a view which asks the user for username & password
		// example for iOS
		MYCredentialsViewController *vc = [[[MyCredentialsViewController alloc] initWithDelegate:self] autorelease];
		[navigationController pushViewController:vs animated:YES];
	}
	
	// after the user entered his credentials
	- (void)credentialsController:(MYCredentialsViewController *)controller
	              didGetUsername:(NSString *)username
                        password:(NSString *)password;
	{
		// authorize with it
		[scAPI authorizeWithUsername:username password:password];
	}

But consider that this bypasses one of the major reasons for using OAuth, by passing the user credentials through your app.


### Invoking Requests on the API

There is one central method for sending requests to the API: 

	- (id)performMethod:(NSString *)httpMethod
		 	 onResource:(NSString *)resource
		 withParameters:(NSDictionary *)parameters
				context:(id)context
			   userInfo:(id)userInfo;
			
This method returns an `id` which you can use to cancel the request later using `-cancelConnection:` method.

The context can be used to pass data to the delegate callbacks. It is retained for as long as the underlying Connection exists.

### The Connection Delegate Protocol

The second important delegate in the wrapper is `SCSoundCloudConnectionDelegate`. Use it to implement callbacks for requests you send via the API. If you're familiar with [NSURLConnection and its delegate](http://developer.apple.com/mac/library/documentation/Cocoa/Conceptual/URLLoadingSystem/Tasks/UsingNSURLConnection.html) you'll instantly feel familiar with this protocol. That's why I won't go into detail here. It offers you callbacks for certain events during the lifecycle of a request to the API. Notice that each callback contains the `(id)context` object that you passed when performing the request. It also collects the data, so you don't have to. Nice, eh?

There's even an experimental for performing methods on the API that you can give the callbacks to as blocks. The nice thing about it is that the call and the asynchrounous success or failure methods are neatly bundled. We're loving this, and it will be the standard way of doing things once blocks are supported everywhere.

### So, yeah, the request comes back, what do I do now?

Since in an existing app you usually already have a JSON parser, use it to parse the data that comes back in 