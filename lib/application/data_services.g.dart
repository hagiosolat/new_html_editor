// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_services.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(dataServices)
const dataServicesProvider = DataServicesFamily._();

final class DataServicesProvider
    extends
        $FunctionalProvider<
          Map<String, double?>,
          Map<String, double?>,
          Map<String, double?>
        >
    with $Provider<Map<String, double?>> {
  const DataServicesProvider._({
    required DataServicesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'dataServicesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$dataServicesHash();

  @override
  String toString() {
    return r'dataServicesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Map<String, double?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, double?> create(Ref ref) {
    final argument = this.argument as int;
    return dataServices(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, double?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, double?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is DataServicesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$dataServicesHash() => r'1384c26cb63c5158e9743effaf370fc02e6062cd';

final class DataServicesFamily extends $Family
    with $FunctionalFamilyOverride<Map<String, double?>, int> {
  const DataServicesFamily._()
    : super(
        retry: null,
        name: r'dataServicesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  DataServicesProvider call(int index) =>
      DataServicesProvider._(argument: index, from: this);

  @override
  String toString() => r'dataServicesProvider';
}

@ProviderFor(mobileDataServices)
const mobileDataServicesProvider = MobileDataServicesFamily._();

final class MobileDataServicesProvider
    extends
        $FunctionalProvider<
          Map<String, double?>,
          Map<String, double?>,
          Map<String, double?>
        >
    with $Provider<Map<String, double?>> {
  const MobileDataServicesProvider._({
    required MobileDataServicesFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'mobileDataServicesProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$mobileDataServicesHash();

  @override
  String toString() {
    return r'mobileDataServicesProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Map<String, double?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, double?> create(Ref ref) {
    final argument = this.argument as int;
    return mobileDataServices(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, double?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, double?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is MobileDataServicesProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$mobileDataServicesHash() =>
    r'8eaffec2d2bbd5609b5f76396072d8ce46f3ee29';

final class MobileDataServicesFamily extends $Family
    with $FunctionalFamilyOverride<Map<String, double?>, int> {
  const MobileDataServicesFamily._()
    : super(
        retry: null,
        name: r'mobileDataServicesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  MobileDataServicesProvider call(int index) =>
      MobileDataServicesProvider._(argument: index, from: this);

  @override
  String toString() => r'mobileDataServicesProvider';
}

@ProviderFor(videoTotalDuration)
const videoTotalDurationProvider = VideoTotalDurationFamily._();

final class VideoTotalDurationProvider
    extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  const VideoTotalDurationProvider._({
    required VideoTotalDurationFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'videoTotalDurationProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$videoTotalDurationHash();

  @override
  String toString() {
    return r'videoTotalDurationProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    final argument = this.argument as int;
    return videoTotalDuration(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is VideoTotalDurationProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$videoTotalDurationHash() =>
    r'4a0e53841f719e31ae9c97a16694e937d977fced';

final class VideoTotalDurationFamily extends $Family
    with $FunctionalFamilyOverride<int, int> {
  const VideoTotalDurationFamily._()
    : super(
        retry: null,
        name: r'videoTotalDurationProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  VideoTotalDurationProvider call(int index) =>
      VideoTotalDurationProvider._(argument: index, from: this);

  @override
  String toString() => r'videoTotalDurationProvider';
}

@ProviderFor(getVideoDurations)
const getVideoDurationsProvider = GetVideoDurationsFamily._();

final class GetVideoDurationsProvider
    extends
        $FunctionalProvider<
          Map<String, double?>,
          Map<String, double?>,
          Map<String, double?>
        >
    with $Provider<Map<String, double?>> {
  const GetVideoDurationsProvider._({
    required GetVideoDurationsFamily super.from,
    required int super.argument,
  }) : super(
         retry: null,
         name: r'getVideoDurationsProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$getVideoDurationsHash();

  @override
  String toString() {
    return r'getVideoDurationsProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $ProviderElement<Map<String, double?>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, double?> create(Ref ref) {
    final argument = this.argument as int;
    return getVideoDurations(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, double?> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, double?>>(value),
    );
  }

  @override
  bool operator ==(Object other) {
    return other is GetVideoDurationsProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$getVideoDurationsHash() => r'21d40aaa05f522b50d9a3977019e07baebddae14';

final class GetVideoDurationsFamily extends $Family
    with $FunctionalFamilyOverride<Map<String, double?>, int> {
  const GetVideoDurationsFamily._()
    : super(
        retry: null,
        name: r'getVideoDurationsProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  GetVideoDurationsProvider call(int index) =>
      GetVideoDurationsProvider._(argument: index, from: this);

  @override
  String toString() => r'getVideoDurationsProvider';
}
