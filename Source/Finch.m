#import "Finch.h"
#import <OpenAL/al.h>
#import <OpenAL/alc.h>

@interface Finch ()
@property(assign) ALCdevice *device;
@property(assign) ALCcontext *context;
@end

@implementation Finch
@synthesize device=_device;
@synthesize context=_context;

- (id) init
{
    [super init];
    
    _device = alcOpenDevice(NULL);
    if (!_device) {
        NSLog(@"Finch: Could not open default OpenAL device.");
        [self release];
        return nil;
    }
    
    _context = alcCreateContext(_device, 0);
    if (!_context) {
        NSLog(@"Finch: Failed to create OpenAL context for default device.");
        [self release];
        return nil;
    }
    
    const BOOL success = alcMakeContextCurrent(_context);
    if (!success) {
        NSLog(@"Finch: Failed to set current OpenAL context.");
        [self release];
        return nil;
    }
    
    return self;
}

- (void) dealloc
{
    alcMakeContextCurrent(NULL);
    alcDestroyContext(_context);
    alcCloseDevice(_device);
    [super dealloc];
}

@end