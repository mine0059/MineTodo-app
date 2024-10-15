import 'package:flutter/material.dart';
import 'package:mine_todo_app/utils/app_strings.dart';

class RepTextfield extends StatelessWidget {
  const RepTextfield({
    required this.controller,
    super.key,
    this.isForDescription = false,
  });
  final TextEditingController? controller;

  final bool isForDescription;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: ListTile(
        title: TextFormField(
          controller: controller,
          // maxLines: !isForDescription ? 1 : null,
          // cursorHeight: !isForDescription ? 25 : null,
          cursorColor: Theme.of(context).colorScheme.inversePrimary,
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          decoration: InputDecoration(
            border: UnderlineInputBorder(
              borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.inversePrimary,
                  width: 3),
            ),
            counter: Container(),
            hintText: isForDescription ? AppStr.addNote : 'Add Title',
            prefixIcon: isForDescription
                ? const Icon(Icons.description)
                : const Icon(Icons.title),
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(
                color: Theme.of(context).colorScheme.onPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
