//
//  ProcessSongOperation.m
//  VTM_AViPodReader
//
//  Created by Andy Sinesio on 2/27/11.
//  Copyright 2011 Precognitive Research, LLC. All rights reserved.
//

#import <AVFoundation/AVAudioSettings.h>
#import "SFWaveform.h"
#import "SFProcessSongOperation.h"
#import "SFSong.h"
#import "DataService.h"

#define FFT_SAMPLE_N 1024
#define FFT_SAMPLE_LOG2N 10
#define THRESHOLD_WINDOW_SIZE 7
#define THRESHOLD_MULTIPLIER 1.25f
//#define AUDIO_FRAMES_PER_SECOND 44100
#define AUDIO_FRAMES_PER_SECOND 22050

@interface SFProcessSongOperation(privateMethods) 
-(void) processBuffer: (CMSampleBufferRef) sampleBuffer;
-(void) process: (AVURLAsset *) songURL;
-(void) processAdditionalWaveformData: (SFWaveform *) waveform;
-(void) calculateThresholdSpectralFlux: (SFWaveform *) destinationWaveform;
-(void) main;
@end

@implementation SFProcessSongOperation

@synthesize maxBinValue;
@synthesize percentComplete;

- (id)initWithSong: (AVURLAsset *)songURLToProcess {
    if ((self = [super init])) {
        // Create a managed object context in this thread
        
        songURL = [songURLToProcess retain];
          
        previousFloatSamples = (float *) malloc(FFT_SAMPLE_N * sizeof(float));
        percentComplete = 0.0f;
        maxBinValue = 0;
        totalSamples = 1.0f;
        totalPeaks = 0;
        recentWaveforms = [[NSMutableArray arrayWithCapacity:THRESHOLD_WINDOW_SIZE * 2] retain];
        
    }
    return self;
}

- (void) dealloc {
    [super dealloc];
    [recentWaveforms release]; recentWaveforms = nil;
    free(previousFloatSamples);
}

