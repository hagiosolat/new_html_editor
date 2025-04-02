import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_html_editor/src/html_text.dart';
import '../../../../../new_html_editor.dart';
import '../../../../core/edit_table_drop_down.dart';
import '../../../../core/webviewx/src/models/scroll_position.dart';
import '../../../../core/webviewx/src/models/selection_model.dart';
import '../../../../core/webviewx/src/models/video_progress.dart';

/// A typedef representing a loading builder function.
///
/// A [LoadingBuilderNew] is a function that takes a [BuildContext] as an argument
/// and returns a [Widget]. It is typically used in conjunction with asynchronous
/// operations or data fetching, allowing you to display a loading indicator or
/// any other UI element during the loading process.
typedef LoadingBuilderNew = Widget Function(BuildContext context);

class QuillEditorNew extends ConsumerStatefulWidget {
  QuillEditorNew({
    this.text,
    required this.controller,
    required this.minHeight,
    this.isEnabled = true,
    this.onTextChanged,
    this.backgroundColor = Colors.white,
    this.hintText = 'Start typing something amazing',
    this.onFocusChanged,
    this.onEditorCreated,
    this.onSelectionChanged,
    this.padding = EdgeInsets.zero,
    this.hintTextPadding = EdgeInsets.zero,
    this.hintTextAlign = TextAlign.start,
    this.onEditorResized,
    this.onEditingComplete,
    this.ensureVisible = false,
    this.loadingBuilder,
    this.inputAction = InputAction.newline,
    this.autoFocus = false,
    this.textStyle = const TextStyle(
      fontStyle: FontStyle.normal,
      fontSize: 20.0,
      color: Colors.black87,
      fontWeight: FontWeight.normal,
    ),
    this.hintTextStyle = const TextStyle(
      fontStyle: FontStyle.normal,
      fontSize: 20.0,
      color: Colors.black87,
      fontWeight: FontWeight.normal,
    ),
    this.navigationDelegate,
    this.onVerticalScrollChange,
    this.webVideoTracking,
    this.lastScrollPosition = 0,
    this.videoLink,
    this.videosDuration,
    this.watchedVideo,
  }) : super(key: controller.editorKey);

  /// [text] to set initial text to the editor, please use text
  /// We can also use the setText method for the same
  final String? text;

  /// [minHeight] to define the minimum height of the editor
  final double minHeight;

  /// [hintText] is a placeholder, by default, the hint will be 'Description'
  /// We can override the placeholder text by passing hintText to the editor
  final String? hintText;

  /// [isEnabled] as the name suggests, is used to enable or disable the editor
  /// When it is set to false, the user cannot edit or type in the editor
  final bool isEnabled;

  /// [controller] to access all the methods of editor and toolbar
  final QuillEditorController controller;

  /// [onTextChanged] callback function that triggers on text changed
  final Function(String)? onTextChanged;

  /// [onEditingComplete] callback function that triggers on editing completed
  final Function(String)? onEditingComplete;

  ///[backgroundColor] to set the background color of the editor
  final Color backgroundColor;

  ///[onFocusChanged] method returns a boolean value, if the editor has focus,
  ///it will return true; if not, will return false
  final Function(bool)? onFocusChanged;

  ///[onSelectionChanged] method returns SelectionModel, which has index and
  ///length of the selected text
  final Function(SelectionModel)? onSelectionChanged;

  ///[onEditorResized] method returns height of the widget on resize,
  final Function(double)? onEditorResized;

  ///[onEditorCreated] a callback method triggered once the editor is created
  ///it will be called only once after editor is loaded completely
  final VoidCallback? onEditorCreated;

  ///[textStyle] optional style for the default editor text,
  ///while all fields in the style are not mapped;Some basic fields like,
  ///fontStyle, fontSize, color,fontWeight can be applied
  ///font family support is not available yet
  final TextStyle? textStyle;

  ///[padding] optional style to set padding to the editor's text,
  /// default padding will be EdgeInsets.zero
  final EdgeInsets? padding;

  ///[hintTextStyle] optional style for the hint text styepe,
  ///while all fields in the style are not mapped;Some basic fields like,
  ///fontStyle, fontSize, color,fontWeight can be applied
  ///font family support is not available yet
  final TextStyle? hintTextStyle;

