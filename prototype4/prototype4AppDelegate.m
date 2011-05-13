
#import "prototype4AppDelegate.h"
#import "FullscreenWindow.h"

@implementation prototype4AppDelegate

@synthesize window;
@synthesize webView;
@synthesize toggleSoundItem;
@synthesize showFPSItem;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    isFullscreen = NO;
    
    [self readUserDefaults];
    
    soundEngine = [[SoundEngine alloc] init];
}

- (void)readUserDefaults
{
    defaults = [NSUserDefaults standardUserDefaults];

    NSDictionary *def = [NSDictionary dictionaryWithObjectsAndKeys:
                         [NSNumber numberWithBool:YES], @"soundEnabled",
                         [NSNumber numberWithBool:NO], @"showFPS",
                         [NSString stringWithString:@"{}"], @"GameState",
                         nil];

    [defaults registerDefaults: def];
    
    isSoundEnabled = [defaults boolForKey:@"soundEnabled"];    
    if (isSoundEnabled) {
        [toggleSoundItem setState:NSOnState];
    } else {
        [toggleSoundItem setState:NSOffState];
    }
    
    showFPS = [defaults boolForKey:@"showFPS"];
    if (showFPS) {
        [showFPSItem setState:NSOnState];
    } else {
        [showFPSItem setState:NSOffState];
    }
}

- (void) save: (NSString*) key withValue: (NSString*) value
{
    [defaults setObject:value forKey:key];
    [defaults synchronize];
}

- (NSString *) getGameState
{
    return [defaults stringForKey:@"GameState"];
}

- (IBAction)toggleSound:(id)sender
{
    if (isSoundEnabled) {
        [toggleSoundItem setState:NSOffState];
        isSoundEnabled = NO;
    } else {
        [toggleSoundItem setState:NSOnState];
        isSoundEnabled = YES;
    }
    
    [defaults setBool:isSoundEnabled forKey: @"soundEnabled"];
    [defaults synchronize];
}

- (IBAction)toggleShowFPS:(id)sender
{
    if (showFPS) {
        [showFPSItem setState:NSOffState];
        showFPS = NO;
    } else {
        [showFPSItem setState:NSOnState];
        showFPS = YES;
    }
    
    [defaults setBool:showFPS forKey: @"showFPS"];
    [defaults synchronize];
}

- (void)awakeFromNib
{
    /* set ourself to the app's delegate so our
     applicationShouldTerminateAfterLastWindowClosed
     method will be called. */
	[NSApp setDelegate: self];
    
    /* set self as UI and Resource Load delegate for our WebView */
	[webView setUIDelegate: self];
	[webView setResourceLoadDelegate: self];

    [webView setDrawsBackground:NO];    
    [window setBackgroundColor:[NSColor blackColor]];
    
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
    NSString *htmlPath = [resourcesPath stringByAppendingString:@"/game.dat"];
    NSString *htmlEnc = [[NSString alloc] initWithContentsOfFile:htmlPath encoding:NSUTF8StringEncoding error:nil];
    
    NSData *data = [htmlEnc dataUsingEncoding:NSUTF8StringEncoding];
    char *dataPtr = (char *) [data bytes];
    
    for (int i = 0; i < [data length]; i++) {
        *dataPtr = *dataPtr ^ 65;
        dataPtr++;
    }
    
    NSString *html = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];    
    
    NSURL *url = [NSURL fileURLWithPath:resourcesPath];
    [[webView mainFrame] loadHTMLString:html baseURL:url];
}

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)theApplication
{
    return YES;
}

- (void)webView:(WebView *)webView windowScriptObjectAvailable:(WebScriptObject *)windowScriptObject
{
    /* here we'll add our object to the window object as an object named
     'console'.  We can use this object in JavaScript by referencing the 'console'
     property of the 'window' object.   */
    [windowScriptObject setValue:self forKey:@"ext"];    
}

- (void)webView:(WebView *)sender runJavaScriptAlertPanelWithMessage:(NSString *)message
{
	NSLog(@"%@ received %@ with '%@'", self, NSStringFromSelector(_cmd), message);
}

