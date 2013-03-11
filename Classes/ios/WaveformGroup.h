//
//  WaveformGroup.h
//  FlyingSquirrel
//
//  Created by Andy Sinesio on 3/30/11.
//  Copyright (c) 2011 Precognitive Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class SFSong;
@class SFWaveform;

@interface WaveformGroup : NSManagedObject {
@private
}
@property (nonatomic, retain) NSNumber * beginningFrameIndex;
@property (nonatomic, retain) NSNumber * endingFrameIndex;
@property (nonatomic, retain) SFSong * song;
@property (nonatomic, retain) NSSet * waveforms;

- (BOOL) isWaveformEligibleForAddition: (SFWaveform *) waveform;

@end

@interface WaveformGroup (WaveformGroupAccessors)

- (void)addWaveformsObject:(SFWaveform *)value;

@end