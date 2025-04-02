import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_html_editor/new_html_editor.dart';
import 'package:new_html_editor/src/feature/Data/html_repo.dart';
import 'package:new_html_editor/src/feature/Presentation/controller/html_content_controller.dart';
import 'package:new_html_editor/src/feature/Presentation/view/widgets/mobile_youtube_video.dart';
import 'package:new_html_editor/src/feature/Presentation/view/widgets/progress_bar.dart';
import 'package:new_html_editor/src/feature/Presentation/view/widgets/show_web_video.dart';

class EditorScreen extends ConsumerStatefulWidget {
  const EditorScreen(
      {
      //required this.htmlContent,
      // required this.videosTotalDuration,
      super.key});

  // final String htmlContent;
  // final int videosTotalDuration;

  @override
  ConsumerState<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends ConsumerState<EditorScreen> {
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
      fontFamily: 'Roboto');
  final _hintTextStyle = const TextStyle(
      fontSize: 18, color: Colors.black38, fontWeight: FontWeight.normal);

  bool _hasFocus = false;
  bool isLoading = false;

  int selectedTextlength = 0;
  int selectedTextPosition = 0;
  // final GlobalKey _textKey = GlobalKey();
  final List<Comment> _comments = [];
  final TextEditingController commentController = TextEditingController();
  final QuillEditorController controller = QuillEditorController();
  StreamController<num> progressController = StreamController();
  Stream? streamTest;

  //TODO: Testing use case for the total duration of the videos
  final int videosTotalDuration = 60070 + 653803 + 213000;

  ScrollController scrollController = ScrollController();
  ScrollController mobileScrollController = ScrollController();
  // variable to hold videoProgress
  double _videoProgress = 0.0;
  //Variable to hold the total Progress.[videos and article Progress]
  double totalInteractionProgress = 0.0;
  //variable to hold the scrolling progress
  num _progress = 0.0;
  //variable to hold current scroll
  num scrollength = 0.0;
  //variable to hold the video and their last position to be saved
  //to the backend database
  Map<String, dynamic> controllerMap = {};
  //variable to hold the progress of the videos being played
  Map<String, dynamic> videoProgressMap = {};
  //variable to hold the progress of both the videos and
  //the article progress
  Map<String, dynamic> totalProgressMap = {};

  double _currentPosition = 0.0; // currentPosition
  double _maxPosition = 0.0; // max Position

  bool isWebviewvisible = false;

  String content = '';

  void _addComment(String text) {
    final comment = Comment(text: text);
    setState(() {
      _comments.add(comment);
      commentController.clear();
      selectedTextlength = 0;
    });
  }

// function for total progress
  void _getTotalProgress() {
    /// Get the scroll Length
    /// Get the total Duration
    setState(() {
      totalInteractionProgress = (totalProgressMap.values
              .fold(0.0, (sum, progressTtotal) => sum + progressTtotal)) /
          (videosTotalDuration + scrollength.toDouble());
    });
  }

  // Listen to changes in the scroll position

// This method will be called on every scroll event
  void _onScroll() {
    setState(() {
      _currentPosition =
          mobileScrollController.position.pixels; // current position
      _maxPosition = mobileScrollController.position.maxScrollExtent;

      _progress = (_currentPosition / _maxPosition).abs(); // max position

     // print(_progress.toString());
    });
  }

