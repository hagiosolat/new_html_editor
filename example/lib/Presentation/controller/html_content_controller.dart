import 'package:new_html_editor/domain/html_data_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:new_html_editor/data/html_repo.dart';
part 'html_content_controller.g.dart';

@riverpod
class HtmlContentController extends _$HtmlContentController {
  @override
  List<HtmlData> build() {
    return ref.read(repoProvider).getHtmlList();
  }
}

@riverpod
class ParamsUpateController extends _$ParamsUpateController {
  @override
  Future<void> build() async {}

  Future<void> updateTotalProgress(Map<String, Object?> totalProgress) async {
    await ref.read(repoProvider).updateTotalProgress(totalProgress);
  }

  void updateCurrentVideoProgress({
    required String articleID,
    required String videoUrl,
    required double currentPosition,
  }) {
    ref
        .read(repoProvider)
        .updateCurrentVideoPosition(
          articleID: articleID,
          videoUrl: videoUrl,
          currentPosition: currentPosition,
        );
  }

  Future<void> updateScrollProgress(double readProgress) async {
    await ref.read(repoProvider).updateScrollProgress(readProgress);
  }
}

// TODO:sorting out data to Map data type from here.
// I CAN HAVE A CONTROLLER THAT CAN DO THE WORK OF MAKING AVAILABLE THE DATAS NEEDED
// I WOULD HAVE SORTED OUT ALL THE DATA NEEDED TO BE ASSIGNED TO THE MAP FROM THIS LAYER.

// FROM THIS POINT IT WILL REQUIRES THAT I SORT THE MAP TYPE BY
// 1. HAVING THE LAST SCROLL POSITION IN THE MAP WITH THE
// 2. VIDEO DATA: BASICALLY THE VIDEO URL AND THE LAST SAVED DURATION.
@riverpod
class SaveProgress extends _$SaveProgress {
  @override
  List<HtmlData> build() {
    return [];
  }

  void saveArticleProgress({
    required String articleID,
    required String articleData,
    required Map<String, Object?> videoMetaData, // dynamic → Object?
    required Map<String, int?> videosDurationsData, // dynamic → Object?
    required double scrollProgress, // num → double
    required double totalProgress, // num → double
    required int videosTotalDuration, // num → int
  }) {
    final videos =
        videoMetaData.keys
            .where((key) => videosDurationsData.containsKey(key))
            .map(
              (key) => Video(
                videoUrl: key,
                savedDuration: (videoMetaData[key] as num?)?.toDouble(),
                videoDuration: (videosDurationsData[key] as int),
              ),
            )
            .toList();

    final savingData = HtmlData(
      articleData: articleData,
      articleID: articleID,
      videos: videos,
      videosTotalDuration: videosTotalDuration,
      scrollProgress: scrollProgress,
      totalProgress: totalProgress,
    );

    //  print(savingData);

    final articleIndex = state.indexWhere(
      (article) => article.articleID == savingData.articleID,
    );
    if (articleIndex > -1) {
      final updatedList = [...state];
      updatedList[articleIndex] = savingData;
      state = updatedList;
    } else {
      state = [...state, savingData];
    }
  }
}
