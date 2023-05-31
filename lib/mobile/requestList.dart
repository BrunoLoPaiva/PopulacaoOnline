import 'package:app/data/requests.dart';
import 'package:flutter/material.dart';
import 'request_info.dart';
import 'package:app/models/request.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

class RequestList extends StatelessWidget {
  const RequestList({Key? key}) : super(key: key);

  static const iconsList = {
    '1': Icons.warning_amber_rounded,
    '2': Icons.done,
    '3': Icons.close,
  };

  @override
  Widget build(BuildContext context) {
    var req = {...allRequests};

    Future getDocs() async {
      await Firebase.initializeApp();
      QuerySnapshot<Map<String, dynamic>> qn =
          await db.collection("solicitacoes").get();
      return qn.docs;
    }

    String appBar_title = 'Lista de solicitações';

    return Scaffold(
      appBar: AppBar(
        title: Text(appBar_title),
      ),
      body: FutureBuilder(
        future: getDocs(),
        builder: (context, AsyncSnapshot snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(
              child: CircularProgressIndicator(),
            );
          } else {
            print(snapshot.data.length);
            return ListView.separated(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemCount: snapshot.data.length,
              itemBuilder: (context, index) {
                return Center(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          return RequestInfo(
                              id: snapshot.data[index].data()[
                                  'id']); //RequestInfo(id: snapshot.data[index].data()['id']);
                        },
                      ),
                    );
                  },
                  child: Card(
                    color:
                        Color(int.parse(snapshot.data[index].data()['color'])),
                    child: Padding(
                      padding: const EdgeInsets.all(8),
                      child: Row(
                        children: [
                          Icon(iconsList[snapshot.data[index]
                              .data()['status']
                              .toString()]),
                          SizedBox(width: 10),
                          Text(
                              'Solicitação #1564${snapshot.data[index].data()['id']}'),
                          Spacer(),
                          Icon(Icons.keyboard_arrow_right),
                        ],
                      ),
                    ),
                  ),
                ));
              },
            );
          }
        },
      ),
    );
  }
}
