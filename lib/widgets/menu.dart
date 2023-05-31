import 'package:app/web/web_home.dart';
import 'package:app/web/web_requests.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:getwidget/getwidget.dart';

class Menu extends StatelessWidget {
  const Menu({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 3,
      child: Container(
        color: Color.fromARGB(255, 61, 61, 61),
        height: MediaQuery.of(context).size.height,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.all(36),
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  border: Border.all(width: 2, color: Colors.grey)),
              child: Icon(
                Icons.person,
                size: MediaQuery.of(context).size.height * .05,
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
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
              child: GFButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return WebHome();
                      },
                    ),
                  );
                },
                text: "Inicio",
                shape: GFButtonShape.pills,
                fullWidthButton: true,
                color: Colors.grey,
                type: GFButtonType.outline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
              child: GFButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute<void>(
                      builder: (BuildContext context) {
                        return WebRequest();
                      },
                    ),
                  );
                },
                text: "Solicitações",
                shape: GFButtonShape.pills,
                fullWidthButton: true,
                color: Colors.grey,
                type: GFButtonType.outline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
              child: GFButton(
                onPressed: () {},
                text: "Gerenciar Usuários",
                shape: GFButtonShape.pills,
                fullWidthButton: true,
                color: Colors.grey,
                type: GFButtonType.outline,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 5, 20, 10),
              child: GFButton(
                onPressed: () {},
                text: "Sair",
                shape: GFButtonShape.pills,
                fullWidthButton: true,
                color: Colors.grey,
                type: GFButtonType.outline,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
