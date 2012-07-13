#import "JFImageSavePanel.h"

@interface JFImageSavePanel ()
@property (retain) NSSavePanel              *savePanel;
@property (assign) IBOutlet NSView          *accessoryView;
@property (assign) IBOutlet NSPopUpButton   *fileTypes;
@property (assign) IBOutlet NSSlider        *compressionFactor;
@property (assign) IBOutlet NSTextField     *compressionFactorLabel;

- (void)configureSavePanel;
- (void)fileTypeChanged:(id)sender;
- (void)saveImage:(NSImage *)image;

@end

@implementation JFImageSavePanel

@synthesize title, imageType;
@synthesize savePanel, accessoryView, fileTypes, compressionFactor, compressionFactorLabel;

+ (JFImageSavePanel *)savePanel
{
    JFImageSavePanel *panel = [[JFImageSavePanel alloc] init];
    return [panel autorelease];
}

- (id)init
{
    self = [super init];
    if (self) {
        
        self.title      = @"Save Image";
        self.imageType  = kUTTypePNG;
        
        self.savePanel  = [NSSavePanel savePanel];
        
        NSNib *accessoryNib = [[NSNib alloc] initWithNibNamed:@"JFImageSavePanelAccessoryView" bundle:nil];
        [accessoryNib instantiateNibWithOwner:self topLevelObjects:nil];
        
        [self.fileTypes setTarget:self];
        [self.fileTypes setAction:@selector(fileTypeChanged:)];
        
        [accessoryNib release];
    
    }
    return self;
}

- (void)dealloc
{
    self.title = nil;
    
    self.savePanel = nil;
    
    [self.accessoryView release];
}

- (NSInteger)runModalForImage:(NSImage *)image error:(NSError **)error
{
    [self configureSavePanel];
    NSInteger result = [self.savePanel runModal];
    
    if (result == NSFileHandlingPanelOKButton) {
        [self saveImage:image];
    }
    
    return result;
}

- (void)beginWithImage:(NSImage *)image completionHandler:(void (^)(NSInteger result))block
{
    [self configureSavePanel];
    [self.savePanel beginWithCompletionHandler:^(NSInteger result) {
        if (result == NSFileHandlingPanelOKButton) {
            [self saveImage:image];
        }
        
        block(result);
    }];
}

- (void)configureSavePanel
{
    [self.savePanel setAccessoryView:self.accessoryView];
    
    [self.savePanel setCanCreateDirectories:YES];
    [self.savePanel setCanSelectHiddenExtension:YES];
    [self.savePanel setExtensionHidden:NO];
    [self.savePanel setAllowsOtherFileTypes:YES];
    
    [self.savePanel setTitle:self.title];

    if (UTTypeEqual(self.imageType, kUTTypeJPEG)) {
        [self.fileTypes selectItemAtIndex:0];
    } else if (UTTypeEqual(self.imageType, kUTTypePNG)) {
        [self.fileTypes selectItemAtIndex:1];
    } else if (UTTypeEqual(self.imageType, kUTTypeTIFF)) {
        [self.fileTypes selectItemAtIndex:2];
    }
    
    [self fileTypeChanged:nil];
    
}

- (void)fileTypeChanged:(id)sender
{
    switch ([self.fileTypes indexOfSelectedItem]) {
        case 0:
        {
            self.imageType = kUTTypeJPEG;
            [self.compressionFactor setEnabled:YES];
            [self.compressionFactorLabel setTextColor:[NSColor controlTextColor]];
            [self.savePanel setAllowedFileTypes:[NSArray arrayWithObjects:(NSString*)kUTTypeJPEG, nil]];
            break;
        }
        case 1:
        {
            self.imageType = kUTTypePNG;
            [self.compressionFactor setEnabled:NO];
            [self.compressionFactorLabel setTextColor:[NSColor disabledControlTextColor]];
            [self.savePanel setAllowedFileTypes:[NSArray arrayWithObjects:(NSString*)kUTTypePNG, nil]];
            break;
        }
        case 2:
        {
            self.imageType = kUTTypeTIFF;
            [self.compressionFactor setEnabled:NO];
            [self.compressionFactorLabel setTextColor:[NSColor disabledControlTextColor]];
            [self.savePanel setAllowedFileTypes:[NSArray arrayWithObjects:(NSString*)kUTTypeTIFF, nil]];
            break;
        }
    }
    
    NSString *name = [self.savePanel nameFieldStringValue];
    NSString *nameWithoutExtension = [name stringByDeletingPathExtension];
    
    if (![name isEqualToString:nameWithoutExtension]) {
        NSString *correctExtension = (NSString *) UTTypeCopyPreferredTagWithClass(self.imageType, kUTTagClassFilenameExtension);
        name = [nameWithoutExtension stringByAppendingPathExtension:correctExtension];
        [self.savePanel setNameFieldStringValue:name];
    }
}

- (void)saveImage:(NSImage *)image
{
    NSData *outData = nil;
    
    if (UTTypeEqual(self.imageType, kUTTypeJPEG)) {
        CGFloat compression = [self.compressionFactor floatValue] / 100.0f;
        outData = [NSBitmapImageRep representationOfImageRepsInArray:[image representations]
                                                           usingType:NSJPEGFileType
                                                          properties:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                      [NSNumber numberWithFloat:compression], NSImageCompressionFactor, nil]];
    } else if (UTTypeEqual(self.imageType, kUTTypePNG)) {
        outData = [NSBitmapImageRep representationOfImageRepsInArray:[image representations]
                                                           usingType:NSPNGFileType
                                                          properties:nil];
    } else if (UTTypeEqual(self.imageType, kUTTypeTIFF)) {
        outData = [NSBitmapImageRep representationOfImageRepsInArray:[image representations]
                                                           usingType:NSTIFFFileType
                                                          properties:nil];        
    }
    
    if (outData) {
        [outData writeToURL:[savePanel URL] atomically:YES];
    }
}

@end
