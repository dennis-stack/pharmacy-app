import 'package:flutter/material.dart';

class TextField extends StatelessWidget {
  final String label;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool obscureText;
  final IconData? icon;

  const TextField({
    Key? key,
    required this.label,
    this.validator,
    this.controller,
    this.obscureText = false,
    this.icon,
    required String hintText,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: label,
        icon: icon != null ? Icon(icon) : null,
      ),
      obscureText: obscureText,
      validator: validator,
      controller: controller,
    );
  }
}
