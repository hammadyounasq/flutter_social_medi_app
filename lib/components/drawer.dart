import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/my_list_tille.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key,required this.onProfileTap,required this.onSignOut});
  final Function()? onProfileTap;
  final Function()? onSignOut;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.grey[900],
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
        Column(children: [
           DrawerHeader(
           child: Icon(
             Icons.person,color: Colors.white,size: 64 ,),
             ),

             MyListTile(icon: Icons.home, text: 'H O M E',onTap: ()=>Navigator.pop(context),),
             MyListTile(icon: Icons.person, text: 'P R O F I L E', onTap: onProfileTap),
        ],),
             Padding(
               padding: const EdgeInsets.only(bottom: 25.0),
               child: MyListTile(icon: Icons.logout, text: 'L O G O U T', onTap: onSignOut),
             ),

        ],
        ),
    );
  }
}