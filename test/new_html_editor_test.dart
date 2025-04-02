// import 'package:flutter_test/flutter_test.dart';
// import 'package:new_html_editor/new_html_editor.dart';
// import 'package:new_html_editor/new_html_editor_platform_interface.dart';
// import 'package:new_html_editor/new_html_editor_method_channel.dart';
// import 'package:plugin_platform_interface/plugin_platform_interface.dart';

// class MockNewHtmlEditorPlatform
//     with MockPlatformInterfaceMixin
//     implements NewHtmlEditorPlatform {

//   @override
//   Future<String?> getPlatformVersion() => Future.value('42');
// }

// void main() {
//   final NewHtmlEditorPlatform initialPlatform = NewHtmlEditorPlatform.instance;

//   test('$MethodChannelNewHtmlEditor is the default instance', () {
//     expect(initialPlatform, isInstanceOf<MethodChannelNewHtmlEditor>());
//   });

//   test('getPlatformVersion', () async {
//     NewHtmlEditor newHtmlEditorPlugin = NewHtmlEditor();
//     MockNewHtmlEditorPlatform fakePlatform = MockNewHtmlEditorPlatform();
//     NewHtmlEditorPlatform.instance = fakePlatform;

//     expect(await newHtmlEditorPlugin.getPlatformVersion(), '42');
//   });
// }
