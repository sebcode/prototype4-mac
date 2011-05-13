//
//  SoundEngine.m
//  prototype4
//
//  Created by Sebastian Volland on 14.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "SoundEngine.h"


@implementation SoundEngine

- (id)init
{
    self = [super init];
    if (self) {
        [[Finch alloc] init];
        [self preload];
    }
    
    return self;
}

- (void)dealloc
{
    [super dealloc];
}

- (void)preload
{
    sounds = [[NSMutableDictionary alloc] init];
    
    NSString *resourcesPath = [[NSBundle mainBundle] resourcePath];
    NSBundle *bundle = [NSBundle mainBundle];
    
    /* find all .wav files and load them */
    
    for (NSString *file in [[NSFileManager defaultManager] contentsOfDirectoryAtPath:resourcesPath error:nil]) {
        if (![file hasSuffix: @".wav"]) {
            continue;
        }

        NSString *absFile = [resourcesPath stringByAppendingFormat:@"/%@", file];
        NSString *name = [file stringByDeletingPathExtension];
        
        RevolverSound *sound = [[RevolverSound alloc] initWithFile:
            [bundle URLForResource:name withExtension:@"wav"] rounds:10];        
        
        if (!sound) {
            NSLog(@"SoundEngine: Could not load %@", absFile);
            continue;
        }
        

        [sounds setObject:sound forKey:name];
    }
}

- (BOOL)play: (NSString *) name
{
    RevolverSound * sound = [sounds valueForKey:name];

    if (!sound) {
        NSLog(@"SoundEngine: Sound not found: %@", name);
        return false;
    }

    [sound play];
    
    return true;
}

@end
