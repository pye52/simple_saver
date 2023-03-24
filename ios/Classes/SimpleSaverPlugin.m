#import "SimpleSaverPlugin.h"
#if __has_include(<simple_saver/simple_saver-Swift.h>)
#import <simple_saver/simple_saver-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "simple_saver_-Swift.h"
#endif

@implementation SimpleSaverPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftSimpleSaverPlugin registerWithRegistrar:registrar];
}
@end
