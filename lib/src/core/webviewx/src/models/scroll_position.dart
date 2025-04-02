///[CustomScrollPosition] a model class for position scrolling of the web
class CustomScrollPosition {
  /// [scrollTop] the scrollTop length
  dynamic scrollTop;

  /// [currentPosition] the current Position in the web scrolling
  dynamic currentPosition;

  /// [maxScroll] the maxScroll Length
  dynamic maxScroll;

  ///[ScrollPosition.fromJson] extension method to get the scrollTop and the currentPosition model from json
  CustomScrollPosition.fromJson(Map<String, dynamic> json) {
    scrollTop = json['scrollTop'];
    currentPosition = json['currentScrollPosition'];
    maxScroll = json['maxScroll'];
  }
}
