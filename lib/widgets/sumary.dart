import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

class Sumary extends StatelessWidget {
  Sumary(this.data);

  List data = [];

  @override
  Widget build(BuildContext context) {
    //Total, Pendente, Aberta, Finalizada, Recusada
    return Container(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(16.0)),
          color: Color.fromARGB(255, 61, 61, 61)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 8),
            Text('Total de solicitações: ${data[0]}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Solicitações pendentes de aprovação: ${data[1]}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Solicitações Abertas: ${data[2]}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Solicitações recusadas: ${data[4]}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
            Text('Solicitações finalizadas: ${data[3]}',
                style: TextStyle(fontSize: 16)),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}
