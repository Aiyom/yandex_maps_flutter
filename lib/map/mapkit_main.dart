import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as text_style;
import 'package:flutter/rendering.dart';
import 'package:yandex_maps/map/utils/extension_utils.dart';
import 'package:yandex_maps/map/utils/snackbar.dart';
import 'package:yandex_maps/map/widgets/cluster_widget.dart';

import 'package:yandex_maps_mapkit_lite/mapkit.dart' as mapkit;
import 'package:yandex_maps_mapkit_lite/ui_view.dart';
import 'package:yandex_maps_mapkit_lite/mapkit.dart';
import 'package:yandex_maps_mapkit_lite/image.dart' as image_provider;


import 'data/geometry_provider.dart';
import 'listeners/cluster_listener.dart';
import 'listeners/map_object_tap_listener.dart';
import 'listeners/map_size_changed_listener.dart';
import 'map/flutter_map_widget.dart';

class MapkitFlutterApp extends StatefulWidget {
  final List data;
  final bool isHotel;
  final dynamic requestData;
  final bool showButton;

  const MapkitFlutterApp(
      {
        super.key,
        required this.data,
        this.isHotel = false,
        this.requestData,
        this.showButton = true
      });

  @override
  State<MapkitFlutterApp> createState() => _MapkitFlutterAppState();
}

class _MapkitFlutterAppState extends State<MapkitFlutterApp> {
  static const _clusterRadius = 60.0;
  static const _clusterMinZoom = 15;

  final _indexToPlacemarkType = {};

  late final mapkit.MapObjectCollection _mapObjectCollection;
  late final mapkit.ClusterizedPlacemarkCollection _clusterizedCollection;
  late final MapSizeChangedListenerImpl _mapWindowSizeChangedListener;
  late final MapObjectTapListenerImpl _placemarkTapListener;
  late final ClusterListenerImpl _clusterListener;

  @override
  void initState() {
    super.initState();
    // Регистрация слушателя изменения размера карты
    _mapWindowSizeChangedListener = MapSizeChangedListenerImpl(
      onMapWindowSizeChange: (_, __, ___) => _updateFocusRect(),
    );

    // Регистрация слушателя кликов на объекты карты
    _placemarkTapListener = MapObjectTapListenerImpl(
      onMapObjectTapped: (mapObject, _) {
        final hotelData = _indexToPlacemarkType[mapObject.userData];

        if (hotelData != null && widget.showButton) {
          showSnackBar(
              context,
              hotelData,
              widget.isHotel,
              widget.requestData
          );
        }
        return true;
      },
    );

    // Регистрация слушателя для кластеров
    _clusterListener = ClusterListenerImpl(
      onClusterAddedCallback: (cluster) {
        final placemarkData = cluster.placemarks
            .map((placemark) {
              final hotelId = placemark.userData as int?;
              return _indexToPlacemarkType[hotelId];
            })
            .whereType()
            .toList();

        // Определяем уровень детализации отображения
        final currentZoom = _mapWindow?.map.cameraPosition.zoom ?? 0;
        final showDetails = currentZoom > _clusterMinZoom;

        cluster.appearance
          ..setView(
            ViewProvider(
              configurationFactory: (mediaQuery) => ViewConfiguration(
                physicalConstraints: BoxConstraints.tight(mediaQuery.size),
                logicalConstraints: BoxConstraints.tight(mediaQuery.size),
                devicePixelRatio: mediaQuery.devicePixelRatio,
              ),
              builder: () => ClusterWidget(
                placemarkData: placemarkData,
                showDetails: showDetails,
              ),
            ),
          )
          ..zIndex = 100.0;
      },
    );
  }

