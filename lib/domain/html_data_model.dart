// import 'dart:convert';

// class MyHtmlData {
//   final String? articleID;
//   final String? articleData;
//   final String? title;
//   final double? videosTotalDuration;
//   final double? totalProgress;
//   final double? scrollProgress;
//   final List<Video> videos;

//   const MyHtmlData({
//     this.articleID,
//     this.articleData,
//     this.title,
//     this.videosTotalDuration,
//     this.totalProgress,
//     this.scrollProgress,
//     this.videos = const [],
//   });

//   Map<String, Object?> toMap() {
//     return {
//       'articleID': articleID,
//       'articleData': articleData,
//       'title': title,
//       'videosTotalDuration': videosTotalDuration,
//       'totalProgress': totalProgress,
//       'scrollProgress': scrollProgress,
//       'videos': videos.map((x) => x.toMap()).toList(),
//     };
//   }

//   factory MyHtmlData.fromMap(Map<String, Object?> map) {
//     return MyHtmlData(
//       articleID: map['articleID'] as String?,
//       articleData: map['articleData'] as String?,
//       title: map['title'] as String?,
//       videosTotalDuration: (map['videosTotalDuration'] as num?)?.toDouble(),
//       totalProgress: (map['totalProgress'] as num?)?.toDouble(),
//       scrollProgress: (map['scrollProgress'] as num?)?.toDouble(),
//       videos:
//           map['videos'] != null
//               ? List<Video>.from(
//                 (map['videos'] as List).map(
//                   (x) => Video.fromMap(x as Map<String, Object?>),
//                 ),
//               )
//               : [],
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory MyHtmlData.fromJson(String source) =>
//       MyHtmlData.fromMap(json.decode(source) as Map<String, Object?>);
// }

class HtmlData {
  final String? articleID;
  final String? articleData;
  final String? title;
  final int? videosTotalDuration;
  final double? totalProgress;
  final double? scrollProgress;
  final List<Video> videos;

  const HtmlData({
    this.articleID,
    this.articleData,
    this.title,
    this.videosTotalDuration,
    this.totalProgress,
    this.scrollProgress,
    this.videos = const [],
  });

  factory HtmlData.fromMap(Map<String, dynamic> map) {
    return HtmlData(
      articleID: map['articleID'] as String?,
      articleData: map['articleData'] as String?,
      title: map['title'] as String?,
      videosTotalDuration: map['videosTotalDuration'] as int?,
      totalProgress: (map['totalProgress'] as num?)?.toDouble(),
      scrollProgress: (map['scrollProgress'] as num?)?.toDouble(),
      videos:
          (map['videos'] as List<dynamic>? ?? [])
              .map((x) => Video.fromMap(x as Map<String, dynamic>))
              .toList(),
    );
  }
}

// class Video {
//   final String? videoUrl;
//   final String? thumbnailUrl;
//   final double? videoDuration;
//   final double? savedDuration;

//   const Video({
//     this.videoUrl,
//     this.thumbnailUrl,
//     this.savedDuration,
//     this.videoDuration,
//   });

//   Map<String, Object?> toMap() {
//     return {
//       'videoUrl': videoUrl,
//       'thumbnailUrl': thumbnailUrl,
//       'savedDuration': savedDuration,
//       'videoDuration': videoDuration,
//     };
//   }

//   factory Video.fromMap(Map<String, Object?> map) {
//     return Video(
//       videoUrl: map['videoUrl'] as String?,
//       thumbnailUrl: map['thumbnailUrl'] as String?,
//       savedDuration: (map['savedDuration'] as num?)?.toDouble(),
//       videoDuration: (map['videoDuration'] as num?)?.toDouble(),
//     );
//   }

//   String toJson() => json.encode(toMap());

//   factory Video.fromJson(String source) =>
//       Video.fromMap(json.decode(source) as Map<String, Object?>);
// }

class Video {
  final String? videoUrl;
  final int? videoDuration;
  final double? savedDuration;

  const Video({this.videoUrl, this.videoDuration, this.savedDuration});

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      videoUrl: map['videoUrl'] as String?,
      videoDuration: (map['videoDuration'] as int?),
      savedDuration: (map['savedDuration'] as num?)?.toDouble(),
    );
  }
}
