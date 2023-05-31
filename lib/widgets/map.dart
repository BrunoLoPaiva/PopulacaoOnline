import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as coord;
import '../mobile/request_info.dart';
import 'package:app/data/requests.dart';

class Mapa extends StatefulWidget {
  List<Marker> markers;
  Mapa({required this.markers});

  @override
  State<Mapa> createState() => _MapaState();
}

class _MapaState extends State<Mapa> {
  @override
  Widget build(BuildContext context) {
    var req = {...allRequests};
    markers.clear();
    for (var i = 0; i < req.length; i++) {
      markers.add(Marker(
        point: coord.LatLng(req.values.elementAt(i).latitude,
            req.values.elementAt(i).longitude),
        width: 80,
        height: 80,
        builder: (context) => IconButton(
          icon: Icon(
            Icons.location_on_outlined,
            color: Colors.red,
          ),
          iconSize: 35,
          tooltip:
              '\nVisualizar chamado\nID: #${req.values.elementAt(i).id}\nTipo do chamado\n',
          onPressed: () => {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (BuildContext context) {
                  return RequestInfo(
                    id: req.values.elementAt(i).id,
                  );
                },
              ),
            )
          },
        ),
      ));
    }

    curPosition[0] != 0 ? print('igual') : print('diferente');

    return FlutterMap(
      options: MapOptions(
        interactiveFlags: InteractiveFlag.pinchZoom | InteractiveFlag.drag,
        center: curPosition[0] != 0
            ? coord.LatLng(curPosition[0], curPosition[1])
            : coord.LatLng(-21.6732263, -49.7456391),
        zoom: 15.75,
        maxZoom: 18,
      ),
      layers: [
        TileLayerOptions(
          urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          userAgentPackageName: 'com.example.app',
        ),
        MarkerLayerOptions(
          markers: markers,
        ),
      ],
      /*
      nonRotatedChildren: [
        AttributionWidget.defaultWidget(
          source: 'OpenStreetMap contributors',
          onSourceTapped: null,
        ),
      ],

      */
    );
  }
}
