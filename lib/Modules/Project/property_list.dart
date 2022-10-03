import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:real_estate_admin/Model/Project.dart';
import 'package:real_estate_admin/Model/Property.dart';
import 'package:real_estate_admin/Modules/Project/project_controller.dart';
import 'package:real_estate_admin/Modules/Project/project_form_data.dart';
import 'package:real_estate_admin/Modules/Project/property_form.dart';
import 'package:real_estate_admin/Modules/Project/property_view.dart';

class PropertyList extends StatefulWidget {
  const PropertyList({Key? key, required this.project}) : super(key: key);

  final Project project;

  @override
  State<PropertyList> createState() => _PropertyListState();
}

class _PropertyListState extends State<PropertyList> {
  Property? selectedProperty;
  void Function(void Function())? reloadPropertyView;

  @override
  Widget build(BuildContext context) {
    var controller = ProjectController(ProjectFormData.fromProject(widget.project));
    return ChangeNotifierProvider(
      create: (context) => controller,
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.project.name),
        ),
        body: Row(
          children: [
            Expanded(
                flex: 4,
                child: Card(
                  child: Column(
                    children: [
                      AppBar(
                        title: Text(
                          "PROPERTY LIST",
                          style: Theme.of(context).textTheme.titleSmall!.copyWith(color: Colors.black),
                        ),
                        centerTitle: true,
                        backgroundColor: Colors.white,
                        actions: [
                          ElevatedButton(
                              onPressed: () {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                        content: SizedBox(height: 800, width: 600, child: PropertyForm(project: widget.project)),
                                      );
                                    });
                              },
                              child: const Text("ADD"))
                        ],
                      ),
                      SizedBox(
                        height: 60,
                        width: double.maxFinite,
                        child: Card(
                          child: TextFormField(),
                        ),
                      ),
                      Expanded(
                        child: StreamBuilder<List<Property>>(
                            stream: controller.getPropertiesAsStream(),
                            builder: (context, AsyncSnapshot<List<Property>> snapshot) {
                              if (snapshot.connectionState == ConnectionState.active && snapshot.hasData) {
                                if (snapshot.data!.isEmpty) {
                                  return const Center(
                                    child: Text("No Properties for this project"),
                                  );
                                } else {
                                  return StatefulBuilder(builder: (context, reload) {
                                    return GridView.count(
                                      childAspectRatio: 2.5 / 3,
                                      crossAxisCount: 3,
                                      padding: const EdgeInsets.all(8),
                                      children: snapshot.data!
                                          .map((e) => GestureDetector(
                                                onTap: () {
                                                  reload(() {
                                                    selectedProperty = e;
                                                  });
                                                  if (reloadPropertyView != null) {
                                                    reloadPropertyView!(() {});
                                                  }
                                                },
                                                child: PropertyTile(
                                                  property: e,
                                                  selected: e.docId == selectedProperty?.docId,
                                                ),
                                              ))
                                          .toList(),
                                    );
                                  });
                                }
                              }
                              if (snapshot.hasError) {
                                return Center(
                                  child: SelectableText(snapshot.data.toString()),
                                );
                              }
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }),
                      ),
                    ],
                  ),
                )),
            Expanded(
                flex: 4,
                child: Builder(builder: (context) {
                  return StatefulBuilder(builder: (context, reload) {
                    reloadPropertyView = reload;
                    return PropertyView(property: selectedProperty);
                  });
                })),
          ],
        ),
      ),
    );
  }
}

class PropertyTile extends StatelessWidget {
  const PropertyTile({Key? key, required this.property, this.selected = false}) : super(key: key);

  final Property property;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    var projectController = Provider.of<ProjectController>(context);

    return Container(
      color: selected ? Colors.blue : Colors.white,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              AspectRatio(
                aspectRatio: 16 / 9,
                child: Image.network(
                  property.coverPhoto ?? 'https://picsum.photos/id/1/200/300',
                  fit: BoxFit.cover,
                ),
              ),
              const Divider(),
              ListTile(
                title: Text(
                  property.title,
                  overflow: TextOverflow.ellipsis,
                ),
                selected: selected,
                isThreeLine: true,
                subtitle: Text(
                  property.description ?? '',
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    TextButton(
                        onPressed: () {
                          projectController.deleteProject();
                        },
                        child: const Text("DELETE")),
                    TextButton(
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                  content: SizedBox(
                                      height: 800,
                                      width: 600,
                                      child: PropertyForm(
                                        property: property,
                                        project: projectController.projectFormData.object,
                                      )),
                                );
                              });
                        },
                        child: const Text("EDIT")),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
