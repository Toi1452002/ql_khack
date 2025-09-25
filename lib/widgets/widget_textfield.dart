import 'package:flutter/services.dart';
import 'package:shadcn_flutter/shadcn_flutter.dart';

class WidgetTextField extends StatefulWidget {
  final double spacing;
  final void Function(String)? onChanged;
  final TextEditingController? controller;
  final bool obscureText;
  final void Function(String)? onSubmitted;
  final bool autofocus;
  final int? maxLines;
  final bool enabled;
  final bool isNumber;
  final bool isUpperCase;
  final TextAlign textAlign;
  final String? hintText;
  final bool readOnly;
  final void Function()? onTap;
  final Widget? trailing;
  final FocusNode? focusNode;
  final void Function(bool)? hasFocus;
  final bool isDouble;
  final int? maxLength;
  final TextStyle? style;
  final Color? color;
  final void Function()? onEditingComplete;

  const WidgetTextField({
    super.key,
    this.spacing = 10,
    this.isNumber = false,
    this.isDouble = false,
    this.isUpperCase = false,
    this.enabled = true,
    this.maxLines = 1,
    this.onChanged,
    this.autofocus = false,
    this.controller,
    this.obscureText = false,
    this.onSubmitted,
    this.hintText,
    this.focusNode,
    this.textAlign = TextAlign.start,
    this.readOnly = false,
    this.onTap,
    this.trailing,
    this.maxLength,
    this.style,
    this.color,
    this.onEditingComplete,
    this.hasFocus
  });

  @override
  State<WidgetTextField> createState() => _WidgetTextFieldState();
}

class _WidgetTextFieldState extends State<WidgetTextField> {
  late FocusNode focus;
  @override
  void initState() {
    // TODO: implement initState
    focus = widget.focusNode?? FocusNode();
    focus.addListener((){
      widget.hasFocus?.call(focus.hasFocus);
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(

      maxLength: widget.maxLength,
      readOnly: widget.readOnly,
      decoration: widget.color != null
          ? BoxDecoration(
              color: widget.color,
              border: Border.all(color: Colors.blue.shade900, width: .5),
              borderRadius: BorderRadius.circular(3),
            )
          : null,
      placeholder: Text( widget.hintText ?? ''),
      enabled: widget.enabled,
      maxLines: widget.maxLines,
      onChanged: widget.onChanged,
      controller: widget.controller,
      obscureText: widget.obscureText,
      onSubmitted: widget.onSubmitted,
      onEditingComplete: widget.onEditingComplete,
      // focusNode: focusNode,
      focusNode: focus,
      onTap: widget.onTap,
      trailing: widget.trailing,
      textAlign: widget.textAlign,
      autofocus: widget.autofocus,
      style: TextStyle(
        color: widget.enabled ? Colors.black : Colors.gray.shade400
      ),
      padding: EdgeInsets.symmetric(horizontal: 5, vertical: 4),
      inputFormatters: [
        if (widget.isUpperCase) TextInputFormatters.toUpperCase,
        if (widget.isNumber) FilteringTextInputFormatter.allow(RegExp(r'[\d\,]')),
        if (widget.isDouble) FilteringTextInputFormatter.allow(RegExp(r'[\d\.]')),
      ],
    );
  }
}
