// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';

class HtmlData extends Equatable {
  final String? articleIcon;
  final String? articleData;
  final String? title;
  final int? videosTotalDuration;
  const HtmlData({
    this.articleIcon,
    this.articleData,
    this.title,
    this.videosTotalDuration,
  });
  @override
  List<Object?> get props =>
      [articleIcon, articleData, title, videosTotalDuration];
}

class HtmlFullContent extends Equatable {
  final List<HtmlData> htmlContents;
  final int? videosTotalDuration;
  const HtmlFullContent({
    required this.htmlContents,
    this.videosTotalDuration,
  });

  @override
  List<Object?> get props => [htmlContents, videosTotalDuration];
}
