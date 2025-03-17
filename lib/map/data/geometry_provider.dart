import 'package:yandex_maps_mapkit_lite/mapkit.dart';

final class GeometryProvider {
  /// Определяет начальную позицию камеры
  static CameraPosition getStartPosition(List hotels, bool isHotel) {
    final latitudes = hotels
        .where((hotel) => !isHotel
        ? hotel['latitude'] != null
        : hotel['hotel'] != null && hotel['hotel']['latitude'] != null)
        .map((hotel) => double.tryParse(!isHotel
        ? hotel['latitude'].toString()
        : hotel['hotel']['latitude'].toString())
         ?? 0.0)
        .toList();

    final longitudes = hotels
        .where((hotel) => !isHotel
        ? hotel['longitude'] != null
        : hotel['hotel'] != null && hotel['hotel']['longitude'] != null)
        .map((hotel) => double.tryParse(!isHotel
        ? hotel['longitude'].toString()
        : hotel['hotel']['longitude'].toString())
        ?? 0.0)
        .toList();
    final avgLat = latitudes.reduce((a, b) => a + b) / latitudes.length;
    final avgLon = longitudes.reduce((a, b) => a + b) / longitudes.length;

    final center = Point(latitude: avgLat, longitude: avgLon);
    return CameraPosition(
            center,
            zoom: 8.5, // Установите подходящий уровень зума
            azimuth: 0.0,
            tilt: 0.0,
          );
  }
  // static CameraPosition getStartPosition(List results) {
  //   final points = getPointsToMap(results);
  //
  //   // Расчет BoundingBox
  //   final boundingBox = getBoundingBox(points);
  //
  //   // Центрируем камеру на среднюю точку границ
  //   final center = Point(
  //     latitude: (boundingBox.southWest.latitude + boundingBox.northEast.latitude) / 2,
  //     longitude: (boundingBox.southWest.longitude + boundingBox.northEast.longitude) / 2,
  //   );
  //
  //   return CameraPosition(
  //     center,
  //     zoom: 8.0, // Установите подходящий уровень зума
  //     azimuth: 0.0,
  //     tilt: 0.0,
  //   );
  // }

  /// Преобразует данные в список точек
  static List<Point> getPointsToMap(List results) {
    return results
        .where((point) => point['latitude'] != null && point['longitude'] != null)
        .map((point) => Point(
      latitude: point['latitude'],
      longitude: point['longitude'],
    ))
        .toList();
  }

  /// Рассчитывает границы, чтобы охватить все точки
  static BoundingBox getBoundingBox(List<Point> points) {
    double minLat = points.first.latitude;
    double maxLat = points.first.latitude;
    double minLon = points.first.longitude;
    double maxLon = points.first.longitude;

    for (final point in points) {
      if (point.latitude < minLat) minLat = point.latitude;
      if (point.latitude > maxLat) maxLat = point.latitude;
      if (point.longitude < minLon) minLon = point.longitude;
      if (point.longitude > maxLon) maxLon = point.longitude;
    }

    return BoundingBox(
      Point(latitude: minLat, longitude: minLon),
      Point(latitude: maxLat, longitude: maxLon),
    );
  }
}
