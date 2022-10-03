import 'package:flutter/material.dart';
import '../Model/Property.dart';

class PropertyTile extends StatelessWidget {
  const PropertyTile({Key? key, required this.property}) : super(key: key);

  final Property property;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          ListTile(
            title: Text(property.title),
            subtitle: Text(property.taluk ?? ''),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              property.description ?? '',
              style: TextStyle(color: Colors.black.withOpacity(0.6)),
            ),
          ),
          property.coverPhoto == null
              ? Container()
              : AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(property.coverPhoto!),
                ),
        ],
      ),
    );
  }
}
