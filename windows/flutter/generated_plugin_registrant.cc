//
//  Generated file. Do not edit.
//

// clang-format off

#include "generated_plugin_registrant.h"

#include <flutter_localization/flutter_localization_plugin_c_api.h>
#include <flutter_twain_scanner/flutter_twain_scanner_plugin_c_api.h>

void RegisterPlugins(flutter::PluginRegistry* registry) {
  FlutterLocalizationPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterLocalizationPluginCApi"));
  FlutterTwainScannerPluginCApiRegisterWithRegistrar(
      registry->GetRegistrarForPlugin("FlutterTwainScannerPluginCApi"));
}
