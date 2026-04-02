// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'data_services.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
///THE SERVICE CLASS IS TO GET THE AVAILABLE VIDEOS AND THE LAST SAVED DURATION
///TOGETHER WITH THE LAST SAVED SCROLL POSITION.

@ProviderFor(dataServices)
const dataServicesProvider = DataServicesFamily._();

///THE SERVICE CLASS IS TO GET THE AVAILABLE VIDEOS AND THE LAST SAVED DURATION
///TOGETHER WITH THE LAST SAVED SCROLL POSITION.

final class DataServicesProvider
    extends
        $FunctionalProvider<
          Map<String, dynamic>,
          Map<String, dynamic>,
          Map<String, dynamic>
        >
    with $Provider<Map<String, dynamic>> {
  ///THE SERVICE CLASS IS TO GET THE AVAILABLE VIDEOS AND THE LAST SAVED DURATION
  ///TOGETHER WITH THE LAST SAVED SCROLL POSITION.
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
  $ProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, dynamic> create(Ref ref) {
    final argument = this.argument as int;
    return dataServices(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
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

String _$dataServicesHash() => r'8df0933f2150e47c0daeb736c728238a16619b35';

///THE SERVICE CLASS IS TO GET THE AVAILABLE VIDEOS AND THE LAST SAVED DURATION
///TOGETHER WITH THE LAST SAVED SCROLL POSITION.

final class DataServicesFamily extends $Family
    with $FunctionalFamilyOverride<Map<String, dynamic>, int> {
  const DataServicesFamily._()
    : super(
        retry: null,
        name: r'dataServicesProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  ///THE SERVICE CLASS IS TO GET THE AVAILABLE VIDEOS AND THE LAST SAVED DURATION
  ///TOGETHER WITH THE LAST SAVED SCROLL POSITION.

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
          Map<String, dynamic>,
          Map<String, dynamic>,
          Map<String, dynamic>
        >
    with $Provider<Map<String, dynamic>> {
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
  $ProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, dynamic> create(Ref ref) {
    final argument = this.argument as int;
    return mobileDataServices(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
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
    r'dba528dfd2570868d434c05fd776cd78ab70f012';

final class MobileDataServicesFamily extends $Family
    with $FunctionalFamilyOverride<Map<String, dynamic>, int> {
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
    r'35e0c191894d88ca286785e599e578ad752f300d';

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
          Map<String, dynamic>,
          Map<String, dynamic>,
          Map<String, dynamic>
        >
    with $Provider<Map<String, dynamic>> {
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
  $ProviderElement<Map<String, dynamic>> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  Map<String, dynamic> create(Ref ref) {
    final argument = this.argument as int;
    return getVideoDurations(ref, argument);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
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

String _$getVideoDurationsHash() => r'7e13b2436d2450d83a4f001b098f9572aa22df17';

final class GetVideoDurationsFamily extends $Family
    with $FunctionalFamilyOverride<Map<String, dynamic>, int> {
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
