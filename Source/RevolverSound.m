#import "RevolverSound.h"
#import "Sound.h"

@implementation RevolverSound

- (id) initWithFile: (NSURL*) fileURL rounds: (int) max
{
    [super init];
    sounds = [[NSMutableArray alloc] init];
    for (int i=0; i<max; i++)
    {
        Sound *const sample = [[Sound alloc] initWithFile:fileURL];
        if (!sample)
            return nil;
        [sounds addObject:sample];
        [sample release];
    }
    return self;
}

- (void) dealloc
{
    [sounds release];
    [super dealloc];
}

- (void) play
{
    Sound *sound = [sounds objectAtIndex:current];
    [sound play];
    current = (current + 1) % [sounds count];
}

- (void) stop
{
    Sound *sound = [sounds objectAtIndex:current];
    [sound stop];
}

- (void) setGain: (float) val
{
    for (Sound *sound in sounds)
        [sound setGain:val];
}

- (float) gain
{
    return [[sounds lastObject] gain];
}

@end
