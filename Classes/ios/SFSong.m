//
//  Song.m
//  FlyingSquirrel
//
//  Created by Andy Sinesio on 3/30/11.
//  Copyright (c) 2011 Precognitive Research, LLC. All rights reserved.
//

#import "SFSong.h"
#import "SFWaveform.h"
#import "WaveformGroup.h"
#import "DataService.h"

#define TITLE_KEY @"title"
#define ARTIST_KEY @"artist"
#define URL_KEY @"url"
#define DURATION_KEY @"duration"
#define BPM_KEY @"beatsPerMin"
#define SAMPLE_KEY @"sampleRate"
#define COMPLETE_KEY @"complete"

@interface SFSong (PrivateMethods) 
    
@end

@implementation SFSong

@synthesize artist;
@synthesize title;
@synthesize url;
@synthesize duration;
@synthesize beatsPerMinute;
@synthesize sampleRate;
@synthesize complete;

- (id)init {
    self = [super init];
    if (self) {
        
    }
    return self;
}

- (void)dealloc {
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




@end
