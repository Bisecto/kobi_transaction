import 'package:flutter/material.dart';

import '../../widgets/app_custom_text.dart';
import '../../widgets/form_button.dart';

class NotFoundContainer extends StatelessWidget {
  final String title;
  final String description;
  final IconData icon;
  final VoidCallback? onActionTap;
  final String? actionLabel;

  const NotFoundContainer({
    Key? key,
    required this.title,
    required this.description,
    required this.icon,
    this.onActionTap,
    this.actionLabel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TweenAnimationBuilder<double>(
              duration: const Duration(milliseconds: 500),
              tween: Tween(begin: 0.0, end: 1.0),
              builder: (context, value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: const Color(0xFF4CAF50).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      icon,
                      size: 60,
                      color: const Color(0xFF4CAF50),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            CustomText(
              text: title,
              size: 20,
              weight: FontWeight.bold,
              color: Colors.black87,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            CustomText(
              text: description,
              size: 16,
              color: Colors.grey.shade600,
              textAlign: TextAlign.center,
            ),
            if (onActionTap != null && actionLabel != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: FormButton(
                  text: actionLabel!,
                  onPressed: onActionTap!,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}