//
//  SoundEngine.h
//  prototype4
//
//  Created by Sebastian Volland on 14.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Finch.h"
#import "Sound.h"
#import "RevolverSound.h"

@interface SoundEngine : NSObject {
@private
    NSMutableDictionary * sounds;
}

- (void) preload;
- (BOOL)play: (NSString *) name;

@end
