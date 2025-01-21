import 'dart:async';

import 'package:flutter/material.dart';
import 'package:yandex_map_application/core/services/map_services/location_service.dart';
import 'package:yandex_mapkit/yandex_mapkit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  final mapControllerCompleter = Completer<YandexMapController>();

  @override
  void initState() {
    super.initState();
    _initPermission().ignore();
  }

  List<MapObject> mapObjects = [];

  AnimationController? _animationController;
  Animation<double>? _animation;
  double opacity = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          YandexMap(
            onMapTap: (point) {
              addMark(point: point);
            },
            mapObjects: mapObjects,
            onMapCreated: (controller) =>
                mapControllerCompleter.complete(controller),
          ),
        ],
      ),
    );
  }

  Future<void> _initPermission() async {
    if (!await LocationService().checkPermission()) {
      await LocationService().requestPermission();
    }
    await _fetchCurrentLocation();
  }

  Future<void> _fetchCurrentLocation() async {
    AppLatLong location;
    const defLocation = SidneyLocation();
    try {
      location = await LocationService().getCurrentLocation();
    } catch (_) {
      location = defLocation;
    }
    addObjects(location);
    _moveToCurrentLocation(location);
  }

  Future<void> _moveToCurrentLocation(
    AppLatLong appLatLong,
  ) async {
    (await mapControllerCompleter.future).moveCamera(
      animation: const MapAnimation(type: MapAnimationType.linear, duration: 1),
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: Point(
            latitude: appLatLong.lat,
            longitude: appLatLong.long,
          ),
          zoom: 15,
        ),
      ),
    );
  }

  void addObjects(AppLatLong appLatLong) {
    final myLocationMarker = PlacemarkMapObject(
      mapId: const MapObjectId('currentLocation'),
      point: Point(
        latitude: appLatLong.lat,
        longitude: appLatLong.long,
      ),
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage('assets/images/mark.png'),
          rotationType: RotationType.rotate,
          scale: 0.3,
        ),
      ),
    );

    final currentLocationCircle = CircleMapObject(
      mapId: const MapObjectId('currentLocationCircle'),
      fillColor: Colors.yellow.withOpacity(opacity),
      strokeWidth: 0,
      circle: Circle(
        center: Point(
          latitude: appLatLong.lat,
          longitude: appLatLong.long,
        ),
        radius: 120,
      ),
    );

    mapObjects.addAll([currentLocationCircle, myLocationMarker]);
    setState(() {});
  }

  void addMark({required Point point}) {
    final secondMarker = PlacemarkMapObject(
      mapId: const MapObjectId('secondLocation'),
      point: point,
      icon: PlacemarkIcon.single(
        PlacemarkIconStyle(
          image: BitmapDescriptor.fromAssetImage('assets/images/mark.png'),
          rotationType: RotationType.rotate,
          scale: 0.3,
        ),
      ),
    );

    mapObjects.add(secondMarker);
    setState(() {});
  }

  void animation() {
    _animationController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );
    _animation = Tween(
      begin: 0.0,
      end: 0.3,
    ).animate(_animationController!)
      ..addListener(() {
        setState(() {});
        opacity = _animation!.value;
      });
    _animationController!.repeat(reverse: true);
  }
}
