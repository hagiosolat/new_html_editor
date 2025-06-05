import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_html_editor/new_html_editor.dart';
import 'package:new_html_editor_example/Application/data_services.dart';
import 'package:new_html_editor_example/Domain/html_data_model.dart';
import 'package:new_html_editor_example/Presentation/controller/html_content_controller.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ProviderScope(
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: ArticleListScreen(),
      ),
    ),
  );
}

class ArticleListScreen extends ConsumerStatefulWidget {
  const ArticleListScreen({super.key});

  @override
  ConsumerState<ArticleListScreen> createState() => _ArticleListScreenState();
}

class _ArticleListScreenState extends ConsumerState<ArticleListScreen> {
  QuillEditorController controller = QuillEditorController();
  bool isWebviewvisible = false;
  String editorContent = "";
  String articleID = "";
  Map<String, dynamic> metaData = {};
  Map<String, dynamic> metaDataTotal = {};
  Map<String, dynamic> videoMetaData = {};
  Map<String, dynamic> videosDurationsData = {};
  Map<String, dynamic> videosDurations = {};
  num scrollProgress = 0.0;
  num totalProgress = 0.0;
  int videoTotalDuration = 0;
  List<HtmlData> savedData = [];

  void videosToMap(List<Video> videos) {
    metaData = {};
    for (var video in videos) {
      metaData[video.videoUrl!] = video.savedDuration;
    }
  }

  void videoDurationToMap(List<Video> videos) {
    videosDurations = {};
    for (var video in videos) {
      videosDurations[video.videoUrl!] = video.videoDuration;
    }
  }

  void allProgressToMap(List<Video> videos, double scrollProgress) {
    metaDataTotal = {};
    metaDataTotal['scrollPosition'] = scrollProgress;
    for (var video in videos) {
      metaDataTotal[video.videoUrl!] = video.savedDuration;
    }
  }

  void saveArticleProgress() {
    //VidoData is available...
    //videoTotalDuration available...
    //scrollProgress available...
    List<Video> videos =
        videoMetaData.keys
            .where((key) => videosDurationsData.containsKey(key))
            .map(
              (key) => Video(
                videoUrl: key,
                savedDuration: videoMetaData[key]!,
                videoDuration: videosDurationsData[key]!,
              ),
            )
            .toList();

    // List<Video> videos =
    //     videoMetaData.entries
    //         .map(
    //           (video) => Video(videoUrl: video.key, savedDuration: video.value),
    //         )
    //         .toList();
    final savingData = HtmlData(
      articleData: editorContent,
      articleID: articleID,
      videos: videos,
      videosTotalDuration: videoTotalDuration,
      scrollProgress: scrollProgress,
      totalProgress: totalProgress,
    );

    int articleIndex = savedData.indexWhere(
      (article) => article.articleID == savingData.articleID,
    );

    if (articleIndex > -1) {
      savedData[articleIndex] = savingData;
    } else {
      savedData.add(savingData);
    }
  }

  void saveProgress() {
    ref
        .read(saveProgressProvider.notifier)
        .saveArticleProgress(
          articleID: articleID,
          articleData: editorContent,
          videoMetaData: videoMetaData,
          videosDurationsData: videosDurationsData,
          scrollProgress: scrollProgress,
          totalProgress: totalProgress,
          videosTotalDuration: videoTotalDuration,
        );
  }

