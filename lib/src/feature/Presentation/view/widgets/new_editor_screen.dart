// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_html_editor/new_html_editor.dart';
import 'package:new_html_editor/src/feature/Presentation/view/widgets/comment_edit_widget.dart';
import 'package:new_html_editor/src/feature/Presentation/view/widgets/comment_item_widget.dart';
import 'package:new_html_editor/src/feature/Presentation/view/widgets/mobile_youtube_video.dart';
import 'package:new_html_editor/src/feature/Presentation/view/widgets/progress_bar.dart';
import 'package:new_html_editor/src/feature/Presentation/view/widgets/show_web_video.dart';
import 'package:new_html_editor/src/html_text.dart';
import '../../../../core/edit_table_drop_down.dart';
import '../../../../core/webviewx/src/models/scroll_position.dart';
import '../../../../core/webviewx/src/models/video_progress.dart';

// ignore: must_be_immutable
class NewEditorScreen extends ConsumerStatefulWidget
    with WidgetsBindingObserver {
  NewEditorScreen({
    required this.controller,
    required this.editorContent,
    required this.metaData,
    required this.videosTotalDuration,
    required this.isOutSideEditor,
    required this.metaDataTotal,
    required this.updateScrollProgress,
    required this.updateTotalProgress,
    required this.updateCurrentVideoProgress,
    required this.getVideosUpdates,
    required this.videoDurationData,
  }) : super(key: controller.editorKey);

  final QuillEditorController controller;
  final String editorContent;
  final Map<String, dynamic> metaData;
  final Map<String, dynamic> metaDataTotal;
  final Map<String, dynamic> videoDurationData;
  final int videosTotalDuration;
  final Function(dynamic) updateScrollProgress;
  final Function(dynamic, double) updateTotalProgress;
  final Function(Map<String, dynamic>) updateCurrentVideoProgress;
  final Function(Map<String, dynamic>, Map<String, dynamic>) getVideosUpdates;
  bool isOutSideEditor;

  @override
  ConsumerState<NewEditorScreen> createState() => NewEditorScreenState();
}

typedef LoadingBuilderLatest = Widget Function(BuildContext context);

class NewEditorScreenState extends ConsumerState<NewEditorScreen> {
  ///[controller] create a QuillEditorController to access the editor methods
  ///late QuillEditorController controller;

  ///[customToolBarList] pass the custom toolbarList to show only selected styles in the editor

  final customToolBarList = [
    ToolBarStyle.bold,
    ToolBarStyle.italic,
    ToolBarStyle.align,
    ToolBarStyle.color,
    ToolBarStyle.background,
    ToolBarStyle.listBullet,
    ToolBarStyle.listOrdered,
    ToolBarStyle.clean,
    ToolBarStyle.addTable,
    ToolBarStyle.editTable,
  ];

  final _toolbarColor = Colors.grey.shade200;
  final _backgroundColor = Colors.white70;
  final _toolbarIconColor = Colors.black87;
  final _editorTextStyle = const TextStyle(
    fontSize: 18,
    color: Colors.black,
    fontWeight: FontWeight.normal,
    fontFamily: 'Roboto',
  );
  final _hintTextStyle = const TextStyle(
    fontSize: 18,
    color: Colors.black38,
    fontWeight: FontWeight.normal,
  );

  WebViewXController? _webviewController;

  final TextEditingController commentController = TextEditingController();

  List<Comment> _comments = [];

  String activeCommentId = '';

  int selectedTextlength = 0;

  int selectedTextPosition = 0;

  int savedselectionLength = 0;

  int savedSelectionPosition = 0;

  Map<String, dynamic> totalProgressMap = {};

  Map<String, dynamic> videoProgressMap = {};

  double totalInteractionProgress = 0.0;

  ScrollController scrollController = ScrollController();

  ScrollController mobileScrollController = ScrollController();

  StreamController<num> progressController = StreamController();

  StreamController<Map<String, dynamic>> totalVideoProgressController =
      StreamController();

  String _initialContent = "";

  double _currentPosition = 0.0;

  double _videoProgress = 0.0;

  num scrollength = 0.0;

  num _progress = 0.0;

  bool _hasFocus = false;

  bool isLoading = false;

  bool isWebviewvisible = false;

  double _currentHeight = 0.0;

  bool _editorLoaded = false;

  bool isEnabled = true;

  bool autofocus = false;

  late String _encodedStyle;

  String textContent = '';

  bool editorEnable = false;

  bool ensureVisible = false;

  bool? isLoadingDone;

  bool showModal = false;

  FocusNode commentFocusNode = FocusNode();

  late String _fontFamily;
  bool isReply = false;
  bool isEditingMode = false;

  bool openComment = false;

  bool showTextField = false;
  bool alreadyShowModal = false;