+ (BOOL)isSelectorExcludedFromWebScript:(SEL)selector
{
    if (selector == @selector(doOutputToLog:)) {
        return NO;
    }

    if (selector == @selector(playSound:)) {
        return NO;
    }
    
    if (selector == @selector(quitApp:)) {
        return NO;
    }
    
    if (selector == @selector(save:withValue:)) {
        return NO;
    }
    
    if (selector == @selector(getGameState)) {
        return NO;
    }
    
    return YES;
}

+ (NSString *) webScriptNameForSelector:(SEL)sel
{
    if (sel == @selector(doOutputToLog:)) {
		return @"log";
	}

    if (sel == @selector(playSound:)) {
		return @"play";
	}
    
    if (sel == @selector(quitApp:)) {
		return @"quit";
	}
    
    if (sel == @selector(save:withValue:)) {
		return @"save";
	}
    
    if (sel == @selector(getGameState)) {
		return @"getGameState";
	}
    
    return nil;
}

+ (BOOL)isKeyExcludedFromWebScript:(const char *)property
{
	if (strcmp(property, "showFPS") == 0) {
        return NO;
    }
    
    return YES;
}

- (NSArray *)webView:(WebView *)sender contextMenuItemsForElement:(NSDictionary *)element 
    defaultMenuItems:(NSArray *)defaultMenuItems
{
    // disable right-click context menu
    return nil;
}

- (void) doOutputToLog: (NSString*) theMessage
{
    NSLog(@"LOG: %@", theMessage);    
}

- (void) playSound: (NSString*) name
{
    if (!isSoundEnabled) {
        return;
    }
    
    [soundEngine play: name];
}

- (void) quitApp: (NSString*) name
{
    [NSApp terminate: nil];
}

- (NSApplicationTerminateReply)applicationShouldTerminate:(NSApplication *)sender
{
    CGRestorePermanentDisplayConfiguration();
    
    return YES;
}

- (IBAction)toggleFullscreen:(id)sender
{
    if (isFullscreen) {
        [self switchWindow];
    } else {
        [self switchFull];
    }
}

- (void)switchWindow
{
    CGRestorePermanentDisplayConfiguration();
    
    CGReleaseAllDisplays();
    
    NSRect newFrame = [fullscreenWindow frameRectForContentRect:
                       [window contentRectForFrameRect:[window frame]]];
    
    [fullscreenWindow setFrame:newFrame display:YES animate:YES];
    
    NSView *contentView = [[[fullscreenWindow contentView] retain] autorelease];
    [fullscreenWindow setContentView:[[[NSView alloc] init] autorelease]];
    
    [window setContentView:contentView];
    [window makeKeyAndOrderFront:nil];
    
    [fullscreenWindow close];
    fullscreenWindow = nil;
    
    if ([[window screen] isEqual:[[NSScreen screens] objectAtIndex:0]]) {
        [NSMenu setMenuBarVisible:YES];
    }
    
    isFullscreen = NO;
}

- (void)switchFull
{
    //[NSApp setPresentationOptions:NSApplicationPresentationHideDock | NSApplicationPresentationHideMenuBar];

    /* switch display resolution */
    struct screenMode mode;
    mode.width = 640;
    mode.height = 480;
    mode.bitsPerPixel = 32;
    CGDisplayModeRef m = [self bestMatchForMode: mode];
    [self switchToMode:m];
    
    [window orderOut:nil];
    
    //NSRect rect = [window contentRectForFrameRect:[window frame]];
    NSRect rect;
    rect.origin.x = 0;
    rect.origin.y = 0;
    rect.size.width = 640;
    rect.size.height = 480;
    
    NSScreen * screen = [NSScreen mainScreen];
    
    fullscreenWindow = [[FullscreenWindow alloc]
                        initWithContentRect:rect
                        styleMask:NSBorderlessWindowMask
                        backing:NSBackingStoreBuffered
                        defer:YES
                        screen:screen];
    
    NSView *contentView = [[[window contentView] retain] autorelease];
    [window setContentView:[[[NSView alloc] init] autorelease]];
    
    [fullscreenWindow setHidesOnDeactivate:YES];
    [fullscreenWindow setLevel:NSFloatingWindowLevel];
    [fullscreenWindow setContentView:contentView];
    [fullscreenWindow setTitle:[window title]];
    [fullscreenWindow makeKeyAndOrderFront:nil];
    
    [fullscreenWindow setFrame: [fullscreenWindow frameRectForContentRect:[[fullscreenWindow screen] frame]] display:YES animate:YES];
    
    int windowLevel = CGShieldingWindowLevel();
    [fullscreenWindow setLevel:windowLevel];
    [fullscreenWindow makeKeyAndOrderFront:nil]; 
    
    isFullscreen = YES;
}

