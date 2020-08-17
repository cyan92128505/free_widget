#import "FreeWidgetPlugin.h"
#if __has_include(<free_widget/free_widget-Swift.h>)
#import <free_widget/free_widget-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "free_widget-Swift.h"
#endif

@implementation FreeWidgetPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftFreeWidgetPlugin registerWithRegistrar:registrar];
}
@end
