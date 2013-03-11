//
//  WaveformGroup.m
//  FlyingSquirrel
//
//  Created by Andy Sinesio on 3/30/11.
//  Copyright (c) 2011 Precognitive Research, LLC. All rights reserved.
//

#import "WaveformGroup.h"
#import "SFSong.h"
#import "SFWaveform.h"


@implementation WaveformGroup
@dynamic beginningFrameIndex;
@dynamic endingFrameIndex;
@dynamic song;
@dynamic waveforms;

- (BOOL) isWaveformEligibleForAddition: (SFWaveform *) waveform {
    return (self.beginningFrameIndex <= waveform.frameIndex && self.endingFrameIndex >= waveform.frameIndex);
}


- (void)removeWaveformObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"waveform" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"waveform"] removeObject:value];
    [self didChangeValueForKey:@"waveform" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addWaveformObjects:(NSSet *)value {    
    [self willChangeValueForKey:@"waveform" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"waveform"] unionSet:value];
    [self didChangeValueForKey:@"waveform" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeWaveformObjects:(NSSet *)value {
    [self willChangeValueForKey:@"waveform" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"waveform"] minusSet:value];
    [self didChangeValueForKey:@"waveform" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}


@end