  @override
  void initState() {
    // _currentHeight = MediaQuery.of(context).size.height;
    _fontFamily = _editorTextStyle.fontFamily ?? 'Roboto';
    _encodedStyle = Uri.encodeFull(_fontFamily);

    if (kIsWeb && widget.isOutSideEditor) {
      SchedulerBinding.instance.scheduleFrameCallback((_) {
        // setHtmlTextToEditor(widget.editorContent);
        setState(() {
          isLoadingDone = false;
          videoProgressMap.clear();
          totalProgressMap.clear();
          videoProgressMap = widget.metaData;
          totalProgressMap = widget.metaDataTotal;
          _updateTotalVideoProgress();
          _getTotalProgress();
          // _waitAndJumptoSavedScrollPostion();
          widget.isOutSideEditor = false;
        });
      });
    }
    mobileScrollController.addListener(_onScroll);
    //CONTROLLER FOR TOTALPROGRESS
    //CONTROLLER FOR ARTICLE VIDEO PROGRESS
    totalVideoProgressController.stream.listen((event) {
      _updateTotalVideoProgress();
    });
    //ENABLE THE STREAM CONTROLLER TO LISTEN FOR DATA UPDATES
    progressController.stream.listen((event) {
      setState(() {
        //THIS IS THE ARTICLE SCROLL PROGRESS ONLY WITHOUT CONSIDERING THE VIDEO DURATION.
        _progress = event;
        _getTotalProgress();
        widget.updateScrollProgress(_progress);
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    // widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorControllerProvider);
    //SetScroll Position for the first Option
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!kIsWeb && widget.isOutSideEditor) {
        setHtmlTextToEditor(widget.editorContent);
        setState(() {
          videoProgressMap.clear();
          totalProgressMap.clear();
          videoProgressMap = widget.metaData;
          totalProgressMap = widget.metaDataTotal;
          _updateTotalVideoProgress();
          _waitAndJumptoSavedScrollPostion();
          //  _getTotalProgress();
          widget.isOutSideEditor = false;
        });
      }
    });
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPopUp, result) {},
        child: Scaffold(
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: false,
          floatingActionButton:
              //CONDITION TO RENDER THE TEXTFIELD FOR MOBILE VERSION
              !kIsWeb && selectedTextlength >= 1
                  ? ElevatedButton(
                    onPressed: () async {
                      //Remove the backGround for former selected text
                      widget.controller.setFormat(
                        format: 'background',
                        value: null,
                        index: savedSelectionPosition,
                        length: savedselectionLength,
                      );
                      //Set a pending new background for the new selectedText
                      widget.controller.setFormat(
                        format: 'background',
                        value: '#3D3D3D',
                        index: selectedTextPosition,
                        length: selectedTextlength,
                      );
                      setState(() {
                        savedSelectionPosition = selectedTextPosition;
                        savedselectionLength = selectedTextlength;
                        showModal = true;
                        selectedTextlength = 0;
                      });
                    },
                    child: const Text("Add Comment"),
                  )
                  : const SizedBox.shrink(),
          //  : const SizedBox.shrink(),
          body: Column(
            children: [
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraint) {
                    return Stack(
                      children: [
                        kIsWeb
                            ? CustomScrollView(
                              slivers: [
                                SliverToBoxAdapter(
                                  child: Column(
                                    children: [
                                      toolbar(),
                                      if (isLoadingDone == true)
                                        ProgressBars(
                                          label:
                                              'Total Progress ${(totalInteractionProgress * 100).toStringAsFixed(1)}%',
                                          progress: totalInteractionProgress,
                                          color: Colors.blue,
                                          textColor: Colors.black,
                                        ),
                                      if (isLoadingDone == true)
                                        Container(
                                          height: 2,
                                          color: Colors.grey,
                                        ),
                                      if (isLoadingDone == true)
                                        ProgressBars(
                                          label:
                                              'Video Progress ${(_videoProgress * 100).toStringAsFixed(1)}%',
                                          progress: _videoProgress,
                                          color: Colors.blueAccent,
                                          textColor: Colors.black,
                                        ),
                                      if (isLoadingDone == true)
                                        Container(
                                          height: 2,
                                          color: Colors.grey,
                                        ),
                                      if (isLoadingDone == true)
                                        ProgressBars(
                                          label:
                                              'Article Progress ${(_progress.toDouble() * 100).toStringAsFixed(1)}%',
                                          progress: _progress.toDouble(),
                                          color: Colors.lightBlue,
                                          textColor: Colors.black,
                                        ),
                                    ],
                                  ),
                                ),
                                SliverFillRemaining(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        flex: 3,
                                        child:
                                            isLoading
                                                ? const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                )
                                                : state.when(
                                                  data:
                                                      (data) => LayoutBuilder(
                                                        builder: (
                                                          context,
                                                          constraints,
                                                        ) {
                                                          _initialContent = getQuillPage(
                                                            width:
                                                                constraints
                                                                    .maxWidth,
                                                            quillJsScript: data,
                                                            fontFamily:
                                                                _fontFamily,
                                                            backgroundColor:
                                                                _backgroundColor,
                                                            encodedStyle:
                                                                _encodedStyle,
                                                            hintTextPadding:
                                                                const EdgeInsets.only(
                                                                  left: 20,
                                                                ),
                                                            hintTextStyle:
                                                                _hintTextStyle,
                                                            hintText: '',
                                                            textStyle:
                                                                _editorTextStyle,
                                                            isEnabled:
                                                                isEnabled,
                                                            hintTextAlign:
                                                                TextAlign.start,
                                                            inputAction:
                                                                InputAction
                                                                    .newline,
                                                            minHeight:
                                                                MediaQuery.of(
                                                                  context,
                                                                ).size.height,
                                                            // padding: widget.padding,
                                                          );
                                                          return _buildEditorView(
                                                            context: context,
                                                            width:
                                                                constraints
                                                                    .maxWidth,
                                                            scripts: data,
                                                          );
                                                        },
                                                      ),
                                                  loading:
                                                      () => Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                              color:
                                                                  Colors.green,
                                                              strokeWidth: 0.3,
                                                            ),
                                                      ),
                                                  error:
                                                      (e, _) => Column(
                                                        children: [
                                                          Icon(Icons.error),
                                                          Text(e.toString()),
                                                        ],
                                                      ),
                                                ),
                                      ),
                                      _comments.isEmpty &&
                                              selectedTextlength < 1
                                          ? const SizedBox.shrink()
                                          : openComment
                                          ? Container(
                                            decoration: BoxDecoration(
                                              color: Colors.grey.withAlpha(20),
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            margin: const EdgeInsets.only(
                                              right: 15,
                                              top: 10,
                                              bottom: 10,
                                            ),
                                            width:
                                                MediaQuery.of(
                                                  context,
                                                ).size.width *
                                                0.3,
                                            height:
                                                MediaQuery.of(
                                                  context,
                                                ).size.height,
                                            //Comment Session implementation on the Editor
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.end,
                                              children: [
                                                //Condition to show just the commentTextField
                                                IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      openComment = false;
                                                    });
                                                  },
                                                  icon: Icon(
                                                    Icons.close,
                                                    weight: 900.0,
                                                  ),
                                                ),
                                                if (selectedTextlength >= 1 &&
                                                    kIsWeb &&
                                                    showTextField)
                                                  CommentTextField(
                                                    onCommentClick: (value) {
                                                      if (value.isEmpty) {
                                                        setState(() {
                                                          selectedTextlength =
                                                              0;
                                                        });
                                                      } else {
                                                        widget.controller
                                                            .addComment(value);
                                                        selectedTextlength = 0;
                                                      }
                                                    },
                                                    onCancelPressed: () {
                                                      setState(() {
                                                        selectedTextlength = 0;
                                                      });
                                                    },
                                                  ),
                                                Expanded(
                                                  child: ListView.builder(
                                                    shrinkWrap: true,
                                                    itemCount: _comments.length,
                                                    itemBuilder: (
                                                      context,
                                                      index,
                                                    ) {
                                                      return CommentItemWidget(
                                                        controller:
                                                            widget.controller,
                                                        isEditingMode:
                                                            isEditingMode,
                                                        onEditPressed: (value) {
                                                          setState(() {
                                                            isReply = value;
                                                            isEditingMode =
                                                                value;
                                                          });
                                                        },
                                                        activeCommentId:
                                                            activeCommentId,
                                                        comment:
                                                            _comments[index],
                                                        enableCommentId: (
                                                          value,
                                                        ) {
                                                          setState(() {
                                                            activeCommentId =
                                                                value;
                                                          });
                                                        },
                                                        onCardClick: () {
                                                          setState(() {
                                                            activeCommentId =
                                                                _comments[index]
                                                                    .id;
                                                            widget.controller
                                                                .scrollToComment(
                                                                  _comments[index]
                                                                      .id,
                                                                );
                                                            widget.controller
                                                                .setActiveComment(
                                                                  _comments[index]
                                                                      .id,
                                                                );
                                                          });
                                                        },
                                                        isReply: isReply,
                                                        onReplyPressed: (
                                                          value,
                                                        ) {
                                                          setState(() {
                                                            isReply = value;
                                                          });
                                                        },
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ],
                                            ),
                                          )
                                          : const SizedBox.shrink(),
                                    ],
                                  ),
                                ),
                              ],
                            )
                            //MOBILE VERSION EDITOR OUTLOOK
                            : Column(
                              children: [
                                toolbar(),
                                ProgressBars(
                                  label:
                                      'Total Progress ${(totalInteractionProgress * 100).toStringAsFixed(1)}%',
                                  progress: totalInteractionProgress,
                                  color: Colors.blue,
                                  textColor: Colors.black,
                                ),
                                Container(height: 2, color: Colors.grey),
                                ProgressBars(
                                  label:
                                      'Video Progress ${(_videoProgress * 100).toStringAsFixed(1)}%',
                                  progress: _videoProgress,
                                  color: Colors.blueAccent,
                                  textColor: Colors.black,
                                ),
                                Container(height: 2, color: Colors.grey),
                                ProgressBars(
                                  label:
                                      'Article Progress ${(_progress.toDouble() * 100).toStringAsFixed(1)}%',
                                  progress: _progress.toDouble(),
                                  color: Colors.lightBlue,
                                  textColor: Colors.black,
                                ),
                                Expanded(
                                  child: SingleChildScrollView(
                                    controller: mobileScrollController,
                                    child: state.when(
                                      data:
                                          (data) => LayoutBuilder(
                                            builder: (context, constraints) {
                                              _initialContent = getQuillPage(
                                                width: constraints.maxWidth,
                                                quillJsScript: data,
                                                fontFamily: _fontFamily,
                                                backgroundColor:
                                                    _backgroundColor,
                                                encodedStyle: _encodedStyle,
                                                hintTextPadding:
                                                    const EdgeInsets.only(
                                                      left: 20,
                                                    ),
                                                hintTextStyle: _hintTextStyle,
                                                hintText: '',
                                                textStyle: _editorTextStyle,
                                                isEnabled: isEnabled,
                                                hintTextAlign: TextAlign.start,
                                                inputAction:
                                                    InputAction.newline,
                                                minHeight:
                                                    MediaQuery.of(
                                                      context,
                                                    ).size.height,
                                              );
                                              return _buildEditorView(
                                                context: context,
                                                width: constraints.maxWidth,
                                                scripts: data,
                                              );
                                            },
                                          ),
                                      loading:
                                          () => Center(
                                            child: CircularProgressIndicator(
                                              color: Colors.green,
                                              strokeWidth: 0.3,
                                            ),
                                          ),
                                      error:
                                          (e, _) => Column(
                                            children: [
                                              Icon(Icons.error),
                                              Text(e.toString()),
                                            ],
                                          ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                      ],
                    );
                  },
                ),
              ),
              //This the commentTextField for mobile Version
              showModal
                  ? CommentTextField(
                    onCancelPressed: () {
                      setState(() {
                        showModal = false;
                      });
                    },
                    onCommentClick: (value) {
                      if (value.isEmpty) {
                      } else {
                        widget.controller.addComment(
                          value,
                          index: savedSelectionPosition,
                          length: savedselectionLength,
                        );
                        setState(() {
                          showModal = false;
                        });
                      }
                    },
                    focusNode: commentFocusNode,
                  )
                  : const SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEditorView({
    required BuildContext context,
    required double width,
    required String scripts,
  }) {
    //print(_currentHeight);
    return Stack(
      children: [
        WebViewX(
          key: ValueKey(widget.controller.toolBarKey.hashCode.toString()),
          initialContent: _initialContent,
          initialSourceType: SourceType.html,
          height: kIsWeb ? MediaQuery.of(context).size.height : _currentHeight,
          onPageStarted: (s) {
            _editorLoaded = false;
            if (kIsWeb) {
              Future.delayed(const Duration(microseconds: 0)).then((value) {
                widget.controller.enableEditor(isEnabled);
                if (widget.editorContent.isNotEmpty) {
                  setHtmlTextToEditor(widget.editorContent);
                }
              });
            }
          },
          ignoreAllGestures: false,
          width: width,
          onWebViewCreated: (controller) => _webviewController = controller,
          onPageFinished: (src) {
            Future.delayed(const Duration(microseconds: 0)).then((value) {
              _editorLoaded = true;
              debugPrint('_editorLoaded $_editorLoaded');
              if (mounted) {
                setState(() {});
              }
              widget.controller.enableEditor(isEnabled);
              if (widget.editorContent.isNotEmpty) {
                setHtmlTextToEditor(widget.editorContent);
              }
              if (autofocus == true) {
                widget.controller.focus();
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
                  _currentHeight =
                      double.tryParse(height.toString()) ??
                      MediaQuery.of(context).size.height;
                } catch (e) {
                  _currentHeight = MediaQuery.of(context).size.height;
                } finally {
                  if (mounted) {
                    setState(() => _currentHeight);
                  }
                }
              },
            ),
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
              },
            ),
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
                    widget.controller.changeController!.add(finalText);
                  }
                } catch (e) {
                  if (!kReleaseMode) {
                    debugPrint(e.toString());
                  }
                }
              },
            ),
            // Web scroll restoration: triggered by JS window.load event.
            // On web, scroll happens inside the webview via JS window.scrollTo().
            // Mobile uses _waitAndJumptoSavedScrollPostion() instead,
            // which scrolls the Flutter ScrollController wrapping the webview.
            DartCallback(
              name: 'ScrollReady',
              callBack: (message) {
                if (message != null) {
                  if (kIsWeb) {
                    setScrollPosition(
                      scrollPosition:
                          widget.metaDataTotal['scrollPosition'],
                    );
                    setVideoPosition(
                      videos: widget.metaData,
                    );
                  }
                }
              },
            ),
            DartCallback(
              name: 'FocusChanged',
              callBack: (map) {
                setState(() {
                  _hasFocus = map?.toString() == 'true';
                  if (_hasFocus) {
                    commentFocusNode.unfocus();
                  }
                });

                // if (widget.onFocusChanged != null) {
                //   widget.onFocusChanged!(_hasFocus);
                // }

                /// scrolls to the end of the text area, to keep the focus visible
                if (ensureVisible == true && _hasFocus) {
                  Scrollable.of(context).position.ensureVisible(
                    context.findRenderObject()!,
                    duration: const Duration(milliseconds: 300),
                    alignmentPolicy:
                        ScrollPositionAlignmentPolicy.keepVisibleAtEnd,
                    curve: Curves.fastLinearToSlowEaseIn,
                  );
                }
              },
            ),
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
                      if (map != null) {
                        setState(() {
                          finalText = map;
                        });
                      }
                    }
                    // if (widget.onEditingComplete != null) {
                    //   widget.onEditingComplete!(finalText);
                    // }
                    widget.controller.changeController!.add(finalText);
                  }
                } catch (e) {
                  if (!kReleaseMode) {
                    debugPrint(e.toString());
                  }
                }
              },
            ),
            // DartCallback(
            //   name: 'OnSelectionChanged',
            //   callBack: (selection) {
            //     try {
            //       if (_hasFocus) {
            //         setState(() {
            //           commentFocusNode.unfocus();
            //         });
            //       }
            //       // var sel =
            //       //     selection != null
            //       //         ? SelectionModel.fromJson(jsonDecode(selection))
            //       //         : SelectionModel(index: 0, length: 0);
            //       // setState(() {
            //       //   selectedTextlength = sel.length ?? 0;
            //       //   selectedTextPosition = sel.index ?? 0;
            //       //   if (selectedTextlength >= 1) {
            //       //     openComment = true;
            //       //   }
            //       // });
            //     } catch (e) {
            //       if (!kReleaseMode) {
            //         debugPrint(e.toString());
            //       }
            //     }
            //   },
            // ),

            /// callback to notify once editor is completely loaded
            DartCallback(
              name: 'EditorLoaded',
              callBack: (map) {
                _editorLoaded = true;
                if (mounted) {
                  setState(() {});
                }
              },
            ),
            //THIS IS FOR TRACKING THE CURRENT VIDEO THAT IS PLAYING BOTH YOUTUBE AND
            //NORMAL VIDEO
            DartCallback(
              name: 'GetVideoTracking',
              callBack: (timing) {
                try {
                  if (timing != null) {
                    var video = VideoProgressTracking.fromJson(
                      jsonDecode(timing),
                    );
                    if (kIsWeb) {
                      setState(() {
                        // From here I can get the current Position and then pass
                        // it to the Map
                        // print('--This is the timig $timing');
                        videoProgressMap[video.videoUrl] =
                            video.currentPosition;
                        totalProgressMap[video.videoUrl] =
                            video.currentPosition;
                        // _updateTotalVideoProgress();
                        _getTotalProgress();
                        //THE ESSENCE OF THE CONTROLLER MAP IS FOR RESUMPTION
                        //FROM WHERE THE VIDEO LEFT OFF
                        //   singleVideoDuration = video.totalDuration;
                        //  print(videoProgressMap);
                      });
                      //TODO: Testting it
                      widget.updateCurrentVideoProgress({
                        'articleID': '',
                        'videoUrl': video.videoUrl,
                        'currentPosition': video.currentPosition,
                      });
                      totalVideoProgressController.add(videoProgressMap);
                    }
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
            ),
            DartCallback(
              name: 'VideoStateChange',
              callBack: (msg) {
                try {
                  if (msg != null) {
                    // if (widget.videoLink != null) {
                    //   //  print('Testing the video link $msg');
                    //   //  widget.videoLink!(msg.toString());
                    // }
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
            ),
            //THIS IS ONLY FOR THE WEB-VERSION, THE MOBILE SCROLLING
            //IS HANDLED AT THE FLUTTER SIDE
            DartCallback(
              name: 'GetScrollPosition',
              callBack: (message) {
                try {
                  if (message != null) {
                    var p0 = CustomScrollPosition.fromJson(jsonDecode(message));
                    if (kIsWeb) {
                      setState(() {
                        //_progress = p0.currentPosition ?? 0.0;
                        scrollength = p0.maxScroll ?? 0.0;
                        totalProgressMap['scrollPosition'] = p0.scrollTop;
                        //This is the stream that will be sending the progress to the backend.
                        progressController.add(p0.currentPosition ?? 0.0);
                        //  _getTotalProgress();
                      });
                    }
                  }
                } catch (e) {
                  //   print(e.toString());
                }
              },
            ),
            DartCallback(
              name: 'CommentChannel',
              callBack: (comments) {
                try {
                  if (comments != null) {
                    final commentConvert =
                        jsonDecode(comments) as List<dynamic>;
                    setState(() {
                      _comments =
                          commentConvert
                              .map((comment) => Comment.fromJson(comment))
                              .toList();
                    });
                  }
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
            ),
            DartCallback(
              name: 'CommentClickChannel',
              callBack: (jsCommentId) {
                try {
                  if (jsCommentId != null) {
                    setState(() {
                      activeCommentId = jsCommentId;
                      if (jsCommentId.isNotEmpty) {
                        openComment = true;
                      }
                    });
                    if (jsCommentId.isNotEmpty &&
                        _comments.isNotEmpty &&
                        !kIsWeb &&
                        !alreadyShowModal) {
                      showCommentModalForMobile(
                        context,
                        _comments,
                        widget.controller,
                        activeCommentId,
                        isReply,
                        (onclose) {
                          if (onclose) {
                            setState(() {
                              alreadyShowModal = false;
                            });
                          }
                        },
                      );
                      setState(() {
                        alreadyShowModal = true;
                      });
                    }
                    widget.controller.setActiveComment(jsCommentId);
                  }
                } catch (e) {}
              },
            ),
            DartCallback(
              name: 'SelectionChannel',
              callBack: (selectionData) {
                try {
                  if (selectionData == null) return;

                  if (_hasFocus) {
                    setState(() {
                      commentFocusNode.unfocus();
                    });
                  }
                  final data = jsonDecode(selectionData);
                  if (data['hidden'] == true) {
                    setState(() {
                      selectedTextlength = 0;
                      selectedTextPosition = 0;
                    });
                    return;
                  }
                  //The selectedTextLength is greater than one
                  //Then check if the selectedText is an existing commented text
                  setState(() {
                    selectedTextlength = data['length'];
                    selectedTextPosition = data['index'];
                    //TO render the comments for mobile version when already
                    // commented text is highlighted
                    if (!kIsWeb &&
                        data['existingComment'] != null &&
                        _comments.isNotEmpty &&
                        !alreadyShowModal) {
                      showCommentModalForMobile(
                        context,
                        _comments,
                        widget.controller,
                        data['existingComment']['commentId'],
                        isReply,
                        (onclose) {
                          setState(() {
                            alreadyShowModal = false;
                          });
                        },
                      );
                      alreadyShowModal = true;
                    }
                    if (data['existingComment'] != null) {
                      final existingComment = data['existingComment'];
                      activeCommentId = existingComment['commentId'];
                      showTextField = false;
                      openComment = true;
                      widget.controller.setActiveComment(
                        existingComment['commentId'],
                      );
                    } else {
                      showTextField = true;
                      openComment = true;
                    }
                  });
                } catch (e) {
                  debugPrint(e.toString());
                }
              },
            ),
            DartCallback(
              name: 'GetVideoUrl',
              callBack: (message) {
                try {
                  if (message != null) {
                    //  if (widget.videoLink != null) {
                    String videoUrlLink = message.toString();
                    // widget.videoLink!(message.toString());
                    // }
                    if (kIsWeb) {
                      //INITIALLY PLANNED TO USE THIS FOR VIDEO SAVING
                    } else {
                      if (videoUrlLink.contains('youtube')) {
                        if (videoUrlLink.contains("?enablejsapi=1")) {
                          String url = videoUrlLink.replaceFirst(
                            "?enablejsapi=1",
                            "",
                          );
                          showdialog(context, url);
                        } else {
                          showdialog(context, videoUrlLink);
                        }
                      } else {
                        shownormalVideoDialog(context, videoUrlLink);
                      }
                    }
                  }
                } catch (e) {
                  //   print(e.toString());
                }
              },
            ),
            DartCallback(
              name: 'IsLoadingDone',
              callBack: (isloadingdone) {
                try {
                  if (isloadingdone != null) {
                    if (kIsWeb) {
                      setState(() {
                        isLoadingDone = isloadingdone as bool;
                      });
                    }
                  }
                } catch (e) {}
              },
            ),
            DartCallback(
              name: 'WatchVideo',
              callBack: (message) {
                try {
                  if (message != null) {
                    String videolink = message.toString();
                    //  widget.watchedVideo!(message.toString());
                    if (kIsWeb) {
                    } else {
                      //MOBILE SESSION VIDEO UPDATE AT THE LOADING TIME
                      setState(() {
                        //TODO: There should be a condition to check if the videoLink is thesame as the one sent
                        widget.videoDurationData[videolink];
                        videoProgressMap[videolink] =
                            widget.videoDurationData[videolink];
                        totalProgressMap[videolink] =
                            widget.videoDurationData[videolink];
                        // }
                        _getTotalProgress();
                        // print(videoProgressMap);
                        totalVideoProgressController.add(videoProgressMap);
                      });
                    }
                  }
                } catch (e) {
                  //
                }
              },
            ),
          },
          webSpecificParams: const WebSpecificParams(printDebugInfo: false),
          mobileSpecificParams: const MobileSpecificParams(
            androidEnableHybridComposition: true,
          ),
          //  navigationDelegate: widget.navigationDelegate,
        ),
        if (isLoadingDone == false)
          Stack(
            children: [
              ModalBarrier(dismissible: false, color: Colors.black54),
              Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget toolbar() {
    return ToolBar.scroll(
      onBeforeVideoInserted: (message) {
        if (message != null) {
          setState(() {
            isLoading = message as bool;
          });
        }
      },
      toolBarColor: _toolbarColor,
      padding: const EdgeInsets.all(8),
      iconSize: 25,
      iconColor: _toolbarIconColor,
      activeIconColor: Colors.greenAccent.shade400,
      controller: widget.controller,
      crossAxisAlignment: CrossAxisAlignment.start,
      // crossAxisAlignment: WrapCrossAlignment.start,
      direction: Axis.horizontal,
      customButtons: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
            color: _hasFocus ? Colors.green : Colors.grey,
            borderRadius: BorderRadius.circular(15),
          ),
        ),
        InkWell(
          onTap: () => widget.controller.unFocus(),
          child: const Icon(Icons.favorite, color: Colors.black),
        ),
        InkWell(
          onTap: () async {
            await widget.controller.getSelectedText();
            await widget.controller.getSelectedHtmlText();
          },
          child: const Icon(Icons.add_circle, color: Colors.black),
        ),
      ],
    );
  }

  // Function for total progress
  void _getTotalProgress() {
    /// Get the scroll Length Position
    /// Get the total Duration, that would be the totalVideoDuration
    //TODO: In updating the totalInteractionProgress include all the videos and the
    //scrollPosition.
    setState(() {
      // [totalProgressMap] contains the scrollPosition and the video Data.
      totalInteractionProgress =
          (totalProgressMap.values.fold(
            0.0,
            (sum, progressTtotal) => sum + progressTtotal,
          )) /
          (widget.videosTotalDuration + scrollength.toDouble());
      //A call back to be sent to the Main Application
      widget.updateTotalProgress(totalProgressMap, totalInteractionProgress);
    });
  }

  // Mobile scroll restoration: polls until content is rendered, then jumps.
  // On mobile, scroll is controlled by Flutter's mobileScrollController.
  // Web uses the ScrollReady DartCallback instead, which scrolls
  // inside the webview via JS window.scrollTo().
  void _waitAndJumptoSavedScrollPostion() async {
    while (mobileScrollController.hasClients &&
        mobileScrollController.position.maxScrollExtent == 0.0) {
      await Future.delayed(Duration(seconds: 1));
    }
    final scrollLength = mobileScrollController.position.maxScrollExtent;
    final scrollRatio = widget.metaDataTotal['scrollPosition'] ?? 0.0;
    final targetPosition = scrollLength * scrollRatio;
    mobileScrollController.jumpTo(targetPosition);
    // print("✅ Jumped to saved scroll position: $targetPosition");
  }

  // Listen to changes in the scroll position
  // This method will be called on every scroll event
  void _onScroll() {
    setState(() {
      _currentPosition =
          mobileScrollController.position.pixels; // current position
      scrollength = mobileScrollController.position.maxScrollExtent;
      double progress = (_currentPosition / scrollength).abs(); // max position
      totalProgressMap['scrollPosition'] = _currentPosition;
      progressController.add(progress);
    });
  }

  void _updateTotalVideoProgress() {
    //TODO:videoProgressMap to be updated with the videoList data from backend upon loading.
    if (videoProgressMap.isNotEmpty) {
      _videoProgress =
          (videoProgressMap.values.fold(
                0.0,
                (sum, progress) => sum + progress,
              ) /
              widget.videosTotalDuration);
      widget.getVideosUpdates(videoProgressMap, widget.videoDurationData);
    } else {
      _videoProgress = 0.0;
    }
  }

  /// Youtube mobile version dialog box
  showdialog(BuildContext context, String youtubeLink) {
    showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) {
        return MobileYoutubeVideoWidget(
          //I want to pass duration to start back where the video stops
          positioning:
              widget.metaData.containsKey(youtubeLink)
                  ? Duration(milliseconds: widget.metaData[youtubeLink])
                  : Duration.zero,
          videoUrl: youtubeLink,
          durationRation: (duration) {
            //This will save the percentage of the video
          },
          videoDuration: (totalDuration) {
            //when the video has been paused on quit.
            // send the position to this point and then save it
            // to the Map Controller to retrieve it back when resumed.
          },
          currentPosition: (currentPosition) {
            setState(() {
              videoProgressMap[youtubeLink] = currentPosition.inMilliseconds;
              totalProgressMap[youtubeLink] = currentPosition.inMilliseconds;
              //UPDATING THE CLOUD FIRESTORE WHEN PLAYING YOUTUBE VIDEO ON MOBILE
              //TODO: Try it if it is not inside the setstate.
              //TODO: Testing it
              widget.updateCurrentVideoProgress({
                'articleID': '',
                'videoUrl': youtubeLink,
                'currentPosition': currentPosition.inMilliseconds,
              });
              _getTotalProgress();
            });
            totalVideoProgressController.add(videoProgressMap);
          },
        );
      },
    );
  }

  //Normal video Alert Dialog  Mobile Version
  shownormalVideoDialog(BuildContext context, String videolink) {
    showDialog(
      barrierDismissible: false,
      barrierLabel: 'Video Dialog',
      context: context,
      builder: (BuildContext context) {
        return Center(
          child: Material(
            type: MaterialType.transparency,
            child: VideoWidget(
              positioning:
                  widget.metaData.containsKey(videolink)
                      ? Duration(milliseconds: widget.metaData[videolink])
                      : Duration.zero,
              videoUrl: videolink,
              videoDuration: (videoduration) {
                ///This is to save the videoDuration when the video has been exited
                ///from the pop-up
                ///THIS MAY NOT BE NECESSARY AS THE CURRENTtIME SAVING IS DONE IN REAL-TIME
                //  singleVideoDuration = videoduration.inMilliseconds;
              },
              videoRatio: (videoPercentage) {},
              currentPosition: (currentTime) {
                setState(() {
                  videoProgressMap[videolink] = currentTime.inMilliseconds;
                  totalProgressMap[videolink] = currentTime.inMilliseconds;
                  //UPDATING THE CLOUD FIRESTORE WHEN PLAYING NORMALS VIDEO ON MOBILE
                  //TODO:Try it if it is not inside the setstate function.
                  //TODO: Testing it
                  widget.updateCurrentVideoProgress({
                    'articleID': '',
                    'videoUrl': videolink,
                    'currentPosition': currentTime.inMilliseconds,
                  });
                  _getTotalProgress();
                });
                totalVideoProgressController.add(videoProgressMap);
              },
            ),
          ),
        );
      },
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
  }) => _setFormat(format: format, value: value, index: index, length: length);

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

  Future addComment({
    required String commentBody,
    int? length,
    int? index,
    String? commentId,
  }) => _addComment(
    commentBody: commentBody,
    length: length,
    index: index,
    commentId: commentId,
  );

  Future setActiveComment({required String commentId}) =>
      _setActiveComment(commentId: commentId);

  Future deleteCommentReply({required String commentId, required int index}) =>
      _deleteCommentReply(commentId: commentId, index: index);

  Future editComment({
    required String commentId,
    required int threadIndex,
    required String newBody,
  }) => _editComment(
    commentId: commentId,
    threadIndex: threadIndex,
    newBody: newBody,
  );

  Future scrollToComment({required String commentId}) =>
      _scrollToComment(commentId: commentId);

  /// it is a regex method to remove the tags and replace them with empty space
  static String _stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&[^;]+;'), ' ');
  }

  /// a private method to get the Html text from the editor
  Future<String> _getHtmlFromEditor() async {
    return await _webviewController?.callJsMethod("getHtmlText", []);
  }

  /// a private method to get the Plain text from the editor
  Future<String> _getPlainTextFromEditor() async {
    return await _webviewController?.callJsMethod("getPlainText", []);
  }

  /// a private method to get the delta  from the editor
  Future<String> _getDeltaFromEditor() async {
    return await _webviewController?.callJsMethod("getDelta", []);
  }

  /// a private method to check if editor has focus
  Future<int> _getSelectionCount() async {
    return await _webviewController?.callJsMethod("getSelection", []);
  }

  /// a private method to check if editor has focus
  Future<dynamic> _getSelectionRange() async {
    return await _webviewController?.callJsMethod("getSelectionRange", []);
  }

  /// a private method to check if editor has focus
  Future<dynamic> _setSelectionRange(int index, int length) async {
    return await _webviewController?.callJsMethod("setSelection", [
      index,
      length,
    ]);
  }

  /// a private method to set the Html text to the editor
  Future _setHtmlTextToEditor({required String htmlText}) async {
    return await _webviewController?.callJsMethod("setHtmlText", [
      htmlText,
      kIsWeb,
      isEnabled,
    ]);
  }

  /// a private method to set the Delta  text to the editor
  Future _setDeltaToEditor({required Map<dynamic, dynamic> deltaMap}) async {
    return await _webviewController?.callJsMethod("setDeltaContent", [
      jsonEncode(deltaMap),
    ]);
  }

  /// a private method to request focus to the editor
  Future _requestFocus() async {
    return await _webviewController?.callJsMethod("requestFocus", []);
  }

  /// a private method to un focus the editor
  Future _unFocus() async {
    return await _webviewController?.callJsMethod("unFocus", []);
  }

  /// a private method to insert the Html text to the editor
  Future _insertHtmlTextToEditor({required String htmlText, int? index}) async {
    return await _webviewController?.callJsMethod("insertHtmlText", [
      htmlText,
      index,
    ]);
  }

  /// a private method to embed the video to the editor
  Future _embedVideo({required String videoUrl}) async {
    return await _webviewController?.callJsMethod("embedVideo", [videoUrl]);
  }

  /// a private method to embed the image to the editor
  Future _embedImage({required String imgSrc}) async {
    return await _webviewController?.callJsMethod("embedImage", [imgSrc]);
  }

  /// a private method to enable/disable the editor
  Future _enableTextEditor({required bool isEnabled}) async {
    return await _webviewController?.callJsMethod("enableEditor", [isEnabled]);
  }

  /// a private method to enable/disable the editor
  Future _setFormat({
    required String format,
    required dynamic value,
    int index = -1,
    int length = 0,
  }) async {
    try {
      return await _webviewController?.callJsMethod("setFormat", [
        format,
        value,
        index,
        length,
      ]);
    } catch (e) {
      _printWrapper(false, e.toString());
    }
  }

  /// a private method to insert table by row and column to the editor
  Future _insertTableToEditor({required int row, required int column}) async {
    return await _webviewController?.callJsMethod("insertTable", [row, column]);
  }

  /// a private method to add remove or delete table in the editor
  Future _modifyTable(EditTableEnum type) async {
    return await _webviewController?.callJsMethod("modifyTable", [type.name]);
  }

  /// a private method to replace selection text in the editor
  Future _replaceText(String replaceText) async {
    return await _webviewController?.callJsMethod("replaceSelection", [
      replaceText,
    ]);
  }

  /// a private method to get the selected text from editor
  Future _getSelectedText() async {
    return await _webviewController?.callJsMethod("getSelectedText", []);
  }

  /// a private method to get the selected html text from editor
  Future _getSelectedHtmlText() async {
    return await _webviewController?.callJsMethod("getSelectionHtml", []);
  }

  /// a private method to undo the history
  Future _undo() async {
    return await _webviewController?.callJsMethod("undo", []);
  }

  /// a private method to redo the history
  Future _redo() async {
    return await _webviewController?.callJsMethod("redo", []);
  }

  /// a private method to clear the history stack
  Future _clearHistory() async {
    return await _webviewController?.callJsMethod("clearHistory", []);
  }

  /// a formatted text upon selection
  Future _formatText() async {
    return await _webviewController?.callJsMethod("setFormatText", []);
  }

  /// set the savedScrollPosition to load the pre-existing web Position
  Future _setScrollPosition({required double scrollPosition}) async {
    return await _webviewController?.callJsMethod("setScrollPosition", [
      scrollPosition,
    ]);
  }

  Future _setVideoPosition({required Map<String, dynamic> videos}) async {
    return await _webviewController?.callJsMethod("setVideoPosition", [
      jsonEncode(videos),
    ]);
  }

  /// method to un focus editor
  void unFocusEditor() => widget.controller.unFocus();

  Future _addComment({
    required String commentBody,
    int? index,
    int? length,
    String? commentId,
  }) async {
    return await _webviewController?.callJsMethod("addComment", [
      commentBody,
      index ?? -1,
      length ?? 0,
      commentId,
    ]);
  }

  Future _setActiveComment({required String commentId}) async {
    return await _webviewController?.callJsMethod("setActiveComment", [
      commentId,
    ]);
  }

  Future _deleteCommentReply({
    required String commentId,
    required int index,
  }) async {
    return await _webviewController?.callJsMethod("deleteReply", [
      commentId,
      index,
    ]);
  }

  Future _editComment({
    required String commentId,
    required int threadIndex,
    required String newBody,
  }) async {
    return await _webviewController?.callJsMethod(("editComment"), [
      commentId,
      threadIndex,
      newBody,
    ]);
  }

  Future _scrollToComment({required String commentId}) async {
    return await _webviewController?.callJsMethod("scrollToComment", [
      commentId,
    ]);
  }
}

void _printWrapper(bool showPrint, String text) {
  if (showPrint) {
    debugPrint(text);
  }
}

class Comment {
  final String id;
  final String commentedText;
  final List<CommentReply> thread;
  final int start;
  final int end;

  const Comment({
    required this.id,
    required this.commentedText,
    required this.thread,
    required this.start,
    required this.end,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      commentedText: json['commentedText'],
      thread:
          (json['thread'] as List)
              .map((reply) => CommentReply.fromJson(reply))
              .toList(),
      start: json['start'],
      end: json['end'],
    );
  }
}

class CommentReply {
  String author;
  String body;
  String timestamp;
  bool? edited;
  String? editedAt;

  CommentReply({
    required this.author,
    required this.body,
    required this.timestamp,
    this.edited,
    this.editedAt,
  });

  factory CommentReply.fromJson(Map<String, dynamic> json) {
    return CommentReply(
      author: json['author'],
      body: json['body'],
      timestamp: json['timestamp'],
      edited: json['edited'],
      editedAt: json['editedAt'],
    );
  }
}
