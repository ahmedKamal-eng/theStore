import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField({Key? key,this.labelText,this.onChange,this.textInputType,this.controller}) : super(key: key);
  final String? labelText;
  Function(String)? onChange;
   TextInputType? textInputType;
   TextEditingController? controller;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      keyboardType: textInputType,

      validator: (data){
        if(data!.isEmpty)
        {
          return 'field empty';
        }
      },
      onChanged: onChange,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle:const TextStyle(color: Colors.white),
        border:const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
        enabledBorder:const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
        ),
      ),
    );
  }
}