  ///[hintTextAlign] optional style to align the editor's hint text
  /// default value is hintTextAlign.start
  final TextAlign? hintTextAlign;

  ///[hintTextPadding] optional style to set padding to the editor's text,
  /// default padding will be EdgeInsets.zero
  final EdgeInsets? hintTextPadding;

  /// [ensureVisible] by default it will be set to false, set it to true to
  /// make sure the focus area of the editor is visible.
  /// Note:  Please make sure to wrap the editor with SingleChildScrollView, to make the
  /// editor scrollable.
  final bool? ensureVisible;

  /// A builder function that provides a widget to display while the data is loading.
  ///
  /// The [loadingBuilder] is responsible for creating a widget that represents the
  /// loading state of the custom widget. It is called when the data is being fetched
  /// or processed, allowing you to display a loading indicator or any other UI element
  /// that indicates the ongoing operation.
  final LoadingBuilderNew? loadingBuilder;

  /// Represents an optional input action within a specific context.
  ///
  /// An instance of this class holds an optional [InputAction] value, which can be either
  /// [InputAction.newline] indicating a line break or [InputAction.send] indicating
  /// that the input content should be sent or submitted.
  final InputAction? inputAction;

  /// [autoFocus] Whether the widget should automatically request focus when it is inserted
  /// into the widget tree. If set to `true`, the widget will request focus
  /// immediately after being built and inserted into the tree. If set to `false`,
  /// it will not request focus automatically.
  ///
  /// The default value is `false`
  /// **Note** due to limitations of flutter webview at the moment, focus doesn't launch the keyboard in mobile, however, it will set the cursor at the end on focus.
  final bool? autoFocus;

  /// [navigationDelegate] to override the default navigation from the UI code sesssion.
  final NavigationDelegate? navigationDelegate;

  /// [onVerticalScrollChange] to get the value of the scrolling vertically.
  final Function(CustomScrollPosition)? onVerticalScrollChange;

  /// [lastScrollPosition] this is the value of the last position of the web page
  final num? lastScrollPosition;

  /// [videoLink] this is a callback to get the video Link generated from the Javascript sid
  final Function(String)? videoLink;

  /// [webVideoTracking] to get the values of the video progress
  final Function(VideoProgressTracking)? webVideoTracking;

  /// [videosDuration] to get the duration of the saved videos
  final Map<String, dynamic>? videosDuration;

  /// [watchedVideo] to track the progress of the video
  final Function(String)? watchedVideo;

  @override
  ConsumerState<QuillEditorNew> createState() => QuillEditorNewState();
}

class QuillEditorNewState extends ConsumerState<QuillEditorNew> {
  /// it is the controller used to access the functions of quill js library
  late WebViewXController _webviewController;

  /// this variable is used to set the html code that renders the quill js library
  String _initialContent = "";

  /// [isEnabled] as the name suggests, is used to enable or disable the editor
  /// When it is set to false, the user cannot edit or type in the editor
  bool isEnabled = true;

  late double _currentHeight;
  bool _hasFocus = false;
  //String _quillJsScript = '';
  //late Future _loadScripts;
  late String _fontFamily;
  late String _encodedStyle;
  bool _editorLoaded = false;

