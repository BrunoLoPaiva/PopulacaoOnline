import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'help.dart';
import 'create_step1.dart';
import 'requestList.dart';
import '../widgets/map.dart';
import 'dart:convert';
import 'dart:math';

import 'package:app/data/requests.dart';
import '../mobile/request_info.dart';
import 'package:app/models/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:latlong2/latlong.dart' as coord;

List<Marker> markers = [];

class MobileHome extends StatelessWidget {
  const MobileHome({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
                Scaffold(
              extendBody: true,
              appBar: AppBar(
                title: Text('População Online'),
              ),
              body: Center(child: Mapa(markers: markers)),
              floatingActionButton: FloatingActionButton(
                //backgroundColor: Color.fromRGBO(253, 43, 255, 1),
                onPressed: () => {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return Create1();
                      },
                    ),
                  )
                },

                child: Icon(
                  Icons.add_to_photos,
                  semanticLabel: 'Criar',
                ),
              ),
              floatingActionButtonLocation:
                  FloatingActionButtonLocation.centerDocked,
              bottomNavigationBar: BottomAppBar(
                //color: Color.fromRGBO(94, 15, 255, 1),
                shape: CircularNotchedRectangle(),
                notchMargin: 5,
                child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    IconButton(
                      icon: Icon(
                        Icons.ballot_rounded,
                        semanticLabel: 'Lista',
                        color: Colors.white,
                      ),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                              return RequestList();
                            },
                          ),
                        )
                      },
                    ),
                    SizedBox(
                      width: 30,
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.help_center,
                        semanticLabel: 'Ajuda',
                        color: Colors.white,
                      ),
                      onPressed: () => {
                        Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (BuildContext context) {
                              return Help();
                            },
                          ),
                        )
                      },
                    ),
                  ],
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
