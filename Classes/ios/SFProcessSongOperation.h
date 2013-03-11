//
//  ProcessSongOperation.h
//  
//
//  Created by Andy Sinesio on 2/27/11.
//  Copyright 2011 Precognitive Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Accelerate/Accelerate.h>
#import <AudioToolbox/AudioToolbox.h>
#import <AVFoundation/AVFoundation.h>

@interface SFProcessSongOperation : NSOperation {
    unsigned long currentFrameIndex;

    float *previousFloatSamples;
    SInt16 maxBinValue;
    float percentComplete;
    unsigned long totalSamples;
    
    int totalPeaks;
    
    NSMutableArray *recentWaveforms;
    AVURLAsset *songURL;
    
}

@property (nonatomic, readonly) SInt16 maxBinValue;
@property (nonatomic, readonly) float percentComplete;  // progress, between 0 and 1


- (id)initWithSong:(AVURLAsset *) songURLToProcess;

@end
