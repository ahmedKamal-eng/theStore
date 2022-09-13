import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  CustomButton({ this.onTap,required this.text,this.color=Colors.white,this.textColor=Colors.black});
  String text;
  Color color;
  Color textColor;
  VoidCallback? onTap;
  @override
  Widget build(BuildContext context) {
    return  GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(10),
        height: 60,
        width: double.infinity,
        decoration: BoxDecoration(color: color,
            borderRadius: BorderRadius.circular(10)
        ),
        child: Center(child: Text('$text',style: TextStyle(fontSize: 25,color: textColor),),),
      ),
    );
  }
}