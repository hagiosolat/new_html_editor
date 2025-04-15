import 'package:new_html_editor/src/feature/Data/html_repo.dart';
import 'package:new_html_editor/src/feature/Domain/html_data_model.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'html_content_controller.g.dart';

@riverpod
class HtmlContentController extends _$HtmlContentController {
  @override
  List<HtmlData> build() {
    return getHtmlContent();
  }

  List<HtmlData> getHtmlContent() {
    final repo = ref.read(repoProvider).getHtmlList();
    return repo;
  }
}

@riverpod
class ParamsUpateController extends _$ParamsUpateController {
  @override
  void build() {}

  void updateTotalProgress(Map<String, dynamic> totalProgress) async {
    // print("Can I print the map values for totalProgress $totalProgress");
    return await ref.read(repoProvider).updateTotalProgress(totalProgress);
  }

  void updateCurrentVideoProgress({
    required String articleID,
    required String videoUrl,
    required num currentPosition,

  }) async {
    return ref
        .read(repoProvider)
        .updateCurrentVideoPosition(
          articleID: articleID,
          videoUrl: videoUrl,
          currentPosition: currentPosition,
         
        );
  }

  void updateScrollProgress(num readProgress) async {
    return await ref.read(repoProvider).updateScrollProgress(readProgress);
  }
}

//TODO:sorting out data to Map data type from here.
//I CAN HAVE A CONTROLLER THAT CAN DO THE WORK OF MAKING AVAILABLE THE DATAS NEEDED
//I WOULD HAVE SORTED OUT ALL THE DATA NEEDED TO BE ASSIGNED TO THE MAP FROM THIS LAYER.


//FROM THIS POINT IT WILL REQUIRES THAT I SORTED THE MAP TYPE BY
//1. HAVING THE LAST SCROLL POSITION IN THE MAP WITH THE 
//2. VIDEO DATA: BASICALLY THE VIDEO URL AND THE LAST SAVED DURATION.