  mapkit.MapWindow? _mapWindow;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: const IconThemeData(
          color: Colors.white, //change your color here
        ),
        backgroundColor: const Color(0xFF5CD8D2),
        title: const Text(
          'Расположение отели',
          style: text_style.TextStyle(color: Colors.white),
        ),
      ),
      body: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [FlutterMapWidget(onMapCreated: _createMapObjects)],
        ),
      ),
    );
  }

  void _createMapObjects(mapkit.MapWindow mapWindow) {
    _mapWindow = mapWindow;

    // Добавляем слушатель изменения размеров карты
    mapWindow.addSizeChangedListener(_mapWindowSizeChangedListener);

    // Устанавливаем начальную позицию камеры
    mapWindow.map.move(GeometryProvider.getStartPosition(widget.data, widget.isHotel));

    // Создаём коллекцию объектов карты
    _mapObjectCollection = mapWindow.map.mapObjects.addCollection();

    // Создаём коллекцию кластеризованных объектов
    _clusterizedCollection = _mapObjectCollection
        .addClusterizedPlacemarkCollection(_clusterListener);

    // Добавляем кластеры
    _addClusterizedPlacemarks(_clusterizedCollection);

    // Запускаем кластеризацию сразу после загрузки карты
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _updateClusters();
    });
  }

  void _updateClusters() {
    // Получаем текущий зум карты
    // final currentZoom = _mapWindow?.map.cameraPosition.zoom ?? 0;

    // Инициализируем кластеризацию
    _clusterizedCollection.clusterPlacemarks(
      clusterRadius: _clusterRadius,
      minZoom: _clusterMinZoom,
    );
  }

  void _addClusterizedPlacemarks(
    mapkit.ClusterizedPlacemarkCollection clusterizedCollection,
  ) {
    for (final hotel in widget.data) {
      print('hotel.containsKey=${hotel.containsKey('hotel')}');
      if (hotel['latitude'] != null && hotel['longitude'] != null ||
          hotel['hotel']?['latitude'] != null &&
              hotel['hotel']?['longitude'] != null) {
        print(' hotel=${hotel['latitude']}---${hotel['longitude']}');
        final hotelId =
            !widget.isHotel ? hotel['hotel_id'] : hotel['hid']; //.toInt()
        final latitude = double.tryParse(!widget.isHotel
            ? hotel['latitude'].toString()
            : hotel['hotel']['latitude'].toString())
            ?? 0.0;
        final longitude = double.tryParse(!widget.isHotel
            ? hotel['longitude'].toString()
            : hotel['hotel']['longitude'].toString())
            ?? 0.0;
        final tourPrice = !widget.isHotel
            ? hotel['tour_price']
            : hotel['rates'][0]['daily_prices'][0];
        final hotelName =
            !widget.isHotel ? hotel['hotel_name'] : hotel['hotel']['name'];

        final point = Point(
          latitude: latitude,
          longitude: longitude,
        );
        final imageProvider = image_provider.ImageProvider.fromImageProvider(
          const AssetImage("assets/icons/location.png"),
        );
        print('latitude: $latitude --- longitude: $longitude');
        _clusterizedCollection.addPlacemark()
          ..setIcon(imageProvider)
          ..geometry = point
          ..userData = hotelId
          ..draggable = true
          ..addTapListener(_placemarkTapListener)
          ..setText("$tourPrice ₽ - $hotelName") // Название отеля
          ..setTextStyle(const mapkit.TextStyle(
            size: 14.0,
            color: Colors.white,
            // Цвет текста
            outlineColor: const Color(0xFF5CD8D2),
            // Цвет рамки
            outlineWidth: 10,
            placement: mapkit.TextStylePlacement.Bottom,
            offset: 5.0,
          ));

        _indexToPlacemarkType[hotelId] = hotel;
      }
    }

    clusterizedCollection.clusterPlacemarks(
      clusterRadius: _clusterRadius,
      minZoom: _clusterMinZoom,
    );
  }

  void _updateFocusRect() {
    const horizontalMargin = 40.0;
    const verticalMargin = 70.0;

    _mapWindow?.let((it) {
      it.focusRect = mapkit.ScreenRect(
        const mapkit.ScreenPoint(
          x: horizontalMargin,
          y: verticalMargin,
        ),
        mapkit.ScreenPoint(
          x: it.width() - horizontalMargin,
          y: it.height() - verticalMargin,
        ),
      );
    });
  }
}
