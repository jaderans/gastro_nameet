import 'package:flutter/material.dart';
import 'package:gastro_nameet/pages/profile/profile_settings.dart';

class ProfileButton extends StatefulWidget {
  const ProfileButton({super.key});

  @override
  State<ProfileButton> createState() => _ProfileButtonState();
}

class _ProfileButtonState extends State<ProfileButton> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: (){
        Navigator.push(
          context, 
          MaterialPageRoute(builder: (context) => ProfilePage()
          ),
        );
      },
      child: CircleAvatar(
          radius: 22,
          backgroundColor: Colors.grey[200], // placeholder background
          backgroundImage: AssetImage('assets/images/profile_placeholder.jpg'), 
      ),
    );
  }
}