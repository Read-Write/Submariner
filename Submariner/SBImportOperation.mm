//
//  SBImportOperation.m
//  Submariner
//
//  Created by nark on 06/06/11.
//  Copyright 2011 OPALE. All rights reserved.
//

#import "SBImportOperation.h"
#import <CoreServices/CoreServices.h>
#import <QTKit/QTKit.h>

#import <SFBAudioEngine/AudioDecoder.h>
#import <SFBAudioEngine/AudioMetadata.h>

//#import <taglib/taglib.h>
//#import <taglib/fileref.h>
//#import <taglib/tag.h>
//#import <taglib/tstring.h>

#import "SBAppDelegate.h"

#import "SBLibrary.h"
#import "SBArtist.h"
#import "SBAlbum.h"
#import "SBTrack.h"
#import "SBCover.h"

#import "NSURL+Parameters.h"
#import "NSManagedObjectContext+Fetch.h"




//using namespace TagLib;



@interface SBImportOperation (Private)
- (NSArray *)audioFilesAtPath:(NSString *)path;
@end



@implementation SBImportOperation



@synthesize filePaths;
@synthesize libraryID;
@synthesize copy;
@synthesize remove;
@synthesize remoteTrackID;



- (id)initWithManagedObjectContext:(NSManagedObjectContext *)mainContext {
    self = [super initWithManagedObjectContext:mainContext];
    if (self) {
        copy = NO;
        remove = NO;
    }
    return self;
}



