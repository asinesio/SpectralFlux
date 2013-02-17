//
//  Song.h
//  FlyingSquirrel
//
//  Created by Andy Sinesio on 3/30/11.
//  Copyright (c) 2011 Precognitive Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Waveform;
@class WaveformGroup;

@interface Song : NSManagedObject {
@private
    WaveformGroup *previousCachedWaveformGroup;
    WaveformGroup *cachedWaveformGroup;
    WaveformGroup *futureCachedWaveformGroup;
    NSPredicate *waveformByFrameIndexPredicateTemplate;
}
@property (nonatomic, retain) NSString * artist;
@property (nonatomic, retain) NSString * title;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) NSNumber * duration;
@property (nonatomic, retain) NSNumber * beatsPerMinute;
@property (nonatomic, retain) NSNumber * sampleRate;
@property (nonatomic, retain) NSNumber * complete;
@property (nonatomic, retain) NSSet* waveformGroups;

- (void) addWaveform: (Waveform *) waveform withContext: (NSManagedObjectContext *) context;
- (void) clearWithContext: (NSManagedObjectContext *) context;
- (long) waveformCount;
- (Waveform *) getWaveformAtIndex: (unsigned long) index withContext: (NSManagedObjectContext *) context;
@end

@interface Song (SongAccessors) 
- (void) addWaveformGroupsObject: (WaveformGroup *) value;
@end
