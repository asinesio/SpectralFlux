//
//  DataService.m
//  FlyingSquirrel
//
//  Created by Andy Sinesio on 3/30/11.
//  Copyright 2011 Precognitive Research, LLC. All rights reserved.
//

#import "DataService.h"

#define TEMP_DIR_NAME @"/spectralFlux"

@interface DataService (PrivateMethods)

- (NSURL *) applicationDocumentsDirectory;
- (void) clearTempFile;
- (NSString *) getUUID;

@property (nonatomic, retain) NSFileHandle *tempFile;
@property (nonatomic, retain) NSString *tempFilePath;

@end

@implementation DataService


- (id) init {
    if (self = [super init]) {
        // set up temp dir and properties
        NSString *tempDir = [NSTemporaryDirectory() stringByAppendingPathComponent:TEMP_DIR_NAME];
        BOOL result = [[NSFileManager defaultManager] createDirectoryAtPath:tempDir
                                                withIntermediateDirectories:YES
                                                                 attributes:nil
                                                                      error:nil];
        if (result) {
            // got a temp dir
            self.tempFilePath = [tempDir stringByAppendingPathComponent:[self getUUID]];
            self.tempFile = [NSFileHandle fileHandleForUpdatingAtPath:self.tempFilePath];
            
        } else {
            NSLog(@"Error creating temporary file at %@, cannot save song.", tempDir);
        }
    }
    return self;
}

-(void) appendWaveform:(SFWaveform *)waveform {
    //TODO implement
}

-(SFWaveform *) getWaveformAtIndex:(NSNumber *)index {
    //TODO implement this too
    return nil;
}
-(BOOL) isWriteComplete {
    return NO;
}

#pragma mark - Application's Documents directory

/**
 Returns the URL to the application's Documents directory.
 */
- (NSURL *)applicationDocumentsDirectory {
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

-(NSString *)getUUID {
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
  //  NSString * uuidString = (__bridge_transfer NSString *) CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    NSString * uuidString = (NSString *) CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    CFRelease(newUniqueId);
    return uuidString;
}


@end
