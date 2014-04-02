# Submariner

## About

Submariner is a Subsonic client for Mac which is currently no more maintained. Because I received many requests about it, I decided to publish the sources code under BSD 3-clauses license. 

You have to know that this codebase is old and stay pretty untouched since 2012. I only fixed a few errors to make it compile against 10.9 SDK on Mavericks. 

I changed the bunlde identifier of the application to `fr.read-write.Submariner`, because Submariner was initialy developed as a proprietary software, with another trademark. 

## Development

Developers are welcome to directly contribute to the project by forking it on GitHub.com and by publishing pull-requests, or by using the sources code with respect of the attached license.

According to the direction this project will take, I will be glad to continue to distibute it as a binary from Read-Write.fr domain. But feel free if you want to lead your own project, while you respect terms of the attached license. 

## Third-Party

This project use many third-party frameworks and additions:

* DDHotKey by Dave DeLong ([https://github.com/davedelong/DDHotKey](https://github.com/davedelong/DDHotKey))
* LRResty by Luke Redpath ([https://github.com/lukeredpath/LRResty](https://github.com/lukeredpath/LRResty))
* SFBAudioEngine by Stephen F. Booth ([https://github.com/sbooth/SFBAudioEngine](https://github.com/sbooth/SFBAudioEngine))
	- dumb library	- FLAC library	- mac library	- mp4v2 library	- mpcdec library	- mpg123 library	- shorten library	- sndfile library	- speex library	- taglib library	- vorbis library	- wavpack library
* ShortcutRecorder ([https://github.com/darwin/shortcutrecorder](https://github.com/darwin/shortcutrecorder))

Most of them are out-of-date regarding their current status. See the "Additions" sources group in the Xcode project for more details. 

## Release Notes:

### Version 1.1:

* Add Lossless support for local player.
* Add Mini-Player Menu, callable via a customizable hot-key shortcut.
* Add Max Cover Size setting.
* Add zoom setting for album browser views.
* Improve authentication by supporting password encoding.
* Improve global design, navigation and frame persistence.
* Improve player progress bar stability and design.
* Improve Track-list design.
* Improve cache-streaming engine stability.
* Improve general speed, around 20% faster.
* Fix bug in "Import Audio Files" feature when "Link" option is chosen.
* Fix special character bug in server password.
* Fix memory leaks around REST API

### Version 1.0:

* Initial release.

## License

		Copyright (c) 2011-2014, Rafaël Warnault
		All rights reserved.
		
		Redistribution and use in source and binary forms, with or without
		modification, are permitted provided that the following conditions are met:
		
		* Redistributions of source code must retain the above copyright notice, this
		list of conditions and the following disclaimer.
		
		* Redistributions in binary form must reproduce the above copyright notice,
		this list of conditions and the following disclaimer in the documentation
		and/or other materials provided with the distribution.
		
		* Neither the name of the Read-Write.fr nor the names of its
		contributors may be used to endorse or promote products derived from
		this software without specific prior written permission.
		
		THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
		AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
		IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
		DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
		FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
		DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
		SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
		CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
		OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
		OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.