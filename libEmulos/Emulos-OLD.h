//
//  Emulos.h
//  EmulosHost
//
//  Created by Ishaan Gulrajani on 6/7/13.
//  Copyright (c) 2013 Substrate, Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>


typedef NSString EmulosSessionID;
@interface Emulos : NSObject {
    @private
    
    // general
    NSString *APIKey;
    NSOperationQueue *queue;

    // session management
    NSString *recordingSessionID;
    BOOL abort;
    
    // recording
    BOOL autorecord;
    BOOL writeToDisk;
    NSString *videoFolder;
    NSMutableData *videoData;
    int frameCount;
    
    // occlusion, touch overlays
    NSMutableSet *occluded;
    NSMutableArray *touches;
    
    // events, screens
    NSDictionary *buttonImageLookupTable;
    NSMutableArray *events;
    NSString *currentScreen;
}

/*
 Initializes the Emulos library and opens a connection to the Emulos servers.
 Call this method once, in your application delegate's application:didFinishLaunchingWithOptions: method.
 */
+(void)startWithAPIKey:(NSString *)APIKey;

/*
 Adds a tag to this device in the Emulos dashboard.
 Use this to record user information like app version, username, region, and campaign(s).
 */
+(void)addTagToCurrentDevice:(NSString *)tag;

/*
 Starts a new recording. Call this method whenever you want to begin recording.
 */
+(void)startRecording;

/*
 Adds a tag in the Emulos dashboard to the current recording
 Use this to record information about this recording session (e.g. 'signup dialog', 'success', 'photo share').
 */
+(void)addTagToCurrentRecording:(NSString *)tag;

/*
 Hides the given view in future recordings by covering it with a solid colored rectangle.
 Use this to avoid recording sensitive information (credit card numbers, passwords, etc.)
 */
+(void)occludeView:(UIView *)view;

/*
 Finishes a recording started by startRecording
 */
+(void)finishRecording;

@end