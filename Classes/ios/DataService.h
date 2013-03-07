//
//  DataService.h
//  FlyingSquirrel
//
//  Created by Andy Sinesio on 3/30/11.
//  Copyright 2011 Precognitive Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Waveform.h"

@interface DataService : NSObject {
    
}
- (BOOL) isWriteComplete;
- (void) appendWaveform: (Waveform *) waveform;
- (Waveform *) getWaveformAtIndex: (NSNumber *)index;

@end
