import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/text_box.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final current=FirebaseAuth.instance.currentUser!;
  final usersCollection = FirebaseFirestore.instance.collection('Users');



  Future<void> eidField(String field)async{
  String newValue="";

  await showDialog(
    context: context,
    builder: (context)=>AlertDialog(
      backgroundColor: Colors.grey[900],
      title: Text('Edit'+field,style: TextStyle(color: Colors.white),),
      content: TextField(autofocus: true,style: TextStyle(color: Colors.white),
      decoration:
       InputDecoration(hintText: "Enter new $field",
       hintStyle: TextStyle(color: Colors.grey),
      ),
      onChanged: (value){
        newValue=value;
      },
      ),
      actions: [
        TextButton(
          onPressed: ()=>Navigator.pop(context),
           child: Text('Cancel',style: TextStyle(color: Colors.white),),),

           TextButton(
          onPressed: ()=>Navigator.of(context).pop(newValue),
           child: Text('Save',style: TextStyle(color: Colors.white),),),
      ],
    )
    );
    if(newValue.trim().length>0){
      await usersCollection.doc(current.email).update({field:newValue});
    }

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      appBar: AppBar( title: Text('Profile Page'),),

      body: StreamBuilder(stream: FirebaseFirestore.instance.collection('Users').doc(current.email).snapshots(),
      builder: (context,snapshot){
        if(snapshot.hasData){
          final userData=snapshot.data!.data() as Map<String,dynamic>;
          return ListView(
        children: [
          SizedBox(height: 50,),
          Icon(Icons.person,size: 72,),
          SizedBox(height: 10,),

          Text(current.email!,textAlign: TextAlign.center,style: TextStyle(color: Colors.grey[700]),),
          SizedBox(height: 50,),

          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text('My Details',style: TextStyle(color: Colors.grey[600]),),
          ),

          TextBox(sectionName: 'userName', text: userData['username'],onTap: () => eidField('username'),),
          TextBox(sectionName: 'empty bio', text: userData['bio'],onTap: () => eidField('bio'),),
           
           SizedBox(height: 50,),

          Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Text('My Post',style: TextStyle(color: Colors.grey[600]),),
          ),
        ],
      );
        } else if(snapshot.hasError){
          return Center(child: Text('Error:${snapshot.error}'));
        }
        return Center(child: CircularProgressIndicator());

      }),
    );
  }
}