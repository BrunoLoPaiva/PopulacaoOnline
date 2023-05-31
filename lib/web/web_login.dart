import 'package:app/data/requests.dart';
import 'package:app/web/web_home.dart';
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

OutlineInputBorder myinputborder() {
  //return type is OutlineInputBorder
  return OutlineInputBorder(
      //Outline border type for TextFeild
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(
        color: Colors.grey,
        width: 1,
      ));
}

OutlineInputBorder myfocusborder() {
  return OutlineInputBorder(
      borderRadius: BorderRadius.all(Radius.circular(30)),
      borderSide: BorderSide(
        color: Colors.white,
        width: 1,
      ));
}

class WebLogin extends StatelessWidget {
  const WebLogin({Key? key}) : super(key: key);

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
            return Center(
              child: Container(
                alignment: Alignment.center,
                //color: Color.fromARGB(255, 61, 61, 61),
                constraints: BoxConstraints(
                    maxWidth: 400.0,
                    minHeight: MediaQuery.of(context).size.height),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      margin: EdgeInsets.all(36),
                      padding: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          border: Border.all(width: 2, color: Colors.grey)),
                      child: Icon(
                        Icons.person,
                        size: MediaQuery.of(context).size.height * .1,
                        color: Colors.grey,
                      ),
                    ),
                    Divider(
                      thickness: 2,
                      indent: 20,
                      endIndent: 20,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: TextField(
                          decoration: InputDecoration(
                        label: Center(
                          child: Text("Usuário"),
                        ),
                        border: myinputborder(), //normal border
                        enabledBorder: myinputborder(), //enabled border
                        focusedBorder: myfocusborder(), //focused border
                        // set more border style like disabledBorder
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                      child: TextField(
                          decoration: InputDecoration(
                        label: Center(
                          child: Text("Senha"),
                        ),
                        enabledBorder: myinputborder(),
                        focusedBorder: myfocusborder(),
                      )),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 10),
                      child: GFButton(
                        onPressed: () {},
                        text: "Entrar",
                        shape: GFButtonShape.pills,
                        fullWidthButton: true,
                        color: Colors.white,
                        hoverColor: Colors.blue,
                        type: GFButtonType.outline,
                      ),
                    ),
                  ],
                ),
              ),
            );
            // snapshot.data.length > 1 ?

          }
        },
      ),
    );
  }
}
