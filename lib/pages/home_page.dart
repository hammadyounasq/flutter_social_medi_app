import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/drawer.dart';
import 'package:socialmediaapp/components/wall_post.dart';
import 'package:socialmediaapp/helper/helper_method.dart';
import 'package:socialmediaapp/pages/profile_page.dart';

import '../components/text_field.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
 
 final currentuser=FirebaseAuth.instance.currentUser!;
 final textController=TextEditingController();


  Future<void>signout()async{
  return await FirebaseAuth.instance.signOut();
  }


  void postMessage(){
   if(textController.text.isNotEmpty){
     FirebaseFirestore.instance.collection('User Posts').add({
       'UserEmail':currentuser.email,
        'Message':textController.text,
        'TimeStamp':Timestamp.now(),
        'Likes':[],

     });
   }
   setState(() {
     textController.clear();
   });

  }




void goToProfilePage(){
  Navigator.pop(context);
   Navigator.push(context,MaterialPageRoute(builder: (context)=>ProfilePage()));
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.background,
      
      appBar: AppBar(
      
        title: Text('The Wall'),
        actions: [
        IconButton(
          onPressed:signout ,
           icon: Icon(
             Icons.logout_outlined),),
      ],),
      drawer: MyDrawer(onProfileTap: goToProfilePage, onSignOut: signout,),
      body: Center(
        child: Column(children: [
          // the wall
        Expanded(
          child: StreamBuilder(
           stream: 
           FirebaseFirestore.instance
           .collection('User Posts')
           .orderBy('TimeStamp',descending: false).
           snapshots(),
           builder: (context,snapshot){
             if(snapshot.hasData){
               return ListView.builder(
                 itemCount: snapshot.data!.docs.length,
                 itemBuilder: (context,index){
                   final post=snapshot.data!.docs[index];
                   return WallPost(
                     message: post['Message'], 
                     user: post['UserEmail'],
                     postId: post.id,
                     like: List<String>.from(post['Likes']??[]), 
                     time: formatDate(post['TimeStamp']),);

               }
               );
             }else if(snapshot.hasError){ 
               return Center(child: Text('Error:${snapshot.error.toString()}'));
             }
             return Center(child: CircularProgressIndicator());
           },
        )),
      
      
      
          // post message
         
         Padding(
           padding: const EdgeInsets.all(25.0),
           child: Row(children: [
             Expanded(
               child: MyTextField(
                 controller: textController, hintText: 'Write something on the wall..', obscureText: false,),
                 ),
                 IconButton(onPressed: postMessage, icon:Icon(Icons.arrow_circle_up),),
           ],
           ),
         ),
      
          // login as
      
          Text("logged in as: "+currentuser.email!,style: TextStyle(color: Colors.grey ),),
          SizedBox(height: 50,)
        ]),
      ),
    );
  }
}