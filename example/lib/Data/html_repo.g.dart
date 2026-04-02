// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'html_repo.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(repo)
const repoProvider = RepoProvider._();

final class RepoProvider
    extends $FunctionalProvider<HtmlRepo, HtmlRepo, HtmlRepo>
    with $Provider<HtmlRepo> {
  const RepoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'repoProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$repoHash();

  @$internal
  @override
  $ProviderElement<HtmlRepo> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  HtmlRepo create(Ref ref) {
    return repo(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(HtmlRepo value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<HtmlRepo>(value),
    );
  }
}

String _$repoHash() => r'bad87c616ca92f60aa2b252e6013385dc1da35f3';
