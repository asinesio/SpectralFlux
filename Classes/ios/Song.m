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

#define TITLE_KEY @"title"
#define ARTIST_KEY @"artist"
#define URL_KEY @"url"
#define DURATION_KEY @"duration"
#define BPM_KEY @"beatsPerMin"
#define SAMPLE_KEY @"sampleRate"
#define COMPLETE_KEY @"complete"

@interface Song (PrivateMethods) 
    
@end

@implementation Song

@synthesize artist;
@synthesize title;
@synthesize url;
@synthesize duration;
@synthesize beatsPerMinute;
@synthesize sampleRate;
@synthesize complete;

- (id)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (id) initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        self.artist = [aDecoder decodeObjectForKey:ARTIST_KEY];
        self.title = [aDecoder decodeObjectForKey:TITLE_KEY];
        self.url = [aDecoder decodeObjectForKey:URL_KEY];
        self.duration = [aDecoder decodeObjectForKey:DURATION_KEY];
        self.beatsPerMinute = [aDecoder decodeObjectForKey:BPM_KEY];
        self.sampleRate = [aDecoder decodeObjectForKey:SAMPLE_KEY];
        self.complete = [aDecoder decodeBoolForKey:COMPLETE_KEY];
    }
    return self;
}

- (void) encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.artist forKey:ARTIST_KEY];
    [aCoder encodeObject:self.title forKey:TITLE_KEY];
    [aCoder encodeObject:self.url forKey:URL_KEY];
    [aCoder encodeObject:self.duration forKey:DURATION_KEY];
    [aCoder encodeObject:self.beatsPerMinute forKey:BPM_KEY];
    [aCoder encodeObject:self.sampleRate forKey:SAMPLE_KEY];
    [aCoder encodeBool:self.complete forKey:COMPLETE_KEY];
}

//- (void) addWaveform:(Waveform *)waveform withContext:(NSManagedObjectContext *)context {
//    // find the proper group for this waveform
//    waveform.songIDAndFrameIndex = GET_SONG_AND_FRAME_INDEX(waveform.frameIndex);
//    if (cachedWaveformGroup != nil) {
//        if ([cachedWaveformGroup isWaveformEligibleForAddition:waveform]) {
//            [cachedWaveformGroup addWaveformsObject:waveform];
//            return;
//        }
//    }
//    NSEnumerator *enumerator = [self.waveformGroups objectEnumerator];
//
//    WaveformGroup *waveformGroup;
//    while ((waveformGroup = [enumerator nextObject])) {
//        if ([waveformGroup isWaveformEligibleForAddition:waveform]) {
//            // Found a match.  Replace cached value.
//            [self replaceCachedWaveformGroup:waveformGroup withContext:context];
//            [waveformGroup addWaveformsObject:waveform];
//            return;
//        }
//    }
//    // if we make it here, there is no matching waveform group yet!
//    //waveformGroup = [[[WaveformGroup alloc] init] autorelease];
//    waveformGroup = [[[NSEntityDescription
//                       insertNewObjectForEntityForName:@"WaveformGroup"
//                       inManagedObjectContext:context] retain] autorelease];
//    
//    
//    if (waveformGroup != nil) {
//        waveformGroup.beginningFrameIndex = waveform.frameIndex;
//        waveformGroup.endingFrameIndex = [NSNumber numberWithLong:[waveform.frameIndex longValue] + FRAMES_PER_GROUP];
//        [self addWaveformGroupsObject:waveformGroup];
//        
//        waveform.waveformGroup = waveformGroup;
//        [self replaceCachedWaveformGroup:waveformGroup withContext:context];
//        
//    }
//}

//- (void) clearWithContext: (NSManagedObjectContext *) context {
//    // Delete all waveform groups
//    [cachedWaveformGroup release];
//    cachedWaveformGroup = nil;
//    [futureCachedWaveformGroup release];
//    futureCachedWaveformGroup = nil;
//    [self.waveformGroups enumerateObjectsUsingBlock:^(id obj, BOOL *stop) {
//        [context deleteObject:obj];
//    }];
//}

