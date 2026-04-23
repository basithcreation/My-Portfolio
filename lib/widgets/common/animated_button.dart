import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../theme/app_theme.dart';

class AnimatedButton extends StatefulWidget {
  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  final bool isOutlined;

  const AnimatedButton({
    super.key,
    required this.text,
    required this.onTap,
    this.icon,
    this.isOutlined = false,
  });

  @override
  State<AnimatedButton> createState() => _AnimatedButtonState();
}

class _AnimatedButtonState extends State<AnimatedButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return MouseRegion(
      onEnter: (_) => setState(() => _isHovered = true),
      onExit: (_) => setState(() => _isHovered = false),
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: widget.onTap,
        child:
            AnimatedContainer(
                  duration: 200.ms,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    // FIX: use gradient for filled button, transparent for outlined
                    gradient: widget.isOutlined
                        ? null
                        : const LinearGradient(
                            colors: AppColors.primaryGradient,
                          ),
                    color: widget.isOutlined ? Colors.transparent : null,
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(
                      color: colorScheme.primary,
                      width: widget.isOutlined ? 2 : 0,
                    ),
                    boxShadow: _isHovered && !widget.isOutlined
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.35),
                              blurRadius: 15,
                              offset: const Offset(0, 5),
                              spreadRadius: 1,
                            ),
                          ]
                        : [],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        widget.text,
                        style: theme.textTheme.labelLarge?.copyWith(
                          // FIX: outlined uses primary color, filled always white
                          color: widget.isOutlined
                              ? colorScheme.primary
                              : Colors.white,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                      if (widget.icon != null) ...[
                        const SizedBox(width: 8),
                        Icon(
                          widget.icon,
                          size: 18,
                          color: widget.isOutlined
                              ? colorScheme.primary
                              : Colors.white,
                        ),
                      ],
                    ],
                  ),
                )
                .animate(target: _isHovered ? 1 : 0)
                .scale(
                  begin: const Offset(1, 1),
                  end: const Offset(1.04, 1.04),
                  duration: 200.ms,
                  curve: Curves.easeOut,
                ),
      ),
    );
  }
}
