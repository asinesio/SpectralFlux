//
//  Waveform.h
//
//  Created by Andy Sinesio on 3/30/11.
//  Copyright (c) 2012-2013 Precognitive Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#define BIN_COUNT 64

@class WaveformGroup, Song;

@interface Waveform : NSManagedObject {
@private
    float *binArray;
    BOOL allocatedArray;
}
@property (nonatomic, retain) NSNumber * flux;
@property (nonatomic, retain) NSNumber * frameIndex;
@property (nonatomic, retain) NSNumber * isPeak;
@property (nonatomic, retain) NSNumber * threshold;
@property (nonatomic, retain) NSNumber * isComplete;
@property (nonatomic, retain) NSData * binData;
@property (nonatomic, retain) NSString * songIDAndFrameIndex;
@property (nonatomic, retain) WaveformGroup * waveformGroup;

- (float) getThresholdPeakValue;
- (void) setBinsFromFloatArray:(float *) bins andBinCount: (unsigned short) binCount withContext: (NSManagedObjectContext *) managedObjectContext;
- (float *) getBinArray;
@end
