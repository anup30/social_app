import 'package:flutter/material.dart';

class UserTile extends StatelessWidget {
  final Map<String, dynamic> userInfo;
  final void Function()? onTap;
  const UserTile({
    super.key,
    required this.userInfo,
    this.onTap
  });
  @override
  Widget build(BuildContext context) {
    // return GestureDetector(
    //   onTap: onTap, // go to chat page with that user
    //   child: Center(
    //     child: Container(
    //       width: 300,
    //       decoration: BoxDecoration(
    //         color: Theme.of(context).colorScheme.secondary,
    //         borderRadius: BorderRadius.circular(12),
    //       ),
    //       margin: const EdgeInsets.symmetric(vertical: 4),
    //       padding: const EdgeInsets.all(20),
    //       child: Row(
    //         mainAxisSize: MainAxisSize.min,
    //         children: [
    //           const Icon(Icons.person),
    //           const SizedBox(width: 20),
    //           Text(userInfo["email"]), // or handle
    //         ],
    //       ),
    //     ),
    //   ),
    // );
    return ListTile(
      leading: const Icon(Icons.person),
      title: Text(userInfo["handle"]),
      subtitle: Text(userInfo["email"]),
      onTap: onTap,
    );
  }
}
