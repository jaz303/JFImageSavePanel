//
//  AppDelegate.m
//  JFImageSavePanelExample
//
//  Created by Jason Frame on 05/12/2014.
//  Copyright (c) 2014 Jason Frame. All rights reserved.
//

#import "AppDelegate.h"
#import "JFImageSavePanel.h"

@interface AppDelegate ()

@property (weak) IBOutlet NSWindow *window;
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    // Insert code here to initialize your application
}

- (void)applicationWillTerminate:(NSNotification *)aNotification {
    // Insert code here to tear down your application
}

- (IBAction)showSavePanel:(id)sender
{
    JFImageSavePanel *panel = [JFImageSavePanel savePanel];
    
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Double-alaskan-rainbow.jpg/400px-Double-alaskan-rainbow.jpg"]];
    
    //[panel setImageType:kUTTypeJPEG];
    [panel runModalForImage:image error:NULL];
    
}

@end