  @override
  void initState() {
    _fontFamily = widget.textStyle?.fontFamily ?? 'Roboto';
    _encodedStyle = Uri.encodeFull(_fontFamily);
    isEnabled = widget.isEnabled;
    _currentHeight = widget.minHeight;
    // print("The current height is this $_currentHeight");
    // Future.microtask((){
    //       ref.read(editorControllerProvider.notifier).startIsolateAndLoadHtml({
    //     'fontFamily': _fontFamily,
    //     'backgroundColor': widget.backgroundColor,
    //     'encodedStyle': _encodedStyle,
    //     'hintTextPadding': widget.hintTextPadding,
    //     'hintTextStyle': widget.hintTextStyle,
    //     'hintText': widget.hintText,
    //     'textStyle': widget.textStyle,
    //     'isEnabled': widget.isEnabled,
    //     'hintTextAlign': widget.hintTextAlign,
    //     'inputAction': widget.inputAction,
    //     'minHeight': widget.minHeight,
    //     'padding': widget.padding,
    //   });
    // });

    // WidgetsBinding.instance.addPostFrameCallback((_) {

    // });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorControllerProvider);
    // return LayoutBuilder(builder: (context, constraints) {
    //   final width = constraints.maxWidth;
    //  // return _buildEditorView(context: context, width: width, scripts: state!);
    //   //return Text(state ?? 'No data at the moment yet');
    //   return state.when(
    //       data: (data) {
    //         print(
    //             '@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@Data at the UI $data');
    //         _initialContent = data;
    //         return _buildEditorView(
    //             context: context, width: width, scripts: data);
    //       },
    //       loading: () => Center(
    //             child: CircularProgressIndicator(
    //               color: Colors.green,
    //               strokeWidth: 0.3,
    //             ),
    //           ),
    //       error: (e, _) => Column(
    //             children: [
    //               Icon(Icons.error),
    //               Text(e.toString()),
    //             ],
    //           ));
    // });

    return state.when(
        data: (data) => LayoutBuilder(builder: (context, constraints) {
              // print(data);
              // print(data['imageBlotScript']);
              _initialContent = getQuillPage(
                width: constraints.maxWidth,
                quillJsScript: data,
                fontFamily: _fontFamily,
                backgroundColor: widget.backgroundColor,
                encodedStyle: _encodedStyle,
                hintTextPadding: widget.hintTextPadding,
                hintTextStyle: widget.hintTextStyle,
                hintText: widget.hintText,
                textStyle: widget.textStyle,
                isEnabled: widget.isEnabled,
                hintTextAlign: widget.hintTextAlign,
                inputAction: widget.inputAction,
                minHeight: widget.minHeight,
                padding: widget.padding,
              );
              return _buildEditorView(
                context: context,
                width: constraints.maxWidth,
                scripts: data,
              );
            }),
        loading: () => Center(
              child: CircularProgressIndicator(
                color: Colors.green,
                strokeWidth: 0.3,
              ),
            ),
        error: (e, _) => Column(
              children: [
                Icon(Icons.error),
                Text(e.toString()),
              ],
            ));
  }

