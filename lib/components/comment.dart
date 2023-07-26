import 'package:flutter/material.dart';

class Comment extends StatelessWidget {
  const Comment({super.key,required this.text,required this.user,required this.time});
 final String user;
 final String text;
 final String time;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary,
        borderRadius: BorderRadius.circular(4),
      ),
      margin: EdgeInsets.only(bottom: 5),
      padding: EdgeInsets.all(15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(text),
        SizedBox(height: 5,),
        Row(
          children: [
            Text(user,style: TextStyle(color: Colors.grey[400]),),
            Text(".",style: TextStyle(color: Colors.grey[400]),),
            Text(time,style: TextStyle(color: Colors.grey[400]),),
          ],
        ),
        
      ],),
    );
  }
}