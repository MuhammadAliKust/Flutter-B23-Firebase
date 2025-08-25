import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_b23_firebase/models/priority.dart';
import 'package:flutter_b23_firebase/models/task.dart';
import 'package:flutter_b23_firebase/providers/user.dart';
import 'package:flutter_b23_firebase/services/priority.dart';
import 'package:flutter_b23_firebase/services/task.dart';
import 'package:flutter_b23_firebase/services/upload_file.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateTaskView extends StatefulWidget {
  CreateTaskView({super.key});

  @override
  State<CreateTaskView> createState() => _CreateTaskViewState();
}

class _CreateTaskViewState extends State<CreateTaskView> {
  TextEditingController titleController = TextEditingController();

  TextEditingController descriptionController = TextEditingController();

  bool isLoading = false;

  List<PriorityModel> priorityList = [];

  PriorityModel? selectedPriority;

  File? image;

  @override
  void initState() {
    PriorityServices().getAllPrioritiesViaFuture().then((val) {
      priorityList = val;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Create Task")),
      body: Column(
        children: [
          ElevatedButton(
            onPressed: () {
              ImagePicker().pickImage(source: ImageSource.camera).then((val) {
                image = File(val!.path);
                setState(() {});
              });
            },
            child: Text("Pick Image"),
          ),
          if (image != null) Image.file(image!, height: 200),
          TextField(controller: titleController),
          TextField(controller: descriptionController),
          SizedBox(height: 10),
          DropdownButton(
            items: priorityList.map((priority) {
              return DropdownMenuItem(
                child: Text(priority.name.toString()),
                value: priority,
              );
            }).toList(),
            hint: Text("Select Priority"),
            value: selectedPriority,
            isExpanded: true,
            onChanged: (val) {
              selectedPriority = val;
              setState(() {});
            },
          ),
          SizedBox(height: 20),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () async {
                    if (titleController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Title cannot be empty.")),
                      );
                      return;
                    }
                    if (descriptionController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Description cannot be empty.")),
                      );
                      return;
                    }

                    try {
                      isLoading = true;
                      setState(() {});
                      await UploadFileServices().uploadImage(image).then((
                        imageUrl,
                      ) async {
                        await TaskServices()
                            .createTask(
                              TaskModel(
                                title: titleController.text,
                                description: descriptionController.text,
                                isCompleted: false,
                                image: imageUrl,
                                userID: userProvider.getUser().docId.toString(),
                                priorityID: selectedPriority!.docId.toString(),
                                createdAt:
                                    DateTime.now().millisecondsSinceEpoch,
                              ),
                            )
                            .then((val) {
                              isLoading = false;
                              setState(() {});
                              showDialog(
                                context: context,
                                builder: (context) {
                                  return AlertDialog(
                                    title: Text("Message"),
                                    content: Text(
                                      "Task has been created successfully",
                                    ),
                                    actions: [
                                      TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                          Navigator.pop(context);
                                        },
                                        child: Text("Okay"),
                                      ),
                                    ],
                                  );
                                },
                              );
                            });
                      });
                    } catch (e) {
                      isLoading = false;
                      setState(() {});
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: Text("Create Task"),
                ),
        ],
      ),
    );
  }
}
