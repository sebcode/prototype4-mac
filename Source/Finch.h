#import <OpenAL/alc.h>

@interface Finch : NSObject {
@private
    ALCdevice *_device;
    ALCcontext *_context;

}

@end