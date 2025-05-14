import 'package:flutter/material.dart';
import 'package:gap/gap.dart';

/// Обертка для экранов аутентификации с общим оформлением
class AuthWrapper extends StatelessWidget {
  final String title;
  final String? subtitle;
  final List<Widget> children;
  final EdgeInsets padding;
  final Widget? topWidget;
  final Widget? bottomWidget;

  const AuthWrapper({
    super.key,
    required this.title,
    this.subtitle,
    required this.children,
    this.padding = const EdgeInsets.all(24),
    this.topWidget,
    this.bottomWidget,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Container(
              constraints: BoxConstraints(
                maxWidth: screenSize.width > 600 ? 500 : double.infinity,
              ),
              padding: padding,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (topWidget != null) ...[
                    topWidget!,
                    const Gap(32),
                  ],
                  
                  // Заголовок
                  Text(
                    title,
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  if (subtitle != null) ...[
                    const Gap(8),
                    Text(
                      subtitle!,
                      style: theme.textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade700,
                      ),
                    ),
                  ],
                  
                  const Gap(32),
                  
                  // Основное содержимое
                  ...children,
                  
                  if (bottomWidget != null) ...[
                    const Gap(32),
                    bottomWidget!,
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
} 