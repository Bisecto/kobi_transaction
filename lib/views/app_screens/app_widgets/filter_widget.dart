import 'package:flutter/material.dart';

import '../../widgets/app_custom_text.dart';

class FilterWidget extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const FilterWidget({
    Key? key,
    required this.label,
    required this.isSelected,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 700),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFF4CAF50) : Colors.white,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color:
                    isSelected ? const Color(0xFF4CAF50) : Colors.grey.shade300,
                width: 1,
              ),
              boxShadow:
                  isSelected
                      ? [
                        BoxShadow(
                          color: const Color(0xFF4CAF50).withOpacity(0.3),
                          blurRadius: 8,
                          offset: const Offset(0, 2),
                        ),
                      ]
                      : [],
            ),
            child: CustomText(
              text: label,
              color: isSelected ? Colors.white : Colors.grey.shade700,
              size: 14,
              weight: isSelected ? FontWeight.w600 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}
