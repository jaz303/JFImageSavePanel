#import <Foundation/Foundation.h>

@interface JFImageSavePanel : NSObject
{
}

@property (retain,nonatomic) NSString           *title;
@property (assign,nonatomic) const CFStringRef  imageType;

+ (JFImageSavePanel *)savePanel;

- (NSInteger)runModalForImage:(NSImage *)image error:(NSError **)error;

@end
