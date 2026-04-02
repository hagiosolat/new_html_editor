// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'editor_repository.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(editorRepository)
const editorRepositoryProvider = EditorRepositoryProvider._();

final class EditorRepositoryProvider
    extends
        $FunctionalProvider<
          EditorRepository,
          EditorRepository,
          EditorRepository
        >
    with $Provider<EditorRepository> {
  const EditorRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'editorRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$editorRepositoryHash();

  @$internal
  @override
  $ProviderElement<EditorRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  EditorRepository create(Ref ref) {
    return editorRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(EditorRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<EditorRepository>(value),
    );
  }
}

String _$editorRepositoryHash() => r'bab1506c3eb68ff573b110f78f197ffbbcdf2c03';
