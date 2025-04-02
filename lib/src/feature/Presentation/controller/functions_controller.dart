import 'package:new_html_editor/src/feature/Data/editor_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'functions_controller.g.dart';

//(keepAlive:true)
@riverpod
class EditorController extends _$EditorController {
  // static SendPort? _isolateSendPort;
  @override
  FutureOr<String> build() {
    return getJsFunctions();
  }

  FutureOr<String> getJsFunctions() async {
    final functions = ref.read(editorRepositoryProvider);
    state = const AsyncLoading();
    state = await AsyncValue.guard(functions.getJavaScriptFunctions);
    return state.value!;
  }

  // FutureOr<void> startIsolateAndLoadHtml(Map<String, dynamic> params) async {
  //   state = const AsyncLoading();
  //   final repository =
  //       await ref.read(editorRepositoryProvider).getJavaScriptFunctions();
  // //  print('This is the repository to be gotten $repository');

  //   if (_isolateSendPort == null) {
  //     final ReceivePort receivePort = ReceivePort();
  //     await Isolate.spawn(ref.read(editorRepositoryProvider).loadHtmlContent,
  //         receivePort.sendPort);
  //     _isolateSendPort = await receivePort.first;
  //   }
  //   final responsePort = ReceivePort();
  //   _isolateSendPort?.send({
  //     'fontFamily': params['fontFamily'],
  //     'backgroundColor': params['backgroundColor'],
  //     'encodedStyle': params['encodedStyle'],
  //     'hintTextPadding': params['hintTextPadding'],
  //     'hintTextStyle': params['hintTextStyle'],
  //     'hintText': params['hintText'],
  //     'textStyle': params['textStyle'],
  //     'isEnabled': params['isEnabled'],
  //     'hintTextAlign': params['hintTextAlign'],
  //     'inputAction': params['inputAction'],
  //     'minHeight': params['minHeight'],
  //     'padding': params['padding'],
  //     'script': repository,
  //     'responsePort': responsePort.sendPort,
  //   });
  //   //   final completer = Completer<String>();

  //   // responsePort.listen((htmlContent) {
  //   //   if (!completer.isCompleted) {
  //   //     completer.complete(htmlContent);
  //   //   }
  //   // });
  //   String databack = await responsePort.first;
  // //  print('This is the data from the back $databack');
  //   state = AsyncValue.data(databack);
  //   //  state = AsyncValue.data(await completer.future);
  //   //  print('gggggutfrtseresresdttfyuyguvtyytrd ${state.value}');
  //   //  return state.value!;
  //   print('This is the emitted data from the controller ${state.value}');
  // }
}
