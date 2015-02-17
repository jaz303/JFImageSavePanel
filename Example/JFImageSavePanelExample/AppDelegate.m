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

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification { }

- (IBAction)showSavePanel:(id)sender
{
    JFImageSavePanel *panel = [JFImageSavePanel savePanel];

    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://upload.wikimedia.org/wikipedia/commons/thumb/5/5c/Double-alaskan-rainbow.jpg/400px-Double-alaskan-rainbow.jpg"]];

    //panel.imageType = kUTTypeJPEG;
    [panel runModalForImage:image error:NULL];

    //Alternatives:

    /*[panel beginWithImage:image completionHandler:^(NSInteger result) {
        //Do something
        NSLog(@"Done!");
    }];*/

    /*[panel beginSheetWithImage:image window:_window completionHandler:^(NSInteger result) {
        //Do something
        NSLog(@"Done!");
    }];*/
}

@end
