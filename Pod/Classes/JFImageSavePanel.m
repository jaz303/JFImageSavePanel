#import "JFImageSavePanel.h"

@interface JFImageSavePanel ()

@property (retain) NSSavePanel              *savePanel;
@property (assign) IBOutlet NSView          *accessoryView;
@property (assign) IBOutlet NSPopUpButton   *fileTypes;
@property (assign) IBOutlet NSSlider        *compressionFactor;
@property (assign) IBOutlet NSTextField     *compressionFactorLabel;
@property (assign) IBOutlet NSTextField     *compressionLeastLabel;
@property (assign) IBOutlet NSTextField     *compressionBestLabel;

- (void)configureSavePanel;
- (void)fileTypeChanged:(id)sender;
- (void)saveImage:(NSImage *)image;

@end

#pragma mark -

@implementation JFImageSavePanel

@synthesize title, imageType;
@synthesize savePanel, accessoryView, fileTypes, compressionFactor, compressionFactorLabel;

+ (JFImageSavePanel *)savePanel
{
    JFImageSavePanel *panel = [[JFImageSavePanel alloc] init];
    return panel;
}

- (id)init
{
    self = [super init];
    if (self) {

        self.title      = @"Save Image";
        self.imageType  = kUTTypePNG;

        self.savePanel  = [NSSavePanel savePanel];

        NSNib *accessoryNib = [[NSNib alloc] initWithNibNamed:@"JFImageSavePanelAccessoryView" bundle:nil];
        [accessoryNib instantiateWithOwner:self topLevelObjects:nil];

        [self.fileTypes setTarget:self];
        [self.fileTypes setAction:@selector(fileTypeChanged:)];

    }
    return self;
}

- (void)dealloc
{
    self.title = nil;
    self.savePanel = nil;
}

- (void)configureSavePanel
{
    [self.savePanel setAccessoryView:self.accessoryView];

    [self.savePanel setCanCreateDirectories:YES];
    [self.savePanel setCanSelectHiddenExtension:YES];
    [self.savePanel setExtensionHidden:NO];
    [self.savePanel setAllowsOtherFileTypes:YES];

    [self.savePanel setTitle:self.title];

    [self.fileTypes selectItemAtIndex:-1];
    if (UTTypeEqual(self.imageType, kUTTypeJPEG)) {
        [self.fileTypes selectItemAtIndex:0];
    } else if (UTTypeEqual(self.imageType, kUTTypeJPEG2000)) {
        [self.fileTypes selectItemAtIndex:1];
    } else if (UTTypeEqual(self.imageType, kUTTypePNG)) {
        [self.fileTypes selectItemAtIndex:2];
    } else if (UTTypeEqual(self.imageType, kUTTypeTIFF)) {
        [self.fileTypes selectItemAtIndex:3];
    }

    [self fileTypeChanged:nil];

}

- (void)setCompressionSectionVisible:(BOOL)flag {
    //If flag, increase height to make visible, otherwise decrease height to hide it
    [[self.accessoryView animator] setFrameSize:NSMakeSize(self.accessoryView.frame.size.width, flag? 105.0f : 42.0f)];
}

- (void)fileTypeChanged:(id)sender
{
    switch (self.fileTypes.indexOfSelectedItem) {
        case 0:
        {
            self.imageType = kUTTypeJPEG;
            self.compressionBestLabel.stringValue = @"Best";
            break;
        }
        case 1:
        {
            self.imageType = kUTTypeJPEG2000;
            self.compressionBestLabel.stringValue = @"Lossless";
            break;
        }
        case 2:
        {
            self.imageType = kUTTypePNG;
            break;
        }
        case 3: {
            self.imageType = kUTTypeTIFF;
            break;
        }
    }

    if (self.fileTypes.indexOfSelectedItem < 2) {
        //JPEG or JPEG2000
        [self setCompressionSectionVisible:YES];
        [self.compressionFactorLabel setTextColor:[NSColor controlTextColor]];
    } else {
        //PNG or TIFF
        [self setCompressionSectionVisible:NO];
        [self.compressionFactorLabel setTextColor:[NSColor disabledControlTextColor]];
    }

    [self.savePanel setAllowedFileTypes:@[(NSString*)self.imageType]];


    NSString *name = self.savePanel.nameFieldStringValue;
    NSString *nameWithoutExtension = [name stringByDeletingPathExtension];

    if (![name isEqualToString:nameWithoutExtension]) {
        //NSString *correctExtension = (__bridge NSString *)UTTypeCopyPreferredTagWithClass(self.imageType, kUTTagClassFilenameExtension);
        CFStringRef cfCorrectExtension = UTTypeCopyPreferredTagWithClass(self.imageType, kUTTagClassFilenameExtension);
        NSString *correctExtension = CFBridgingRelease(cfCorrectExtension);
        [self.savePanel setNameFieldStringValue:[nameWithoutExtension stringByAppendingPathExtension:correctExtension]];
    }
}

- (NSInteger)runModalForImage:(NSImage *)image error:(NSError **)error
{
    [self configureSavePanel];
    NSInteger result = [self.savePanel runModal];

    if (result == NSFileHandlingPanelOKButton)
        [self saveImage:image];

    return result;
}

- (void)beginWithImage:(NSImage *)image completionHandler:(void (^)(NSInteger result))block
{
    [self configureSavePanel];
    [self.savePanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton)
            [self saveImage:image];

        if (block)
            block(result);
    }];
}

- (void)beginSheetWithImage:(NSImage *)image window:(NSWindow*)window completionHandler:(void (^)(NSInteger))block
{
    [self configureSavePanel];

    [self.savePanel beginSheetModalForWindow:window completionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton)
            [self saveImage:image];

        if (block)
            block(result);
    }];
}

- (void)saveImage:(NSImage *)image
{
    NSData *outData = nil;
    NSBitmapImageRep *bitmapRep = [NSBitmapImageRep imageRepWithData:image.TIFFRepresentation];
    CGFloat compression = self.compressionFactor.floatValue / 100.0f;

    if (UTTypeEqual(self.imageType, kUTTypeJPEG)) {
        //JPEG
        outData = [bitmapRep representationUsingType:NSJPEGFileType properties:@{NSImageCompressionFactor:@(compression)}];
    }
    else if (UTTypeEqual(self.imageType, kUTTypeJPEG2000)) {
        //JPEG2000
        outData = [bitmapRep representationUsingType:NSJPEG2000FileType properties:@{NSImageCompressionFactor:@(compression)}];
    }
    else if (UTTypeEqual(self.imageType, kUTTypePNG)) {
        //PNG
        outData = [bitmapRep representationUsingType:NSPNGFileType properties:nil];
    }
    else if (UTTypeEqual(self.imageType, kUTTypeTIFF)) {
        //TIFF
        outData = [bitmapRep representationUsingType:NSTIFFFileType properties:nil];
    }

    if (outData)
        [outData writeToURL:savePanel.URL atomically:YES];
}

@end
