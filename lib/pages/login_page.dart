import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:socialmediaapp/components/button.dart';
import 'package:socialmediaapp/components/text_field.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key,required this.onTap});
  final void Function()? onTap;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  
  final emailTextController=TextEditingController();
  final passwordTextController=TextEditingController();

 void singnIn()async{
showDialog(context: context, builder: (BuildContext context)=>Center(child: CircularProgressIndicator()));

try{
     await FirebaseAuth.instance.signInWithEmailAndPassword(
       email: emailTextController.text, 
       password: passwordTextController.text);
       if(context.mounted) Navigator.pop(context);

}on FirebaseAuthException catch(e){
  if(context.mounted) Navigator.pop(context);
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
            padding: const EdgeInsets.symmetric(horizontal: 25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children:[
             
                  
                // logo
                 Icon(Icons.lock,size: 100,),
                 SizedBox(height: 50,),
                  
                 // welcome back message
            Text("Welcome back, yo've been missed!" ),
              SizedBox(height: 25,),
                  
            MyTextField(controller: emailTextController, hintText: 'Email', obscureText: false,),
            SizedBox(height: 10,),
              
             MyTextField(controller: passwordTextController, hintText: 'Password', obscureText: true,),
             SizedBox(height: 10,),

             MyButton(onTap: singnIn, text: 'Sign In'),
              SizedBox(height: 25,),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('Not a member?',style: TextStyle(color: Colors.grey[700],),),
                SizedBox(width: 4,),
                GestureDetector(onTap: widget.onTap,child: Text('Register now',style: TextStyle(fontWeight: FontWeight.bold,color: Colors.blue),))
              ],)

              
            ],),
          ),
        ),
      ),
    );
  }
}