  @override
  Widget build(BuildContext context) {
    final articleList = ref.watch(htmlContentControllerProvider);
    final result = ref.watch(saveProgressProvider);
    return Scaffold(
      body: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPopUp, result) {
          setState(() {
            isWebviewvisible = false;
            saveArticleProgress();
            saveProgress();
          });
        },

        child: IndexedStack(
          index: isWebviewvisible ? 1 : 0,
          children: [
            //THE LIST OF ARTICLES TO BE READ
            Visibility(
              visible: !isWebviewvisible,
              child: ListView.builder(
                physics: ScrollPhysics(),
                shrinkWrap: true,
                itemCount: articleList.length,
                itemBuilder: (contexclt, index) {
                  return GestureDetector(
                    onTap: () {
                      print(
                        "################################################################### This is the result I am watching now ${result.length}",
                      );
                      setState(() {
                        //Check if the selected article is available in the saved list
                        if (savedData.any(
                          (article) =>
                              article.articleID == articleList[index].articleID,
                        )) {
                          //Get the article with its data saved in the variable.
                          final selectedArticle = savedData.firstWhere(
                            (article) =>
                                article.articleID ==
                                articleList[index].articleID,
                          );
                          //Convert the available videos in the article to Map type an save it inside metaData variable.
                          videosToMap(selectedArticle.videos ?? []);

                          //Convert the available videos and the scrollPosition to Map type
                          //And save it inside the metaDataTotal variable
                          allProgressToMap(
                            selectedArticle.videos ?? [],
                            selectedArticle.scrollProgress?.toDouble() ?? 0.0,
                          );

                          //Convert the video DUrations to Map type to save the video Durations
                          //Such that Mark as Read button can function Appropriately
                          videoDurationToMap(selectedArticle.videos ?? []);

                          //Assign the articleData(HTML) to editorContent variable
                          editorContent = selectedArticle.articleData ?? '';
                          //Assign the articleID to the articleID variable for comparison when the user
                          //Comes back from the editor.
                          articleID = selectedArticle.articleID ?? '';
                          //Assign the total VideoDuration to the videoTotalDuration variable.
                          videoTotalDuration =
                              selectedArticle.videosTotalDuration?.toInt() ?? 0;
                        } else {
                          //Assign editorContent of the selectdArticle
                          //(The List of Articles are coming from the backend)
                          editorContent = articleList[index].articleData ?? '';

                          //Assign articleID of the selectdArticle
                          //(The List of Articles are coming from the backend)
                          articleID = articleList[index].articleID ?? '';

                          //Map of the available videos with the currentPosition of the videos.
                          metaData = ref.read(dataServicesProvider(index));

                          //This is the video total Duration
                          videoTotalDuration = ref.read(
                            videoTotalDurationProvider(index),
                          );
                          //Contains the map of the scroll Position and the videos with their
                          //progresss that was made from the back end.
                          metaDataTotal = ref.read(
                            mobileDataServicesProvider(index),
                          );

                          //Contains the video map with their duration to work with mark as Read button.
                          videosDurations = ref.read(
                            getVideoDurationsProvider(index),
                          );
                        }
                        isWebviewvisible = true;
                      });
                    },
                    child: Container(
                      height: 70,
                      margin: EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 25,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(9),
                        border: Border.all(color: Colors.blueGrey.shade200),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Article Testing $index',
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
                },
              ),
            ),
            //THIS IS WHERE THE PACKAGE IS BEING USED WITH THE DATA COMING FROM THE BACKEND.
            !kIsWeb
                //THIS IS THE MOBILE VERSION OF MAKING THE EDITOR VISIBLE
                ? Offstage(
                  offstage: !isWebviewvisible,
                  child: NewEditorScreen(
                    controller: controller,
                    editorContent: editorContent,
                    metaData: metaData,
                    metaDataTotal: metaDataTotal,
                    videosTotalDuration: videoTotalDuration,
                    videoDurationData: videosDurations,
                    //Get videos Update is to get Map of the available
                    //videos and their currentPositions.
                    //Then when it is about to be saved for the ephemeral state, the Map can be converted
                    //to the video Custom Data and to a list.
                    getVideosUpdates: (videoData, videoDurationsDataIn) {
                      videoMetaData = videoData;
                      videosDurationsData = videoDurationsDataIn;
                    },
                    //THE ESSENCE OF GETTING THE PROGRESS WHICH IS THE SCROLL PROGRESS
                    //is to keep track of the scroll progress such
                    //that when the application is laoded again
                    //the application can resume back to the scroll Position.
                    updateScrollProgress: (progress) {
                      scrollProgress = progress as num;

                      ref
                          .read(paramsUpateControllerProvider.notifier)
                          .updateScrollProgress(progress);
                    },
                    //THE ESSENCE OF GETTING THE TOTAL PROGRESS, this is
                    //to get the value of the total Progress made
                    //which is the progress of both the videos and also the scroll Progress position.
                    //The essence of this is to feed the backend with the current total Progress in realtime.
                    updateTotalProgress: (totalProgressMap, totalProgress) {
                      totalProgress = totalProgress;
                      ref
                          .read(paramsUpateControllerProvider.notifier)
                          .updateTotalProgress(totalProgressMap);
                    },
                    //THE ESSENCE OF THIS PROGRESS information is to notify the backend
                    //in realtime the currentPosition of the
                    //current video that is playing and then get
                    //the index of the video in the database to feed it with the currentPosition
                    updateCurrentVideoProgress: (p0) {
                      ref
                          .read(paramsUpateControllerProvider.notifier)
                          .updateCurrentVideoProgress(
                            articleID: p0['articleID'],
                            videoUrl: p0['videoUrl'],
                            currentPosition: p0['currentPosition'],
                          );
                    },
                    isOutSideEditor: true,
                  ),
                )
                //THIS IS FOR THE WEB VERSION IN RENDERING THE EDITOR.
                : Visibility(
                  visible: isWebviewvisible,
                  child: NewEditorScreen(
                    controller: controller,
                    editorContent: editorContent,
                    metaData: metaData,
                    metaDataTotal: metaDataTotal,
                    videosTotalDuration: videoTotalDuration,
                    videoDurationData: videosDurations,
                    //Get videos Update is to get Map of the available
                    //videos and their currentPositions.
                    //Then when it is about to be saved for the ephemeral state, the Map can be converted
                    //to the video Custom Data and to a list.
                    getVideosUpdates: (videoData, videoDurationDataIn) {
                      setState(() {
                        videoMetaData = videoData;
                        videosDurationsData = videoDurationDataIn;
                      });
                    },
                    //THE ESSENCE OF GETTING THE PROGRESS WHICH IS THE SCROLL PROGRESS
                    //is to keep track of the scroll progress such
                    //that when the application is laoded again
                    //the application can resume back to the scroll Position.
                    updateScrollProgress: (progress) {
                      setState(() {
                        scrollProgress = progress as num;
                      });
                      //ref.read(articleProgressControllerProvider.notifier).addOrUpdateArticle(article)
                      ref
                          .read(paramsUpateControllerProvider.notifier)
                          .updateScrollProgress(progress);
                    },
                    //THE ESSENCE OF GETTING THE TOTAL PROGRESS, this is
                    //to get the value of the total Progress made
                    //which is the progress of both the videos and also the scroll Progress position.
                    //The essence of this is to feed the backend with the current total Progress in realtime.n
                    updateTotalProgress: (totalProgressMap, totalProgress) {
                      totalProgress = totalProgress;
                      ref
                          .read(paramsUpateControllerProvider.notifier)
                          .updateTotalProgress(totalProgressMap);
                    },
                    //THE ESSENCE OF THIS PROGRESS information is to notify the backend
                    //in realtime the currentPosition of the
                    //current video that is playing and then get
                    //the index of the video in the database to feed it with the currentPosition
                    updateCurrentVideoProgress: (p0) {
                      ref
                          .read(paramsUpateControllerProvider.notifier)
                          .updateCurrentVideoProgress(
                            articleID: p0['articleID'],
                            videoUrl: p0['videoUrl'],
                            currentPosition: p0['currentPosition'],
                          );
                    },
                    isOutSideEditor: true,
                  ),
                ),
          ],
        ),
      ),
    );
  }
}
