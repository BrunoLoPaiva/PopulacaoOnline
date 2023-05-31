import 'package:app/main.dart';
import 'package:flutter/material.dart';
import '/mobile/create_step3.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

late double long;
late double lat;
late String endereco;

late bool searching = false;

const snackBar = SnackBar(
  content: Text('Compartilhe sua localização para continuar.'),
);

class Create2 extends StatefulWidget {
  final image;

  Create2({
    Key? key,
    required this.image,
  }) : super(key: key);

  @override
  State<Create2> createState() => _Create2State();
}

class _Create2State extends State<Create2> {
  late double long;

  late double lat;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('2º Passo')),
      body: searching
          ? Center(
              child: Column(
                children: [
                  Spacer(flex: 3),
                  SpinKitRipple(
                    color: Colors.white,
                    size: 500,
                  ),
                  Spacer(
                    flex: 1,
                  ),
                  Text(
                    'Encontrando sua localização...',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(
                    flex: 3,
                  ),
                ],
              ),
            )
          : Center(
              child: Column(children: [
                Spacer(),
                Text(
                  'Compartilhe sua localização',
                  style: TextStyle(fontSize: 20),
                ),
                SizedBox(height: 20),
                GestureDetector(
                  child: Icon(Icons.add_location_alt_rounded, size: 80),
                  onTap: () async {
                    LocationPermission permission =
                        await Geolocator.checkPermission();

                    if (permission == LocationPermission.denied) {
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      permission = await Geolocator.requestPermission();
                      if (permission == LocationPermission.denied) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        permission = await Geolocator.requestPermission();
                      } else if (permission ==
                          LocationPermission.deniedForever) {
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                        permission = await Geolocator.requestPermission();
                      } else {
                        setState(() {
                          searching = true;
                        });
                        Position position = await Geolocator.getCurrentPosition(
                            desiredAccuracy: LocationAccuracy.high);
                        long = position.longitude;
                        lat = position.latitude;

                        List<Placemark> addresses =
                            await placemarkFromCoordinates(
                                position.latitude, position.longitude);

                        var first = addresses.first;
                        //print('${first..administrativeArea}');
                        endereco =
                            '${first.street}, ${first.name} - ${first.subLocality}, ${first.subAdministrativeArea} - ${first.administrativeArea}, ${first.country}';
                      }
                    } else {
                      setState(() {
                        searching = true;
                      });
                      Position position = await Geolocator.getCurrentPosition(
                          desiredAccuracy: LocationAccuracy.high);
                      long = position.longitude;
                      lat = position.latitude;

                      List<Placemark> addresses =
                          await placemarkFromCoordinates(
                              position.latitude, position.longitude);

                      var first = addresses.first;
                      //print('${first..administrativeArea}');
                      endereco =
                          '${first.street}, ${first.name} - ${first.subLocality}, ${first.subAdministrativeArea} - ${first.administrativeArea}, ${first.country}';
                    }

                    curPosition[0] = lat;
                    curPosition[1] = long;

                    setState(() {
                      searching = false;
                    });
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (BuildContext context) {
                          print('Searching: ${searching}');
                          return Create3(
                              image: this.widget.image,
                              lat: lat,
                              long: long,
                              endereco: endereco);
                        },
                      ),
                    );
                  },
                ),
                Spacer(),
              ]),
            ),
    );
  }
}
