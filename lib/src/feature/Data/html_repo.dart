import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_html_editor/src/feature/Data/dummydata.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:new_html_editor/src/feature/Domain/html_data_model.dart';

part 'html_repo.g.dart';

class HtmlRepo {
  const HtmlRepo();

  List<HtmlData> getHtmlList() {
    //FUNCTION TO ACCESS FIREBASE TO GET THE ARTICLES
    return content;
  }

  Future<void> updateCurrentVideoPosition({
    required String articleID,
    required String videoUrl,
    required num currentPosition,
  }) async {
    //I CAN CHECK THE INDEX WHERE THE VIDEOURL IS EQUAL TO THE ONE IN THE LIST OF THE
    //AVAILABLE VIDEOS, THEN UPDATE THE CURRENTPOSITION PROPERTY OF THE PARTICULAR VIDEO
  }

  Future<void> updateTotalProgress(Map<String, dynamic> articleProgress) async {
    // print('This is the current article Progress $articleProgress');
  }

  Future<void> updateScrollProgress(num readProgress) async {
    //  print('This is the current Scroll Progress $readProgress');
  }

  ///
  //API to update the content at the frontend
  ///especially updating the video duration when video is being uploaded for video thumbnail.
  ///this is to update the video total duration so as to make progress accurate and consistent.

  //This is still the get and set function.
  /*{“videos” : [ {videoUrl1: {image: thumbnailUrl1, duration:duration1, savedDuration: lastSavedDuration1}},
    {videoUrl2 : {image: thumbnailUrl2, duration:duration2, savedDuration: lastSavedDuration2}},
    {videoUrl3 : {image: thumbnailUrl3, duration:duration3, savedDuration: lastSavedDuration3 }},
    {videoUrl4 : {image: thumbnailUrl4, duration:duration4, savedDuration: lastSavedDuration4}},
], 
   “totalduration”: totalduration,
   “lastSCrollposition”: lastSCrollposition,
}*/

  ///API to save the videos with their video current position.
  /// That would be gotten in real-time.
}

@riverpod
HtmlRepo repo(Ref ref) => HtmlRepo();
