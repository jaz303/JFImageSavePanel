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

- (void)setCompressionSectionVisible:(BOOL)flag {
    NSRect newFrame = accessoryView.frame;
    
    if (flag) {
        //Yes - make it visible. Increase the height so it is visible.
        newFrame.size.height = 105.0f;
    } else {
        //No - hide it. Decrease the height so it is not visible.
        newFrame.size.height = 44.0f;
    }
    
    [[accessoryView animator] setFrame:newFrame];
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
        
        if (block != nil)
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

- (void)fileTypeChanged:(id)sender
{
    switch ([self.fileTypes indexOfSelectedItem]) {
        case 0:
        {
            self.imageType = kUTTypeJPEG;
            [self setCompressionSectionVisible:YES];
            [self.compressionBestLabel setStringValue:@"Best"];
            [self.compressionFactorLabel setTextColor:[NSColor controlTextColor]];
            [self.savePanel setAllowedFileTypes:@[(NSString*)kUTTypeJPEG]];
            break;
        }
        case 1:
        {
            self.imageType = kUTTypeJPEG2000;
            [self setCompressionSectionVisible:YES];
            [self.compressionBestLabel setStringValue:@"Lossless"];
            [self.compressionFactorLabel setTextColor:[NSColor controlTextColor]];
            [self.savePanel setAllowedFileTypes:@[(NSString*)kUTTypeJPEG2000]];
            break;
            
        }
        case 2:
        {
            self.imageType = kUTTypePNG;
            [self setCompressionSectionVisible:NO];
            [self.compressionFactorLabel setTextColor:[NSColor disabledControlTextColor]];
            [self.savePanel setAllowedFileTypes:@[(NSString*)kUTTypePNG]];
            break;
        }
        case 3: {
            self.imageType = kUTTypeTIFF;
            [self setCompressionSectionVisible:NO];
            [self.compressionFactorLabel setTextColor:[NSColor disabledControlTextColor]];
            [self.savePanel setAllowedFileTypes:@[(NSString*)kUTTypeTIFF]];
            break;
        }
    }
    
    NSString *name = [self.savePanel nameFieldStringValue];
    NSString *nameWithoutExtension = [name stringByDeletingPathExtension];
    
    if (![name isEqualToString:nameWithoutExtension]) {
        CFStringRef cfCorrectExtension = UTTypeCopyPreferredTagWithClass(self.imageType, kUTTagClassFilenameExtension);
        NSString *correctExtension = CFBridgingRelease(cfCorrectExtension);
        name = [nameWithoutExtension stringByAppendingPathExtension:correctExtension];
        [self.savePanel setNameFieldStringValue:name];
    }
}

- (void)saveImage:(NSImage *)image
{
    NSData *outData = nil;
    
    if (UTTypeEqual(self.imageType, kUTTypeJPEG)) {
        
        CGFloat compression = [self.compressionFactor floatValue] / 100.0f;
        
        NSBitmapImageRep *bitmapRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
        outData = [bitmapRep representationUsingType:NSJPEGFileType properties:@{NSImageCompressionFactor: [NSNumber numberWithFloat:compression]}];
        
    } else if (UTTypeEqual(self.imageType, kUTTypeJPEG2000)) {
        
        CGFloat compression = [self.compressionFactor floatValue] / 100.0f;
        
        NSBitmapImageRep *bitmapRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
        outData = [bitmapRep representationUsingType:NSJPEG2000FileType properties:@{NSImageCompressionFactor: [NSNumber numberWithFloat:compression]}];
        
    }
    else if (UTTypeEqual(self.imageType, kUTTypePNG)) {
        
        NSBitmapImageRep *bitmapRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
        outData = [bitmapRep representationUsingType:NSPNGFileType properties:nil];
        
    } else if (UTTypeEqual(self.imageType, kUTTypeTIFF)) {
        
        NSBitmapImageRep *bitmapRep = [NSBitmapImageRep imageRepWithData:[image TIFFRepresentation]];
        outData = [bitmapRep representationUsingType:NSTIFFFileType properties:nil];
    }
    
    if (outData) {
        [outData writeToURL:[savePanel URL] atomically:YES];
    }
}

@end