  Widget _buildEditorView({
    required BuildContext context,
    required double width,
    required String scripts,
  }) {
    //  _initialContent = scripts;
    print('This is the current Height $_currentHeight');
    return Stack(
      children: [
        Visibility(
          visible: true,
          child: WebViewX(
            key: ValueKey(widget.controller.toolBarKey.hashCode.toString()),
            initialContent: _initialContent,
            initialSourceType: SourceType.html,
            height: _currentHeight,
            onPageStarted: (s) {
              _editorLoaded = false;
              if (kIsWeb) {
                Future.delayed(const Duration(microseconds: 2)).then((value) {
                  widget.controller.enableEditor(isEnabled);
                  if (widget.text != null) {
                    setHtmlTextToEditor(widget.text!);
                    _webviewController.callJsMethod('setScrollPosition',
                        [widget.lastScrollPosition?.toInt()]);
                    setVideoPosition(videos: widget.videosDuration ?? {});
                  }
                });
              }
            },
            ignoreAllGestures: false,
            width: width,
            onWebViewCreated: (controller) => _webviewController = controller,
            onPageFinished: (src) {
              Future.delayed(const Duration(microseconds: 1)).then((value) {
                _editorLoaded = true;
                debugPrint('_editorLoaded $_editorLoaded');
                if (mounted) {
                  setState(() {});
                }
                widget.controller.enableEditor(isEnabled);
                if (widget.text != null) {
                  setHtmlTextToEditor(widget.text!);
                }
                if (widget.autoFocus == true) {
                  widget.controller.focus();
                }
                if (widget.onEditorCreated != null) {
                  widget.onEditorCreated!();
                }
                widget.controller.editorLoadedController?.add('');
                _webviewController.callJsMethod(
                    'setScrollPosition', [widget.lastScrollPosition?.toInt()]);
                if (kIsWeb) {
                  setVideoPosition(videos: widget.videosDuration ?? {});
                }
              });
            },
            dartCallBacks: {
              DartCallback(
                  name: 'EditorResizeCallback',
                  callBack: (height) {
                    if (_currentHeight == double.tryParse(height.toString())) {
                      return;
                    }
                    try {
                      _currentHeight = double.tryParse(height.toString()) ??
                          widget.minHeight;
                    } catch (e) {
                      _currentHeight = widget.minHeight;
                    } finally {
                      if (mounted) {
                        setState(() => _currentHeight);
                      }
                      if (widget.onEditorResized != null) {
                        widget.onEditorResized!(_currentHeight);
                      }
                    }
                  }),
              DartCallback(
                  name: 'UpdateFormat',
                  callBack: (map) {
                    try {
                      if (widget.controller.toolBarKey != null) {
                        widget.controller.toolBarKey!.currentState
                            ?.updateToolBarFormat(jsonDecode(map));
                      }
                    } catch (e) {
                      if (!kReleaseMode) {
                        debugPrint(e.toString());
                      }
                    }
                  }),
              DartCallback(
                  name: 'OnTextChanged',
                  callBack: (map) {
                    var tempText = "";
                    if (tempText == map) {
                      return;
                    } else {
                      tempText = map;
                    }
                    try {
                      if (widget.controller.changeController != null) {
                        String finalText = "";
                        String parsedText = stripHtmlIfNeeded(map);
                        if (parsedText.trim() == "") {
                          finalText = "";
                        } else {
                          finalText = map;
                        }
                        if (widget.onTextChanged != null) {
                          widget.onTextChanged!(finalText);
                        }
                        widget.controller.changeController!.add(finalText);
                      }
                    } catch (e) {
                      if (!kReleaseMode) {
                        debugPrint(e.toString());
                      }
                    }
                  }),
              DartCallback(
                  name: 'FocusChanged',
                  callBack: (map) {
                    _hasFocus = map?.toString() == 'true';
                    if (widget.onFocusChanged != null) {
                      widget.onFocusChanged!(_hasFocus);
                    }

                    /// scrolls to the end of the text area, to keep the focus visible
                    if (widget.ensureVisible == true && _hasFocus) {
                      Scrollable.of(context).position.ensureVisible(
                          context.findRenderObject()!,
                          duration: const Duration(milliseconds: 300),
                          alignmentPolicy:
                              ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
                          curve: Curves.fastLinearToSlowEaseIn);
                    }
                  }),
              DartCallback(
                  name: 'OnEditingCompleted',
                  callBack: (map) {
                    var tempText = "";
                    if (tempText == map) {
                      return;
                    } else {
                      tempText = map;
                    }
                    try {
                      if (widget.controller.changeController != null) {
                        String finalText = "";
                        String parsedText = stripHtmlIfNeeded(map);
                        if (parsedText.trim() == "") {
                          finalText = "";
                        } else {
                          finalText = map;
                        }
                        if (widget.onEditingComplete != null) {
                          widget.onEditingComplete!(finalText);
                        }
                        widget.controller.changeController!.add(finalText);
                      }
                    } catch (e) {
                      if (!kReleaseMode) {
                        debugPrint(e.toString());
                      }
                    }
                  }),
              DartCallback(
                  name: 'OnSelectionChanged',
                  callBack: (selection) {
                    try {
                      if (widget.onSelectionChanged != null) {
                        if (!_hasFocus) {
                          if (widget.onFocusChanged != null) {
                            _hasFocus = true;
                            widget.onFocusChanged!(_hasFocus);
                          }
                        }
                        widget.onSelectionChanged!(selection != null
                            ? SelectionModel.fromJson(jsonDecode(selection))
                            : SelectionModel(index: 0, length: 0));
                      }
                    } catch (e) {
                      if (!kReleaseMode) {
                        debugPrint(e.toString());
                      }
                    }
                  }),

              /// callback to notify once editor is completely loaded
              DartCallback(
                  name: 'EditorLoaded',
                  callBack: (map) {
                    _editorLoaded = true;
                    if (mounted) {
                      setState(() {});
                    }
                  }),
              DartCallback(
                  name: 'GetVideoTracking',
                  callBack: (timing) {
                    try {
                      if (timing != null) {
                        widget.webVideoTracking!(
                            VideoProgressTracking.fromJson(jsonDecode(timing)));
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  }),

              DartCallback(
                  name: 'VideoStateChange',
                  callBack: (msg) {
                    try {
                      if (msg != null) {
                        if (widget.videoLink != null) {
                          //  print('Testing the video link $msg');
                          //  widget.videoLink!(msg.toString());
                        }
                      }
                    } catch (e) {
                      debugPrint(e.toString());
                    }
                  }),
              DartCallback(
                  name: 'GetScrollPosition',
                  callBack: (message) {
                    try {
                      if (message != null) {
                        widget.onVerticalScrollChange!(
                            CustomScrollPosition.fromJson(jsonDecode(message)));
                      }
                    } catch (e) {
                      //   print(e.toString());
                    }
                  }),

              DartCallback(
                  name: 'GetVideoUrl',
                  callBack: (message) {
                    try {
                      if (message != null) {
                        //  if (widget.videoLink != null) {
                        print('This is the videoUrl ${message.toString()}');
                        widget.videoLink!(message.toString());
                        // }
                      }
                    } catch (e) {
                      //   print(e.toString());
                    }
                  }),
              DartCallback(
                  name: 'WatchVideo',
                  callBack: (message) {
                    try {
                      if (message != null) {
                        widget.watchedVideo!(message.toString());
                      }
                    } catch (e) {
                      //
                    }
                  })
            },
            webSpecificParams: const WebSpecificParams(
              printDebugInfo: false,
            ),
            mobileSpecificParams: const MobileSpecificParams(
              androidEnableHybridComposition: true,
            ),
            navigationDelegate: widget.navigationDelegate,
          ),
        ),
      ],
    );
  }

  Future<String> get getHtmlFromEditor => _getHtmlFromEditor();

  Future<String> get getPlainTextFromEditor => _getPlainTextFromEditor();

  Future<String> get getDeltaFromEditor => _getDeltaFromEditor();

  Future<int> get getSelectionCount => _getSelectionCount();

  Future<dynamic> get getSelectionRange => _getSelectionRange();

  Future<dynamic> setSelectionRange(int index, int length) =>
      _setSelectionRange(index, length);

  Future setHtmlTextToEditor(String text) =>
      _setHtmlTextToEditor(htmlText: text);

  Future setDeltaToEditor(Map<dynamic, dynamic> deltaMap) =>
      _setDeltaToEditor(deltaMap: deltaMap);

  Future get requestFocus => _requestFocus();

  Future get unFocus => _unFocus();

  Future insertHtmlTextToEditor({required String htmlText, int? index}) =>
      _insertHtmlTextToEditor(htmlText: htmlText, index: index);

  Future embedVideo({required String videoUrl}) =>
      _embedVideo(videoUrl: videoUrl);

  Future embedImage({required String imgSrc}) => _embedImage(imgSrc: imgSrc);

  Future enableTextEditor({required bool isEnabled}) =>
      _enableTextEditor(isEnabled: isEnabled);

  Future setFormat({
    required String format,
    required dynamic value,
    int index = -1,
    int length = 0,
  }) =>
      _setFormat(format: format, value: value, index: index, length: length);

  Future insertTableToEditor({required int row, required int column}) =>
      _insertTableToEditor(row: row, column: column);

  Future modifyTable({required EditTableEnum type}) => _modifyTable(type);

  Future replaceText({required String replaceText}) =>
      _replaceText(replaceText);

  Future get getSelectedText => _getSelectedText();

  Future get getSelectedHtmlText => _getSelectedHtmlText();

  Future get undo => _undo();

  Future get redo => _redo();

  Future get clearHistory => _clearHistory();

  Future get formatText => _formatText();

  Future setScrollPosition({required double scrollPosition}) =>
      _setScrollPosition(scrollPosition: scrollPosition);

  Future setVideoPosition({required Map<String, dynamic> videos}) =>
      _setVideoPosition(videos: videos);

  String stripHtmlIfNeeded(text) => _stripHtmlIfNeeded(text);

  /// it is a regex method to remove the tags and replace them with empty space
  static String _stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  /// a private method to get the Html text from the editor
  Future<String> _getHtmlFromEditor() async {
    return await _webviewController.callJsMethod("getHtmlText", []);
  }

  /// a private method to get the Plain text from the editor
  Future<String> _getPlainTextFromEditor() async {
    return await _webviewController.callJsMethod("getPlainText", []);
  }

  /// a private method to get the delta  from the editor
  Future<String> _getDeltaFromEditor() async {
    return await _webviewController.callJsMethod("getDelta", []);
  }

  /// a private method to check if editor has focus
  Future<int> _getSelectionCount() async {
    return await _webviewController.callJsMethod("getSelection", []);
  }

  /// a private method to check if editor has focus
  Future<dynamic> _getSelectionRange() async {
    return await _webviewController.callJsMethod("getSelectionRange", []);
  }

  /// a private method to check if editor has focus
  Future<dynamic> _setSelectionRange(int index, int length) async {
    return await _webviewController
        .callJsMethod("setSelection", [index, length]);
  }

  /// a private method to set the Html text to the editor
  Future _setHtmlTextToEditor({required String htmlText}) async {
    return await _webviewController
        .callJsMethod("setHtmlText", [htmlText, kIsWeb, widget.isEnabled]);
  }

  /// a private method to set the Delta  text to the editor
  Future _setDeltaToEditor({required Map<dynamic, dynamic> deltaMap}) async {
    return await _webviewController
        .callJsMethod("setDeltaContent", [jsonEncode(deltaMap)]);
  }

  /// a private method to request focus to the editor
  Future _requestFocus() async {
    return await _webviewController.callJsMethod("requestFocus", []);
  }

  /// a private method to un focus the editor
  Future _unFocus() async {
    return await _webviewController.callJsMethod("unFocus", []);
  }

  /// a private method to insert the Html text to the editor
  Future _insertHtmlTextToEditor({required String htmlText, int? index}) async {
    return await _webviewController
        .callJsMethod("insertHtmlText", [htmlText, index]);
  }

  /// a private method to embed the video to the editor
  Future _embedVideo({required String videoUrl}) async {
    return await _webviewController.callJsMethod("embedVideo", [videoUrl]);
  }

  /// a private method to embed the image to the editor
  Future _embedImage({required String imgSrc}) async {
    return await _webviewController.callJsMethod("embedImage", [imgSrc]);
  }

  /// a private method to enable/disable the editor
  Future _enableTextEditor({required bool isEnabled}) async {
    return await _webviewController.callJsMethod("enableEditor", [isEnabled]);
  }

  /// a private method to enable/disable the editor
  Future _setFormat({
    required String format,
    required dynamic value,
    int index = -1,
    int length = 0,
  }) async {
    try {
      return await _webviewController
          .callJsMethod("setFormat", [format, value, index, length]);
    } catch (e) {
      _printWrapper(false, e.toString());
    }
  }

  /// a private method to insert table by row and column to the editor
  Future _insertTableToEditor({required int row, required int column}) async {
    return await _webviewController.callJsMethod("insertTable", [row, column]);
  }

  /// a private method to add remove or delete table in the editor
  Future _modifyTable(EditTableEnum type) async {
    return await _webviewController.callJsMethod("modifyTable", [type.name]);
  }

  /// a private method to replace selection text in the editor
  Future _replaceText(
    String replaceText,
  ) async {
    return await _webviewController
        .callJsMethod("replaceSelection", [replaceText]);
  }

  /// a private method to get the selected text from editor
  Future _getSelectedText() async {
    return await _webviewController.callJsMethod("getSelectedText", []);
  }

  /// a private method to get the selected html text from editor
  Future _getSelectedHtmlText() async {
    return await _webviewController.callJsMethod("getSelectionHtml", []);
  }

  /// a private method to undo the history
  Future _undo() async {
    return await _webviewController.callJsMethod("undo", []);
  }

  /// a private method to redo the history
  Future _redo() async {
    return await _webviewController.callJsMethod("redo", []);
  }

  /// a private method to clear the history stack
  Future _clearHistory() async {
    return await _webviewController.callJsMethod("clearHistory", []);
  }

  /// a formatted text upon selection
  Future _formatText() async {
    return await _webviewController.callJsMethod("setFormatText", []);
  }

  /// set the savedScrollPosition to load the pre-existing web Position
  Future _setScrollPosition({required double scrollPosition}) async {
    return await _webviewController
        .callJsMethod("setScrollPosition", [scrollPosition]);
  }

  Future _setVideoPosition({required Map<String, dynamic> videos}) async {
    return await _webviewController
        .callJsMethod("setVideoPosition", [jsonEncode(videos)]);
  }
}

void _printWrapper(bool showPrint, String text) {
  if (showPrint) {
    debugPrint(text);
  }
}
