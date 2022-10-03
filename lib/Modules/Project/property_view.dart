import 'package:flutter/material.dart';
import 'package:real_estate_admin/Model/Property.dart';
import 'package:real_estate_admin/helper.dart';

class PropertyView extends StatelessWidget {
  const PropertyView({Key? key, this.property}) : super(key: key);

  final Property? property;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
      ),
      floatingActionButton: ButtonBar(
        children: [
          ElevatedButton(onPressed: () {}, child: Text("SELL")),
          ElevatedButton(onPressed: () {}, child: Text("SELL")),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            property?.title ?? "TITLE",
            style: getText(context).headline2!,
          ),
          Table(
            children: const [
              TableRow(children: [
                Text("Description"),
                Text("Description"),
              ])
            ],
          ),
        ],
      ),
    );
  }
}