  void _updateTotalProgress() {
    if (videoProgressMap.isNotEmpty) {
      _videoProgress = (videoProgressMap.values
              .fold(0.0, (sum, progress) => sum + progress) /
          videosTotalDuration);
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
            positioning: controllerMap.containsKey(youtubeLink)
                ? controllerMap[youtubeLink]
                : Duration.zero,
            videoUrl: youtubeLink,
            durationRation: (duration) {
              //This will save the percentage of the video
            },
            videoDuration: (totalDuration) {
              //when the video has been paused on quit.
              // send the position to this point and then save it
              // to the Map Controller to retrieve it back when resumed.
              controllerMap[youtubeLink] = totalDuration;
            },
            currentPosition: (currentPosition) {
              // print('$currentPosition');
              setState(() {
                videoProgressMap[youtubeLink] = currentPosition.inMilliseconds;
                totalProgressMap[youtubeLink] = currentPosition.inMilliseconds;
                _updateTotalProgress();
                _getTotalProgress();
              });
            });
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
                  positioning: controllerMap.containsKey(videolink)
                      ? controllerMap[videolink]
                      : Duration.zero,
                  videoUrl: videolink,
                  videoDuration: (currentTime) {
                    ///This is to save the videoDuration when the video has been exited
                    ///from the pop-up
                    controllerMap[videolink] = currentTime;
                    print(controllerMap[videolink]);
                  },
                  videoRatio: (videoPercentage) {},
                  currentPosition: (currentTime) {
                    setState(() {
                      videoProgressMap[videolink] = currentTime.inMilliseconds;
                      totalProgressMap[videolink] = currentTime.inMilliseconds;
                      _updateTotalProgress();
                      _getTotalProgress();
                    });
                  },
                )),
          );
        });
  }

  ///Modal Bottom Sheet
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
                    )
                  ]),
              child: Wrap(
                children: [
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 14.0, left: 9, right: 9),
                    child: Column(
                      children: [
                        TextField(
                          controller: commentController,
                          autofocus: true,
                          decoration: InputDecoration(
                              hintText: 'Make your comment...',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(50))),
                        ),
                        const SizedBox(
                          height: 9,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            ElevatedButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: const Text('Cancel')),
                            ElevatedButton(
                                onPressed: () {
                                  _addComment(commentController.text);
                                  controller.setFormat(
                                      format: 'background',
                                      value: '#FF9800',
                                      index: index,
                                      length: length);
                                  Navigator.pop(context);
                                },
                                child: const Text('Comment'))
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
          //: const SizedBox.shrink(): const SizedBox.shrink()
        });
  }

  //TODO: When to save all the datas as a Map and also to access them all at inistate
  // when they are called back at the screen
  @override
  void initState() {
    mobileScrollController.addListener(_onScroll);

    controller.onTextChanged((text) {
      debugPrint('listening to $text');
    });
    controller.onEditorLoaded(() {
      debugPrint('Editor Loaded :)');
    });
    try {
      controller.setText(content);
    } catch (e) {
      print(e.toString());
    }

    //ENABLE THE STREAM CONTROLLER TO LISTEN FOR DATA UPDATES
    progressController.stream.listen((event) {
      setState(() {
        print(
            'fhjshsjhfjfhdjfhjdhfjhs77777777777777777777777777777777777${_progress.toDouble()}');
        _progress = event;
      });
    });

    /// From here we can load the saved percentage of
    /// the previous saved article
    /// then update it with the current playing videos
    super.initState();
  }

  @override
  void dispose() {
    //  scrollController.removeListener(scrollListener);
    scrollController.dispose();
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(htmlFullContentControllerProvider);
    // final state2 = ref.watch(htmlContentControllerProvider);
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        setState(() {
          isWebviewvisible = false;
        });
      },
      child: SafeArea(
          child: isWebviewvisible
              ? Scaffold(
                  floatingActionButton: selectedTextlength >= 1
                      ? !kIsWeb
                          ? ElevatedButton(
                              onPressed: () async {
                                final selection =
                                    await controller.getSelectionRange();
                                if (selection.length == 0) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                        content:
                                            Text('Select text to comment on')),
                                  );
                                } else {
                                  showModalSheetScreen(
                                      selectedTextPosition, selectedTextlength);
                                }
                              },
                              child: const Text('Add Comment'))
                          : const SizedBox.shrink()
                      : const SizedBox.shrink(),
                  backgroundColor: Colors.white,
                  resizeToAvoidBottomInset: true,
                  body: kIsWeb
                      //WEB VERSION EDITOR OUTLOOK
                      ? CustomScrollView(
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
                                  Container(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
                                  ProgressBars(
                                    label:
                                        'Video Progress ${(_videoProgress * 100).toStringAsFixed(1)}%',
                                    progress: _videoProgress,
                                    color: Colors.blueAccent,
                                  ),
                                  Container(
                                    height: 2,
                                    color: Colors.grey,
                                  ),
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
                                //height: MediaQuery.of(context).size.height,
                                child:
                                    //Column(children: [//  Expanded(child:
                                    Row(
                              children: [
                                Flexible(
                                    flex: 3,
                                    child: isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : editor()),
                                _comments.isEmpty
                                    ? const SizedBox.shrink()
                                    : Container(
                                        decoration: BoxDecoration(
                                            color: Colors.grey.withOpacity(0.1),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        margin: const EdgeInsets.only(
                                            right: 15, top: 10, bottom: 10),
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
                                                _comments[index].text);
                                          },
                                        ))
                              ],
                            )
                                //   ) //  ],),
                                )
                          ],
                        )
                      //THE MOBILE VERSION EDITOR OUTLOOK
                      : Column(
                          children: [
                            toolbar(),
                            ProgressBars(
                              label:
                                  'Total Progress ${(totalInteractionProgress * 100).toStringAsFixed(1)}%',
                              progress: totalInteractionProgress,
                              color: Colors.blue,
                            ),
                            Container(
                              height: 2,
                              color: Colors.grey,
                            ),
                            ProgressBars(
                              label:
                                  'Video Progress ${(_videoProgress * 100).toStringAsFixed(1)}%',
                              progress: _videoProgress,
                              color: Colors.blueAccent,
                            ),
                            Container(
                              height: 2,
                              color: Colors.grey,
                            ),
                            ProgressBars(
                              label:
                                  'Article Progress ${(_progress.toDouble() * 100).toStringAsFixed(1)}%',
                              progress: _progress.toDouble(),
                              color: Colors.lightBlue,
                            ),
                            Expanded(
                                flex: 10,
                                child: SingleChildScrollView(
                                    controller: mobileScrollController,
                                    child: isLoading
                                        ? const Center(
                                            child: CircularProgressIndicator(),
                                          )
                                        : editor())),
                          ],
                        ),
                  bottomNavigationBar: kIsWeb
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
                                    )
                                  ]),
                              child: Wrap(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        top: 14.0, left: 9, right: 9),
                                    child: Column(
                                      children: [
                                        TextField(
                                          controller: commentController,
                                          decoration: InputDecoration(
                                              hintText: 'Make your comment...',
                                              border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50))),
                                        ),
                                        const SizedBox(
                                          height: 9,
                                        ),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceAround,
                                          children: [
                                            ElevatedButton(
                                                onPressed: () {},
                                                child: const Text('Cancel')),
                                            ElevatedButton(
                                                onPressed: () {
                                                  _addComment(
                                                      commentController.text);
                                                  controller.setFormat(
                                                      format: 'background',
                                                      value: '#FF9800');
                                                },
                                                child: const Text('Comment'))
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            )
                          : const SizedBox.shrink()
                      : const SizedBox.shrink(),
                )
              : Scaffold(
                  backgroundColor: Colors.white,
                  body: Center(
                      child: ListView.builder(
                          itemCount: state.htmlContents.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  isWebviewvisible = true;
                                  content =
                                      state.htmlContents[index].articleData ??
                                          '';
                                });
                                // Navigator.push(context,
                                //     MaterialPageRoute(builder: (context) {
                                //   return EditorScreen(
                                //     htmlContent:
                                //         state.htmlContents[index].articleData ?? '',
                                //     videosTotalDuration: state.videosTotalDuration!,
                                //     //state[index].articleData ?? '',
                                //   );
                                // }));
                              },
                              child: Container(
                                height: 70,
                                margin: EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 25),
                                decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(9),
                                    border: Border.all(
                                        color: Colors.blueGrey.shade200)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Article $index',
                                      style: TextStyle(
                                        fontFamily: 'Time New Roman',
                                        fontSize: 25,
                                        color: Colors.black,
                                      ),
                                    ),
                                    //  Icon(color: Colors.grey, Icons.arrow_forward),
                                  ],
                                ),
                              ),
                            );
                          })

                      //  Column(
                      //   mainAxisAlignment: MainAxisAlignment.center,
                      //   children: [
                      //
                      //   ],
                      // ),
                      ))),
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
                blurRadius: 24)
          ],
          color: Colors.white,
          border: Border.all(color: Colors.grey.withOpacity(0.3)),
          borderRadius: BorderRadius.circular(9)),
      child: Text(comment),
    );
  }

  ///EDITOR WIDGET.
  Widget editor() {
    return QuillEditorNew(
        text: htmlcontent.htmlContents[0].articleData ?? '',
        hintText: '',
        //'Hint text goes here',
        controller: controller,
        isEnabled: true,
        ensureVisible: false,
        minHeight: MediaQuery.of(context).size.height,
        autoFocus: false,
        textStyle: _editorTextStyle,
        hintTextStyle: _hintTextStyle,
        hintTextAlign: TextAlign.start,
        //padding: const EdgeInsets.only(left: 10, top: 10),
        hintTextPadding: const EdgeInsets.only(left: 20),
        backgroundColor: _backgroundColor,
        inputAction: InputAction.newline,
        onEditingComplete: (s) => debugPrint('Editing completed $s'),
        onFocusChanged: (focus) {
          debugPrint('has focus $focus');
          setState(() {
            _hasFocus = focus;
          });
        },
        videoLink: (videoLink) {
          if (kIsWeb) {
            //INITIALLY PLANNED TO USE THIS FOR VIDEO SAVING
          } else {
            if (videoLink.contains('youtube')) {
              showdialog(context, videoLink);
            } else {
              shownormalVideoDialog(context, videoLink);
            }
          }
        },
        //Call back for the button to show that the read function is completed
        watchedVideo: (videolink) {
          if (kIsWeb) {
          } else {
            setState(() {
              //TODO: There should be a condition to check if the videoLink is thesame as the one sent
              //from the firebase; then it will update that particular video
              //Something like; list of videos coming from backend; where the videolink is thesame with the videos.videourl
              //Then update the video with the duration
              videoProgressMap[videolink] = 60070;
              totalProgressMap[videolink] = 60070;
              _updateTotalProgress();
              _getTotalProgress();

              //THIS SHOULD BE THAT THE CONTROLLERMAP IS NOW AT THE END
              //OF THE VIDEO
              //SO WHEN IT IS RESUMED, IT WILL START FROM THE BEGIIING
              controllerMap[videolink] = const Duration(milliseconds: 60070);
            });
          }
        },

        //  onTextChanged: (text) => debugPrint('widget text change $text'),
        onEditorCreated: () {
          debugPrint('Editor has been loaded');
          controller.setText(htmlcontent.htmlContents[0].articleData ?? '');
        },
        onEditorResized: (height) => debugPrint('Editor resized $height'),
        onSelectionChanged: (sel) {
          debugPrint('index ${sel.index}, range ${sel.length}');
          setState(() {
            selectedTextlength = sel.length ?? 0;
            selectedTextPosition = sel.index ?? 0;
          });
        },
        webVideoTracking: (video) {
          if (kIsWeb) {
            setState(() {
              // From here I can get the current Position and then pass
              // it to the Map
              videoProgressMap[video.videoUrl] = video.currentPosition;
              totalProgressMap[video.videoUrl] = video.currentPosition;
              _updateTotalProgress();
              _getTotalProgress();
              //THE ESSENCE OF THE CONTROLLER MAP IS FOR RESUMPTION
              //FROM WHERE THE VIDEO LEFT OFF
              controllerMap[video.videoUrl] = video.currentPosition;
            });
          }
        },
        onVerticalScrollChange: (p0) {
          if (kIsWeb) {
            // print(
            //     'scrollTop is ${p0.scrollTop}, currentPosition ${p0.currentPosition}');
            setState(() {
              // _progress = p0.currentPosition ?? 0.0;
              scrollength = p0.maxScroll ?? 0.0;
              totalProgressMap['scrollPosition'] = p0.scrollTop;

              //This is the streamController that will be sending the progress to the backend.
              progressController.add(p0.currentPosition ?? 0.0);
              _getTotalProgress();
            });
          } else {
            // print(
            //     'scrollTop is ${p0.scrollTop}, currentPosition ${p0.currentPosition}');
            setState(() {
              //_progress = p0.currentPosition ?? 0.0;
              print('${p0.currentPosition}');
              scrollength = p0.maxScroll ?? 0.0;
              totalProgressMap['scrollPosition'] = p0.scrollTop;
              //This is the stream that will be sending the progress to the backend.
              progressController.add(p0.currentPosition ?? 0.0);
              _getTotalProgress();
            });
          }
        },
        lastScrollPosition: totalProgressMap['scrollPosition'],
        videosDuration: //TESTING SCENARIO FOR VIDEO RESUMPTION ON THE WEB SIDE
            const {
          'https://www.youtube.com/embed/dQw4w9WgXcQ?enablejsapi=1':
              13055.963938964844,
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4':
              13749.145999999999,
          'http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4':
              323413.349
        });
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
      controller: controller,
      crossAxisAlignment: WrapCrossAlignment.start,
      direction: Axis.horizontal,
      customButtons: [
        Container(
          width: 25,
          height: 25,
          decoration: BoxDecoration(
              color: _hasFocus ? Colors.green : Colors.grey,
              borderRadius: BorderRadius.circular(15)),
        ),
        InkWell(
            onTap: () => unFocusEditor(),
            child: const Icon(
              Icons.favorite,
              color: Colors.black,
            )),
        InkWell(
            onTap: () async {
              var selectedText = await controller.getSelectedText();
              debugPrint('selectedText $selectedText');
              var selectedHtmlText = await controller.getSelectedHtmlText();
              debugPrint('selectedHtmlText $selectedHtmlText');
            },
            child: const Icon(
              Icons.add_circle,
              color: Colors.black,
            )),
      ],
    );
  }

  Widget textButton({required String text, required VoidCallback onPressed}) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: MaterialButton(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
          color: _toolbarIconColor,
          onPressed: onPressed,
          child: Text(
            text,
            style: TextStyle(color: _toolbarColor),
          )),
    );
  }

  ///[getHtmlText] to get the html text from editor
  void getHtmlText() async {
    String? htmlText = await controller.getText();
    debugPrint(htmlText);
  }

  ///[setHtmlText] to set the html text to editor
  void setHtmlText(String text) async {
    await controller.setText(text);
  }

  ///[insertNetworkImage] to set the html text to editor
  void insertNetworkImage(String url) async {
    await controller.embedImage(url);
  }

  ///[insertVideoURL] to set the video url to editor
  ///this method recognises the inserted url and sanitize to make it embeddable url
  ///eg: converts youtube video to embed video, same for vimeo
  void insertVideoURL(String url) async {
    await controller.embedVideo(url);
  }

  /// to set the html text to editor
  /// if index is not set, it will be inserted at the cursor postion
  void insertHtmlText(String text, {int? index}) async {
    await controller.insertText(text, index: index);
  }

  /// to clear the editor
  void clearEditor() => controller.clear();

  /// to enable/disable the editor
  void enableEditor(bool enable) => controller.enableEditor(enable);

  /// method to un focus editor
  void unFocusEditor() => controller.unFocus();

  void formatText() => controller.formatText();
}

class Comment {
  final String text;
  Comment({required this.text});
}
