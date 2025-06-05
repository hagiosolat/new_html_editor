// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_services.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$dataServicesHash() => r'8df0933f2150e47c0daeb736c728238a16619b35';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

///THE SERVICE CLASS IS TO GET THE AVAILABLE VIDEOS AND THE LAST SAVED DURATION
///TOGETHER WITH THE LAST SAVED SCROLL POSITION.
///
/// Copied from [dataServices].
@ProviderFor(dataServices)
const dataServicesProvider = DataServicesFamily();

///THE SERVICE CLASS IS TO GET THE AVAILABLE VIDEOS AND THE LAST SAVED DURATION
///TOGETHER WITH THE LAST SAVED SCROLL POSITION.
///
/// Copied from [dataServices].
class DataServicesFamily extends Family<Map<String, dynamic>> {
  ///THE SERVICE CLASS IS TO GET THE AVAILABLE VIDEOS AND THE LAST SAVED DURATION
  ///TOGETHER WITH THE LAST SAVED SCROLL POSITION.
  ///
  /// Copied from [dataServices].
  const DataServicesFamily();

  ///THE SERVICE CLASS IS TO GET THE AVAILABLE VIDEOS AND THE LAST SAVED DURATION
  ///TOGETHER WITH THE LAST SAVED SCROLL POSITION.
  ///
  /// Copied from [dataServices].
  DataServicesProvider call(int index) {
    return DataServicesProvider(index);
  }

  @override
  DataServicesProvider getProviderOverride(
    covariant DataServicesProvider provider,
  ) {
    return call(provider.index);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'dataServicesProvider';
}

///THE SERVICE CLASS IS TO GET THE AVAILABLE VIDEOS AND THE LAST SAVED DURATION
///TOGETHER WITH THE LAST SAVED SCROLL POSITION.
///
/// Copied from [dataServices].
class DataServicesProvider extends AutoDisposeProvider<Map<String, dynamic>> {
  ///THE SERVICE CLASS IS TO GET THE AVAILABLE VIDEOS AND THE LAST SAVED DURATION
  ///TOGETHER WITH THE LAST SAVED SCROLL POSITION.
  ///
  /// Copied from [dataServices].
  DataServicesProvider(int index)
    : this._internal(
        (ref) => dataServices(ref as DataServicesRef, index),
        from: dataServicesProvider,
        name: r'dataServicesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$dataServicesHash,
        dependencies: DataServicesFamily._dependencies,
        allTransitiveDependencies:
            DataServicesFamily._allTransitiveDependencies,
        index: index,
      );

  DataServicesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.index,
  }) : super.internal();

  final int index;

  @override
  Override overrideWith(
    Map<String, dynamic> Function(DataServicesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: DataServicesProvider._internal(
        (ref) => create(ref as DataServicesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        index: index,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Map<String, dynamic>> createElement() {
    return _DataServicesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is DataServicesProvider && other.index == index;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, index.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin DataServicesRef on AutoDisposeProviderRef<Map<String, dynamic>> {
  /// The parameter `index` of this provider.
  int get index;
}

class _DataServicesProviderElement
    extends AutoDisposeProviderElement<Map<String, dynamic>>
    with DataServicesRef {
  _DataServicesProviderElement(super.provider);

  @override
  int get index => (origin as DataServicesProvider).index;
}

String _$mobileDataServicesHash() =>
    r'e2133598866ff3b454cb12a727ab0de802c96f21';

/// See also [mobileDataServices].
@ProviderFor(mobileDataServices)
const mobileDataServicesProvider = MobileDataServicesFamily();

/// See also [mobileDataServices].
class MobileDataServicesFamily extends Family<Map<String, dynamic>> {
  /// See also [mobileDataServices].
  const MobileDataServicesFamily();

  /// See also [mobileDataServices].
  MobileDataServicesProvider call(int index) {
    return MobileDataServicesProvider(index);
  }

  @override
  MobileDataServicesProvider getProviderOverride(
    covariant MobileDataServicesProvider provider,
  ) {
    return call(provider.index);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'mobileDataServicesProvider';
}

/// See also [mobileDataServices].
class MobileDataServicesProvider
    extends AutoDisposeProvider<Map<String, dynamic>> {
  /// See also [mobileDataServices].
  MobileDataServicesProvider(int index)
    : this._internal(
        (ref) => mobileDataServices(ref as MobileDataServicesRef, index),
        from: mobileDataServicesProvider,
        name: r'mobileDataServicesProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$mobileDataServicesHash,
        dependencies: MobileDataServicesFamily._dependencies,
        allTransitiveDependencies:
            MobileDataServicesFamily._allTransitiveDependencies,
        index: index,
      );

  MobileDataServicesProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.index,
  }) : super.internal();

  final int index;

  @override
  Override overrideWith(
    Map<String, dynamic> Function(MobileDataServicesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: MobileDataServicesProvider._internal(
        (ref) => create(ref as MobileDataServicesRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        index: index,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Map<String, dynamic>> createElement() {
    return _MobileDataServicesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MobileDataServicesProvider && other.index == index;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, index.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MobileDataServicesRef on AutoDisposeProviderRef<Map<String, dynamic>> {
  /// The parameter `index` of this provider.
  int get index;
}

class _MobileDataServicesProviderElement
    extends AutoDisposeProviderElement<Map<String, dynamic>>
    with MobileDataServicesRef {
  _MobileDataServicesProviderElement(super.provider);

  @override
  int get index => (origin as MobileDataServicesProvider).index;
}

String _$videoTotalDurationHash() =>
    r'4a0e53841f719e31ae9c97a16694e937d977fced';

/// See also [videoTotalDuration].
@ProviderFor(videoTotalDuration)
const videoTotalDurationProvider = VideoTotalDurationFamily();

/// See also [videoTotalDuration].
class VideoTotalDurationFamily extends Family<int> {
  /// See also [videoTotalDuration].
  const VideoTotalDurationFamily();

  /// See also [videoTotalDuration].
  VideoTotalDurationProvider call(int index) {
    return VideoTotalDurationProvider(index);
  }

  @override
  VideoTotalDurationProvider getProviderOverride(
    covariant VideoTotalDurationProvider provider,
  ) {
    return call(provider.index);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'videoTotalDurationProvider';
}

/// See also [videoTotalDuration].
class VideoTotalDurationProvider extends AutoDisposeProvider<int> {
  /// See also [videoTotalDuration].
  VideoTotalDurationProvider(int index)
    : this._internal(
        (ref) => videoTotalDuration(ref as VideoTotalDurationRef, index),
        from: videoTotalDurationProvider,
        name: r'videoTotalDurationProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$videoTotalDurationHash,
        dependencies: VideoTotalDurationFamily._dependencies,
        allTransitiveDependencies:
            VideoTotalDurationFamily._allTransitiveDependencies,
        index: index,
      );

  VideoTotalDurationProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.index,
  }) : super.internal();

  final int index;

  @override
  Override overrideWith(int Function(VideoTotalDurationRef provider) create) {
    return ProviderOverride(
      origin: this,
      override: VideoTotalDurationProvider._internal(
        (ref) => create(ref as VideoTotalDurationRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        index: index,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<int> createElement() {
    return _VideoTotalDurationProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is VideoTotalDurationProvider && other.index == index;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, index.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin VideoTotalDurationRef on AutoDisposeProviderRef<int> {
  /// The parameter `index` of this provider.
  int get index;
}

class _VideoTotalDurationProviderElement extends AutoDisposeProviderElement<int>
    with VideoTotalDurationRef {
  _VideoTotalDurationProviderElement(super.provider);

  @override
  int get index => (origin as VideoTotalDurationProvider).index;
}

String _$getVideoDurationsHash() => r'7e13b2436d2450d83a4f001b098f9572aa22df17';

/// See also [getVideoDurations].
@ProviderFor(getVideoDurations)
const getVideoDurationsProvider = GetVideoDurationsFamily();

/// See also [getVideoDurations].
class GetVideoDurationsFamily extends Family<Map<String, dynamic>> {
  /// See also [getVideoDurations].
  const GetVideoDurationsFamily();

  /// See also [getVideoDurations].
  GetVideoDurationsProvider call(int index) {
    return GetVideoDurationsProvider(index);
  }

  @override
  GetVideoDurationsProvider getProviderOverride(
    covariant GetVideoDurationsProvider provider,
  ) {
    return call(provider.index);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getVideoDurationsProvider';
}

/// See also [getVideoDurations].
class GetVideoDurationsProvider
    extends AutoDisposeProvider<Map<String, dynamic>> {
  /// See also [getVideoDurations].
  GetVideoDurationsProvider(int index)
    : this._internal(
        (ref) => getVideoDurations(ref as GetVideoDurationsRef, index),
        from: getVideoDurationsProvider,
        name: r'getVideoDurationsProvider',
        debugGetCreateSourceHash:
            const bool.fromEnvironment('dart.vm.product')
                ? null
                : _$getVideoDurationsHash,
        dependencies: GetVideoDurationsFamily._dependencies,
        allTransitiveDependencies:
            GetVideoDurationsFamily._allTransitiveDependencies,
        index: index,
      );

  GetVideoDurationsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.index,
  }) : super.internal();

  final int index;

  @override
  Override overrideWith(
    Map<String, dynamic> Function(GetVideoDurationsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: GetVideoDurationsProvider._internal(
        (ref) => create(ref as GetVideoDurationsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        index: index,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<Map<String, dynamic>> createElement() {
    return _GetVideoDurationsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is GetVideoDurationsProvider && other.index == index;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, index.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin GetVideoDurationsRef on AutoDisposeProviderRef<Map<String, dynamic>> {
  /// The parameter `index` of this provider.
  int get index;
}

class _GetVideoDurationsProviderElement
    extends AutoDisposeProviderElement<Map<String, dynamic>>
    with GetVideoDurationsRef {
  _GetVideoDurationsProviderElement(super.provider);

  @override
  int get index => (origin as GetVideoDurationsProvider).index;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
