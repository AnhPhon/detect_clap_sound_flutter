import 'package:flutter/material.dart';

class ExampleButton extends StatelessWidget {
  const ExampleButton({
    super.key,
    required this.onTap,
    required this.label,
    this.margin,
    this.colorBG,
  });
  final Function() onTap;
  final String label;
  final EdgeInsets? margin;
  final Color? colorBG;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        onTap.call();
      },
      child: Container(
        margin: margin ?? const EdgeInsets.only(bottom: 15),
        height: 50,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: colorBG ?? Colors.blue,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}
