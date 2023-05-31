import 'package:app/models/request.dart';
import 'package:app/web/web_home.dart';
import 'package:app/web/web_request_info.dart';
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
var actionList;
TextEditingController dateinput = TextEditingController();
TextEditingController actionInput = TextEditingController();
DateTime? pickedDate;

class AddAction extends StatefulWidget {
  late int id;

  AddAction({Key? key, required this.id}) : super(key: key);

  @override
  State<AddAction> createState() => _RequestState(id);
}

class _RequestState extends State<AddAction> {
  late int id;
  _RequestState(this.id);
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
                        acoes = [];
                        actionList = null;

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
                        }

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
                                      textAlign: TextAlign.left,
                                      style: TextStyle(fontSize: 12),
                                    )
                                  ],
                                )));

                        actionList = snapshot.data[index].data()['actions'];

                        return SingleChildScrollView(
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            GFButton(
                                              onPressed: () async {
                                                if (pickedDate != null ||
                                                    actionInput == null) {
                                                  var a = pickedDate.toString();

                                                  actionList[dateinput.text] =
                                                      actionInput.text;
                                                }

                                                await db
                                                    .collection("solicitacoes")
                                                    .doc(
                                                        snapshot.data[index].id)
                                                    .update({
                                                  'actions': actionList
                                                });
                                                Navigator.push(
                                                  context,
                                                  MaterialPageRoute<void>(
                                                    builder:
                                                        (BuildContext context) {
                                                      return WebRequestInfo(
                                                          id: snapshot
                                                              .data[index]
                                                              .data()['id']);
                                                    },
                                                  ),
                                                );
                                              },
                                              icon: Icon(Icons.done),
                                              text: "Salvar",
                                              shape: GFButtonShape.pills,
                                              color: Colors.grey,
                                              type: GFButtonType.outline,
                                            )
                                          ],
                                        ),
                                        TextField(
                                          controller: dateinput,
                                          decoration: InputDecoration(
                                              icon: Icon(Icons.calendar_today),
                                              labelText:
                                                  "Quando a ação foi realizada?"),
                                          readOnly: true,
                                          onTap: () async {
                                            pickedDate = await showDatePicker(
                                              context: context,
                                              initialDate: DateTime.now(),
                                              firstDate: DateTime(2000),
                                              lastDate: DateTime(2101),
                                            );
                                            var a = pickedDate.toString();
                                            dateinput.text = (a[8] +
                                                    a[9] +
                                                    '/' +
                                                    a[5] +
                                                    a[6] +
                                                    '/' +
                                                    a[0] +
                                                    a[1] +
                                                    a[2] +
                                                    a[3])
                                                .toString();
                                          },
                                        ),
                                        SizedBox(
                                          height: 24,
                                        ),
                                        TextField(
                                          controller: actionInput,
                                          keyboardType: TextInputType.multiline,
                                          maxLines: 4,
                                          decoration: InputDecoration(
                                              hintText:
                                                  "Descreva a ação realizada",
                                              focusedBorder: OutlineInputBorder(
                                                  borderSide: BorderSide(
                                                      width: 1,
                                                      color: Colors.white70))),
                                        ),
                                      ]),
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 4,
                                child: SingleChildScrollView(
                                  child: Container(
                                    constraints: BoxConstraints(
                                      minHeight:
                                          MediaQuery.of(context).size.height,
                                    ),
                                    color: Color.fromARGB(255, 61, 61, 61),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                            snapshot.data[index]
                                                .data()['statusText']
                                                .toUpperCase(),
                                            style: TextStyle(
                                              fontSize: 20,
                                              color: Color(int.parse(snapshot
                                                  .data[index]
                                                  .data()['color'])),
                                            )),
                                        SizedBox(height: screen.height * 0.03),
                                        Text(snapshot.data[index]
                                            .data()['situationText']),
                                        SizedBox(height: screen.height * 0.02),
                                        Text(
                                            'Iniciada em: ${snapshot.data[index].data()['date']}'),
                                        SizedBox(height: screen.height * 0.02),
                                        SizedBox(height: screen.height * 0.03),
                                        CarouselSlider(
                                          items: [
                                            ClipRRect(
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
                                              ),
                                            ),
                                            ClipRRect(
                                                borderRadius:
                                                    BorderRadius.circular(8.0),
                                                child: Container(
                                                  child: FlutterMap(
                                                    options: MapOptions(
                                                      interactiveFlags:
                                                          InteractiveFlag
                                                                  .pinchZoom |
                                                              InteractiveFlag
                                                                  .drag,
                                                      center: coord.LatLng(
                                                          snapshot.data[index]
                                                                  .data()[
                                                              'latitude'],
                                                          snapshot.data[index]
                                                                  .data()[
                                                              'longitude']),
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
                                            autoPlayAnimationDuration:
                                                Duration(milliseconds: 2000),
                                            viewportFraction: 0.8,
                                          ),
                                        ),
                                        SizedBox(height: screen.height * 0.02),
                                        SizedBox(height: screen.height * 0.02),
                                        Text('Tipo'),
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
                                      ],
                                    ),
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
