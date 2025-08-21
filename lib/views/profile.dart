import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_b23_firebase/providers/user.dart';
import 'package:flutter_b23_firebase/views/update_profile.dart';
import 'package:provider/provider.dart';

class ProfileDemo extends StatelessWidget {
  const ProfileDemo({super.key});

  @override
  Widget build(BuildContext context) {
    var userProvider = Provider.of<UserProvider>(context);
    return Scaffold(
      appBar: AppBar(title: Text("Profile")),
      body: Column(
        children: [
          Text(
            "Name: ${userProvider.getUser().name}",
            style: TextStyle(fontSize: 30),
          ),
          Text(
            "Phone: ${userProvider.getUser().phone}",
            style: TextStyle(fontSize: 30),
          ),
          Text(
            "Email: ${userProvider.getUser().email}",
            style: TextStyle(fontSize: 30),
          ),
          Text(
            "Address: ${userProvider.getUser().address.toString()}",
            style: TextStyle(fontSize: 30),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UpdateProfileView()),
              );
            },
            child: Text("Edit Profile"),
          ),
        ],
      ),
    );
  }
}
