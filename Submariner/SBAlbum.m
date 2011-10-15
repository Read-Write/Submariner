#import "SBAlbum.h"
#import "SBCover.h"


@implementation SBAlbum


- (void)awakeFromInsert {
//    if(self.cover == nil) {
//        [self setCover:[SBCover insertInManagedObjectContext:self.managedObjectContext]];
//    }
}


- (NSString *) imageTitle {
    NSString *result = nil;
    
    [self willAccessValueForKey:@"albumName"];
    result = self.itemName;
    [self didAccessValueForKey:@"albumName"];
    
    return result;
}

- (NSString *) imageUID {
    NSString *result = nil;
    
    [self willAccessValueForKey:@"albumName"];
    result = self.itemName;
    [self didAccessValueForKey:@"albumName"];
    
    return result;
}

- (NSString *) imageRepresentationType {
    return IKImageBrowserNSImageRepresentationType;
}

- (id) imageRepresentation {
    NSImage *image = [NSImage imageNamed:@"NoArtwork"];
    
    if(self.cover && self.cover.imagePath) {
        image = [[[NSImage alloc] initByReferencingFile:self.cover.imagePath] autorelease];
    } 
    return image;
}

- (void)setImageRepresentation:(id)image {
    // do nothing
    [self willChangeValueForKey:@"imageRepresentation"];
    
    [self didChangeValueForKey:@"imageRepresentation"];
}

- (NSUInteger) imageVersion {
    NSImage *image = [NSImage imageNamed:@"NoArtwork"];
    NSInteger length = 0;
    
    if(self.cover && self.cover.imagePath) {
        image = [[[NSImage alloc] initByReferencingFile:self.cover.imagePath] autorelease];
    } 
    
    length = [[image TIFFRepresentation] length];
    
    return length;
}


@end
