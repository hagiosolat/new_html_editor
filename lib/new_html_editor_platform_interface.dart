import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'new_html_editor_method_channel.dart';

abstract class NewHtmlEditorPlatform extends PlatformInterface {
  /// Constructs a NewHtmlEditorPlatform.
  NewHtmlEditorPlatform() : super(token: _token);

  static final Object _token = Object();

  static NewHtmlEditorPlatform _instance = MethodChannelNewHtmlEditor();

  /// The default instance of [NewHtmlEditorPlatform] to use.
  ///
  /// Defaults to [MethodChannelNewHtmlEditor].
  static NewHtmlEditorPlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [NewHtmlEditorPlatform] when
  /// they register themselves.
  static set instance(NewHtmlEditorPlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
