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
    r'0d125d414826a9118554e3cffe2a6e980e62b173';

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
    extends $NotifierProvider<ParamsUpateController, void> {
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

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$paramsUpateControllerHash() =>
    r'd04d7ce198ad6e04c3bca5cf2cb5d95355d4fd36';

abstract class _$ParamsUpateController extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
