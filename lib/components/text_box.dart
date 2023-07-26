import 'package:flutter/material.dart';

class TextBox extends StatelessWidget {
  const TextBox({super.key,required this.sectionName,required this.text,required this.onTap});
  final String text;
  final String sectionName;
  final Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 20,right: 20,top: 20),
      padding: EdgeInsets.only(left: 15,bottom: 15),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
        

      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
        
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            Text(sectionName,style: TextStyle(color: Colors.grey[500]),),
            IconButton(
              onPressed: onTap, 
              icon: Icon(Icons.settings,color: Colors.grey[400],),),
          ],
        ),
        Text(text,),
     

      ],),
    );
  }
}