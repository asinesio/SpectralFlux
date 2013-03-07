//
//  Waveform.h
//
//  Created by Andy Sinesio on 3/30/11.
//  Copyright (c) 2012-2013 Precognitive Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#define BIN_COUNT 64

@interface Waveform : NSObject<NSCoding> {

}
@property (nonatomic, retain) NSNumber * flux;
@property (nonatomic, retain) NSNumber * frameIndex;
@property (nonatomic) BOOL isPeak;
@property (nonatomic, retain) NSNumber * threshold;
@property (nonatomic, retain) NSArray * bins;
@property (nonatomic) BOOL isComplete;

- (float) getThresholdPeakValue;
- (void) setBinsFromFloatArray:(float *) rawBins andBinCount: (unsigned short) binCount;
@end
