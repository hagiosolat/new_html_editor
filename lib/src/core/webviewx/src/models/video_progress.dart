///[VideoProgressTracking] a model class to get the current duration and total duration of a particular video
class VideoProgressTracking {
  /// [totalDuration] the video duration
  dynamic totalDuration;

  /// [currentPosition] the video current Position
  dynamic currentPosition;

  /// [videoUrl] the video link value
  dynamic videoUrl;

  ///[VideoProgressTracking.fromJson] extension method to get the duration and the currentPosition model from Json
  VideoProgressTracking.fromJson(Map<String, dynamic> json) {
    totalDuration = json['totalDuration'];
    currentPosition = json['currentPosition'];
    videoUrl = json['videoUrl'];
  }
}
