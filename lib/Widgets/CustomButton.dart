import 'package:chaty/Constants.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({super.key, required this.text, required this.ontap});
  final String text;
  final VoidCallback ontap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: ontap,
      child: Center(
        child: Container(
          height: 50,
          width: 120,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Center(
            child: Text(
              text,
              style: const TextStyle(
                color: KSecColor,
                fontSize: 22,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
