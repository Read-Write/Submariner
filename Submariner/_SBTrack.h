// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to SBTrack.h instead.

#import <CoreData/CoreData.h>
#import "SBMusicItem.h"

@class SBNowPlaying;
@class SBAlbum;
@class SBCover;
@class SBEpisode;
@class SBServer;
@class SBPlaylist;
@class SBTrack;
@class SBTrack;


















@interface SBTrackID : NSManagedObjectID {}
@end

@interface _SBTrack : SBMusicItem {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SBTrackID*)objectID;



@property (nonatomic, retain) NSString *albumName;

//- (BOOL)validateAlbumName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *isPlaying;

@property BOOL isPlayingValue;
- (BOOL)isPlayingValue;
- (void)setIsPlayingValue:(BOOL)value_;

//- (BOOL)validateIsPlaying:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *size;

@property int sizeValue;
- (int)sizeValue;
- (void)setSizeValue:(int)value_;

//- (BOOL)validateSize:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *contentSuffix;

//- (BOOL)validateContentSuffix:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *year;

@property int yearValue;
- (int)yearValue;
- (void)setYearValue:(int)value_;

//- (BOOL)validateYear:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *contentType;

//- (BOOL)validateContentType:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *bitRate;

@property int bitRateValue;
- (int)bitRateValue;
- (void)setBitRateValue:(int)value_;

//- (BOOL)validateBitRate:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *coverID;

//- (BOOL)validateCoverID:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *playlistIndex;

@property int playlistIndexValue;
- (int)playlistIndexValue;
- (void)setPlaylistIndexValue:(int)value_;

//- (BOOL)validatePlaylistIndex:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *rating;

@property int ratingValue;
- (int)ratingValue;
- (void)setRatingValue:(int)value_;

//- (BOOL)validateRating:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *transcodedType;

//- (BOOL)validateTranscodedType:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *transcodeSuffix;

//- (BOOL)validateTranscodeSuffix:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *artistName;

//- (BOOL)validateArtistName:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *trackNumber;

@property int trackNumberValue;
- (int)trackNumberValue;
- (void)setTrackNumberValue:(int)value_;

//- (BOOL)validateTrackNumber:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSNumber *duration;

@property int durationValue;
- (int)durationValue;
- (void)setDurationValue:(int)value_;

//- (BOOL)validateDuration:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) NSString *genre;

//- (BOOL)validateGenre:(id*)value_ error:(NSError**)error_;




@property (nonatomic, retain) SBNowPlaying* nowPlaying;
//- (BOOL)validateNowPlaying:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) SBAlbum* album;
//- (BOOL)validateAlbum:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) SBCover* cover;
//- (BOOL)validateCover:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) SBEpisode* episode;
//- (BOOL)validateEpisode:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) SBServer* server;
//- (BOOL)validateServer:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) SBPlaylist* playlist;
//- (BOOL)validatePlaylist:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) SBTrack* remoteTrack;
//- (BOOL)validateRemoteTrack:(id*)value_ error:(NSError**)error_;



@property (nonatomic, retain) SBTrack* localTrack;
//- (BOOL)validateLocalTrack:(id*)value_ error:(NSError**)error_;




@end

@interface _SBTrack (CoreDataGeneratedAccessors)

@end

@interface _SBTrack (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAlbumName;
- (void)setPrimitiveAlbumName:(NSString*)value;




- (NSNumber*)primitiveIsPlaying;
- (void)setPrimitiveIsPlaying:(NSNumber*)value;

- (BOOL)primitiveIsPlayingValue;
- (void)setPrimitiveIsPlayingValue:(BOOL)value_;




- (NSNumber*)primitiveSize;
- (void)setPrimitiveSize:(NSNumber*)value;

- (int)primitiveSizeValue;
- (void)setPrimitiveSizeValue:(int)value_;




- (NSString*)primitiveContentSuffix;
- (void)setPrimitiveContentSuffix:(NSString*)value;




- (NSNumber*)primitiveYear;
- (void)setPrimitiveYear:(NSNumber*)value;

- (int)primitiveYearValue;
- (void)setPrimitiveYearValue:(int)value_;




- (NSString*)primitiveContentType;
- (void)setPrimitiveContentType:(NSString*)value;




- (NSNumber*)primitiveBitRate;
- (void)setPrimitiveBitRate:(NSNumber*)value;

- (int)primitiveBitRateValue;
- (void)setPrimitiveBitRateValue:(int)value_;




- (NSString*)primitiveCoverID;
- (void)setPrimitiveCoverID:(NSString*)value;




- (NSNumber*)primitivePlaylistIndex;
- (void)setPrimitivePlaylistIndex:(NSNumber*)value;

- (int)primitivePlaylistIndexValue;
- (void)setPrimitivePlaylistIndexValue:(int)value_;




- (NSNumber*)primitiveRating;
- (void)setPrimitiveRating:(NSNumber*)value;

- (int)primitiveRatingValue;
- (void)setPrimitiveRatingValue:(int)value_;




- (NSString*)primitiveTranscodedType;
- (void)setPrimitiveTranscodedType:(NSString*)value;




- (NSString*)primitiveTranscodeSuffix;
- (void)setPrimitiveTranscodeSuffix:(NSString*)value;




- (NSString*)primitiveArtistName;
- (void)setPrimitiveArtistName:(NSString*)value;




- (NSNumber*)primitiveTrackNumber;
- (void)setPrimitiveTrackNumber:(NSNumber*)value;

- (int)primitiveTrackNumberValue;
- (void)setPrimitiveTrackNumberValue:(int)value_;




- (NSNumber*)primitiveDuration;
- (void)setPrimitiveDuration:(NSNumber*)value;

- (int)primitiveDurationValue;
- (void)setPrimitiveDurationValue:(int)value_;




- (NSString*)primitiveGenre;
- (void)setPrimitiveGenre:(NSString*)value;





- (SBNowPlaying*)primitiveNowPlaying;
- (void)setPrimitiveNowPlaying:(SBNowPlaying*)value;



- (SBAlbum*)primitiveAlbum;
- (void)setPrimitiveAlbum:(SBAlbum*)value;



- (SBCover*)primitiveCover;
- (void)setPrimitiveCover:(SBCover*)value;



- (SBEpisode*)primitiveEpisode;
- (void)setPrimitiveEpisode:(SBEpisode*)value;



- (SBServer*)primitiveServer;
- (void)setPrimitiveServer:(SBServer*)value;



- (SBPlaylist*)primitivePlaylist;
- (void)setPrimitivePlaylist:(SBPlaylist*)value;



- (SBTrack*)primitiveRemoteTrack;
- (void)setPrimitiveRemoteTrack:(SBTrack*)value;



- (SBTrack*)primitiveLocalTrack;
- (void)setPrimitiveLocalTrack:(SBTrack*)value;


@end
