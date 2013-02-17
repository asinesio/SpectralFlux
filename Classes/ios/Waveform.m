//
//  Waveform.m
//  FlyingSquirrel
//
//  Created by Andy Sinesio on 3/30/11.
//  Copyright (c) 2011 Precognitive Research, LLC. All rights reserved.
//

#import "Waveform.h"
#import "WaveformGroup.h"
#import "Song.h"

#define BIN_GROUP_SIZE 8
#define NORMALIZE_FACTOR 200.0f


@implementation Waveform
@dynamic flux;
@dynamic frameIndex;
@dynamic songIDAndFrameIndex;
@dynamic isPeak;
@dynamic isComplete;
@dynamic threshold;
@dynamic binData;
@dynamic waveformGroup;

-(id) init {
    self = [super init];
	if (self==nil) return nil;
    
    
    
    return self;
}
-(float) getThresholdPeakValue {
    if ([self.flux floatValue] > [self.threshold floatValue]) {
        return [self.flux floatValue] - [self.threshold floatValue];
    } else {
        return 0.0f;
    }
}

- (void) setBinsFromFloatArray:(float *) bins andBinCount: (unsigned short) binCount withContext: (NSManagedObjectContext *) managedObjectContext {
    //NSMutableArray *array = [NSMutableArray arrayWithCapacity:binCount/BIN_GROUP_SIZE];
    short currentBin = 0;
    float *normalizedBins = malloc(sizeof(float) * BIN_COUNT);
    
    for (int i = 0; i < binCount; i += BIN_GROUP_SIZE) {
        float sum = 0;
        short binSize = 0;        
        for (int j = 0; (j < BIN_GROUP_SIZE) && (i + j < binCount); j++) {
            sum += bins[i+j];
            binSize++;
        }
        if (binSize > 0) {
            float normalizedValue = sum / (binSize * NORMALIZE_FACTOR);
            //NSLog(@"Original value: %4.4f normalized value: %1.4f", sum / binSize, normalizedValue);
            normalizedValue = MIN(normalizedValue, 1.0f);
            normalizedBins[currentBin] = normalizedValue;
            
            //Bin * bin = [[[NSEntityDescription
            //   insertNewObjectForEntityForName:@"Bin"
            //   inManagedObjectContext:managedObjectContext] retain] autorelease];
            //bin.index = [NSNumber numberWithShort:currentBin];
            //bin.value = [NSNumber numberWithFloat:normalizedValue];
            //bin.waveform = self;
        }
        currentBin++;
    }
    [self willChangeValueForKey:@"binData"];
    self.binData = [NSData dataWithBytes:normalizedBins length:(sizeof(float) * BIN_COUNT)];
    [self didChangeValueForKey:@"binData"];
    free(normalizedBins);
}

- (float *) getBinArray {
    
    if (!binArray) {
        [self willAccessValueForKey:@"binData"];
        NSData * data = self.binData;
        [self didAccessValueForKey:@"binData"];
        binArray = malloc(sizeof(float) * BIN_COUNT);
        [data getBytes:binArray length:sizeof(float) * BIN_COUNT];
    }
    return binArray;
}

- (void) didTurnIntoFault {
    [super didTurnIntoFault];
    if (binArray)
        free(binArray);
}



@end
