//
//  Song.m
//  FlyingSquirrel
//
//  Created by Andy Sinesio on 3/30/11.
//  Copyright (c) 2011 Precognitive Research, LLC. All rights reserved.
//

#import "Song.h"
#import "Waveform.h"
#import "WaveformGroup.h"
#import "DataService.h"

#define FRAMES_PER_GROUP 500

#define GET_SONG_AND_FRAME_INDEX(frameIndex) [NSString stringWithFormat:@"%@_%@",self.url, frameIndex]

@interface Song (PrivateMethods) 
- (void) replaceCachedWaveformGroup: (WaveformGroup *) newWaveformGroup withContext: (NSManagedObjectContext *) context;
@end

@implementation Song
@dynamic artist;
@dynamic title;
@dynamic url;
@dynamic duration;
@dynamic beatsPerMinute;
@dynamic sampleRate;
@dynamic complete;
@dynamic waveformGroups;


- (void) addWaveform:(Waveform *)waveform withContext:(NSManagedObjectContext *)context {
    // find the proper group for this waveform
    waveform.songIDAndFrameIndex = GET_SONG_AND_FRAME_INDEX(waveform.frameIndex);
    if (cachedWaveformGroup != nil) {
        if ([cachedWaveformGroup isWaveformEligibleForAddition:waveform]) {
            [cachedWaveformGroup addWaveformsObject:waveform];
            return;
        }
    }
    NSEnumerator *enumerator = [self.waveformGroups objectEnumerator];

    WaveformGroup *waveformGroup;
    while ((waveformGroup = [enumerator nextObject])) {
        if ([waveformGroup isWaveformEligibleForAddition:waveform]) {
            // Found a match.  Replace cached value.
            [self replaceCachedWaveformGroup:waveformGroup withContext:context];
            [waveformGroup addWaveformsObject:waveform];
            return;
        }
    }
    // if we make it here, there is no matching waveform group yet!
    //waveformGroup = [[[WaveformGroup alloc] init] autorelease];
    waveformGroup = [[[NSEntityDescription
                       insertNewObjectForEntityForName:@"WaveformGroup"
                       inManagedObjectContext:context] retain] autorelease];
    
    
    if (waveformGroup != nil) {
        waveformGroup.beginningFrameIndex = waveform.frameIndex;
        waveformGroup.endingFrameIndex = [NSNumber numberWithLong:[waveform.frameIndex longValue] + FRAMES_PER_GROUP];
        [self addWaveformGroupsObject:waveformGroup];
        
        waveform.waveformGroup = waveformGroup;
        [self replaceCachedWaveformGroup:waveformGroup withContext:context];
        
    }
}

- (void) clearWithContext: (NSManagedObjectContext *) context {
    // Delete all waveform groups
    [cachedWaveformGroup release];
    cachedWaveformGroup = nil;
    [futureCachedWaveformGroup release];
    futureCachedWaveformGroup = nil;
    [self.waveformGroups enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
        [context deleteObject:obj];
    }];
}

// Doesn't handle future yet....
- (void) replaceCachedWaveformGroup: (WaveformGroup *) newWaveformGroup withContext: (NSManagedObjectContext *) context {
    if (previousCachedWaveformGroup != nil) {
        // Turn the existing cached waveform into a Fault to save memory.
        
      //  [context refreshObject:previousCachedWaveformGroup mergeChanges:YES];
        [previousCachedWaveformGroup release];
    }
    previousCachedWaveformGroup = cachedWaveformGroup;
    cachedWaveformGroup = newWaveformGroup;
    [cachedWaveformGroup retain];
}

- (void)addWaveformGroupsObject:(WaveformGroup *)value {    
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"waveformGroups"] addObject:value];
    [self didChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (NSPredicate *) getWaveformByFrameIndexPredicateTemplate {
    if (waveformByFrameIndexPredicateTemplate == nil) {
        waveformByFrameIndexPredicateTemplate = [[NSPredicate predicateWithFormat:
                                                  @"songIDAndFrameIndex == $SONG_ID_AND_WAVEFORM_INDEX"] retain];
    }
    return waveformByFrameIndexPredicateTemplate;
}

- (long) waveformCount {
    NSEnumerator *enumerator = [self.waveformGroups objectEnumerator];
    WaveformGroup *waveformGroup;
    WaveformGroup *lastWaveformGroup = nil;
    while ((waveformGroup = [enumerator nextObject])) {
        if (lastWaveformGroup == nil || waveformGroup.endingFrameIndex > lastWaveformGroup.endingFrameIndex) {
            lastWaveformGroup = waveformGroup;
        }
    }
    int lastWaveformGroupSize = 0;
    if (lastWaveformGroup != nil) {
        [lastWaveformGroup.waveforms count];
    }
    unsigned long totalWaveforms = ([self.waveformGroups count] - 1 ) * FRAMES_PER_GROUP + lastWaveformGroupSize;
    NSLog(@"Total frames in song: %ld" ,totalWaveforms);
    
    return totalWaveforms;
    
}

- (Waveform *) getWaveformAtIndex: (unsigned long) index withContext: (NSManagedObjectContext *) context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [[[NSEntityDescription 
                                     entityForName:@"Waveform" inManagedObjectContext:context] retain] autorelease];
    [fetchRequest setEntity:entity];
    
    NSDictionary *variables = [[NSDictionary alloc] initWithObjectsAndKeys:
                               GET_SONG_AND_FRAME_INDEX([NSNumber numberWithLong:index]) , @"SONG_ID_AND_WAVEFORM_INDEX",
                               nil];
    NSPredicate *predicate = [[self getWaveformByFrameIndexPredicateTemplate]
                              predicateWithSubstitutionVariables:variables];
    [fetchRequest setPredicate:predicate];
    
    [fetchRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObject:@"bins"]];
    
    NSError *error = nil;
    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
    [fetchRequest release];
    [variables release];
    
    if (fetchedObjects != nil && [fetchedObjects count] > 0) {
        return [fetchedObjects objectAtIndex:0];
    } else {
        NSLog(@"Error reading waveform with index: %ld", index);
    }
    return nil;
}

- (void)removeWaveformGroupsObject:(NSManagedObject *)value {
    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
    [self willChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [[self primitiveValueForKey:@"waveformGroups"] removeObject:value];
    [self didChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
    [changedObjects release];
}

- (void)addWaveformGroups:(NSSet *)value {    
    [self willChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"waveformGroups"] unionSet:value];
    [self didChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
}

- (void)removeWaveformGroups:(NSSet *)value {
    [self willChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
    [[self primitiveValueForKey:@"waveformGroups"] minusSet:value];
    [self didChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
}

- (void) dealloc {
    [super dealloc];
    [cachedWaveformGroup release]; cachedWaveformGroup = nil;
    [futureCachedWaveformGroup release]; futureCachedWaveformGroup = nil;
    [previousCachedWaveformGroup release]; previousCachedWaveformGroup = nil;
    [waveformByFrameIndexPredicateTemplate release]; waveformByFrameIndexPredicateTemplate = nil;
}

@end
