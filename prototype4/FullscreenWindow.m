//
//  FullscreenWindow.m
//  prototype4
//
//  Created by Sebastian Volland on 28.05.11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "FullscreenWindow.h"

@implementation FullscreenWindow

- (BOOL)makeFirstResponder:(NSResponder *)aResponder
{
	BOOL result = [super makeFirstResponder:aResponder];
	return result;
}

- (BOOL)canBecomeKeyWindow
{
	return YES;
}

@end
