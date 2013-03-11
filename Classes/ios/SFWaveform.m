//
//  Waveform.m
//  FlyingSquirrel
//
//  Created by Andy Sinesio on 3/30/11.
//  Copyright (c) 2011 Precognitive Research, LLC. All rights reserved.
//

#import "SFWaveform.h"

#define BIN_GROUP_SIZE 8
#define NORMALIZE_FACTOR 200.0f

#define FLUX_KEY @"flux"
#define FRAME_KEY @"frame"
#define PEAK_KEY @"peak"
#define THRESHOLD_KEY @"threshold"
#define BINS_KEY @"bins"
#define COMPLETE_KEY @"complete"

@interface SFWaveform (PrivateMethods)

@end

@implementation SFWaveform
@synthesize flux;
@synthesize frameIndex;
@synthesize isPeak;
@synthesize threshold;
@synthesize bins;

-(id) init {
    self = [super init];
	if (self==nil) return nil;
    return self;
}

-(id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.flux = [aDecoder decodeObjectForKey:FLUX_KEY];
        self.frameIndex = [aDecoder decodeObjectForKey:FRAME_KEY];
        self.isPeak = [aDecoder decodeBoolForKey:PEAK_KEY];
        self.isComplete = [aDecoder decodeBoolForKey:COMPLETE_KEY];
        self.threshold = [aDecoder decodeObjectForKey:THRESHOLD_KEY];
        self.bins = [aDecoder decodeObjectForKey:BINS_KEY];
    }
    return self;
}

-(void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.flux forKey:FLUX_KEY];
    [aCoder encodeObject:self.frameIndex forKey:FRAME_KEY];
    [aCoder encodeBool:self.isPeak forKey:PEAK_KEY];
    [aCoder encodeBool:self.isComplete forKey:COMPLETE_KEY];
    [aCoder encodeObject:self.threshold forKey:THRESHOLD_KEY];
    [aCoder encodeObject:self.bins forKey:BINS_KEY];
}

-(float) getThresholdPeakValue {
    if ([self.flux floatValue] > [self.threshold floatValue]) {
        return [self.flux floatValue] - [self.threshold floatValue];
    } else {
        return 0.0f;
    }
}

- (void) setBinsFromFloatArray:(float *) rawBins andBinCount: (unsigned short) binCount {
    NSMutableArray *convertedBins = [NSMutableArray arrayWithCapacity:binCount];
    for (int i = 0; i < binCount; i++) {
        [convertedBins insertObject:[NSNumber numberWithFloat:rawBins[i]] atIndex:i];
    }
    self.bins = convertedBins;
}


@end
