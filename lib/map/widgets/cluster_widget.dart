// Расчёт расстояния между двумя точками
import 'dart:math';

import 'package:flutter/material.dart';

double haversineDistance({
  required double lat1,
  required double lon1,
  required double lat2,
  required double lon2,
}) {
  const earthRadius = 6371; // Радиус Земли в километрах

  final dLat = radians(lat2 - lat1);
  final dLon = radians(lon2 - lon1);

  final a = sin(dLat / 2) * sin(dLat / 2) +
      cos(radians(lat1)) * cos(radians(lat2)) *
          sin(dLon / 2) * sin(dLon / 2);

  final c = 2 * atan2(sqrt(a), sqrt(1 - a));

  return earthRadius * c * 1000; // Возвращаем расстояние в метрах
}

double radians(double degrees) => degrees * pi / 180;

List groupHotelsByProximity({
  required List hotels,
  double radius = 1000, // Радиус в метрах
}) {
  final clusters = <List<Map<String, dynamic>>>[];
  final visited = <int>{};

  for (int i = 0; i < hotels.length; i++) {
    if (visited.contains(i)) continue;

    final cluster = <Map<String, dynamic>>[];
    final queue = [i];

    while (queue.isNotEmpty) {
      final currentIndex = queue.removeLast();

      if (visited.contains(currentIndex)) continue;
      visited.add(currentIndex);

      final currentHotel = hotels[currentIndex];
      cluster.add(currentHotel);

      for (int j = 0; j < hotels.length; j++) {
        if (visited.contains(j)) continue;

        final otherHotel = hotels[j];
        final distance = haversineDistance(
          lat1: currentHotel['latitude'] as double,
          lon1: currentHotel['longitude'] as double,
          lat2: otherHotel['latitude'] as double,
          lon2: otherHotel['longitude'] as double,
        );

        if (distance <= radius) {
          queue.add(j);
        }
      }
    }

    clusters.add(cluster);
  }

  return clusters;
}

// Виджет для отображения кластера
class ClusterWidget extends StatelessWidget {
  final List placemarkData;
  final bool showDetails; // Контролирует, отображать только количество или полный список

  const ClusterWidget({
    super.key,
    required this.placemarkData,
    required this.showDetails,
  });

  @override
  Widget build(BuildContext context) {
    if (!showDetails) {
      // Только число, если showDetails = false
      return Container(
        width: 50,
        height: 50,
        decoration: const BoxDecoration(
          color: const Color(0xFF5CD8D2),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Text(
          "${placemarkData.length}",
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
    }
    else {
      // Показываем список отелей, если showDetails = true
      return Container();
      //     decoration: BoxDecoration(
      //       color: Colors.white,
      //       border: Border.all(color: const Color(0xFF5CD8D2)),
      //       borderRadius: const BorderRadius.all(Radius.circular(12.0)),
      //     ),
      //     padding: const EdgeInsets.all(8.0),
      //     child: Column(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: placemarkData.map((hotel) {
      //         final name = "${hotel['tour_price']} - ${hotel['hotel_name']}" ?? "Unknown Hotel";
      //         return Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text(name),
      //           ],
      //         );
      //       }).toList(),
      //     ),
      //   );
    }
  }
}
