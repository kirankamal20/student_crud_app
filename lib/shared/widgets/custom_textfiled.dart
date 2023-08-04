import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final TextEditingController? controller;
  final String tittle;
  final String? Function(String?) validator;
  final TextInputType? textInputType;
  const CustomTextField({
    Key? key,
    required this.hintText,
    this.controller,
    required this.validator,
    required this.tittle,
    this.textInputType,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 3, bottom: 10),
            child: Text(
              tittle,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: controller,
            keyboardType: textInputType,
            style: const TextStyle(fontSize: 16),
            decoration: InputDecoration(
              hintText: hintText,
              contentPadding: const EdgeInsets.all(10),
              hintStyle: const TextStyle(color: Colors.grey),
              border: const OutlineInputBorder(),
              filled: true,
              fillColor: Colors.white,
            ),
            validator: validator,
          ),
        ],
      ),
    );
  }
}
