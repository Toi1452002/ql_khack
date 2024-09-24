import 'package:flutter/material.dart';


class DropdownTextfieldSearch extends StatelessWidget {
  DropdownTextfieldSearch({super.key, this.controller, this.focusNode, this.onSubmitted});
  TextEditingController? controller;
  FocusNode? focusNode;
  void Function(String)? onSubmitted;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 25,
      child: TextField(
        controller: controller,
        style: const TextStyle(
          fontSize: 13
        ),
        onSubmitted: onSubmitted,
        textAlign: TextAlign.start,
        focusNode: focusNode,
        decoration: const InputDecoration(
          isDense: true,
          hintText: 'Search',
          // prefixIcon: Icon(Icons.search),
          contentPadding: EdgeInsets.symmetric(horizontal: 5,vertical: 10),
        ),
      ),
    );
  }
}
