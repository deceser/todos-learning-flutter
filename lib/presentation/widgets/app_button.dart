import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

/// Переиспользуемый компонент кнопки с общими стилями
class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final bool isLoading;
  final bool isOutlined;
  final Color? color;
  final Color? textColor;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final BorderRadius? borderRadius;
  final Widget? icon;

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.color,
    this.textColor,
    this.width,
    this.height,
    this.padding,
    this.borderRadius,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final defaultColor = color ?? theme.primaryColor;
    final defaultTextColor = textColor ?? (isOutlined ? defaultColor : Colors.white);
    final defaultPadding = padding ?? const EdgeInsets.symmetric(
      horizontal: 24,
      vertical: 14,
    );
    final defaultBorderRadius = borderRadius ?? BorderRadius.circular(8);

    final buttonStyle = isOutlined
        ? OutlinedButton.styleFrom(
            padding: defaultPadding,
            side: BorderSide(color: defaultColor),
            shape: RoundedRectangleBorder(
              borderRadius: defaultBorderRadius,
            ),
          )
        : ElevatedButton.styleFrom(
            padding: defaultPadding,
            backgroundColor: defaultColor,
            foregroundColor: defaultTextColor,
            shape: RoundedRectangleBorder(
              borderRadius: defaultBorderRadius,
            ),
          );

    final child = isLoading
        ? LoadingAnimationWidget.threeArchedCircle(
            color: defaultTextColor,
            size: 24,
          )
        : icon != null
            ? Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  icon!,
                  const SizedBox(width: 8),
                  Text(text),
                ],
              )
            : Text(text);

    Widget button = isOutlined
        ? OutlinedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: child,
          )
        : ElevatedButton(
            onPressed: isLoading ? null : onPressed,
            style: buttonStyle,
            child: child,
          );

    if (width != null || height != null) {
      button = SizedBox(
        width: width,
        height: height,
        child: button,
      );
    }

    return button;
  }
} 