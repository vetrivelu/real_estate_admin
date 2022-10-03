import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:real_estate_admin/Modules/Project/project_controller.dart';
import 'package:real_estate_admin/Modules/Project/project_form.dart';
import 'package:real_estate_admin/Modules/Project/project_form_data.dart';
import 'package:real_estate_admin/Modules/Project/property_list.dart';

import '../../Model/Project.dart';

class ProjectList extends StatefulWidget {
  const ProjectList({Key? key}) : super(key: key);

  @override
  State<ProjectList> createState() => _ProjectListState();
}

final CollectionReference<Map<String, dynamic>> projects = FirebaseFirestore.instance.collection('projects');

class _ProjectListState extends State<ProjectList> {
  Query<Map<String, dynamic>> query = projects;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("PROJECTS"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          SizedBox(
            height: 100,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (context) {
                              return const AlertDialog(
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                                content: SizedBox(height: 800, width: 600, child: ProjectForm()),
                              );
                            });
                      },
                      child: const Text("Add")),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                      onPressed: () {
                        setState(() {});
                      },
                      child: const Text("Refresh")),
                )
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: StreamBuilder(
                stream: query.snapshots(),
                builder: (BuildContext context, AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                  if ((snapshot.connectionState == ConnectionState.active || snapshot.connectionState == ConnectionState.done) && snapshot.hasData) {
                    List<Project> projectslist = snapshot.data!.docs.map((e) => Project.fromJson(e.data())).toList();
                    return GridView.count(
                      crossAxisCount: 4,
                      children: projectslist.map((e) => ProjectTile(project: e)).toList(),
                    );
                  }
                  if (snapshot.hasError) {
                    return Center(
                      child: SelectableText(snapshot.error.toString()),
                    );
                  }
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                },
              ),
            ),
          )
        ],
      ),
    );
  }
}

class ProjectTile extends StatelessWidget {
  const ProjectTile({Key? key, required this.project}) : super(key: key);
  final Project project;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Column(
        children: [
          AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.network(
              project.coverPhoto ?? 'https://picsum.photos/id/1/200/300',
              fit: BoxFit.cover,
            ),
          ),
          Divider(),
          ListTile(
            title: Text(project.name),
            subtitle: Text(project.location),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: () {
                        Get.to(() => PropertyList(project: project));
                      },
                      child: const Text("VIEW PROPERTIES"),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () {
                      var projectController = ProjectController(ProjectFormData.fromProject(project));
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
                                  child: ProjectForm(
                                    project: project,
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
    );
  }
}
