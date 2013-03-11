//
//  Song.h
//  FlyingSquirrel
//
//  Created by Andy Sinesio on 3/30/11.
//  Copyright (c) 2011 Precognitive Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SFSong : NSObject<NSCoding> {

}

@property (nonatomic, retain) NSString *artist;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *url;
@property (nonatomic, retain) NSNumber *duration;
@property (nonatomic, retain) NSNumber *beatsPerMinute;
@property (nonatomic, retain) NSNumber *sampleRate;
@property (nonatomic) BOOL complete;
@property (nonatomic, retain) NSNumber *waveformCount;
@property (nonatomic, retain) NSNumber *waveformRecordSize;

@end