- (void)main {
    NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
    
    @try {
        
        NSMutableArray *audioFiles = [NSMutableArray array];
        
        SBLibrary *library = (SBLibrary *)[[self threadedContext] objectWithID:libraryID];
        
        for(NSString *path in self.filePaths) {
            [audioFiles addObjectsFromArray:[self audioFilesAtPath:path]];
        }
        
#if DEBUG
        NSLog(@"INFO : %ld files to import...", [audioFiles count]);
#endif
        
        for(NSString *aPath in audioFiles) {
            
            NSString *path = [[[NSURL temporaryFileURL] absoluteString] stringByAppendingPathExtension:@"mp3"];
            //NSLog(@"temp path : %@", path);
            [[NSFileManager defaultManager] copyItemAtPath:aPath toPath:path error:nil];
            //NSDictionary *dict = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
            //NSLog(@"temp path size : %@", [dict valueForKey:NSFileSize]);
            
            NSPredicate *predicate = nil;
            
            NSString *titleString       = nil;
            NSString *artistString      = nil;  
            NSString *albumString       = nil;   
            NSString *genreString       = nil;  
            NSString *contentType       = nil;   
            NSNumber *trackNumber       = nil;   
            NSNumber *durationNumber    = nil;
            NSNumber *bitRateNumber     = nil;
            NSData   *coverData         = nil;   
            
            NSError *fetchError = nil;
            SBArtist *newArtist = nil;
            SBAlbum *newAlbum = nil;
            SBTrack *newTrack = nil;
            
            NSError *copyError = nil;
            NSString *artistPath = nil;
            NSString *albumPath = nil;
            NSString *trackPath = nil;
            
            // use SFBAudioEngine
            CFURLRef fileURL = CFURLCreateFromFileSystemRepresentation(kCFAllocatorDefault, 
                                                                       reinterpret_cast<const UInt8 *>([path UTF8String]), 
                                                                       strlen([path UTF8String]), 
                                                                       FALSE);
            
            AudioMetadata *metadata =  AudioMetadata::CreateMetadataForURL(fileURL);
            CFRelease(fileURL), fileURL = NULL;
            
            if(NULL != metadata) {
                if(!remoteTrackID) {
                    
                    // get file metadata
                    titleString       = (NSString *)metadata->GetTitle(); 
                    artistString      = (NSString *)metadata->GetArtist();
                    albumString       = (NSString *)metadata->GetAlbumTitle();
                    genreString       = (NSString *)metadata->GetGenre();
                    trackNumber       = (NSNumber *)metadata->GetTrackNumber();
                    durationNumber    = (NSNumber *)metadata->GetDuration();
                    bitRateNumber     = (NSNumber *)metadata->GetBitrate();
                    coverData         = (NSData   *)metadata->GetFrontCoverArt();
                    
                    // if this is a cache or download data importation
                } else {
                    // use remote track metadata
                    SBTrack *remoteTrack = (SBTrack *)[[self threadedContext] objectWithID:remoteTrackID];
                    
                    titleString       = remoteTrack.itemName;
                    artistString      = remoteTrack.artistString;
                    albumString       = remoteTrack.albumString;
                    genreString       = remoteTrack.genre;
                    trackNumber       = remoteTrack.trackNumber;
                    durationNumber    = remoteTrack.duration;
                    bitRateNumber     = remoteTrack.bitRate;
                    contentType       = remoteTrack.contentType;
                    coverData         = (NSData   *)metadata->GetFrontCoverArt();
                }
            }
            
            
            // use of taglib
//            TagLib::FileRef audioFile([path UTF8String]);  
//            QTMovie *audioSound = [[QTMovie alloc] initWithFile:path error:nil];
//            
//            // get file duration
//            NSTimeInterval durationInterval = nil;
//            QTGetTimeInterval([audioSound duration], &durationInterval);
//            
//            // if this is a local file importation
//            if(!remoteTrackID) {
//                // get file metadata
//                titleString       = [NSString stringWithUTF8String:audioFile.tag()->title().toCString()];
//                artistString      = [NSString stringWithUTF8String:audioFile.tag()->artist().toCString()];
//                albumString       = [NSString stringWithUTF8String:audioFile.tag()->album().toCString()];
//                genreString       = [NSString stringWithUTF8String:audioFile.tag()->genre().toCString()];
//                trackNumber       = [NSNumber numberWithUnsignedInt:audioFile.tag()->track()];
//                durationNumber    = [NSNumber numberWithDouble:durationInterval];
//                bitRateNumber     = [NSNumber numberWithFloat:[audioSound rate]];
//                coverData         = nil;
//            
//            // if this is a cache or download data importation
//            } else {
//                // use remote track metadata
//                SBTrack *remoteTrack = (SBTrack *)[[self threadedContext] objectWithID:remoteTrackID];
//                
//                titleString       = remoteTrack.itemName;
//                artistString      = remoteTrack.artistString;
//                albumString       = remoteTrack.albumString;
//                genreString       = remoteTrack.genre;
//                trackNumber       = remoteTrack.trackNumber;
//                durationNumber    = remoteTrack.duration;
//                bitRateNumber     = remoteTrack.bitRate;
//                coverData         = nil;
//            }
            
            // create artist object if needed
            if(!artistString || [artistString isEqualToString:@""])
                artistString = @"Unknow Artist";
            
            predicate = [NSPredicate predicateWithFormat:@"(itemName == %@) && (server == nil)", artistString];
            newArtist = [[self threadedContext] fetchEntityNammed:@"Artist" withPredicate:predicate error:&fetchError];
            
            if(newArtist == nil) {
                newArtist = [SBArtist insertInManagedObjectContext:[self threadedContext]];
                [newArtist setItemName:artistString];
            }
            
            // create album if needed
            if(!albumString || [albumString isEqualToString:@""]) 
                albumString = @"Unknow Album";
            
            predicate = [NSPredicate predicateWithFormat:@"(itemName == %@) && (artist == %@)", albumString, newArtist];
            newAlbum = [[self threadedContext] fetchEntityNammed:@"Album" withPredicate:predicate error:&fetchError];
            
            if(newAlbum == nil) {
                newAlbum = [SBAlbum insertInManagedObjectContext:[self threadedContext]];
                [newAlbum setItemName:albumString];
            }
            
            // create track if needed
            if(!titleString || [titleString isEqualToString:@""]) 
                titleString = @"Unknow Track";
            
            predicate = [NSPredicate predicateWithFormat:@"(itemName == %@) && (server == nil)", titleString];
            newTrack = [[self threadedContext] fetchEntityNammed:@"Track" withPredicate:predicate error:&fetchError];
            
            if(newTrack == nil) {
                newTrack = [SBTrack insertInManagedObjectContext:[self threadedContext]];
                [newTrack setItemName:titleString];
                
                if(bitRateNumber)
                    [newTrack setBitRate:bitRateNumber];
                
                if(durationNumber)
                    [newTrack setDuration:durationNumber];
                
                if(trackNumber)
                    [newTrack setTrackNumber:trackNumber];
                
                if(genreString)
                    [newTrack setGenre:genreString];
                
                if(contentType)
                    [newTrack setContentType:contentType];
            }
            
            if(![newAlbum.tracks containsObject:newTrack]) {
                [newAlbum addTracksObject:newTrack];
            }
            
            if(![newArtist.albums containsObject:newAlbum]) {
                [newArtist addAlbumsObject:newAlbum];
            }
            
            if(![library.artists containsObject:newArtist]) {
                [library addArtistsObject:newArtist];
            }

            
            // treat copy
            if(copy == YES) {
                artistPath = [[[SBAppDelegate sharedInstance] musicDirectory] stringByAppendingPathComponent:artistString];
                albumPath = [artistPath stringByAppendingPathComponent:albumString];
                trackPath = [albumPath stringByAppendingPathComponent:[path lastPathComponent]];
                
                // create artist and album directory if needed
                [[NSFileManager defaultManager] createDirectoryAtPath:albumPath withIntermediateDirectories:YES attributes:nil error:&copyError];
                
                // copy track to new destination
                [[NSFileManager defaultManager] copyItemAtPath:path toPath:trackPath error:&copyError];
                
                [newTrack setPath:trackPath];
                [newAlbum setPath:albumPath];
                [newArtist setPath:artistPath];
                
            } else {
                [newTrack setPath:aPath];
            }
            
//            // work with the cover
//            if (coverData) {
//                // if file metadata contains the cover art data
//                NSString *coverDir = [[SBAppDelegate sharedInstance] coverDirectory];
//                NSString *artistCoverDir = [coverDir stringByAppendingPathComponent:artistString];
//                if(![[NSFileManager defaultManager] fileExistsAtPath:artistCoverDir]) {
//                    [[NSFileManager defaultManager] createDirectoryAtPath:artistCoverDir withIntermediateDirectories:YES attributes:nil error:nil];
//                }
//                NSString *finalPath = [artistCoverDir stringByAppendingPathComponent:albumString];
//                [coverData writeToFile:finalPath atomically:YES];
//            
//                [newAlbum.cover setImagePath:finalPath];
//                [newTrack.cover setImagePath:finalPath];
//            
//            } else {
//                // else if track parent directory contains cover file
//                NSString *originalAlbumFolder = [path stringByDeletingLastPathComponent];
//                BOOL isDir;
//        
//                if([[NSFileManager defaultManager] fileExistsAtPath:originalAlbumFolder isDirectory:&isDir] && isDir) {
//                    NSArray *albumFiles = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:originalAlbumFolder error:nil];
//                    for(NSString *fileName in albumFiles) {
//                        NSString *filePath = [originalAlbumFolder stringByAppendingPathComponent:fileName];
//                        
//                        CFStringRef fileExtension = (CFStringRef) [filePath pathExtension];
//                        CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
//                        
//                        // if the current file is an image
//                        if (UTTypeConformsTo(fileUTI, kUTTypeImage)) {
//                            // if it doesn't contain "back" word
//                            if([fileName rangeOfString:@"back"].location == NSNotFound) {
//                                // copy the artwork
//                                NSString *coverDir = [[SBAppDelegate sharedInstance] coverDirectory];
//                                NSString *artistCoverDir = [coverDir stringByAppendingPathComponent:artistString];
//                                if(![[NSFileManager defaultManager] fileExistsAtPath:artistCoverDir]) {
//                                    [[NSFileManager defaultManager] createDirectoryAtPath:artistCoverDir withIntermediateDirectories:YES attributes:nil error:nil];
//                                }
//                                NSString *finalPath = [artistCoverDir stringByAppendingPathComponent:fileName];
//                                [[NSFileManager defaultManager] copyItemAtPath:filePath toPath:finalPath error:nil];
//                                [newAlbum.cover setImagePath:finalPath];
//                                [newTrack.cover setImagePath:finalPath];
//                            }
//                        }
//                    }
//                }
//            }
            
            // set if items are linked or not
            [newTrack setIsLinked:[NSNumber numberWithBool:!copy]];
            [newAlbum setIsLinked:[NSNumber numberWithBool:!copy]];
            [newArtist setIsLinked:[NSNumber numberWithBool:!copy]];
            
            // set items are local items
            [newTrack setIsLocal:[NSNumber numberWithBool:YES]];
            [newAlbum setIsLocal:[NSNumber numberWithBool:YES]];
            [newArtist setIsLocal:[NSNumber numberWithBool:YES]];
            
            // check remove
            if(remove) {
                [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
            }
            
            // check if this import op comes from a stream
            if(remoteTrackID != nil) {
                // attach local track and remote track
                // to enhance caching capacities
                SBTrack *remoteTrack = (SBTrack *)[[self threadedContext] objectWithID:remoteTrackID];
                [remoteTrack setLocalTrack:newTrack];
                [newTrack setRemoteTrack:remoteTrack];
                
                if(newAlbum.cover == nil)
                    [newAlbum setCover:[SBCover insertInManagedObjectContext:[self threadedContext]]];
                    
                [newAlbum.cover setImagePath:remoteTrack.album.cover.imagePath];
            }
            
            // remove temp file
            [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"EXCEPTION : %@", exception);
    }
    @finally {
        [self saveThreadedContext];
        [self finish];
    }
    
    [pool release];
}



/** Highly recursive */
- (NSArray *)audioFilesAtPath:(NSString *)path {
    
    NSMutableArray *result = [NSMutableArray array];
    NSFileManager *fm = [NSFileManager defaultManager];
    BOOL isDir;
    
    if([fm fileExistsAtPath:path isDirectory:&isDir] && isDir) {
        
        NSArray *content = [fm contentsOfDirectoryAtPath:path error:nil];
        for(NSString *fileName in content) {
            NSString *newPath = [path stringByAppendingPathComponent:fileName];
            [result addObjectsFromArray:[self audioFilesAtPath:newPath]];
        }
        
    } else if(!isDir) {
        
        CFStringRef fileExtension = (CFStringRef) [path pathExtension];
        CFStringRef fileUTI = UTTypeCreatePreferredIdentifierForTag(kUTTagClassFilenameExtension, fileExtension, NULL);
        
        // if the current file is an image
        if (UTTypeConformsTo(fileUTI, kUTTypeAudio) && [[path pathExtension] isEqualToString:@"mp3"]) {
            [result addObject:path];
        }
    }
    return result;
}


@end
