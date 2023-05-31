import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';

final db = FirebaseFirestore.instance;

class Request {
  late int id;
  late String userId;
  late String date;
  late double latitude;
  late double longitude;
  late int status;
  late String statusText;
  late int situation;
  late String situationText;
  late String type;
  late String description;
  late String address;
  late int likes;
  late String color;
  late bool danger;
  late Map actions = {};
  late var icon;
  late var image;
  late int month;

  Request(
      {required this.id,
      required this.userId,
      required this.date,
      required this.month,
      required this.latitude,
      required this.longitude,
      required this.status,
      required this.situation,
      required this.type,
      required this.description,
      required this.address,
      required this.likes,
      required this.image,
      required this.danger,
      required this.actions});

  void updateStatus() {
    if (this.status == 1) {
      this.color = '0xFFdbba35';
      this.statusText = 'Em análise';
      this.icon = Icons.warning_amber_rounded;
    } else if (this.status == 2) {
      this.color = '0xFF2b9e38';
      this.statusText = 'Aprovado';
      this.icon = Icons.done;
    } else if (this.status == 3) {
      this.color = '0xFFd13f37';
      this.statusText = 'Rejeitado';
      this.icon = Icons.close;
    }
  }

  void updateSituation() {
    if (this.situation == 1) {
      situationText = 'Aguardando avaliação';
    } else if (this.situation == 2) {
      situationText = 'Em andamento';
    } else if (this.situation == 3) {
      situationText = 'Finalizado';
    }
  }

  void update() {
    updateSituation();
    updateStatus();
  }

  saveData() async {
    final docRef = db.collection('solicitacoes').doc();
    update();

    Map<String, dynamic> dados = await {
      'id': this.id,
      'userId': this.userId,
      'date': this.date,
      'month': this.month,
      'latitude': this.latitude,
      'longitude': this.longitude,
      'status': this.status,
      'situation': this.situation,
      'type': this.type,
      'description': this.description,
      'address': this.address,
      'likes': this.likes,
      'image': base64Encode(this.image.readAsBytesSync()),
      'danger': this.danger,
      'actions': this.actions,
      'color': this.color,
      'statusText': this.statusText,
      'situationText': this.situationText,
      //'icon': this.icon
    };

    await docRef.set(dados).then(
        (value) => print("Solicitação salva com sucesso!"),
        onError: (e) => print("Erro ao salvar solicitação: $e"));
  }
}

getData() async {
  await db.collection("solicitacoes").get().then(
        (res) => res.docs.forEach((req) {
          req.data().entries.forEach((element) {
            print(element.toString());
          });
        }),
        onError: (e) => print("Error completing: $e"),
      );
}

getRequestData(int requiredID) async {
  var result;
  await db
      .collection("solicitacoes")
      .where("id", isEqualTo: requiredID)
      .get()
      .then(
        (res) => result = res.docs.first.data(),
        onError: (e) => print("Error completing: $e"),
      );

  return await result;
}
