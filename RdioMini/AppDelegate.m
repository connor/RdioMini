//
//  AppDelegate.m
//  RdioMini
//
//  Created by Connor Montgomery on 12/2/12.
//  Copyright (c) 2012 Connor Montgomery. All rights reserved.
//

#import "AppDelegate.h"
#import "WindowController.h"

#import "Rdio.h"

@interface AppDelegate ()
    @property (nonatomic, retain) NSTimer *timer;
    @property (nonatomic, retain) RdioApplication *rdio;
    @property (nonatomic, retain) RdioTrack *currentTrack;
@end

@implementation AppDelegate
@synthesize track,
            artist,
            albumImage,
            timeIntoTrack,
            trackProgressIndicator,
            rdio,
            playPauseBtn,
            shuffleBtn,
            repeatBtn,
            album;


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
   
    self.rdio = [SBApplication applicationWithBundleIdentifier:@"com.rdio.desktop"];
    self.currentTrack = [self.rdio currentTrack];
    
    self.window.trafficLightButtonsLeftMargin = 7.0;
    self.window.fullScreenButtonRightMargin = 7.0;
    self.window.centerFullScreenButton = YES;
    self.window.titleBarHeight = 42.0;
    self.window.showsBaselineSeparator = YES;
    self.window.titleBarStartColor     = [NSColor whiteColor];
    self.window.titleBarEndColor       = [NSColor whiteColor];
   
    self.window.baselineSeparatorColor = [NSColor colorWithCalibratedRed:243 green:243 blue:243 alpha:0.9f];

    NSView *titleBarView = self.window.titleBarView;

    NSRect logoFrame = NSMakeRect(NSMidX(titleBarView.bounds) - (26.5), NSMidY(titleBarView.bounds) - (11), 53, 22);
    NSImageView *myImage = [[NSImageView alloc] initWithFrame:logoFrame];
    myImage.image = [NSImage imageNamed:@"rdio_logo.png"];
    
    [titleBarView addSubview:myImage];
    

    self.timer = [NSTimer scheduledTimerWithTimeInterval:1.0f
                                                  target:self
                                                selector:@selector(incrementPlayerPosition:)
                                                userInfo:nil
                                                 repeats:YES];
   
    [[NSDistributedNotificationCenter defaultCenter] addObserver: self
                                                        selector:@selector(didReceivePlayerNotification:)
                                                            name:@"com.rdio.desktop.playStateChanged"
                                                          object:nil];
    
    [self updateTrackInfo];
}

- (void)awakeFromNib {
    self.window.backgroundColor = [NSColor colorWithCalibratedRed:244 green:244 blue:244 alpha:0.99f];
    [self updateTrackInfo];
    [self incrementPlayerPosition:self.timer];
}

- (void)updateTrackInfo {
    if ([self.rdio isRunning]) {
        
        if ([self.rdio playerState] == RdioEPSSPlaying) {
            [playPauseBtn setImage:[NSImage imageNamed:@"pause_grey.png"]];
            
            NSString *trackName = [self.currentTrack name];
            NSString *artistName = [self.currentTrack artist];
            NSString *albumName = [self.currentTrack album];
            double progress = [self.rdio playerPosition];
            double duration = [self.currentTrack duration];

            NSImage *artwork = [self.currentTrack artwork];
            [self checkShuffle];
            [albumImage setImage:artwork];
            
            [artist setStringValue:artistName];
            [track setStringValue:trackName];
            [album setStringValue:albumName];
            
            [trackProgressIndicator setMaxValue:duration];
            [trackProgressIndicator setDoubleValue:progress];
            
            [self incrementPlayerPosition:self.timer];
        } else {
            [playPauseBtn setImage:[NSImage imageNamed:@"shuffle_grey.png"]];
        }
    }
    
}

- (NSString *)parseSeconds: (double)numberOfSeconds {
    
    double minutes = floor(numberOfSeconds / 60);
    int seconds = floor(numberOfSeconds - (60 * minutes));

    NSString *minuteString;
    NSString *secondString;
    
    if (minutes < 10) {
        minuteString = [NSString stringWithFormat:@"0%ld", lroundf(minutes)];
    } else {
        minuteString = [NSString stringWithFormat:@"%ld", lroundf(minutes)];
    }
   
    if (seconds < 10) {
        secondString = [NSString stringWithFormat:@"0%i", seconds];
    } else {
        secondString = [NSString stringWithFormat:@"%i", seconds];
    }
    
    NSString *time = [NSString stringWithFormat:@"%@:%@", minuteString, secondString];
   
    return time;
}

- (void)didReceivePlayerNotification:(NSNotification *)notification {
    [self updateTrackInfo];
}

- (void)incrementPlayerPosition:(NSTimer *)theTimer {
    NSInteger timePassed = [self.rdio playerPosition];
    NSString *timePassedStr = [self parseSeconds:timePassed];

    [timeIntoTrack setStringValue:timePassedStr];
}

- (IBAction)previousSong:(id)sender {
    [self.rdio previousTrack];
}
- (IBAction)playPause:(id)sender {
    [self.rdio playpause];
}

- (IBAction)nextSong:(id)sender {
    [self.rdio nextTrack];
}

- (void)checkShuffle {
    NSAppleScript *script = [[NSAppleScript alloc] initWithSource: @"tell application \"Rdio\" to get shuffle"];
    BOOL result = [script executeAndReturnError: nil];
    
    if (!result) {
        [shuffleBtn setState:NSOnState];
    } else {
        [shuffleBtn setState:NSOffState];
    }
}
@end
