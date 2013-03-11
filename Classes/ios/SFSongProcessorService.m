//
//  SongProcessorService.m
//  
//
//  Created by Andy Sinesio on 2/27/11.
//  Copyright 2011 Precognitive Research, LLC. All rights reserved.
//

#import "SFSongProcessorService.h"

@implementation SFSongProcessorService

@synthesize currentSong;


/**
 * This code graciously donated by Jon Steinmetz of Pixel Research Labs.
 */
- (BOOL) mediaItemIsProtected: (MPMediaItem*) mediaItem {
    if( mediaItem == nil ) {
        return NO;
    }
    NSNumber* protectedFlag = [ mediaItem valueForProperty: @"protected" ];
    if( protectedFlag ) {
        return [ protectedFlag boolValue ];
    }
    NSURL* url = [ mediaItem valueForProperty: MPMediaItemPropertyAssetURL ];
    if( url == nil ) {
        return YES;
    }
    NSString* extension = [ url pathExtension ];
    if( [ extension isEqualToString: @"m4p" ] ) {
        return YES;
    }
    
    NSDictionary* assetOptions = [ NSDictionary dictionaryWithObjectsAndKeys:
                                  [ NSNumber numberWithBool: NO ], AVURLAssetPreferPreciseDurationAndTimingKey,
                                  nil ];
    AVAsset* asset = [ AVURLAsset URLAssetWithURL: url 
                                          options: assetOptions ];
    if( [ asset respondsToSelector: @selector( hasProtectedContent ) ]
       && [ asset hasProtectedContent ] ) {
        return YES;
    }
    
    return NO;
}

-(void) finishProcessingSong {
    NSLog(@"Done processing.");
    doneProcessing = YES;
    if (currentSongCompletionBlock != nil)
        currentSongCompletionBlock();
}

// Returns YES if we can process the song, NO otherwise.
- (BOOL) startProcessingSong: (MPMediaItem *) songToProcess withCompletionBlock: (void (^)(void))block {
    @synchronized(self) {
        //if (currentSongProcess == nil) {
        [currentSongProcess release];
        currentSongProcess = nil;
        
        currentSongProcess = [[SFProcessSongOperation alloc] initWithSong:[songToProcess valueForProperty:MPMediaItemPropertyAssetURL]];
        
        currentSongCompletionBlock = [block copy];
        
        [currentSongProcess setCompletionBlock:^ {
            NSLog(@"Completion block called.");
        }];
        [currentSongProcess addObserver:self forKeyPath:@"isFinished" options:0 context:currentSongProcess];
        [queue addOperation:currentSongProcess];
        return YES;
        //   } 
    }
    return NO;
    
}

- (float) currentSongProgress {
    if (currentSongProcess != nil)
        return currentSongProcess.percentComplete;
    else
        return 0.0f;
}

- (SInt16) currentSongMaxBinValue {
    if (currentSongProcess != nil)
        return currentSongProcess.maxBinValue;
    else
        return 1;
}

- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context {
    NSLog(@"Received notification of process complete");
    if (context == currentSongProcess)
        [self performSelectorOnMainThread:@selector(finishProcessingSong) withObject:nil waitUntilDone:NO];
}

- (id) init {
	if( (self=[super init]) ) {
		// Setup values here
		queue = [[NSOperationQueue alloc] init];
	}
	return self;
}

- (void) dealloc {
    [super dealloc];
    [queue release]; queue = nil;
    [currentSongProcess release]; currentSongProcess = nil;
}

@end
