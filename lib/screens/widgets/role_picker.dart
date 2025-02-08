import 'package:flutter/material.dart';

class RolePicker {
  static void show({
    required BuildContext context,
    required List<String> roles,
    required Function(String) onRoleSelected,
  }) {
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.symmetric(vertical: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              for (var i = 0; i < roles.length; i++) ...[
                ListTile(
                  title: Text(roles[i]),
                  onTap: () {
                    onRoleSelected(roles[i]);
                    Navigator.pop(context);
                  },
                ),
                if (i < roles.length - 1)
                  Divider(
                    color: Colors.grey.shade300,
                    thickness: 1.0,
                    endIndent: 0,
                    indent: 0,
                  ),
              ],
            ],
          ),
        );
      },
    );
  }
}
