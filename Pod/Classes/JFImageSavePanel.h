#import <Foundation/Foundation.h>

@interface JFImageSavePanel : NSObject

/*
 * Defaults to "Save Image"
 */
@property (retain,nonatomic) NSString           *title;

/*
 * Defaults to kUTTypePNG
 */
@property (assign,nonatomic) const CFStringRef  imageType;

/*
 * Instantiates and returns a new save panel, not a singleton
 */
+ (JFImageSavePanel *)savePanel;

- (NSInteger)runModalForImage:(NSImage *)image error:(NSError **)error;
- (void)beginWithImage:(NSImage *)image completionHandler:(void (^)(NSInteger result))block;

/*
 * Note that this method will not display a title
 */
- (void)beginSheetWithImage:(NSImage *)image window:(NSWindow*)window completionHandler:(void (^)(NSInteger))block;

@end
