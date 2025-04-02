import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'new_html_editor_platform_interface.dart';

/// An implementation of [NewHtmlEditorPlatform] that uses method channels.
class MethodChannelNewHtmlEditor extends NewHtmlEditorPlatform {
  /// The method channel used to interact with the native platform.
  @visibleForTesting
  final methodChannel = const MethodChannel('new_html_editor');

  @override
  Future<String?> getPlatformVersion() async {
    final version = await methodChannel.invokeMethod<String>('getPlatformVersion');
    return version;
  }
}
