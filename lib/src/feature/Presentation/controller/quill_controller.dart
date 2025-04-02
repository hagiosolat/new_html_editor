import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_html_editor/new_html_editor.dart';
import '../../../utils/string_util.dart';
import '../../../core/edit_table_drop_down.dart';
import '../../../core/webviewx/src/models/selection_model.dart';

///[QuillEditorController] controller constructor to generate editor, toolbar state keys
class QuillEditorController {
  //GlobalKey<QuillEditorNewState>? _editorKey;
  GlobalKey<NewEditorScreenState>? _editorKey;
  GlobalKey<ToolBarState>? _toolBarKey;
  StreamController<String>? _changeController;
  StreamController<String>? _editorLoadedController;

  ///[isEnable] to enable/disable editor
  bool isEnable = true;

  /// A controller for the Quill editor.
  ///
  /// The [QuillEditorController] class provides control over the Quill editor by managing its state
  /// and providing methods to interact with the editor's content and toolbar.
  ///
  QuillEditorController() {
    _editorKey =
    GlobalKey<NewEditorScreenState>(debugLabel: _getRandomString(15));
    //  GlobalKey<QuillEditorNewState>(debugLabel: _getRandomString(15));
    _toolBarKey = GlobalKey<ToolBarState>(debugLabel: _getRandomString(15));
    _changeController = StreamController<String>();
    _editorLoadedController = StreamController<String>();
  }

  /// to access toolbar key from toolbar widget
  GlobalKey<ToolBarState>? get toolBarKey => _toolBarKey;

  GlobalKey<NewEditorScreenState>? get editorKey => _editorKey;
 // GlobalKey<QuillEditorNewState>? get editorKey => _editorKey;

  StreamController<String>? get changeController => _changeController;

  StreamController<String>? get editorLoadedController =>
      _editorLoadedController;

  /// [getText] method is used to get the html string from the editor
  /// To avoid getting empty html tags, we are validating the html string
  /// if it doesn't contain any text, the method will return empty string instead of empty html tag
  Future<String> getText() async {
    try {
      String? text = await _editorKey?.currentState?.getHtmlFromEditor;
      if (text == '<p><br></p>') {
        return text!.replaceAll('<p><br></p>', '');
      }
      return text ?? '';
    } catch (e) {
      return "";
    }
  }

  /// Retrieves the plain text content from the editor.
  ///
  /// The [getPlainText] method is used to extract the plain text content from the editor
  /// as a [String]. This can be useful when you need to retrieve the editor's content
  /// without any formatting or HTML tags.
  ///
  Future<String> getPlainText() async {
    try {
      String? text = await _editorKey?.currentState?.getPlainTextFromEditor;
      if (text == null) {
        return "";
      } else {
        return text;
      }
    } catch (e) {
      return "";
    }
  }

  /// Sets the HTML text content in the editor.
  ///
  /// The [setText] method is used to set the HTML text content in the editor,
  /// overriding any existing text with the new content.
  Future setText(String text) async {
    return await _editorKey?.currentState?.setHtmlTextToEditor(text);
  }

  /// Sets the Delta object in the editor.
  ///
  /// The [setDelta] method is used to set the Delta object in the editor,
  /// overriding any existing text with the new content.
  Future setDelta(Map delta) async {
    return await _editorKey?.currentState?.setDeltaToEditor(delta);
  }

  /// Retrieves the Delta map from the editor.
  ///
  /// The [getDelta] method is used to retrieve the Delta map from the editor
  /// as a [Map]. The Delta map represents the content and formatting of the editor.
  ///
  Future<Map> getDelta() async {
    var text = await _editorKey?.currentState?.getDeltaFromEditor;
    return jsonDecode(text.toString());
  }

  /// Requests focus for the editor.
  ///
  /// The [focus] method is used to request focus for the editor,
  /// bringing it into the active input state.
  ///
  Future focus() async {
    return await _editorKey?.currentState?.requestFocus;
  }

  /// Inserts a table into the editor.
  ///
  /// The [insertTable] method is used to insert a table into the editor
  /// with the specified number of rows and columns.
  ///
  Future insertTable(int row, int column) async {
    return await _editorKey?.currentState
        ?.insertTableToEditor(row: row, column: column);
  }

  /// Modifies an existing table in the editor.
  ///
  /// The [modifyTable] method is used to add or remove rows or columns of an existing table in the editor.
  ///
  Future modifyTable(EditTableEnum type) async {
    return await _editorKey?.currentState?.modifyTable(type: type);
  }

  /// Inserts HTML text into the editor.
  ///
  /// The [insertText] method is used to insert HTML text into the editor.
  /// If the [index] parameter is not specified, the text will be inserted at the current cursor position.
  ///
  Future insertText(String text, {int? index}) async {
    return await _editorKey?.currentState
        ?.insertHtmlTextToEditor(htmlText: text, index: index);
  }

  /// Replaces the selected text in the editor.
  ///
  /// The [replaceText] method is used to replace the currently selected text in the editor
  /// with the specified HTML text.
  ///
  /// custom format for replaced text will come in future release
  Future replaceText(String text) async {
    return await _editorKey?.currentState?.replaceText(replaceText: text);
  }

