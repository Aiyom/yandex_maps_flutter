import 'package:yandex_maps_mapkit_lite/mapkit.dart';

final class ClusterTapListenerImpl implements ClusterTapListener {
  final bool Function(Cluster) onClusterTapCallback;

  const ClusterTapListenerImpl({required this.onClusterTapCallback});

  @override
  bool onClusterTap(Cluster cluster) => onClusterTapCallback(cluster);
}