- (BOOL)switchToMode: (CGDisplayModeRef)m
{
    CGError err;
	CGDisplayConfigRef newConfig;
    
    err = CGCaptureAllDisplays();
    if (err) {
        return NO;
    }
    
    err = CGBeginDisplayConfiguration(&newConfig);
    if (err) {
        return NO;
    }
    
    err = CGConfigureDisplayWithDisplayMode(newConfig, kCGDirectMainDisplay, m, NULL);
    if (err) {
        return NO;
    }
    
    err = CGCompleteDisplayConfiguration(newConfig, kCGConfigureForAppOnly);
    if (err) {
        return NO;
    }
    
    return YES;
}

// http://lukassen.wordpress.com/2010/01/18/taming-snow-leopard-cgdisplaybestmodeforparameters-deprecation/

- (CGDisplayModeRef) bestMatchForMode: (struct screenMode) screenMode
{    
	bool exactMatch = false;
    
	CGDisplayModeRef displayMode = CGDisplayCopyDisplayMode(kCGDirectMainDisplay);
    
    CFArrayRef allModes = CGDisplayCopyAllDisplayModes(kCGDirectMainDisplay, NULL);
    for (int i = 0; i < CFArrayGetCount(allModes); i++)	{
		CGDisplayModeRef mode = (CGDisplayModeRef)CFArrayGetValueAtIndex(allModes, i);
                
		if ([self displayBitsPerPixelForMode: mode] != screenMode.bitsPerPixel) {
			continue;
        }
        
		if ((CGDisplayModeGetWidth(mode) == screenMode.width) && (CGDisplayModeGetHeight(mode) == screenMode.height)) {
			displayMode = mode;
			exactMatch = true;
			break;
		}
	}
    
    if (!exactMatch)	{
		for (int i = 0; i < CFArrayGetCount(allModes); i++) {
			CGDisplayModeRef mode = (CGDisplayModeRef)CFArrayGetValueAtIndex(allModes, i);
			if ([self displayBitsPerPixelForMode: mode] >= screenMode.bitsPerPixel) {
				continue;
            }
            
			if ((CGDisplayModeGetWidth(mode) >= screenMode.width) && (CGDisplayModeGetHeight(mode) >= screenMode.height)) {
                
				displayMode = mode;
				break;
			}
		}
	}
    
	return displayMode;
}

- (size_t) displayBitsPerPixelForMode: (CGDisplayModeRef) mode
{    
	size_t depth = 0;
    
	CFStringRef pixEnc = CGDisplayModeCopyPixelEncoding(mode);
	if (CFStringCompare(pixEnc, CFSTR(IO32BitDirectPixels), kCFCompareCaseInsensitive) == kCFCompareEqualTo) {
		depth = 32;
    } else if(CFStringCompare(pixEnc, CFSTR(IO16BitDirectPixels), kCFCompareCaseInsensitive) == kCFCompareEqualTo) {
		depth = 16;
	} else if(CFStringCompare(pixEnc, CFSTR(IO8BitIndexedPixels), kCFCompareCaseInsensitive) == kCFCompareEqualTo) {
		depth = 8;
    }
    
	return depth;
}

@end
