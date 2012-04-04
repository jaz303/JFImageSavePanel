//
//  OFTAppDelegate.m
//  JFImageSavePanel
//
//  Created by Jason Frame on 04/04/2012.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "OFTAppDelegate.h"
#import "JFImageSavePanel.h"

@implementation OFTAppDelegate

@synthesize window = _window;

- (void)dealloc
{
    [super dealloc];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // Insert code here to initialize your application
}

- (IBAction)showSavePanel:(id)sender
{
    JFImageSavePanel *panel = [JFImageSavePanel savePanel];
    
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Double-alaskan-rainbow.jpg/400px-Double-alaskan-rainbow.jpg"]];
    
    [panel setImageType:kUTTypeJPEG];
    [panel runModalForImage:image error:NULL];
}

@end
