
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../components/button.dart';
import '../components/text_field.dart';

class ResgisterPage extends StatefulWidget {
 ResgisterPage({super.key,required this.onTap});
 void Function()? onTap;

  @override
  State<ResgisterPage> createState() => _ResgisterPageState();
}

class _ResgisterPageState extends State<ResgisterPage> {
  final emailController=TextEditingController();

  final passwordController=TextEditingController();

   final confirmpasswordController=TextEditingController();

  void signUp()async{
    showDialog(context: context, builder: (BuildContext context) => Center(child: CircularProgressIndicator()));

    if(passwordController.text!=confirmpasswordController.text){
      Navigator.pop(context);
      displayMessage("Password dno't match ");
      return;
    }
    try{
     UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text);

       FirebaseFirestore.instance.collection("Users").doc(userCredential.user!.email).set({
         'username':emailController.text.split('@')[0],
         'bio':'Empty bio..',
       });
      


        if(context.mounted) Navigator.pop(context);
    }on FirebaseAuthException catch(e){
      Navigator.pop(context);
      displayMessage(e.code);
    }

  }





 void displayMessage(String message){
   showDialog(context: context, builder: (BuildContext context)=>AlertDialog(
     title: Text(message),
   ));
 }




  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.grey[300],
      body: SafeArea(
        
        child: Center(

          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
              SizedBox(height: 50,),
              //login
               Icon(Icons.lock,size: 100,color: Colors.grey[800],),
                   SizedBox(height: 50,),

              //creat account massage
              const Text( "Let's create an account for you!",style: TextStyle(fontSize: 16),),
                 SizedBox(height: 25,),  
                  
              //email textfield
              MyTextField(controller: emailController, obscureText: false,hintText: 'Email',),
                 SizedBox(height: 10,),
                  
              //password extfield
                MyTextField(controller: passwordController, obscureText:true, hintText: 'Password', ),  
                   SizedBox(height:10,),
                   //password extfield
                MyTextField(controller: confirmpasswordController, obscureText:true, hintText: 'ConfirmPassword',),  
                   SizedBox(height: 25,),
              //sign in button
                MyButton(onTap: signUp, text: "Sign Up"),
                 SizedBox(height: 50,),  
                  
              //not a member? register now 
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                Text('Already a member?'),
                SizedBox(width: 4,),
                GestureDetector(onTap:widget.onTap ,child: Text('Login now',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),)),
              ],)
            ],),
          ),
        ),
      ),
    );
  }
}