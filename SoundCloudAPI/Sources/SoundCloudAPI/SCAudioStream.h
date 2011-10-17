/*
 * Copyright 2009 Ullrich Schäfer for SoundCloud Ltd.
 * 
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 * 
 * http://www.apache.org/licenses/LICENSE-2.0
 * 
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 * 
 */


#import <Foundation/Foundation.h>


// number of frames for mpeg audio layer 2 & 3. constant.
#define	kMP3FrameSize		1152
// the samplerate in Hz. we can assume 44.1kHz here
#define kMP3SampleRate		44100

// connection timeout in secods
#define kHTTPConnectionTimeout		20.0

// lets get chunks of 128k size
#define kHTTPRangeChunkChunkSize	(128 * 1024)


extern NSString * const SCAudioStreamHeadphonesUnpluggedNotification;
extern NSString * const SCAudioStreamDidBecomeUnavailableNotification;

@class SCSoundCloudAPIAuthentication;
@class SCAudioFileStreamParser, SCAudioBufferQueue, SCAudioStreamDataFetcher;
@protocol SCAudioFileStreamParserDelegate, SCAudioBufferQueueDelegate;

@class NXOAuth2Connection;

typedef enum {
	SCAudioStreamState_Initialized = 0,
	SCAudioStreamState_Playing,
	SCAudioStreamState_Paused,
	SCAudioStreamState_Stopped // indicates the track has been played to the end
} SCAudioStreamState;

typedef enum {
	SCAudioStreamBufferState_Buffering = 0,
	SCAudioStreamBufferState_NotBuffering
} SCAudioStreamBufferState;

@interface SCAudioStream : NSObject {
@protected
	SCSoundCloudAPIAuthentication	*authentication;
@private
	NSURL							*URL;
	NSURL							*redirectURL;
	SCAudioStreamState				playState;
	SCAudioStreamBufferState		bufferState;
	
	SCAudioFileStreamParser			*audioFileStreamParser;
	SCAudioBufferQueue				*audioBufferQueue;
	
	NSUInteger						playPosition;
	float							volume;

	// is set to new value on seek
	// incremented when parser parses new packages
	NSUInteger						currentPackage;
	
	// is set to 0 on seek
	// incremented with the length of data the stream parser is feeded with
	long long						currentStreamOffset;
	
	// is set to currentPackage when the audioQueue has been created
	NSUInteger						packageAtQueueStart;
	
	// is set to YES when end of stream is about to be loaded
	BOOL							reachedEOF;
	// is set to YES if the end of the stream actually has been loaded
	BOOL							loadedEOF;
	
	long long						streamLength;
	
	long long						currentConnectionStillToFetch;
	
	
	NXOAuth2Connection				*connection;
	NSUInteger						retryDelay;
}
@property (readonly) SCAudioStreamState playState;			// observable
@property (readonly) SCAudioStreamBufferState bufferState;	// observable
@property (readonly) NSUInteger playPosition;	// in milliseconds // not observable
@property (readonly) float bufferingProgress;	// not observable
@property (readwrite, assign) float volume;
@property (readonly) NSURL *URL;

- (id)initWithURL:(NSURL *)aURL authentication:(SCSoundCloudAPIAuthentication *)apiAuthentication;

- (void)seekToMillisecond:(NSUInteger)milli startPlaying:(BOOL)play;

- (void)play;
- (void)pause;


@end