// Doesn't handle future yet....
//- (void) replaceCachedWaveformGroup: (WaveformGroup *) newWaveformGroup withContext: (NSManagedObjectContext *) context {
//    if (previousCachedWaveformGroup != nil) {
//        // Turn the existing cached waveform into a Fault to save memory.
//        
//      //  [context refreshObject:previousCachedWaveformGroup mergeChanges:YES];
//        [previousCachedWaveformGroup release];
//    }
//    previousCachedWaveformGroup = cachedWaveformGroup;
//    cachedWaveformGroup = newWaveformGroup;
//    [cachedWaveformGroup retain];
//}

//- (void)addWaveformGroupsObject:(WaveformGroup *)value {    
//    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
//    [self willChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
//    [[self primitiveValueForKey:@"waveformGroups"] addObject:value];
//    [self didChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:changedObjects];
//    [changedObjects release];
//}
//
//- (NSPredicate *) getWaveformByFrameIndexPredicateTemplate {
//    if (waveformByFrameIndexPredicateTemplate == nil) {
//        waveformByFrameIndexPredicateTemplate = [[NSPredicate predicateWithFormat:
//                                                  @"songIDAndFrameIndex == $SONG_ID_AND_WAVEFORM_INDEX"] retain];
//    }
//    return waveformByFrameIndexPredicateTemplate;
//}
//
//- (long) waveformCount {
//    NSEnumerator *enumerator = [self.waveformGroups objectEnumerator];
//    WaveformGroup *waveformGroup;
//    WaveformGroup *lastWaveformGroup = nil;
//    while ((waveformGroup = [enumerator nextObject])) {
//        if (lastWaveformGroup == nil || waveformGroup.endingFrameIndex > lastWaveformGroup.endingFrameIndex) {
//            lastWaveformGroup = waveformGroup;
//        }
//    }
//    int lastWaveformGroupSize = 0;
//    if (lastWaveformGroup != nil) {
//        [lastWaveformGroup.waveforms count];
//    }
//    unsigned long totalWaveforms = ([self.waveformGroups count] - 1 ) * FRAMES_PER_GROUP + lastWaveformGroupSize;
//    NSLog(@"Total frames in song: %ld" ,totalWaveforms);
//    
//    return totalWaveforms;
//    
//}

//- (Waveform *) getWaveformAtIndex: (unsigned long) index withContext: (NSManagedObjectContext *) context {
//    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
//    NSEntityDescription *entity = [[[NSEntityDescription 
//                                     entityForName:@"Waveform" inManagedObjectContext:context] retain] autorelease];
//    [fetchRequest setEntity:entity];
//    
//    NSDictionary *variables = [[NSDictionary alloc] initWithObjectsAndKeys:
//                               GET_SONG_AND_FRAME_INDEX([NSNumber numberWithLong:index]) , @"SONG_ID_AND_WAVEFORM_INDEX",
//                               nil];
//    NSPredicate *predicate = [[self getWaveformByFrameIndexPredicateTemplate]
//                              predicateWithSubstitutionVariables:variables];
//    [fetchRequest setPredicate:predicate];
//    
//    [fetchRequest setRelationshipKeyPathsForPrefetching:[NSArray arrayWithObject:@"bins"]];
//    
//    NSError *error = nil;
//    NSArray *fetchedObjects = [context executeFetchRequest:fetchRequest error:&error];
//    [fetchRequest release];
//    [variables release];
//    
//    if (fetchedObjects != nil && [fetchedObjects count] > 0) {
//        return [fetchedObjects objectAtIndex:0];
//    } else {
//        NSLog(@"Error reading waveform with index: %ld", index);
//    }
//    return nil;
//}

//- (void)removeWaveformGroupsObject:(NSManagedObject *)value {
//    NSSet *changedObjects = [[NSSet alloc] initWithObjects:&value count:1];
//    [self willChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
//    [[self primitiveValueForKey:@"waveformGroups"] removeObject:value];
//    [self didChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:changedObjects];
//    [changedObjects release];
//}
//
//- (void)addWaveformGroups:(NSSet *)value {    
//    [self willChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
//    [[self primitiveValueForKey:@"waveformGroups"] unionSet:value];
//    [self didChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueUnionSetMutation usingObjects:value];
//}
//
//- (void)removeWaveformGroups:(NSSet *)value {
//    [self willChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
//    [[self primitiveValueForKey:@"waveformGroups"] minusSet:value];
//    [self didChangeValueForKey:@"waveformGroups" withSetMutation:NSKeyValueMinusSetMutation usingObjects:value];
//}



@end
