import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Dashboard extends StatelessWidget {
  const Dashboard({Key? key}) : super(key: key);

  Widget getTileCard({required String title, required String points}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Card(
          color: Colors.green,
          elevation: 12,
          // shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8))),
          child: Container()),
    );
  }

  Widget getFourTiles() {
    return Row(
      children: [
        getTileCard(title: 'Total Lead', points: '23'),
        getTileCard(title: 'Total Lead', points: '23'),
        getTileCard(title: 'Total Lead', points: '23'),
        getTileCard(title: 'Total Lead', points: '23'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          Expanded(
              flex: 8,
              child: Column(
                children: [
                  Expanded(
                      flex: 3,
                      child: Row(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Container(
                                height: double.maxFinite,
                                width: double.maxFinite,
                              ),
                            ),
                          ),
                          Text("data"),
                        ],
                      )),
                  Expanded(flex: 5, child: Container(color: Colors.red)),
                ],
              )),
          Expanded(flex: 3, child: Container(color: Colors.black)),
        ],
      ),
    );
  }
}
