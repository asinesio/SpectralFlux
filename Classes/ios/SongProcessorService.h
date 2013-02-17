//
//  SongProcessorService.h
//
//  Created by Andy Sinesio on 2/27/11.
//  Copyright 2011 Precognitive Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "ProcessSongOperation.h"
#import "SongProcessorService.h"

@class Song;

@interface SongProcessorService : NSObject {
    NSOperationQueue *queue;
    ProcessSongOperation *currentSongProcess;
    Song *currentSong;

    NSURL *currentSongAssetURL;
    BOOL doneProcessing;
    
    void (^currentSongCompletionBlock) (void);
}

@property (nonatomic, readonly) float currentSongProgress;
@property (nonatomic, readonly) SInt16 currentSongMaxBinValue;
@property (nonatomic, retain) Song *currentSong;

- (BOOL) mediaItemIsProtected: (MPMediaItem *) mediaItem;
- (BOOL) startProcessingSong: (Song *) song withCompletionBlock: (void (^)(void))block;
- (void) finishProcessingSong;

+ (SongProcessorService *) sharedSongProcessorService;
@end
