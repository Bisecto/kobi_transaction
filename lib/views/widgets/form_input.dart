import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../res/app_colors.dart';
import 'app_custom_text.dart';
import 'app_spacer.dart';

class CustomTextFormField extends StatefulWidget {
  final bool isobscure;
  final bool isMobileNumber;
  final ValueChanged<String>? onChanged;
  final Function? onFieldSubmitted;
  final String? Function(String?)? validateName;
  final String hint;
  final String label;
  final int? maxLines;
  final bool isPasswordField;
  final int? maxLength;
  final IconData icon;
  final Color borderColor;
  final double borderRadius;
  final TextInputType textInputType;
  final TextEditingController? controller;
  final FormFieldValidator<String>? validator;
  final Color backgroundColor;
  final Color hintColor;

  const CustomTextFormField(
      {super.key,
      this.maxLength,
      this.maxLines = 1,
      this.textInputType = TextInputType.text,
      required this.icon,
      this.backgroundColor = AppColors.white,
      this.hintColor = AppColors.grey,
      this.borderColor = AppColors.grey,
      this.borderRadius = 10,
      this.isPasswordField = false,
      required this.controller,
      this.validateName,
      this.validator,
      this.isMobileNumber = false,
      this.isobscure = true,
      this.onChanged,
      this.onFieldSubmitted,
      required this.hint,
      required this.label});

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  bool _obscureText = true;

  void _togglePasswordVisibility() {
    setState(() {
      _obscureText = !_obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText(
          text: widget.label,
          weight: FontWeight.bold,
          color: AppColors.grey,
          size: 15,
        ),
        const AppSpacer(
          height: 10,
        ),
        Container(
          decoration: BoxDecoration(
            color: widget.backgroundColor,
            border: Border.all(
              color: widget.borderColor,
              width: 1.0,
            ),
            borderRadius: BorderRadius.circular(
                widget.borderRadius),
          ),
          child: Padding(
            padding: const EdgeInsets.only(left: 5.0),
            child: Row(
              children: [
                if (widget.isMobileNumber)
                  const Text(
                    '+234',
                    style: TextStyle(
                      fontSize: 15,
                    ),
                  ),
                const AppSpacer(width: 10),
                Expanded(
                  child: TextFormField(
                    controller: widget.controller,

                    style: TextStyle(fontSize: 14, color: widget.hintColor),
                    decoration: InputDecoration(

                        prefixIcon: GestureDetector(
                          onTap: () {
                            if (widget.isPasswordField) {
                              _togglePasswordVisibility();
                            }
                          },
                          child: Icon(
                            widget.icon,
                            color: widget.borderColor,
                          ),
                        ),
                        suffixIcon: GestureDetector(
                          onTap: () {
                            if (widget.isPasswordField) {
                              _togglePasswordVisibility();
                            }
                          },
                          child: Icon(
                            widget.isPasswordField
                                ? (_obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility)
                                : null,
                            color: widget.borderColor,
                          ),
                        ),
                        hintText: widget.hint,
                        hintStyle: TextStyle(
                            fontSize: 14, color: widget.hintColor.withOpacity(0.5)),
                        border: InputBorder.none),
                    keyboardType: widget.textInputType,
                    validator: widget.validator,
                    //obscureText: widget.isobscure,
                    maxLines: widget.maxLines,
                    maxLength: widget.maxLength,
                    obscureText: widget.isPasswordField?_obscureText:false,
                    onFieldSubmitted: (val) {
                      widget.onFieldSubmitted!();
                    },
                    onChanged: (String val) {
                      widget.onChanged;
                      //_name = val;
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class CustomTextFormPasswordField extends StatefulWidget {
  final ValueChanged<String>? onChanged;
  final String? Function(String?)? validateName;
  final String label;
  final TextEditingController controller;

  const CustomTextFormPasswordField(
      {super.key,
      required this.controller,
      this.validateName,
      this.onChanged,
      required this.label});

  @override
  State<CustomTextFormPasswordField> createState() =>
      _CustomTextFormPasswordFieldState();
}

class _CustomTextFormPasswordFieldState
    extends State<CustomTextFormPasswordField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: widget.label,
      ),
      keyboardType: TextInputType.text,
      validator: widget.validateName,
      onChanged: (String val) {
      },
    );
  }
}


