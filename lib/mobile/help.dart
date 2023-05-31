import 'package:flutter/material.dart';

class Help extends StatelessWidget {
  const Help({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Ajuda'),
        ),
        body: SafeArea(
          child: Center(
            child: Padding(
              padding: EdgeInsets.all(36.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Seja bem vindo ao População Online!',
                    textScaleFactor: 1.5,
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 36),
                  RichText(
                    textScaleFactor: 1.5,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "O botão ",
                        ),
                        WidgetSpan(
                          child: Icon(Icons.add_to_photos, size: 14),
                        ),
                        TextSpan(
                          text:
                              " na tela inicial permite que você crie novas solicitações.",
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  RichText(
                    textScaleFactor: 1.5,
                    textAlign: TextAlign.center,
                    text: TextSpan(
                      children: [
                        TextSpan(
                          text: "Já o botão ",
                        ),
                        WidgetSpan(
                          child: Icon(Icons.ballot_rounded, size: 14),
                        ),
                        TextSpan(
                          text:
                              " lhe exibirá uma lista com todos os chamados que você segue.",
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ));
  }
}