#pragma mark Processing logic
// This method does the FFT transformation on a sample buffer containing PCM samples
- (void) processBuffer: (CMSampleBufferRef) sampleBuffer {
    CMBlockBufferRef buffer = CMSampleBufferGetDataBuffer( sampleBuffer );
    CMItemCount numSamplesInBuffer = CMSampleBufferGetNumSamples(sampleBuffer);
    
    AudioBufferList audioBufferList;
    
    CMSampleBufferGetAudioBufferListWithRetainedBlockBuffer(
                                                            sampleBuffer,
                                                            NULL,
                                                            &audioBufferList,
                                                            sizeof(audioBufferList),
                                                            NULL,
                                                            NULL,
                                                            kCMSampleBufferFlag_AudioBufferList_Assure16ByteAlignment,
                                                            &buffer
                                                            );
    float *floatSamples = (float *) malloc(FFT_SAMPLE_N * sizeof(float));
    
    int nOver2 = FFT_SAMPLE_N / 2;
    
    COMPLEX_SPLIT complexSamples;
    complexSamples.realp = (float *) malloc(nOver2 * sizeof(float));
    complexSamples.imagp = (float *) malloc(nOver2 * sizeof(float));
    
    // Set up FFT transform
    FFTSetup fftSetup;
    fftSetup = vDSP_create_fftsetup(FFT_SAMPLE_LOG2N, 0);  // support 2^10 = 1024 sample-transforms
    
    for (int bufferCount=0; bufferCount < audioBufferList.mNumberBuffers; bufferCount++) {
        
        SInt16* samples = (SInt16 *)audioBufferList.mBuffers[bufferCount].mData;
        
        // Copy the SHORT samples to the FLOAT array.
        unsigned int numTransforms = numSamplesInBuffer / FFT_SAMPLE_N;
        unsigned int samplesRemaining = numSamplesInBuffer;
        //NSLog(@"Transforming sample buffer size: %ld, numTransforms: %u", numSamplesInBuffer, numTransforms);
        
        for (unsigned int i = 0; i < numTransforms; i++) {
            
            // Figure out if we should transform the next 1024 samples, or less, if we're at the end of the song.
            
            unsigned int samplesToCopyCount = FFT_SAMPLE_N;
            
            if (samplesToCopyCount > samplesRemaining)
                samplesToCopyCount = samplesRemaining;
            if (samplesToCopyCount == 0)
                continue;
            
            vDSP_vflt16(samples + (i * FFT_SAMPLE_N), 1, floatSamples, 1, samplesToCopyCount);
            
            
            //Make a complex vector from the "real" array.
            vDSP_ctoz((COMPLEX *) floatSamples, 2, &complexSamples, 1, nOver2);
            
            // do the FFT now!
            vDSP_fft_zrip(fftSetup, &complexSamples, 1, FFT_SAMPLE_LOG2N, FFT_FORWARD); 
            
            // Don't need that frequency
            complexSamples.imagp[0] = 0.0;
            
            // Scale the data
            //float scale = (float) 1.0 / (2 * (float)FFT_SAMPLE_N);
            float scale = (float) 1.0 / (2.5 * (float)FFT_SAMPLE_N);
            //
            vDSP_vsmul(complexSamples.realp, 1, &scale, complexSamples.realp, 1, nOver2);
            vDSP_vsmul(complexSamples.imagp, 1, &scale, complexSamples.imagp, 1, nOver2);
            
            // Convert the complex data into something usable
            // spectrumData is also a (float*) of size mNumFrequencies
            vDSP_zvabs(&complexSamples, 1, floatSamples, 1, nOver2);
            //vDSP_ztoc(&complexSamples, 1, (COMPLEX *) floatSamples, 2, nOver2);
            
            // whew.  that was a lot of work, now we should do something with the transform, like detect beats.
            
            float flux = 0;
            for (int i = 0; i < FFT_SAMPLE_N; i++) {
                if (maxBinValue < floatSamples[i])
                    maxBinValue = floatSamples[i];
                
                float difference = floatSamples[i] - previousFloatSamples[i];
                if (difference > 0)
                    flux += difference;
            }
            
            
            memcpy(previousFloatSamples, floatSamples, FFT_SAMPLE_N * sizeof(float));
            SFWaveform *waveform = [[SFWaveform alloc] init];
            
            if (waveform != nil) {
              
                waveform.flux = [NSNumber numberWithFloat:flux];
                waveform.frameIndex = [NSNumber numberWithLong:currentFrameIndex];
                [waveform setBinsFromFloatArray:floatSamples andBinCount:nOver2];
                //[song addWaveform:waveform withContext:managedObjectContext];
                [self processAdditionalWaveformData:waveform];
            }
            //currentFrameIndex += FFT_SAMPLE_N;
            currentFrameIndex++;
            samplesRemaining -= FFT_SAMPLE_N;
            [waveform release];
        }
        
    }
    free(floatSamples);
    free(complexSamples.realp);
    free(complexSamples.imagp);
    
}

