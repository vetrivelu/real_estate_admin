import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:real_estate_admin/Modules/Project/project_controller.dart';
import 'package:real_estate_admin/Modules/Project/project_form_data.dart';

import '../../Model/Project.dart';
import '../../widgets/formfield.dart';
import '../../widgets/future_dialog.dart';

class ProjectForm extends StatefulWidget {
  const ProjectForm({Key? key, this.project}) : super(key: key);

  final Project? project;

  @override
  State<ProjectForm> createState() => _ProjectFormState();
}

class _ProjectFormState extends State<ProjectForm> {
  @override
  void initState() {
    if (widget.project != null) {
      controller = ProjectFormData.fromProject(widget.project!);
    } else {
      controller = ProjectFormData();
    }
    super.initState();
  }

  final name = TextEditingController();
  final location = TextEditingController();
  final type = TextEditingController();
  File? coverPhotoData;

  late ProjectFormData controller;

  Widget getCoverImage() {
    if (controller.coverPhototData != null) {
      return Stack(
        children: [
          Positioned.fill(
            child: Image.memory(
              controller.coverPhototData!,
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Container(
                color: Colors.black.withOpacity(0.1),
                child: Align(
                  alignment: Alignment.topRight,
                  child: IconButton(
                    onPressed: controller.removeCoverPhoto,
                    icon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                )),
          ),
        ],
      );
    }
    if (widget.project?.coverPhoto != null) {
      return Image.network(widget.project!.coverPhoto!);
    }
    return GestureDetector(
      onTap: () {
        controller.pickCoverPhoto().then((value) {
          setState(() {});
        });
      },
      child: const Center(
        child: Icon(Icons.add_a_photo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(child: AspectRatio(aspectRatio: 16 / 9, child: getCoverImage())),
          ),
          TileFormField(controller: controller.name, title: 'Project Name'),
          Row(
            children: [
              Expanded(child: TileFormField(controller: controller.location, title: 'Project Location')),
              Expanded(child: TileFormField(controller: controller.type, title: 'Project Type')),
            ],
          ),
          Container(
            height: 60,
            width: double.maxFinite,
            margin: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: () {
                var projectController = ProjectController(controller);

                var future = ((controller.docId ?? '').isEmpty) ? projectController.addProject() : projectController.updateProject();
                showFutureDialog(
                  context,
                  future: future,
                  onSucess: (result) {
                    Navigator.of(context).pop();
                    if (result is Project) {}
                  },
                );
              },
              child: const Text("SAVE PROJECT"),
            ),
          ),
        ],
      ),
    );
  }

  // List<Widget> getPropertyWidgets(List<Property> properties) {
  //   return properties.map((e) => )
  // }
}
