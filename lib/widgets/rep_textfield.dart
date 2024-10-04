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
          maxLines: !isForDescription ? 6 : null,
          cursorHeight: !isForDescription ? 50 : null,
          cursorColor: Theme.of(context).colorScheme.inversePrimary,
          style: TextStyle(color: Theme.of(context).colorScheme.inversePrimary),
          decoration: InputDecoration(
              border: isForDescription ? InputBorder.none : null,
              counter: Container(),
              hintText: isForDescription ? AppStr.addNote : null,
              prefixIcon: isForDescription ? const Icon(Icons.bookmark) : null,
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              focusedErrorBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                color: Colors.blue.shade300,
              ))),
        ),
      ),
    );
  }
}