-(void) process {
    
    totalSamples = CMTimeGetSeconds(songURL.duration) * AUDIO_FRAMES_PER_SECOND;
    
    NSError *assetError = nil;
    AVAssetReader *assetReader = [[AVAssetReader assetReaderWithAsset:songURL
                                                                error:&assetError]
                                  retain];
    
    if (assetError) {
        NSLog (@"error: %@", assetError);
        return;
    }
    
    NSDictionary *audioSettings = [NSDictionary dictionaryWithObjectsAndKeys:
                                   [NSNumber numberWithInt:kAudioFormatLinearPCM], AVFormatIDKey,
                                   [NSNumber numberWithFloat: AUDIO_FRAMES_PER_SECOND],AVSampleRateKey,
                                   [NSNumber numberWithInt: 1], AVNumberOfChannelsKey,
                                   nil];
    AVAssetReaderOutput *assetReaderOutput = [[AVAssetReaderAudioMixOutput 
                                               assetReaderAudioMixOutputWithAudioTracks:songURL.tracks
                                               audioSettings: audioSettings]
                                              retain];
    
    
    if (! [assetReader canAddOutput: assetReaderOutput]) {
        NSLog (@"can't add reader output... die!");
        return;
    }
    [assetReader addOutput: assetReaderOutput];
    
    if (assetError) {
        NSLog (@"error: %@", assetError);
        return;
    }
    
    [assetReader startReading];
    
    //AVAssetTrack *soundTrack = [songAsset.tracks objectAtIndex:0];
    //CMTime startTime = CMTimeMake (0, soundTrack.naturalTimeScale);
    
    CMSampleBufferRef nextBuffer;
    do {  
        nextBuffer = [assetReaderOutput copyNextSampleBuffer];
        if (nextBuffer) {
            [self processBuffer: nextBuffer];
            percentComplete = currentFrameIndex * FFT_SAMPLE_N / (float) totalSamples;
        
        }
    } while (nextBuffer && ![self isCancelled]);
   // if (![self isCancelled] && [song.duration floatValue] > 0.0f) {
   //     float beatsPerMinute = totalPeaks / ([song.duration floatValue] * 60.0f);
   //     song.beatsPerMinute = [NSNumber numberWithFloat:beatsPerMinute];
   // }
    
    [assetReader cancelReading];
    // release a lot of stuff
    [assetReader release];
    [assetReaderOutput release];
}

-(void) calculateThresholdSpectralFlux: (SFWaveform *) destinationWaveform {
    float mean = 0.0f;
    int count = 0;
    for (SFWaveform *waveform in recentWaveforms) {
        mean += [waveform.flux floatValue];
        count++;
    }
    if (count > 0) {
        mean = mean * THRESHOLD_MULTIPLIER / (float) count;
        destinationWaveform.threshold = [NSNumber numberWithFloat:mean];
    }
}

-(void) processAdditionalWaveformData: (SFWaveform *) newWaveform {
    [recentWaveforms addObject:newWaveform];
    if ([recentWaveforms count] > THRESHOLD_WINDOW_SIZE) {
        SFWaveform *waveform = [recentWaveforms objectAtIndex:THRESHOLD_WINDOW_SIZE];
        if (waveform && !waveform.isComplete) {
            // calculate average flux
            [self calculateThresholdSpectralFlux:waveform];
            SFWaveform *previousWaveform = [recentWaveforms objectAtIndex:THRESHOLD_WINDOW_SIZE-1];

            if (previousWaveform && !previousWaveform.isPeak) {
                if ([previousWaveform getThresholdPeakValue] > [waveform getThresholdPeakValue]) {
                    // we have a peak
                    waveform.isPeak = YES;
                    totalPeaks++;
                } else {
                    waveform.isPeak = NO;
                }
            }
            waveform.isComplete = YES;
        }
    }
    if ([recentWaveforms count] > THRESHOLD_WINDOW_SIZE * 2) {
        [recentWaveforms removeObjectAtIndex:0]; // take out object at beginning of queue
    }
}

-(void) main {
    // called by NSOperationQueue
    @try {
        
        NSAutoreleasePool *pool = [[NSAutoreleasePool alloc] init];
        
        
        // Load our AVAsset object
        
                
        percentComplete = 0.0f;
        maxBinValue = 0.0f;
        currentFrameIndex = 0;

        totalSamples = 1;
        
        NSLog(@"Beginning song processing operation.");
        
        if ([self isCancelled]) {
            NSLog(@"Cancelled loading ProcessSongOperation prior to execution");
            return;
        }
        [self process];
       
        
       
        NSLog(@"Completed song processing operation.");
        [pool release];
    }
    @catch(NSException *e) {
        
        // Do not rethrow exceptions.
        NSLog(@"ERROR: Exception occurred during processing song!  %@", e);
    }
    @catch(...) {
        NSLog(@"ERROR: Unknown exception occurred during processing song!");
    }
}

@end
