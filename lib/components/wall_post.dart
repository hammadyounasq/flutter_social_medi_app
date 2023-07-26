import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/comment.dart';
import 'package:socialmediaapp/components/comment_button.dart';
import 'package:socialmediaapp/components/delete_button.dart';
import 'package:socialmediaapp/components/like_button.dart';
import 'package:socialmediaapp/helper/helper_method.dart';

class WallPost extends StatefulWidget {
  const WallPost({super.key,required this.message,required this.user,required this.postId,required this.like,required this.time});

  final String message;
  final String user;
  final String postId;
  final String time;
  final List<String> like;

  @override
  State<WallPost> createState() => _WallPostState();
}

class _WallPostState extends State<WallPost> {

final currentUser=FirebaseAuth.instance.currentUser!;
bool isLike=false;

final commentTextController=TextEditingController();

@override
  void initState() {
     super.initState();
     isLike=widget.like.contains(currentUser.email);
  }

  void toggle(){
    setState(() {
      isLike=!isLike;
    });

  DocumentReference postRef=FirebaseFirestore.instance.collection('User Posts').doc(widget.postId);

  if(isLike){
    postRef.update({
      'Likes':FieldValue.arrayUnion([currentUser.email])
    });
  }else{
    postRef.update({
      'Likes':FieldValue.arrayRemove([currentUser.email])
    });
  }

  }


void addComment(String commentText){
  FirebaseFirestore.instance.collection('User Posts').doc(widget.postId).collection('comments').add({
  "CommentText":commentText,
  "CommentedBy":currentUser.email,
  "CommentTime":Timestamp.now(),
  });
}


void showCommentDialod(){
  showDialog(context: context, builder: (context)=>AlertDialog(
  title: Text('Add Comment'),
  content: TextField(
    controller: commentTextController,
    decoration: InputDecoration(
      hintText: 'Write a comment',
    ),
    
    ),
    actions: [
      TextButton(onPressed: (){
        Navigator.pop(context);
        commentTextController.clear();
      }, child: Text('Cancel'),),
      TextButton(onPressed: (){
        addComment(commentTextController.text);
         Navigator.pop(context);
        commentTextController.clear();
      }, child: Text('Post'),),
       

      
    ],
  ),);
}

void deletePost(){
  showDialog(context: context, builder: (context)=>AlertDialog(
    title: Text('Delete Post'),
    content: Text('Are you sure you want to delete this post?'),
    actions: [
      TextButton(onPressed: ()=>Navigator.pop(context), child: Text('Cancel'),),
       TextButton(onPressed: ()async{
         final commentDocs=await FirebaseFirestore.instance.collection('User Posts').doc(widget.postId).collection('comments').get();
         for(var doc in commentDocs.docs){
           await FirebaseFirestore.instance
           .collection('User Posts')
           .doc(widget.postId)
           .collection('comments').doc(doc.id).delete();

         }

         await FirebaseFirestore.instance.collection('User Posts').doc(widget.postId).delete().then((value) => print('post delete')).catchError((error)=>print('failed to delete post: $error'));
         Navigator.pop(context);

       }
       , child: Text('Delete'),),
    ],
  ));
}
  

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(8),
        ),
      
      margin:  EdgeInsets.only(top: 25,left: 25,right: 25),
      padding: EdgeInsets.all(25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [  

       Row(

         mainAxisAlignment: MainAxisAlignment.spaceBetween,
         crossAxisAlignment: CrossAxisAlignment.start,

         children: [
           Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [

              Text(widget.message),

             SizedBox(height: 5,),

              Row(
              children: [
                Text(widget.user,style: TextStyle(color: Colors.grey[400]),),
                Text(".",style: TextStyle(color: Colors.grey[400]),),
                Text(widget.time,style: TextStyle(color: Colors.grey[400]),),
              ],
            ),
            
           ],
           ),
           if(widget.user==currentUser.email)
              DeleteButton(onTap: deletePost),
         ],
       ),

        SizedBox(height: 20,),

       Row(
         mainAxisAlignment: MainAxisAlignment.center,
         children: [
           //LIKE
           Column(
             children: [
                LikeButton(isLike: isLike,
                 onTap: toggle),

                SizedBox(height: 5,),

                Text(widget.like.length.toString(),style: TextStyle(color: Colors.grey),),
              ],
              ),
               SizedBox(width: 10,),
             // COMMENT
              Column(
             children: [
                CommentButton(onTap: showCommentDialod),

                SizedBox(height: 5,),

                Text('0',style: TextStyle(color: Colors.grey),),
              ],
              ),
              
         ],
       ),
       SizedBox(height: 20,),
      // comments under the post
      StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('User Posts').doc(widget.postId).collection('comments').orderBy('CommentTime',descending: true).snapshots() ,
        builder: (context,snapshot){

          if(!snapshot.hasData){
            return Center(
              child: CircularProgressIndicator(),
            );
          }
          return ListView(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            children: snapshot.data!.docs.map((doc){
              final commenData=doc.data() as Map<String,dynamic>;
              return Comment(
                text: commenData['CommentText'],
                 user: commenData['CommentedBy'],
                  time: formatDate(commenData['CommentTime']),);
            }).toList(),
          );
        
         
        }),

      ],
      ),
    );
  }
}