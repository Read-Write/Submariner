# How to integrate the SoundCloud API Wrapper

This guide assumes a few things:

* You are using Xcode 4
* You are using Git.

If you're still on Xcode 3 or do code management in another way, the steps should be equivalent, albeit not as straight forward. You should really consider upgrading ;-)

## Setup

We're taking a fresh new iOS Project as an example. Integration into an existing project and/or a Desktop project should be similar.

### In the Terminal

1. Go to your project directory.

2. Add the Cocoa API Wrapper as a Git Subproject

		git submodule add git://github.com/soundcloud/cocoa-api-wrapper.git SoundCloudAPI
		
3. Update the Subprojects (the API Wrapper includes the NXOAuth2Framework as a subproject)

		git submodule update --init --recursive

### In Xcode

1. Drag the `SoundCloudAPI.xcodeproj` file below your project file. If it asks you to save this as a Workspace, say yes. For projects in the _root_ hierarchy of a workspace, Xcode ensures "implicit depenencies" between them. That's a good thing.

2. To be able to find the Headers, you still need to add `SoundCloudAPI/**` to the `Header Search Path` of the main project.

3. Now the Target needs to know about the new libraries it should link against. So in the _Project_, select the _Target_, and in _Build Phases_ go to the _Link Binary with Libraries_ section. Add the following:

	* `libSoundCloudAPI.a` (or `SoundCloudAPI.framework` on Desktop)
	* `libOAuth2Client.a` (or `OAuth2Client.framework` on Desktop)
	* `Security.framework`
	* `AudioToolbox.framework` (if you want streaming)


4. Next step is to make sure that the Linker finds everything it needs: So go to the Build settings of the project and add the following to *Other Linker Flags*

		-all_load -ObjC

5. We need a few graphics for the Login Screen: Please move the `SoundCloud.bundle` from the SoundCloudAPI directory to your Resources.

Yay, done! Congrats! Everything is set up, and you can start using it. [Here's how](Usage.md).

## Updating

So, from time to time there will be updates. For that, go to the API Wrapper directory and check out the latest version! After this, you might need to update the submodules, too. To do this, please run the following when you're done:

	git submodule update --init --recursive