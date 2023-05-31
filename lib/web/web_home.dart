import 'dart:convert';
import 'dart:math';

import 'package:app/data/requests.dart';
import 'package:app/widgets/cartesian_chart.dart';
import 'package:app/widgets/menu.dart';
import 'package:app/widgets/pie_chart.dart';
import 'package:app/widgets/sumary.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:getwidget/getwidget.dart';
import '../mobile/request_info.dart';
import 'web_request_info.dart';
import 'package:app/models/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:latlong2/latlong.dart' as coord;

var dataReqAux = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
//Total, Pendente, Aberta, Finalizada, Recusada
var dataReqStatusAux = [0, 0, 0, 0, 0];

var dataReqTipoAux = [0, 0, 0, 0, 0, 0, 0];
List<Marker> markers = [];
var firstLocation_long;
var firstLocation_lat;

class WebHome extends StatelessWidget {
  const WebHome({Key? key}) : super(key: key);

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
            dataReqStatusAux[0] = snapshot.data.length;
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

              dataReqStatusAux = [0, 0, 0, 0, 0];
              dataReqAux = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0];
              if (snapshot.data[index].data()['month'] != null) {
                dataReqAux[snapshot.data[index].data()['month'] - 1]++;
              }

              //Total, Pendente, Aberta, Finalizada, Recusada

              if (snapshot.data[index].data()['status'] == 1) {
                //Aguardando aprovação
                dataReqStatusAux[1]++;
              }
              if (snapshot.data[index].data()['situation'] == 2) {
                dataReqStatusAux[2]++;
              }
              if (snapshot.data[index].data()['situation'] == 3) {
                dataReqStatusAux[3]++;
              }
              if (snapshot.data[index].data()['status'] == 3) {
                dataReqStatusAux[4]++;
              }

              print("---------------" + snapshot.data[index].data()['type']);
              if (snapshot.data[index].data()['type'] == 'Buraco') {
                dataReqTipoAux[0]++;
              } else if (snapshot.data[index].data()['type'] == 'Denúncia') {
                dataReqTipoAux[1]++;
              } else if (snapshot.data[index].data()['type'] == 'Entulho') {
                dataReqTipoAux[2]++;
              } else if (snapshot.data[index].data()['type'] == 'Lixo') {
                dataReqTipoAux[3]++;
              } else if (snapshot.data[index].data()['type'] ==
                  'Poda de árvore') {
                dataReqTipoAux[4]++;
              } else if (snapshot.data[index].data()['type'] == 'Mato') {
                dataReqTipoAux[5]++;
              } else if (snapshot.data[index].data()['type'] == 'Outros') {
                dataReqTipoAux[6]++;
              }
            }
            return
                // snapshot.data.length > 1 ?
                Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Menu(),
                Expanded(
                  flex: 9,
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    child: SingleChildScrollView(
                      child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .025),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: CartesianChart(dataReqAux),
                            ),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .025),
                            Divider(),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .025),
                            RequestsPieChart(dataReqTipoAux),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .025),
                            Divider(),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .025),
                            Sumary(dataReqStatusAux),
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * .025),
                          ]),
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
                        Container(
                          height: MediaQuery.of(context).size.height,
                          color: Color.fromARGB(255, 61, 61, 61),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(48, 0, 48, 0),
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
                                            userAgentPackageName:
                                                'com.example.app',
                                          ),
                                          MarkerLayerOptions(
                                            markers: markers,
                                          ),
                                        ],
                                      ),
                                      width: MediaQuery.of(context).size.width *
                                          .2,
                                      height:
                                          MediaQuery.of(context).size.width *
                                              .22,
                                    )),
                              )
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                )
              ],
            );
          }
        },
      ),
    );
  }
}
