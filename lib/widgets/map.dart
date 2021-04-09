import 'dart:async';

import 'package:bucket_map/models/country.dart';
import 'package:bucket_map/screens/country_search.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:geojson/geojson.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class Map extends StatefulWidget {
  const Map({Key key}) : super(key: key);

  @override
  State createState() => _MapState();
}

class _MapState extends State<Map> {
  Completer<GoogleMapController> _controller = Completer();
  MapType _mapType = MapType.normal;

  Set<Polygon> polygons = {};

  static final _initialCameraPosition = CameraPosition(
    target: LatLng(0, 0),
    zoom: 1,
  );

  @override
  void initState() {
    super.initState();
    parseAndDrawAssetsOnMap();
  }

  Future<void> parseAndDrawAssetsOnMap() async {
    final geo = GeoJson();
    final data = await rootBundle.loadString('assets/countries.geojson');

    await geo.search(data,
        query: GeoJsonQuery(
            geometryType: GeoJsonFeatureType.polygon,
            matchCase: false,
            property: "ADMIN",
            value: "Afghanistan"),
        verbose: true);
    GeoJsonPolygon result = geo.polygons[0];
    var points = result.geoSeries.first.geoPoints
        .map((e) => LatLng(e.latitude, e.longitude))
        .toList();

    setState(() {
      polygons.add(
        Polygon(
          polygonId: PolygonId("Afghanistan"),
          points: points,
          fillColor: Color.fromARGB(50, 0, 0, 0),
          visible: true,
          zIndex: 2,
          strokeWidth: 1,
          strokeColor: Color.fromARGB(255, 0, 0, 0),
        ),
      );
    });
  }

  void updatePolygons(CameraPosition cameraPosition) {
    if (cameraPosition.zoom > 6) {
      setState(() {
        polygons = polygons
            .map((e) =>
                e.copyWith(strokeColorParam: e.strokeColor.withOpacity(0)))
            .toSet();
      });
    }
    else {
      double new_opacity =
          (((1 - (cameraPosition.zoom - 3) / 2) / 2) * 10).roundToDouble() / 10;
      setState(() {
        polygons = polygons
            .map((e) => e.copyWith(
                fillColorParam: e.fillColor.withOpacity(new_opacity),
                strokeColorParam: Color.fromARGB(255, 0, 0, 0)))
            .toSet();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GoogleMap(
          mapType: _mapType,
          initialCameraPosition: _initialCameraPosition,
          trafficEnabled: false,
          mapToolbarEnabled: false,
          myLocationButtonEnabled: false,
          compassEnabled: false,
          tiltGesturesEnabled: false,
          rotateGesturesEnabled: false,
          polygons: polygons,
          onMapCreated: (GoogleMapController controller) {
            if (!_controller.isCompleted) {
              _controller.complete(controller);
            }
          },
          onCameraMove: (CameraPosition cameraPosition) {
            updatePolygons(cameraPosition);
          },
        ),
        SafeArea(
          child: Padding(
            padding: EdgeInsets.all(8),
            child: Column(
              children: [
                Container(
                    width: double.infinity,
                    height: 56,
                    child: GestureDetector(
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(100),
                        ),
                        elevation: 8,
                        child: Padding(
                          padding: EdgeInsets.only(
                            left: 16,
                            right: 16,
                            top: 8,
                            bottom: 8,
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.search),
                              Padding(
                                padding: EdgeInsets.only(left: 16),
                                child: Text(
                                  'Nach Länder oder Region suchen..',
                                  style: TextStyle(
                                    color: Colors.black54,
                                    fontSize: 18,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      onTap: () {
                        /*showSearch(
                          context: context,
                          delegate: CountrySearch(),
                        );*/
                      },
                    )),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    FloatingActionButton(
                      child: Icon(Icons.layers_outlined),
                      mini: true,
                      backgroundColor: Color.fromARGB(230, 255, 255, 255),
                      onPressed: () {
                        showModalBottomSheet<void>(
                          context: context,
                          builder: (BuildContext context) {
                            return Container(height: 200, child: Text('Tetst'));
                          },
                        );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        )
      ],
    );
  }
}