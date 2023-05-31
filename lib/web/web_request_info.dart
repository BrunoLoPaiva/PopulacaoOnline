import 'dart:ui';

import 'package:app/models/request.dart';
import 'package:app/web/web_add_action.dart';
import 'package:app/web/web_home.dart';
import 'package:app/widgets/menu.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:app/data/requests.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:getwidget/getwidget.dart';
import 'package:latlong2/latlong.dart' as coord;
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'package:image/image.dart' as ImageProcess;

List<Marker> markers = [];
List<Widget> acoes = [];

class WebRequestInfo extends StatefulWidget {
  late int id;

  WebRequestInfo({Key? key, required this.id}) : super(key: key);

  @override
  State<WebRequestInfo> createState() => _RequestState(id);
}

class _RequestState extends State<WebRequestInfo> {
  late int id;
  _RequestState(this.id);
  bool _liked = false;
  var req = {...allRequests};

  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    Future getDocs() async {
      await Firebase.initializeApp();
      QuerySnapshot<Map<String, dynamic>> qn =
          await db.collection("solicitacoes").where("id", isEqualTo: id).get();
      return qn.docs;
    }

    return Scaffold(
      body: FutureBuilder(
        future: getDocs(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (!snapshot.hasData) {
            // while data is loading:
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            // data loaded: snapshot.data[index].data()
            //update markers
            markers.add(Marker(
              point: coord.LatLng(
                snapshot.data[index].data()['latitude'],
                snapshot.data[index].data()['longitude'],
              ),
              width: 80,
              height: 80,
              builder: (context) => IconButton(
                  icon: Icon(
                    Icons.location_on_outlined,
                    color: Colors.red,
                  ),
                  iconSize: 35,
                  onPressed: () => {}),
            ));

            return Center(
              child: SafeArea(
                child: Scaffold(
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
                            point: coord.LatLng(
                                snapshot.data[index].data()['latitude'],
                                snapshot.data[index].data()['longitude']),
                            width: 80,
                            height: 80,
                            builder: (context) => Icon(
                              Icons.location_on_outlined,
                              color: Colors.red,
                              size: 35,
                            ),
                          ));

                          acoes = [];

                          snapshot.data[index]
                              .data()['actions']
                              .forEach((k, v) => acoes.add(Column(
                                    children: [
                                      SizedBox(height: screen.height * 0.01),
                                      Align(
                                        alignment: Alignment.centerLeft,
                                        child: Text(k),
                                      ),
                                      Text(
                                        v,
                                        textAlign: TextAlign.justify,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      SizedBox(height: screen.height * 0.01),
                                      Divider()
                                    ],
                                  )));
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
                                  child: SingleChildScrollView(
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          screen.width * 0.1,
                                          screen.width * 0.08,
                                          screen.width * 0.1,
                                          screen.width * 0.04),
                                      child: Column(children: [
                                        Text(
                                            snapshot.data[index]
                                                .data()['statusText']
                                                .toUpperCase(),
                                            style: TextStyle(
                                                fontSize: 30,
                                                color: Colors.white,
                                                shadows: [
                                                  Shadow(
                                                      // bottomLeft
                                                      blurRadius: 2,
                                                      //offset: Offset(-1, -1),
                                                      color: Color(int.parse(
                                                          snapshot.data[index]
                                                                  .data()[
                                                              'color']))),
                                                  Shadow(
                                                      // bottomRight
                                                      blurRadius: 2,
                                                      //offset: Offset(1, -1),
                                                      color: Color(int.parse(
                                                          snapshot.data[index]
                                                                  .data()[
                                                              'color']))),
                                                  Shadow(
                                                      // topRight
                                                      blurRadius: 2,
                                                      //offset: Offset(1, 1),
                                                      color: Color(int.parse(
                                                          snapshot.data[index]
                                                                  .data()[
                                                              'color']))),
                                                  Shadow(
                                                      // topLeft
                                                      blurRadius: 2,
                                                      //offset: Offset(-1, 1),
                                                      color: Color(int.parse(
                                                          snapshot.data[index]
                                                                  .data()[
                                                              'color']))),
                                                ])),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        snapshot.data[index]
                                                    .data()['statusText'] ==
                                                'Em análise'
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GFButton(
                                                    onPressed: () async {
                                                      await db
                                                          .collection(
                                                              "solicitacoes")
                                                          .doc(snapshot
                                                              .data[index].id)
                                                          .update({
                                                        'color': '0xFF2b9e38',
                                                        'situation': 2,
                                                        'status': 2,
                                                        'statusText':
                                                            'Aprovado',
                                                        'situationText':
                                                            'Em andamento'
                                                      });
                                                      setState(() {});
                                                    },
                                                    text: "Aprovar",
                                                    shape: GFButtonShape.pills,
                                                    color: Colors.green,
                                                    type: GFButtonType.outline,
                                                  ),
                                                  const SizedBox(
                                                    width: 8,
                                                  ),
                                                  GFButton(
                                                    onPressed: () async {
                                                      await db
                                                          .collection(
                                                              "solicitacoes")
                                                          .doc(snapshot
                                                              .data[index].id)
                                                          .update({
                                                        'color': '0xFFd13f37',
                                                        'situation': 3,
                                                        'status': 3,
                                                        'statusText':
                                                            'Rejeitado',
                                                        'situationText':
                                                            'Finalizado'
                                                      });
                                                      setState(() {});
                                                    },
                                                    text: "Negar",
                                                    shape: GFButtonShape.pills,
                                                    color: Colors.red,
                                                    type: GFButtonType.outline,
                                                  )
                                                ],
                                              )
                                            : SizedBox(height: 0),
                                        snapshot.data[index]
                                                    .data()['situationText'] ==
                                                'Em andamento'
                                            ? Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  GFButton(
                                                    onPressed: () async {
                                                      await db
                                                          .collection(
                                                              "solicitacoes")
                                                          .doc(snapshot
                                                              .data[index].id)
                                                          .update({
                                                        'color': '0xFF1355a1',
                                                        'situation': 3,
                                                        'situationText':
                                                            'Finalizado',
                                                        'statusText':
                                                            'Finalizado',
                                                      });
                                                      setState(() {});
                                                    },
                                                    text: "Finalizar",
                                                    shape: GFButtonShape.pills,
                                                    color: Colors.red,
                                                    type: GFButtonType.outline,
                                                  )
                                                ],
                                              )
                                            : SizedBox(height: 0),
                                        SizedBox(height: 8.0),
                                        Text(snapshot.data[index]
                                            .data()['situationText']),
                                        SizedBox(height: screen.height * 0.05),
                                        Text(
                                            'Iniciada em: ${snapshot.data[index].data()['date']}'),
                                        SizedBox(height: 8.0),
                                        Text(
                                          'Apoiadores: ${snapshot.data[index].data()['likes']}',
                                        ),
                                        SizedBox(height: screen.height * 0.05),
                                        Text(
                                            'Tipo: ${snapshot.data[index].data()['type']}'),
                                        SizedBox(height: screen.height * 0.06),
                                        Row(children: <Widget>[
                                          Expanded(
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 10.0, right: 20.0),
                                                child: const Divider(
                                                  thickness: 2,
                                                  height: 36,
                                                )),
                                          ),
                                          const Text(
                                            "Ações",
                                            style: TextStyle(fontSize: 25),
                                          ),
                                          Expanded(
                                            child: Container(
                                                margin: const EdgeInsets.only(
                                                    left: 20.0, right: 10.0),
                                                child: const Divider(
                                                  thickness: 2,
                                                  height: 36,
                                                )),
                                          ),
                                        ]),
                                        const SizedBox(height: 8),
                                        Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              20, 5, 20, 10),
                                          child: GFButton(
                                            onPressed: () {
                                              Navigator.push(
                                                context,
                                                MaterialPageRoute<void>(
                                                  builder:
                                                      (BuildContext context) {
                                                    return AddAction(
                                                        id: snapshot.data[index]
                                                            .data()['id']);
                                                  },
                                                ),
                                              );
                                            },
                                            icon: Icon(Icons
                                                .add_circle_outline_rounded),
                                            text: "Adicionar ações",
                                            shape: GFButtonShape.pills,
                                            fullWidthButton: true,
                                            color: Colors.grey,
                                            type: GFButtonType.outline,
                                          ),
                                        ),
                                        SizedBox(height: screen.height * 0.02),
                                        Column(
                                          children: acoes,
                                        )
                                      ]),
                                    ),
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            48, 48, 48, 48),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Image.memory(
                                              Base64Decoder().convert(snapshot
                                                  .data[index]
                                                  .data()['image']),
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .16,
                                            )),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.fromLTRB(
                                            48, 48, 48, 48),
                                        child: ClipRRect(
                                            borderRadius:
                                                BorderRadius.circular(8.0),
                                            child: Container(
                                              child: FlutterMap(
                                                options: MapOptions(
                                                  interactiveFlags:
                                                      InteractiveFlag
                                                              .pinchZoom |
                                                          InteractiveFlag.drag,
                                                  center: coord.LatLng(
                                                      snapshot.data[0]
                                                          .data()['latitude'],
                                                      snapshot.data[0]
                                                          .data()['longitude']),
                                                  zoom: 15.75,
                                                  maxZoom: 18,
                                                ),
                                                layers: [
                                                  TileLayerOptions(
                                                    urlTemplate:
                                                        "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                                                    userAgentPackageName:
                                                        'com.example.app',
                                                  ),
                                                  MarkerLayerOptions(
                                                    markers: markers,
                                                  ),
                                                ],
                                              ),
                                              width: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .16,
                                              height: MediaQuery.of(context)
                                                      .size
                                                      .width *
                                                  .14,
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
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
