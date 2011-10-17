# Changes to the Cocoa API Wrapper

## Changes from version 1

We tried to get rid of the major obstacles that occurred while using the API wrapper. Therefore we had to change the interface but instead of adding stuff we tried to get rid of everything that was distracting. The next sections will describe in a short manner what was removed, what was renamed and what you have to do to move to version 2.


### The SCSoundCloudAPI interface

* Removed the `status`. It had too much complexity attached to it. Therefore added `isAuthenticated` which is a simple BOOL to check if the API is connected already.
* Also removed the delegate method `soundCloudAPI:didChangeAuthenticationStatus:` and replaced it with `soundCloudAPIDidAuthenticate:` and `soundCloudAPIDidResetAuthentication:`

* The verifier was removed since it's not needed anymore with OAuth2

* `soundCloudAPI:requestedAuthenticationWithURL:` was renamed to `soundCloudAPI:preparedAuthorizationURL:`
* `soundCloudAPI:didEncounterError:` was renamed to `soundCloudAPI:didFailToGetAccessTokenWithError:`
* `configurationForSoundCloudAPI:` was removed. You pass the API configuration in the initializer of the API object now.

* `performMethod:onResource:withParameters:context:` was renamed to `-performMethod:onResource:withParameters:context:connectionDelegate:` and now takes a connection delegate and returns a SCSoundCloudConnection object
* `SCSoundCloudAPIDelegate` was moved into `SCSoundCloudConnectionDelegate`. The connection delegate can now be set per request and not API wide.
* Also `-cancelRequest:` was removed. Use `-cancel` in `SCSoundCloudConnection` now.

* The authentication process was streamlined. Therefore `-authorizeRequestToken` was removed and `-handleOpenRedirectURL:` and `-authorizeWithUsername:password:` were added. See next chapter.


### The Authentication Process

The authentication process was too complicated in the previous version. So we streamlined it. Also there's a second authentication scheme now (user credentials). See previous sections for details. This section describes how the process changed.

In version 1 `-soundCloudAPIdidChangeAuthenticationStatus:` had to be implemented and depending on the status different things had to be triggered. Since we got rid of all the different statuses this There's not much left for you to implement :)

In `-soundCloudAPI:preparedAuthorizationURL:` you just have to decide which authentication flow you're using and depending on that either open a webView (or the browser) and present the user with the authentication page, or query the user for username & password. Once you got the response from either your URL callback or the username and password you pass them to the API with either `-handleOpenRedirectURL:` or `-authorizeWithUsername:password:`. That's it.


## Changelog for the Beta of 2.0

The wrapper is still subject to change. Although we thing that v2.0beta3 should be quite stable in it's interface now. But we're willing to optimize things even further and are hoping for your input.

### 2.0 Beta 2 to 2.0 Beta 3

* Renamed `-soundCloudAPIDidGetAccessToken:` to `-soundCloudAPIDidAuthenticate:` & added `-soundCloudAPIDidResetAuthentication:`
* Introduced `SCSoundCloudAPIConnection` and added `connectionDelegate:` per request
* Moved `SCSoundCloudAPIDelegate` into `SCSoundCloudAPIConnectionDelegate`