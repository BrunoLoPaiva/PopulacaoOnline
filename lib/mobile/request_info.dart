import 'package:app/models/request.dart';
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

class RequestInfo extends StatefulWidget {
  late int id;

  RequestInfo({Key? key, required this.id}) : super(key: key);

  @override
  State<RequestInfo> createState() => _RequestState(id);
}

class _RequestState extends State<RequestInfo> {
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
      appBar: AppBar(
        title: Text('Dados da Solicitação'),
      ),
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
                        )
                      ],
                    )));

            return SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(
                      screen.width * 0.1,
                      screen.width * 0.08,
                      screen.width * 0.1,
                      screen.width * 0.04),
                  child: Column(children: [
                    Text(
                        snapshot.data[index].data()['statusText'].toUpperCase(),
                        style: TextStyle(
                          fontSize: 20,
                          color: Color(
                              int.parse(snapshot.data[index].data()['color'])),
                        )),
                    SizedBox(height: screen.height * 0.03),
                    Text(snapshot.data[index].data()['situationText']),
                    SizedBox(height: screen.height * 0.02),
                    Text('Iniciada em: ${snapshot.data[index].data()['date']}'),
                    SizedBox(height: screen.height * 0.02),
                    SizedBox(height: screen.height * 0.03),
                    CarouselSlider(
                      items: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: Image.memory(
                            Base64Decoder()
                                .convert(snapshot.data[index].data()['image']),
                            height: MediaQuery.of(context).size.width * .16,
                          ),
                        ),
                        ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Container(
                              child: FlutterMap(
                                options: MapOptions(
                                  interactiveFlags: InteractiveFlag.pinchZoom |
                                      InteractiveFlag.drag,
                                  center: coord.LatLng(
                                      snapshot.data[index].data()['latitude'],
                                      snapshot.data[index].data()['longitude']),
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
                              width: screen.width * 0.8,
                              height: screen.width * 0.8,
                            ))
                      ],
                      options: CarouselOptions(
                        height: 380.0,
                        enlargeCenterPage: true,
                        autoPlay: true,
                        aspectRatio: 16 / 9,
                        autoPlayCurve: Curves.fastOutSlowIn,
                        enableInfiniteScroll: true,
                        autoPlayAnimationDuration: Duration(milliseconds: 2000),
                        viewportFraction: 0.8,
                      ),
                    ),
                    SizedBox(height: screen.height * 0.02),
                    Row(
                      children: [
                        Spacer(),
                        GestureDetector(
                            child: _liked
                                ? Icon(Icons.favorite,
                                    size: 25, color: Colors.red)
                                : Icon(Icons.favorite_outline, size: 25),
                            onTap: () {}),
                        SizedBox(width: screen.width * 0.01),
                        Text(
                          snapshot.data[index].data()['likes'].toString(),
                          style: TextStyle(fontSize: 10),
                        ),
                        SizedBox(width: screen.width * 0.06),
                      ],
                    ),
                    SizedBox(height: screen.height * 0.03),
                    Text(''),
                    SizedBox(height: screen.height * 0.02),
                    Text(
                        'Tipo: ${snapshot.data[index].data()['type'].toString()}'),
                    SizedBox(height: screen.height * 0.02),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Ações:',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    Column(
                      children: acoes,
                    )
                  ]),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