  /// [getSelectedText] method to get the selected text from editor
  Future getSelectedText() async {
    return await _editorKey?.currentState?.getSelectedText;
  }

  /// [getSelectedHtmlText] method to get the selected html text from editor
  Future getSelectedHtmlText() async {
    return await _editorKey?.currentState?.getSelectedHtmlText;
  }

  /// [embedVideo] method is used to embed url of video to the editor
  Future embedVideo(String url) async {
    String? link = StringUtil.sanitizeVideoUrl(url);
    if (link == null) {
      return;
    }
    return await _editorKey?.currentState?.embedVideo(videoUrl: link);
  }

  /// [embedImage] method is used to insert image to the editor
  Future embedImage(String imgSrc) async {
    return await _editorKey?.currentState?.embedImage(imgSrc: imgSrc);
  }

  /// [enableEditor] method is used to enable/ disable the editor,
  /// while, we can enable or disable the editor directly by passing isEnabled to the widget,
  /// this is an additional function that can be used to do the same with the state key
  /// We can choose either of these ways to enable/disable
  void enableEditor(bool enable) async {
    isEnable = enable;
    await _editorKey?.currentState?.enableTextEditor(isEnabled: enable);
  }

  @Deprecated(
      'Please use onFocusChanged method in the QuillHtmlEditor widget for focus')

  /// [hasFocus]checks if the editor has focus, returns the selection string length
  Future<int> hasFocus() async {
    return (await _editorKey?.currentState?.getSelectionCount) ?? 0;
  }

  /// [getSelectionRange] to get the text selection range from editor
  Future<SelectionModel> getSelectionRange() async {
    var selection = await _editorKey?.currentState?.getSelectionRange;
    return selection != null
        ? SelectionModel.fromJson(jsonDecode(selection))
        : SelectionModel(index: 0, length: 0);
  }

  /// [setSelectionRange] to select the text in the editor by index
  Future setSelectionRange(int index, int length) async {
    return await _editorKey?.currentState?.setSelectionRange(index, length);
  }

  ///  [clear] method is used to clear the editor
  void clear() async {
    await _editorKey?.currentState?.setHtmlTextToEditor('');
  }

  /// [requestFocus] method is to request focus of the editor
  void requestFocus() async {
    await _editorKey?.currentState?.requestFocus;
  }

  ///  [unFocus] method is to un focus the editor
  void unFocus() async {
    await _editorKey?.currentState?.unFocus;
  }

  ///[setFormat]  sets the format to editor either by selection or by cursor position
  void setFormat(
      {required String format,
      required dynamic value,
      int index = -1,
      int length = 0}) async {
    _editorKey?.currentState
        ?.setFormat(format: format, value: value, index: index, length: length);
  }

  ///[onTextChanged] method is used to listen to editor text changes
  void onTextChanged(Function(String) data) {
    try {
      if (_changeController != null &&
          _changeController?.hasListener == false) {
        _changeController?.stream.listen((event) {
          data(event);
        });
      }
    } catch (e) {
      if (!kReleaseMode) {
        debugPrint(e.toString());
      }
    }

    return;
  }

  /// Callback function triggered when the editor is completely loaded.
  ///
  /// The [onEditorLoaded] callback function is called when the Quill editor is fully loaded and ready for user interaction.
  /// It provides an opportunity to perform actions or initialize any additional functionality once the editor is loaded.
  ///
  void onEditorLoaded(VoidCallback callback) {
    try {
      if (_editorLoadedController != null &&
          _editorLoadedController?.hasListener == false) {
        _editorLoadedController?.stream.listen((event) {
          callback();
        });
      }
    } catch (e) {
      if (!kReleaseMode) {
        debugPrint(e.toString());
      }
    }

    return;
  }

  ///[dispose] dispose function to close the stream
  void dispose() {
    // _webviewController.dispose();
    _changeController?.close();
    _editorLoadedController?.close();
  }

  ///  [undo] method to undo the changes in editor
  void undo() async {
    print('Testing at the controller level of the undo function');
    print(_editorKey?.currentState);
    await _editorKey?.currentState?.undo;
  }

  ///  [redo] method to redo the changes in editor
  void redo() async {
    print('Testing at the controller level of the redo function');
    await _editorKey?.currentState?.redo;
  }

  ///  [clearHistory] method to clear the history stack of editor
  void clearHistory() async {
    await _editorKey?.currentState?.clearHistory;
  }

  /// [formatText] method to format the selected text with background Color
  void formatText() async {
    await _editorKey?.currentState?.formatText;
  }

  /// [setScrollPosition] method to setScrollPosition
  void setScrollPosition(double scrollPosition) async {
    await _editorKey?.currentState
        ?.setScrollPosition(scrollPosition: scrollPosition);
  }

  /// [setVideoPosition] method to set the Last saved Video Position
  void setVideoPosition(Map<String, dynamic> videos) async {
    await _editorKey?.currentState?.setVideoPosition(videos: videos);
  }
}

const _chars = 'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
Random _rnd = Random();

String _getRandomString(int length) => String.fromCharCodes(Iterable.generate(
    length, (_) => _chars.codeUnitAt(_rnd.nextInt(_chars.length))));
