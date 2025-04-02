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
class HtmlFullContentController extends _$HtmlFullContentController {
  @override
  HtmlFullContent build() {
    return getHtmlFullContent();
  }

  HtmlFullContent getHtmlFullContent() {
    final repo = ref.read(repoProvider).getWholeContent();
    return repo;
  }
}
