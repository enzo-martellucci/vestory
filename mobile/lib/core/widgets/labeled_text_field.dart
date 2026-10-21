import 'package:material_ui/material_ui.dart';

class LabeledTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final bool obscureText;
  final String? hintText;
  final String? errorText;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String>? onFieldSubmitted;

  const LabeledTextField({
    super.key,
    required this.label,
    required this.controller,
    this.obscureText = false,
    this.hintText,
    this.errorText,
    this.keyboardType,
    this.textInputAction,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: .stretch,
      spacing: 6,
      children: [
        Text(label, style: const TextStyle(fontSize: 14, fontWeight: .w600)),
        TextFormField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          decoration: InputDecoration(hintText: hintText, errorText: errorText),
          validator: validator,
          onFieldSubmitted: onFieldSubmitted,
        ),
      ],
    );
  }
}
