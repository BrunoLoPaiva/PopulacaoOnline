import 'dart:convert';
import 'dart:math';

import 'package:app/data/requests.dart';
import 'package:app/widgets/menu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:getwidget/getwidget.dart';
import '../mobile/request_info.dart';
import 'web_request_info.dart';
import 'package:app/models/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:latlong2/latlong.dart' as coord;

List<Marker> markers = [];
var firstLocation_long;
var firstLocation_lat;

class WebRequest extends StatelessWidget {
  const WebRequest({Key? key}) : super(key: key);

  static const iconsList = {
    '1': Icons.warning_amber_rounded,
    '2': Icons.done,
    '3': Icons.close,
  };

  @override
  Widget build(BuildContext context) {
    //var req = {...allRequests};

    Future getDocs() async {
      await Firebase.initializeApp();
      QuerySnapshot<Map<String, dynamic>> qn =
          await db.collection("solicitacoes").get();
      return qn.docs;
    }

    return Scaffold(
      body: FutureBuilder(
        future: getDocs(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            for (var i = 0; i < snapshot.data.length; i++) {
              markers.add(Marker(
                point: coord.LatLng(snapshot.data[index].data()['latitude'],
                    snapshot.data[index].data()['longitude']),
                width: 80,
                height: 80,
                builder: (context) => IconButton(
                  icon: Icon(
                    Icons.location_on_outlined,
                    color: Colors.red,
                  ),
                  iconSize: 35,
                  onPressed: () => {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return RequestInfo(
                            id: snapshot.data[index].data()['id'],
                          );
                        },
                      ),
                    )
                  },
                ),
              ));
            }
            return
                // snapshot.data.length > 1 ?
                SingleChildScrollView(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Menu(),
                  Expanded(
                    flex: 9,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: ListView.builder(
                        itemCount: snapshot.data.length,
                        itemBuilder: (context, index) {
                          return ListTile(
                            title: Center(
                                child: GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute<void>(
                                          builder: (BuildContext context) {
                                            return WebRequestInfo(
                                                id: snapshot.data[index]
                                                    .data()['id']);
                                          },
                                        ),
                                      );
                                    },
                                    child: Card(
                                      color: Color(int.parse(snapshot
                                          .data[index]
                                          .data()['color'])),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8),
                                        child: Row(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: SizedBox(
                                                height: 120,
                                                child: ClipRRect(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0),
                                                    child: Image.memory(
                                                      Base64Decoder().convert(
                                                          snapshot.data[index]
                                                              .data()['image']),
                                                    )),
                                              ),
                                            ),
                                            Icon(
                                              iconsList[snapshot.data[index]
                                                  .data()['status']
                                                  .toString()],
                                              size: 50,
                                            ),
                                            SizedBox(width: 10),
                                            Text(
                                              'Solicitação #1564${snapshot.data[index].data()['id']}',
                                              style: TextStyle(fontSize: 20),
                                            ),
                                            Spacer(),
                                            Icon(Icons.keyboard_arrow_right),
                                          ],
                                        ),
                                      ),
                                    ))),
                          );
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Container(
                      height: MediaQuery.of(context).size.height,
                      color: Color.fromARGB(255, 61, 61, 61),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(48, 0, 48, 0),
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(8.0),
                                child: Container(
                                  child: FlutterMap(
                                    options: MapOptions(
                                      interactiveFlags:
                                          InteractiveFlag.pinchZoom |
                                              InteractiveFlag.drag,
                                      center: snapshot.data.length > 0
                                          ? coord.LatLng(
                                              snapshot.data[index]
                                                  .data()['latitude'],
                                              snapshot.data[index]
                                                  .data()['longitude'])
                                          : coord.LatLng(
                                              -21.6730411, -49.747527),
                                      zoom: 15.75,
                                      maxZoom: 18,
                                    ),
                                    layers: [
                                      TileLayerOptions(
                                        urlTemplate:
                                            "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                        userAgentPackageName: 'com.example.app',
                                      ),
                                      MarkerLayerOptions(
                                        markers: markers,
                                      ),
                                    ],
                                  ),
                                  width: MediaQuery.of(context).size.width * .2,
                                  height:
                                      MediaQuery.of(context).size.width * .22,
                                )),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
