#import "ShareimagePlugin.h"
#import <shareimage/shareimage-Swift.h>

@implementation ShareimagePlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftShareimagePlugin registerWithRegistrar:registrar];
}
@end
