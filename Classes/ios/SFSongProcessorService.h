//
//  SongProcessorService.h
//
//  Created by Andy Sinesio on 2/27/11.
//  Copyright 2011 Precognitive Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MediaPlayer/MediaPlayer.h>
#import "SFProcessSongOperation.h"
#import "SFSongProcessorService.h"

@class SFSong;

@interface SFSongProcessorService : NSObject {
    NSOperationQueue *queue;
    SFProcessSongOperation *currentSongProcess;
    
    NSURL *currentSongAssetURL;
    BOOL doneProcessing;
    
    void (^currentSongCompletionBlock) (void);
}

@property (nonatomic, readonly) float currentSongProgress;
@property (nonatomic, readonly) SInt16 currentSongMaxBinValue;
@property (nonatomic, retain) SFSong *currentSong;

- (BOOL) mediaItemIsProtected: (MPMediaItem *) mediaItem;
- (BOOL) startProcessingSong: (MPMediaItem *) song withCompletionBlock: (void (^)(void))block;
- (void) finishProcessingSong;

@end
