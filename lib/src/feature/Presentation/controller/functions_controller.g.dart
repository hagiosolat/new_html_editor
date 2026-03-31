// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'functions_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(EditorController)
const editorControllerProvider = EditorControllerProvider._();

final class EditorControllerProvider
    extends $AsyncNotifierProvider<EditorController, String> {
  const EditorControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editorControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editorControllerHash();

  @$internal
  @override
  EditorController create() => EditorController();
}

String _$editorControllerHash() => r'4111fd7178c046f32e2e73f3aee34907eade8dd8';

abstract class _$EditorController extends $AsyncNotifier<String> {
  FutureOr<String> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<String>, String>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<String>, String>,
              AsyncValue<String>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
