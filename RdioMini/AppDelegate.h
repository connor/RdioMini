//
//  AppDelegate.h
//  RdioMini
//
//  Created by Connor Montgomery on 12/2/12.
//  Copyright (c) 2012 Connor Montgomery. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "INAppStoreWindow.h"

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet INAppStoreWindow *window;
@property (strong) IBOutlet NSTextField *artist;
@property (strong) IBOutlet NSTextField *album;
@property (strong) IBOutlet NSTextField *track;
@property (strong) IBOutlet NSImageView *albumImage;
@property (strong) IBOutlet NSTextField *timeIntoTrack;
@property (strong) IBOutlet NSProgressIndicator *trackProgressIndicator;
@property (strong) IBOutlet NSButton *repeatBtn;
@property (strong) IBOutlet NSButton *shuffleBtn;
@property (weak) IBOutlet NSButton *playPauseBtn;

- (IBAction)previousSong:(id)sender;
- (IBAction)playPause:(id)sender;
- (IBAction)nextSong:(id)sender;

@end
