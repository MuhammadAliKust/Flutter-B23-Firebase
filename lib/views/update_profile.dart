import 'package:flutter/material.dart';
import 'package:flutter_b23_firebase/models/user.dart';
import 'package:flutter_b23_firebase/providers/user.dart';
import 'package:flutter_b23_firebase/services/user.dart';
import 'package:provider/provider.dart';

class UpdateProfileView extends StatefulWidget {
  const UpdateProfileView({super.key});

  @override
  State<UpdateProfileView> createState() => _UpdateProfileViewState();
}

class _UpdateProfileViewState extends State<UpdateProfileView> {
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController addressController = TextEditingController();
  bool isLoading = false;

  @override
  void initState() {
    var userProvider = Provider.of<UserProvider>(context, listen: false);
    nameController = TextEditingController(text: userProvider.getUser().name);
    phoneController = TextEditingController(text: userProvider.getUser().phone);
    addressController = TextEditingController(
      text: userProvider.getUser().address,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Update Profile")),
      body: Column(
        children: [
          TextField(controller: nameController),
          TextField(controller: phoneController),
          TextField(controller: addressController),
          SizedBox(height: 20),
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ElevatedButton(
                  onPressed: () async {
                    if (nameController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Name cannot be empty.")),
                      );
                      return;
                    }
                    if (phoneController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Phone cannot be empty.")),
                      );
                      return;
                    }
                    if (addressController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Address cannot be empty.")),
                      );
                      return;
                    }
                    try {
                      isLoading = true;
                      setState(() {});
                      await UserServices()
                          .updateUser(
                            UserModel(
                              name: nameController.text,
                              phone: phoneController.text,
                              address: addressController.text,
                              docId: userProvider.getUser().docId.toString(),
                            ),
                          )
                          .then((val) async {
                            await UserServices()
                                .getUserByID(
                                  userProvider.getUser().docId.toString(),
                                )
                                .then((val) {
                                  userProvider.setUser(val);
                                });
                            isLoading = false;
                            setState(() {});

                            showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  title: Text("Message"),
                                  content: Text(
                                    "Profile has been updated successfully",
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
                    } catch (e) {
                      isLoading = false;
                      setState(() {});
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text(e.toString())));
                    }
                  },
                  child: Text("Update Profile"),
                ),
        ],
      ),
    );
  }
}
