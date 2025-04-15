// ignore_for_file: public_member_api_docs, sort_constructors_first
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
}

class Video extends Equatable {
  final String? videoUrl;
  final String? thumbnailUrl;
  final num? savedDuration;

  const Video({this.videoUrl, this.thumbnailUrl, this.savedDuration});

  @override
  List<Object?> get props => [videoUrl, thumbnailUrl, savedDuration];
}
