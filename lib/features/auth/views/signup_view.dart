import 'package:flutter/material.dart';
import 'package:movixapp/core/constants/app_colors.dart';
import 'package:movixapp/features/auth/widgets/custom_auth_appbar.dart';
import 'package:movixapp/Widgets/custom_text.dart';
import 'package:movixapp/Widgets/custom_text_field.dart';
class SignupView extends StatelessWidget {
  const SignupView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: CustomAppbar(
        title: "Sign Up",
        back: true,
        onPressed: () {
          Navigator.pop(context);
        },
      ),
      body:  Padding(padding: EdgeInsets.all(15),
         child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
               children:[
          CustomText(text: "Name", weight:FontWeight.w600),
          SizedBox(height :12),
          CustomTextfield(hint:"Enter your name",
               isPass:false,controller: TextEditingController(),
               icon: Icons.person_2_outlined,
               ),
            
          
               ]
               ),
       )
        
      
    );
  }
}
