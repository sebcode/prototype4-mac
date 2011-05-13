//
//  prototype4AppDelegate.h
//  prototype4
//
//  Created by Sebastian Volland on 13.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <WebKit/WebKit.h>

#import "SoundEngine.h"

struct screenMode {
    size_t width;
    size_t height;
    size_t bitsPerPixel;
};

@interface prototype4AppDelegate : NSObject <NSApplicationDelegate> {
@private
    NSWindow *window;
    NSWindow *fullscreenWindow;
    
    NSUserDefaults *defaults;
    
    IBOutlet WebView *webView;
    IBOutlet NSMenuItem *toggleSoundItem;
    IBOutlet NSMenuItem *showFPSItem;
    
    SoundEngine *soundEngine;
    
    BOOL isSoundEnabled;
    BOOL isFullscreen;
    BOOL showFPS;
}

@property (assign) IBOutlet NSWindow *window;
@property (nonatomic, retain) IBOutlet WebView *webView;
@property (nonatomic, retain) IBOutlet NSMenuItem *toggleSoundItem;
@property (nonatomic, retain) IBOutlet NSMenuItem *showFPSItem;

- (void) doOutputToLog: (NSString*) theMessage;
- (void) save: (NSString*) key withValue: (NSString*) value;

- (void)readUserDefaults;

- (IBAction)toggleSound:(id)sender;
- (IBAction)toggleShowFPS:(id)sender;
- (IBAction)toggleFullscreen:(id)sender;

- (BOOL)switchToMode: (CGDisplayModeRef)m;
- (CGDisplayModeRef) bestMatchForMode: (struct screenMode) screenMode;
- (size_t) displayBitsPerPixelForMode: (CGDisplayModeRef) mode;
- (void)switchFull;
- (void)switchWindow;

@end
