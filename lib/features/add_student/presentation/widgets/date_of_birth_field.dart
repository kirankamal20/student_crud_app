import 'package:flutter/material.dart';

class DateOfBirthField extends StatelessWidget {
  final TextEditingController dateInputcontroller;

  final Function(String?) onChanged;
  final Function() onTap;
  const DateOfBirthField(
      {super.key,
      required this.dateInputcontroller,
      required this.onChanged,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 3, bottom: 7),
            child: Text(
              "Date of birth",
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          TextFormField(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            controller: dateInputcontroller,
            decoration: InputDecoration(
              hintText: "Enter the Date of Birth",
              suffixIcon: const Icon(
                Icons.calendar_today,
              ),
              contentPadding: const EdgeInsets.all(10),
              hintStyle: const TextStyle(color: Colors.grey),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
              filled: true,
              fillColor: Colors.white,
            ),
            readOnly: true,
            onTap: () async {
              onTap();
            },
            validator: (value) {
              return value!.isEmpty ? "Enter the Date of birth" : null;
            },
            onChanged: (v) {
              onChanged(v);
            },
          ),
        ],
      ),
    );
  }
}
