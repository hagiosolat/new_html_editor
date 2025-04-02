///[SelectionModel] a model class for selection range
class SelectionModel {
  /// [index] index of the cursor
  int? index;

  ///[length] length of the selected value
  int? length;

  ///[SelectionModel] a model class constructor for selection range
  SelectionModel({this.index, this.length});

  ///[SelectionModel.fromJson] extension method to get selection model from json
  SelectionModel.fromJson(Map<String, dynamic> json) {
    index = json['index'];
    length = json['length'];
  }
}
