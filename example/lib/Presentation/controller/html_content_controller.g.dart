// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'html_content_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(HtmlContentController)
const htmlContentControllerProvider = HtmlContentControllerProvider._();

final class HtmlContentControllerProvider
    extends $NotifierProvider<HtmlContentController, List<HtmlData>> {
  const HtmlContentControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'htmlContentControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$htmlContentControllerHash();

  @$internal
  @override
  HtmlContentController create() => HtmlContentController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<HtmlData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<HtmlData>>(value),
    );
  }
}

String _$htmlContentControllerHash() =>
    r'54be7ef785f763a176f4632400cb70180988b058';

abstract class _$HtmlContentController extends $Notifier<List<HtmlData>> {
  List<HtmlData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<HtmlData>, List<HtmlData>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<HtmlData>, List<HtmlData>>,
              List<HtmlData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(ParamsUpateController)
const paramsUpateControllerProvider = ParamsUpateControllerProvider._();

final class ParamsUpateControllerProvider
    extends $AsyncNotifierProvider<ParamsUpateController, void> {
  const ParamsUpateControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'paramsUpateControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$paramsUpateControllerHash();

  @$internal
  @override
  ParamsUpateController create() => ParamsUpateController();
}

String _$paramsUpateControllerHash() =>
    r'ee1c0458a6cd19b41a5d5a1ff446cb758ae3686f';

abstract class _$ParamsUpateController extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}

@ProviderFor(SaveProgress)
const saveProgressProvider = SaveProgressProvider._();

final class SaveProgressProvider
    extends $NotifierProvider<SaveProgress, List<HtmlData>> {
  const SaveProgressProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'saveProgressProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$saveProgressHash();

  @$internal
  @override
  SaveProgress create() => SaveProgress();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(List<HtmlData> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<List<HtmlData>>(value),
    );
  }
}

String _$saveProgressHash() => r'a6574b4103a4f4673ba658757972d6bb958a3413';

abstract class _$SaveProgress extends $Notifier<List<HtmlData>> {
  List<HtmlData> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<List<HtmlData>, List<HtmlData>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<List<HtmlData>, List<HtmlData>>,
              List<HtmlData>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
