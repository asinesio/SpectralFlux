//
//  DataService.h
//
//  Created by Andy Sinesio on 3/30/11.
//  Copyright 2011 Precognitive Research, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SFWaveform.h"

@interface DataService : NSObject {
    
}
- (BOOL) isWriteComplete;
- (void) appendWaveform: (SFWaveform *) waveform;
- (SFWaveform *) getWaveformAtIndex: (NSNumber *)index;

@end
