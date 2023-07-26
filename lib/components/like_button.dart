import 'package:flutter/material.dart';

class LikeButton extends StatelessWidget {
  const LikeButton({super.key,required this.isLike,required this.onTap});

final bool isLike;
final Function()? onTap;


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Icon(isLike? Icons.favorite : Icons.favorite_border,color: isLike? Colors.red:Colors.grey,),
    );
  }
}