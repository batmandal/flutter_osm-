import 'package:flutter/material.dart';

class ButtonCurrentLocation extends StatelessWidget {
  final Function()? onPressed;
  const ButtonCurrentLocation({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        shape: const CircleBorder(),
        padding: const EdgeInsets.all(12),
        backgroundColor: Colors.white,
        foregroundColor: Colors.red,
      ),
      child: const Icon(Icons.location_off, color: Colors.black),
    );
  }
}
