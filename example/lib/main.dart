import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_html_editor/new_html_editor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  QuillEditorController controller = QuillEditorController();
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home:
        //EditorScreen()
        NewEditorScreen(controller: controller),
      ),
    ),
  );
}
