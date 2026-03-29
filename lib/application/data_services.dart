import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:new_html_editor/data/html_repo.dart';
part 'data_services.g.dart';

@riverpod
Map<String, double?> dataServices(Ref ref, int index) {
  final params = <String, double?>{};
  final data = ref.watch(repoProvider).getHtmlList();

  if (data[index].videos.isNotEmpty) {
    for (final video in data[index].videos) {
      final url = video.videoUrl;
      if (url == null) continue;

      if (kIsWeb && url.contains('youtube')) {
        params['$url?enablejsapi=1'] = video.savedDuration;
      } else {
        params[url] = video.savedDuration;
      }
    }
  }
  return params;
}

@riverpod
Map<String, double?> mobileDataServices(Ref ref, int index) {
  final params = <String, double?>{};
  final data = ref.watch(repoProvider).getHtmlList();

  if (data[index].videos.isNotEmpty) {
    params['scrollPosition'] = data[index].scrollProgress;

    for (final video in data[index].videos) {
      final url = video.videoUrl;
      if (url == null) continue;

      if (url.contains('youtube')) {
        params['$url?enablejsapi=1'] = video.savedDuration;
      } else {
        params[url] = video.savedDuration;
      }
    }
  }
  return params;
}

@riverpod
int videoTotalDuration(Ref ref, int index) {
  // this one is fine — int return type
  final data = ref.watch(repoProvider).getHtmlList();
  final totalDuration = data[index].videosTotalDuration?.toInt();
  return totalDuration ?? 0;
}

@riverpod
Map<String, double?> getVideoDurations(Ref ref, int index) {
  final params = <String, double?>{};
  final data = ref.watch(repoProvider).getHtmlList();

  if (data[index].videos.isNotEmpty) {
    for (final video in data[index].videos) {
      final url = video.videoUrl;
      if (url == null) continue;

      if (kIsWeb && url.contains('youtube')) {
        params['$url?enablejsapi=1'] = video.videoDuration;
      } else {
        params[url] = video.videoDuration;
      }
    }
  }
  return params;
}
