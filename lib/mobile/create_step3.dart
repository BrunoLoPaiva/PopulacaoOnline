import 'dart:math';

import 'package:app/mobile/create_step2.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import '/mobile/mobile_home.dart';
import 'package:app/data/requests.dart';
import '../models/request.dart';

const List<String> list = <String>[
  'Buraco',
  'Denúncia',
  'Entulho',
  'Lixo',
  'Poda de árvore',
  'Mato',
  'Outros'
];

bool danger = false;
TextEditingController controllerDescricao = TextEditingController();
late Request currentRequest;

const snackBar = SnackBar(
  content: Text('Solicitação criada com sucesso!'),
);

class Create3 extends StatefulWidget {
  final image;
  double lat;
  double long;
  String endereco;

  Create3({
    Key? key,
    required this.image,
    required this.lat,
    required this.long,
    required this.endereco,
  }) : super(key: key);

  @override
  State<Create3> createState() =>
      _Create3State(newImage: this.image, lat: this.lat, long: this.long);
}

class _Create3State extends State<Create3> {
  final newImage;
  double lat;
  double long;

  late String userId;

  _Create3State({
    required this.newImage,
    required this.lat,
    required this.long,
  });

  deviceInfo() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    userId = androidInfo.id.toString();
  }

  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    var screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: Text('3º Passo')),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            //Foto---------------------------------------------------------------------------------------------------------------------------------
            ClipRRect(
              borderRadius: BorderRadius.circular(8.0),
              child: Image.file(
                newImage,
                width: screen.width * 0.3,
                fit: BoxFit.fitHeight,
              ),
            ),
            SizedBox(height: 15),
            //Endereço------------------------------------------------------------------------------------------------------------------------------
            Padding(
              padding: EdgeInsets.fromLTRB(50, 0, 50, 10),
              child: Text(
                endereco,
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 15, color: Colors.white70),
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.1),
            Padding(
              padding: EdgeInsets.fromLTRB(30, 0, 30, 10),
              child: Text(
                'Nos informe mais alguns detalhes para a abertura da solicitação.',
                textAlign: TextAlign.justify,
                style: TextStyle(fontSize: 20),
              ),
            ),
            SizedBox(height: 30),
            //Tipo--------------------------------------------------------------------------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(30, 0, 0, 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Selecione um tipo:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: DropdownButton<String>(
                value: dropdownValue,
                elevation: 16,
                onChanged: (String? value) {
                  // This is called when the user selects an item.
                  setState(() {
                    dropdownValue = value!;
                  });
                },
                items: list.map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
            //Descrição---------------------------------------------------------------------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 30, 0, 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Descreva o problema:',
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 18,
                  ),
                ),
              ),
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width * 0.8,
              child: TextField(
                controller: controllerDescricao,
                decoration: InputDecoration(
                  labelText: "Descrição",
                  fillColor: Colors.white,
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                        const BorderSide(color: Colors.white, width: 2.0),
                    borderRadius: BorderRadius.circular(25.0),
                  ),
                ),
              ),
            ),
            //Risco--------------------------------------------------------------------------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.fromLTRB(40, 30, 40, 15),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'O problema traz perigo :',
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 18,
                      ),
                    ),
                    Switch(
                      value: danger,
                      onChanged: (value) {
                        print(danger);
                        setState(() => danger = value);
                      },
                    ),
                  ],
                ),
              ),
            ),
            FloatingActionButton(
              onPressed: () async {
                String uniqueId = '';
                var rng = Random();
                for (var i = 0; i < 10; i++) {
                  uniqueId += rng.nextInt(10).toString();
                }
                await deviceInfo();

                currentRequest = Request(
                  id: int.parse(uniqueId),
                  userId: userId,
                  date:
                      '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                  month: DateTime.now().month,
                  latitude: await lat,
                  longitude: await long,
                  status: 1,
                  situation: 1,
                  type: dropdownValue,
                  description: controllerDescricao.text,
                  address: endereco,
                  likes: 12,
                  image: newImage,
                  danger: danger,
                  actions: {
                    '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}':
                        'Solicitação criada'
                  },
                );

                allRequests[index.toString()] = currentRequest;

                allRequests.forEach((k, v) => v.update());

                await currentRequest.saveData();

                // ScaffoldMessenger.of(context).showSnackBar(snackBar);

                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => MobileHome()),
                    (Route<dynamic> route) => false);
              },
              child: Icon(Icons.done),
            ),
          ]),
        ),
      ),
    );
  }
}
