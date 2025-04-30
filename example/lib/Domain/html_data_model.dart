// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';

class HtmlData extends Equatable {
  final String? articleID;
  final String? articleData;
  final String? title;
  final num? videosTotalDuration;
  final num? totalProgress; //it will scrollPosition, video durations,
  final num? scrollProgress;
  //This could be now optional
  //This could become optional
  final List<Video>? videos;
  const HtmlData({
    this.articleID,
    this.articleData,
    this.title,
    this.videosTotalDuration,
    this.totalProgress,
    this.scrollProgress,
    this.videos,
  });
  @override
  List<Object?> get props => [
    articleID,
    articleData,
    title,
    videosTotalDuration,
    totalProgress,
    scrollProgress,
    videos,
  ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'articleID': articleID,
      'articleData': articleData,
      'title': title,
      'videosTotalDuration': videosTotalDuration,
      'totalProgress': totalProgress,
      'scrollProgress': scrollProgress,
      'videos': videos?.map((x) => x.toMap()).toList(),
    };
  }

  factory HtmlData.fromMap(Map<String, dynamic> map) {
    return HtmlData(
      articleID: map['articleID'] != null ? map['articleID'] as String : null,
      articleData:
          map['articleData'] != null ? map['articleData'] as String : null,
      title: map['title'] != null ? map['title'] as String : null,
      videosTotalDuration:
          map['videosTotalDuration'] != null
              ? map['videosTotalDuration'] as num
              : null,
      totalProgress:
          map['totalProgress'] != null ? map['totalProgress'] as num : null,
      scrollProgress:
          map['scrollProgress'] != null ? map['scrollProgress'] as num : null,
      videos:
          map['videos'] != null
              ? List<Video>.from(
                (map['videos'] as List<int>).map<Video?>(
                  (x) => Video.fromMap(x as Map<String, dynamic>),
                ),
              )
              : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory HtmlData.fromJson(String source) =>
      HtmlData.fromMap(json.decode(source) as Map<String, dynamic>);
}

class Video extends Equatable {
  final String? videoUrl;
  final String? thumbnailUrl;
  final num? videoDuration;
  final num? savedDuration;

  const Video({
    this.videoUrl,
    this.thumbnailUrl,
    this.savedDuration,
    this.videoDuration,
  });

  @override
  List<Object?> get props => [
    videoUrl,
    thumbnailUrl,
    savedDuration,
    videoDuration,
  ];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'videoUrl': videoUrl,
      'thumbnailUrl': thumbnailUrl,
      'savedDuration': savedDuration,
      'videoDuration': videoDuration,
    };
  }

  factory Video.fromMap(Map<String, dynamic> map) {
    return Video(
      videoUrl: map['videoUrl'] != null ? map['videoUrl'] as String : null,
      thumbnailUrl:
          map['thumbnailUrl'] != null ? map['thumbnailUrl'] as String : null,
      savedDuration:
          map['savedDuration'] != null ? map['savedDuration'] as num : null,
      videoDuration:
          map['videoDuration'] != null ? map['videoDuration'] as num : null,
    );
  }

  String toJson() => json.encode(toMap());

  factory Video.fromJson(String source) =>
      Video.fromMap(json.decode(source) as Map<String, dynamic>);
}
