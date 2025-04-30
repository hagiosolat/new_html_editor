// ignore_for_file: use_build_context_synchronously
import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_html_editor/new_html_editor.dart';
import 'package:new_html_editor/src/feature/Presentation/view/widgets/mobile_youtube_video.dart';
import 'package:new_html_editor/src/feature/Presentation/view/widgets/progress_bar.dart';
import 'package:new_html_editor/src/feature/Presentation/view/widgets/show_web_video.dart';
import 'package:new_html_editor/src/html_text.dart';
import '../../../../core/edit_table_drop_down.dart';
import '../../../../core/webviewx/src/models/scroll_position.dart';
import '../../../../core/webviewx/src/models/selection_model.dart';
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

  late WebViewXController _webviewController;

  final TextEditingController commentController = TextEditingController();

  final List<Comment> _comments = [];

  int selectedTextlength = 0;

  int selectedTextPosition = 0;

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

  late String _fontFamily;

  @override
  void initState() {
    // _currentHeight = MediaQuery.of(context).size.height;
    _fontFamily = _editorTextStyle.fontFamily ?? 'Roboto';
    _encodedStyle = Uri.encodeFull(_fontFamily);
    mobileScrollController.addListener(_onScroll);

    // widget.controller.onTextChanged((testi) {
    //   debugPrint('listening to $testi');
    //   if (editorEnable) {
    //     if (kIsWeb) {
    //       setVideoPosition(videos: widget.metaData);
    //       setState(() {
    //         editorEnable = false;
    //       });
    //     }

    //   }
    // });

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
    scrollController.dispose();
    progressController.close();
    widget.controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(editorControllerProvider);
    //SetScroll Position for the first Option
    //  if (!kIsWeb && widget.isOutSideEditor) {
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
    //  }
    // final state2 = ref.watch(htmlContentControllerProvider);
    return SafeArea(
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPopUp, result) {},
        child: Scaffold(
          floatingActionButton:
              selectedTextlength >= 1
                  ? !kIsWeb
                      ? ElevatedButton(
                        onPressed: () async {
                          final selection =
                              await widget.controller.getSelectionRange();
                          if (selection.length == 0) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Select text to comment on'),
                              ),
                            );
                          } else {
                            showModalSheetScreen(
                              selectedTextPosition,
                              selectedTextlength,
                            );
                          }
                        },
                        child: const Text('Add Comment'),
                      )
                      : const SizedBox.shrink()
                  : const SizedBox.shrink(),
          backgroundColor: Colors.white,
          resizeToAvoidBottomInset: true,
          body: Container(
            child: LayoutBuilder(
              builder: (context, constraint) {
                return Stack(
                  children: [
                    kIsWeb
                        //WEB VERSION EDITOR OUTLOOK
                        ?
                        //  Offstage(
                        //   offstage: !isWebviewvisible,
                        //   child:
                        CustomScrollView(
                          slivers: [
                            SliverToBoxAdapter(
                              child: Column(
                                children: [
                                  toolbar(),
                                  ProgressBars(
                                    label:
                                        'Total Progress ${(totalInteractionProgress * 100).toStringAsFixed(1)}%',
                                    progress: totalInteractionProgress,
                                    color: Colors.blue,
                                  ),
                                  Container(height: 2, color: Colors.grey),
                                  ProgressBars(
                                    label:
                                        'Video Progress ${(_videoProgress * 100).toStringAsFixed(1)}%',
                                    progress: _videoProgress,
                                    color: Colors.blueAccent,
                                  ),
                                  Container(height: 2, color: Colors.grey),
                                  ProgressBars(
                                    label:
                                        'Article Progress ${(_progress.toDouble() * 100).toStringAsFixed(1)}%',
                                    progress: _progress.toDouble(),
                                    color: Colors.lightBlue,
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
                                                        fontFamily: _fontFamily,
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
                                                        isEnabled: isEnabled,
                                                        hintTextAlign:
                                                            TextAlign.start,
                                                        inputAction:
                                                            InputAction.newline,
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
                                  _comments.isEmpty
                                      ? const SizedBox.shrink()
                                      : Container(
                                        decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(0.1),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        margin: const EdgeInsets.only(
                                          right: 15,
                                          top: 10,
                                          bottom: 10,
                                        ),
                                        width:
                                            MediaQuery.of(context).size.width *
                                            0.3,
                                        height:
                                            MediaQuery.of(context).size.height,
                                        child: ListView.builder(
                                          shrinkWrap: true,
                                          itemCount: _comments.length,
                                          itemBuilder: (context, index) {
                                            return commentTile(
                                              _comments[index].text,
                                            );
                                          },
                                        ),
                                      ),
                                ],
                              ),
                              //   ) //  ],),
                            ),
                          ],
                          // ),
                        )
                        //MOBILE VERSION EDITOR OUTLOOK
                        :
                        // Offstage(
                        //   offstage: !isWebviewvisible,
                        //   child:
                        Column(
                          children: [
                            toolbar(),
                            ProgressBars(
                              label:
                                  'Total Progress ${(totalInteractionProgress * 100).toStringAsFixed(1)}%',
                              progress: totalInteractionProgress,
                              color: Colors.blue,
                            ),
                            Container(height: 2, color: Colors.grey),
                            ProgressBars(
                              label:
                                  'Video Progress ${(_videoProgress * 100).toStringAsFixed(1)}%',
                              progress: _videoProgress,
                              color: Colors.blueAccent,
                            ),
                            Container(height: 2, color: Colors.grey),
                            ProgressBars(
                              label:
                                  'Article Progress ${(_progress.toDouble() * 100).toStringAsFixed(1)}%',
                              progress: _progress.toDouble(),
                              color: Colors.lightBlue,
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
                                            backgroundColor: _backgroundColor,
                                            encodedStyle: _encodedStyle,
                                            hintTextPadding:
                                                const EdgeInsets.only(left: 20),
                                            hintTextStyle: _hintTextStyle,
                                            hintText: '',
                                            textStyle: _editorTextStyle,
                                            isEnabled: isEnabled,
                                            hintTextAlign: TextAlign.start,
                                            inputAction: InputAction.newline,
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
                    // ),
                    //  ),
                  ],
                );
              },
            ),
          ),

          bottomNavigationBar:
              kIsWeb
                  ? selectedTextlength >= 1
                      ? Container(
                        width: double.maxFinite,
                        padding: const EdgeInsets.all(8.0),
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context).canvasColor,
                              blurRadius: 0.1,
                              spreadRadius: 0.4,
                              offset: const Offset(2, 6),
                            ),
                          ],
                        ),
                        child: Wrap(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(
                                top: 14.0,
                                left: 9,
                                right: 9,
                              ),
                              child: Column(
                                children: [
                                  TextField(
                                    controller: commentController,
                                    decoration: InputDecoration(
                                      hintText: 'Make your comment...',
                                      border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(50),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(height: 9),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    children: [
                                      ElevatedButton(
                                        onPressed: () {},
                                        child: const Text('Cancel'),
                                      ),
                                      ElevatedButton(
                                        onPressed: () {
                                          _addComment(commentController.text);
                                          widget.controller.setFormat(
                                            format: 'background',
                                            value: '#FF9800',
                                          );
                                        },
                                        child: const Text('Comment'),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      )
                      : const SizedBox.shrink()
                  : const SizedBox.shrink(),
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
                    //TODO: CHECKING OTHERS
                    // if (widget.onTextChanged != null) {
                    //   widget.onTextChanged!(finalText);
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
            DartCallback(
              name: 'ScrollReady',
              callBack: (message) {
                if (message != null) {
                  //I CAN SEND IT TO THIS PLACE FROM THE DATA LAYER...
                  if (kIsWeb) {
                    print(
                      "Scroll is reading because all the data has been loaded",
                    );
                    setScrollPosition(
                      scrollPosition: widget.metaDataTotal['scrollPosition'],
                    );
                    setVideoPosition(
                      //TODO: Get the List of videos coming from cloud Firestore and update it here.
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
            DartCallback(
              name: 'OnSelectionChanged',
              callBack: (selection) {
                try {
                  if (!_hasFocus) {
                    setState(() {
                      _hasFocus = true;
                    });
                  }
                  var sel =
                      selection != null
                          ? SelectionModel.fromJson(jsonDecode(selection))
                          : SelectionModel(index: 0, length: 0);
                  setState(() {
                    selectedTextlength = sel.length ?? 0;
                    selectedTextPosition = sel.index ?? 0;
                  });
                } catch (e) {
                  if (!kReleaseMode) {
                    debugPrint(e.toString());
                  }
                }
              },
            ),

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
                        // print(
                        //   "This is the Flutter side taking the videos $timing",
                        // );
                        videoProgressMap[video.videoUrl] =
                            video.currentPosition;
                        totalProgressMap[video.videoUrl] =
                            video.currentPosition;
                        // _updateTotalVideoProgress();
                        print(videoProgressMap);
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
            DartCallback(
              name: 'GetScrollPosition',
              callBack: (message) {
                try {
                  // print('This is the message from the scrollPosition $message');
                  if (message != null) {
                    var p0 = CustomScrollPosition.fromJson(jsonDecode(message));
                    if (kIsWeb) {
                      // print(
                      //     'scrollTop is ${p0.scrollTop}, currentPosition ${p0.currentPosition}');
                      setState(() {
                        //_progress = p0.currentPosition ?? 0.0;
                        scrollength = p0.maxScroll ?? 0.0;
                        // print(
                        //   'Maximum Scroll Position is ${p0.currentPosition}',
                        // );
                        totalProgressMap['scrollPosition'] = p0.scrollTop;
                        //This is the stream that will be sending the progress to the backend.
                        progressController.add(p0.currentPosition ?? 0.0);
                        //  _getTotalProgress();
                      });
                    } else {
                      // setState(() {});
                    }
                  }
                } catch (e) {
                  //   print(e.toString());
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
                      if (videoUrlLink.contains("https://") &&
                          !videoUrlLink.contains("youtube")) {
                        String url = videoUrlLink.replaceFirst(
                          "https://",
                          "http://",
                        );
                        shownormalVideoDialog(context, url);
                      } else {
                        shownormalVideoDialog(context, videoUrlLink);
                      }

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
                      }
                    }
                  }
                } catch (e) {
                  //   print(e.toString());
                }
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
                        //from the firebase; then it will update that particular video
                        //Something like; list of videos coming from backend;
                        //where the videolink is thesame with the videos.videourl
                        //Then update the video with the duration

                        ///This should assign the whole Video Duration to this values

                        if (videolink.contains("https") &&
                            !videolink.contains("youtube")) {
                          print("The videolink has https");
                          String url = videolink.replaceFirst(
                            "https://",
                            "http://",
                          );
                          print(url);
                          videoProgressMap[url] = widget.videoDurationData[url];
                          totalProgressMap[url] = widget.videoDurationData[url];
                        } else if (videolink.contains("?enablejsapi=1")) {
                          String url = videolink.replaceFirst(
                            "?enablejsapi=1",
                            "",
                          );
                          videoProgressMap[url] = widget.videoDurationData[url];
                          totalProgressMap[url] = widget.videoDurationData[url];
                        } else {
                          widget.videoDurationData[videolink];
                          videoProgressMap[videolink] =
                              widget.videoDurationData[videolink];
                          totalProgressMap[videolink] =
                              widget.videoDurationData[videolink];
                        }
                        // print(videolink);
                        // print(widget.videoDurationData);
                        // print(videoProgressMap);
                        //  _updateTotalVideoProgress();
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
      ],
    );
  }

  Widget toolbar() {
    return ToolBar(
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
      crossAxisAlignment: WrapCrossAlignment.start,
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
            var selectedText = await widget.controller.getSelectedText();
            debugPrint('selectedText $selectedText');
            var selectedHtmlText =
                await widget.controller.getSelectedHtmlText();
            debugPrint('selectedHtmlText $selectedHtmlText');
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
      // print("######################calling get Total Progress");
      totalInteractionProgress =
          (totalProgressMap.values.fold(
            0.0,
            (sum, progressTtotal) => sum + progressTtotal,
          )) /
          (widget.videosTotalDuration + scrollength.toDouble());

      //TODO:Testing it
      widget.updateTotalProgress(totalProgressMap, totalInteractionProgress);
      // ref
      //     .read(paramsUpateControllerProvider.notifier)
      //     .updateTotalProgress(totalProgressMap);
    });
  }

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
    //TODO:ideoProgressMap to be updated with the videoList data from backend upon loading.
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

  Widget commentTile(String comment) {
    return Container(
      margin: const EdgeInsets.all(8),
      padding: const EdgeInsets.all(9),
      //height: 40,
      width: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            offset: const Offset(0, 4),
            spreadRadius: 0,
            blurRadius: 24,
          ),
        ],
        color: Colors.white,
        border: Border.all(color: Colors.grey.withOpacity(0.3)),
        borderRadius: BorderRadius.circular(9),
      ),
      child: Text(comment),
    );
  }

  void _addComment(String text) {
    final comment = Comment(text: text);
    setState(() {
      _comments.add(comment);
      commentController.clear();
      selectedTextlength = 0;
    });
  }

  ///WEB VERSION COMMENT Modal Bottom Sheet
  showModalSheetScreen(int index, int length) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Container(
            width: double.maxFinite,
            padding: const EdgeInsets.all(8.0),
            margin: const EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
              boxShadow: [
                BoxShadow(
                  color: Theme.of(context).canvasColor,
                  blurRadius: 0.1,
                  spreadRadius: 0.4,
                  offset: const Offset(2, 6),
                ),
              ],
            ),
            child: Wrap(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 14.0, left: 9, right: 9),
                  child: Column(
                    children: [
                      TextField(
                        controller: commentController,
                        autofocus: true,
                        decoration: InputDecoration(
                          hintText: 'Make your comment...',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                      ),
                      const SizedBox(height: 9),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cancel'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              _addComment(commentController.text);
                              widget.controller.setFormat(
                                format: 'background',
                                value: '#FF9800',
                                index: index,
                                length: length,
                              );
                              Navigator.pop(context);
                            },
                            child: const Text('Comment'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
        //: const SizedBox.shrink(): const SizedBox.shrink()
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
    return await _webviewController.callJsMethod("setSelection", [
      index,
      length,
    ]);
  }

  /// a private method to set the Html text to the editor
  Future _setHtmlTextToEditor({required String htmlText}) async {
    return await _webviewController.callJsMethod("setHtmlText", [
      htmlText,
      kIsWeb,
      isEnabled,
    ]);
  }

  /// a private method to set the Delta  text to the editor
  Future _setDeltaToEditor({required Map<dynamic, dynamic> deltaMap}) async {
    return await _webviewController.callJsMethod("setDeltaContent", [
      jsonEncode(deltaMap),
    ]);
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
    return await _webviewController.callJsMethod("insertHtmlText", [
      htmlText,
      index,
    ]);
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
      return await _webviewController.callJsMethod("setFormat", [
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
    return await _webviewController.callJsMethod("insertTable", [row, column]);
  }

  /// a private method to add remove or delete table in the editor
  Future _modifyTable(EditTableEnum type) async {
    return await _webviewController.callJsMethod("modifyTable", [type.name]);
  }

  /// a private method to replace selection text in the editor
  Future _replaceText(String replaceText) async {
    return await _webviewController.callJsMethod("replaceSelection", [
      replaceText,
    ]);
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
    return await _webviewController.callJsMethod("setScrollPosition", [
      scrollPosition,
    ]);
  }

  Future _setVideoPosition({required Map<String, dynamic> videos}) async {
    return await _webviewController.callJsMethod("setVideoPosition", [
      jsonEncode(videos),
    ]);
  }

  /// method to un focus editor
  void unFocusEditor() => widget.controller.unFocus();
}

// class Comment {
//   final String text;
//   Comment({required this.text});
// }

void _printWrapper(bool showPrint, String text) {
  if (showPrint) {
    debugPrint(text);
  }
}

class Comment {
  final String text;
  Comment({required this.text});
}
