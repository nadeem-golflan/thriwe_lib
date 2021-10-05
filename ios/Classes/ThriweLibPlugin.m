#import "ThriweLibPlugin.h"
#if __has_include(<thriwe_lib/thriwe_lib-Swift.h>)
#import <thriwe_lib/thriwe_lib-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "thriwe_lib-Swift.h"
#endif

@implementation ThriweLibPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftThriweLibPlugin registerWithRegistrar:registrar];
}
@end
