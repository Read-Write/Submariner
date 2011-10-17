# SoundCloud Upload & Share Guide for iOS and OSX

So you are familiar with the [SoundCloud API Wrapper](https://github.com/soundcloud/cocoa-api-wrapper) and want to use it to share the sounds you upload? And you want to use the [existing connections on SoundCloud](http://soundcloud.com/settings/connections) or make new ones? Awesome. Here's how to do it.

In a nutshell, SoundCloud takes care of making the connections and authenticating to various social networks for you. Your app can just use those connections. There is no need to exchange and store tokens once you are authorized to SoundCloud.

If you don't use connections at all when uploading a track, then the default connection settings on the website will be used automatically. The purpose of the connection API is to change the sharing options on a per-file basis and to establish new connections.

Currently the following Services are supported:

- Twitter
- Facebook (Profiles and Pages)
- Foursquare
- Tumblr
- Myspace

Here's what you need to do for sharing:

- Getting the users connections
- Provide UI for choosing connections (public sharing) or mail addresses (private sharing)
- Upload the file
- Establish new connections (optional)

Depending on the privacy settings of your upload, the task is a little bit different: You want to share public tracks on social networks, and private uploads via mail.

## Getting the users connections

For getting the user's connections, use the connections resource at [`/me/connections.json`](https://github.com/soundcloud/api/wiki/10.7-Resources%3A-connections). With the API Wrapper, it looks like this:

	[api performMethod:@"GET" onResource:@"me/connections.json" withParameters:nil context:nil userInfo:nil];

What this returns is a JSON array of connections which looks like this:

	[ {
		"id":12345,
		"created_at":"2010/12/02 11:45:07 +0000",
		"display_name":"Joe Test",
		"post_publish":true,
		"post_favorite":false,
		"service":"twitter",
		"uri":"https://api.soundcloud.com/connections/12345"
	}, …]

Use a [JSON library](http://code.google.com/p/json-framework/) to transform this into Ojbective-C structures. We recommend to do this as soon as possible, preferrably directly after the start of the App, so the user does not have to wait for connections to load. You might even want to store this info, but make sure to update it it on use, because not only your app might change it!

## Provide a UI for the User's connections

In your upload screen for *public* files, we recommend using a table to display the connections. You can use `UISwitch` controls as AccessoryViews of your `UITableCell`s.

When publishing a file, it is important to respect the default sharing settings that have been made on the SoundCloud website. The `post_publish` field represents this and should be used as the default setting for the switch.

The *Foursquare* sharing needs special treatment, though: If the user has not chosen a foursquare venue, this connection should be deactivated. If your app doesn't integrate Foursquare locations, this connection should be omitted.

When the user is done entering metadata and setting the sharing options, you should end up with an array of connections that the user has chosen.

In case of *private* sharing, provide a way to specify an array of email adresses. SoundCloud will take care of sending the mail, and shares internally if the user already has a SoundCloud account!

Upload the file
---------------

One all the metadata is in place, the file can be uploaded. For this, we use the API wrapper again:

	[api performMethod:@"POST" onResource:@"tracks" withParameters:parameters context:nil userInfo:nil]

You can get more info about this call and its parameters from the [API documentation for tracks](https://github.com/soundcloud/api/wiki/10.2-Resources%3A-tracks). One parameter is the *sharing note* (the text that get's displayed in a tweet, for example), so you should read it.

The parameters dictionary can look something like this:

	[NSDictionary dictionaryWithObjectsAndKeys:
		fileURL, track[assetdata], //a file URL
		title, track[title],
		(private) ? @"private" : @"public", @"track[sharing]", //a BOOL
		@"recording", @"track[type]",
		sharingConnections, @"track[post_to][][id]", //array of id strings
		tags, track[tag_list], //also an array of strings
		…
		nil];

If you don't supply a `track[post_to][][id]` parameter, SoundCloud will use the default settings on the website. So to share to nobody, use this:

	[NSDictionary dictionaryWithObjectsAndKeys:
		…
		@"", @"track[post_to][]",
		…
		nil];

But how to supply geo coordinates and how to set the Foursquare venue ID? For this we use machine tags that get into the array you send with `track[tag_list]`. The following tags are currently supported:

- `geo:lat=12.34567`
- `geo:lon=56.67890`
- `foursquare:venue=1234567`

As with any upload you should put them somewhere in your app where the user can see them, cancel them, they should continue when the app is sent to the background, etc.

When sharing **private**, you don't want to supply sharing connections, share to mail instead:

	[NSDictionary dictionaryWithObjectsAndKeys:
		…
		arrayOfStringMailAddresses, @"track[shared_to][emails][][address]",
		…
		nil];

## Bonus: Making new connections

So what about users that have not yet connected their favorite services to SoundCloud? Can they do it from within your app? Yes, they can, and it's quite easy.

You just need to send a `POST` with the service type of the connection and you get back an URL:

	 [api performMethod:@"POST"
	         onResource:@"connections"
	     withParameters:[NSDictionary dictionaryWithObjectsAndKeys:
	                                                 service, @"service",
	                                                 @"x-myapplicationsurlscheme://connection", @"redirect_uri",
	                                                 @"touch", @"display", //optional, forces services to use the mobile auth page if available
	                                                 nil]
	            context:nil
	           userInfo:nil];

The services that are currently supported are:

- `twitter`
- `facebook_profile` (this will also connect Facebook pages!)
- `foursquare`
- `tumblr`
- `myspace`

The URL you get back in the JSON should be opened in a WebView. Listen for your callback URL in `-webView:shouldStartLoadWithRequest:navigationType:`. If you get it, close the webView and reload the connections. Voilà, your new connections are there and ready to use!

That's it! And when you're done, don't forget to promote your app in the [SoundCloud App Gallery](http://soundcloud.com/apps)!