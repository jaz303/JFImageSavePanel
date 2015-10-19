# JFImageSavePanel

[![Version](https://img.shields.io/cocoapods/v/JFImageSavePanel.svg?style=flat)](http://cocoadocs.org/docsets/JFImageSavePanel)
[![License](https://img.shields.io/cocoapods/l/JFImageSavePanel.svg?style=flat)](http://cocoadocs.org/docsets/JFImageSavePanel)
[![Platform](https://img.shields.io/cocoapods/p/JFImageSavePanel.svg?style=flat)](http://cocoadocs.org/docsets/JFImageSavePanel)

NSSavePanel wrapper for image save dialogs, similar to those in Preview.app.

## A quick note about `IKSaveOptions`

Apple provides [`IKSaveOptions`](https://developer.apple.com/library/mac/documentation/GraphicsImaging/Reference/IKSaveOptions/index.html#//apple_ref/doc/uid/TP40004705-CH3-DontLinkElementID_8), a class that offers similar functionality which I wasn't aware of when I first wrote this library. It might be worth checking this out first to see if it meets your needs; thanks to Marek Hrušovský for heads-up.

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

JFImageSavePanel is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

    pod "JFImageSavePanel"

## Screenshot

![JFImageSavePanel](https://github.com/jaz303/JFImageSavePanel/raw/master/screenshot.png)

## Usage Example

    JFImageSavePanel *panel = [JFImageSavePanel savePanel];
    
    NSImage *image = [[NSImage alloc] initWithContentsOfURL:[NSURL URLWithString:@"http://..."]];
    
    // This is the default image type, which can be changed.
    // Possible values: kUTTypeJPEG, kUTTypeJPEG2000, kUTTypePNG, kUTTypeTIFF.
    [panel setImageType:kUTTypeJPEG];
    
    // Image will be saved to selected path if 'OK' button is pressed
    [panel runModalForImage:image error:NULL];
    
## Contributors

  * [Seb Jachec](http://github.com/sebj)
  * [Jason Frame](http://github.com/jaz303)

## Copyright and License

&copy; 2012 Jason Frame [ [jason@onehackoranother.com](mailto:jason@onehackoranother.com) / [@jaz303](http://twitter.com/jaz303) ]  
MIT Licensed
