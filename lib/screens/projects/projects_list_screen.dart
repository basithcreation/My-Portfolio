import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../data/portfolio_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/glass_container.dart';
import '../../widgets/layout/footer.dart';
import '../../widgets/layout/nav_bar.dart';

class ProjectsListScreen extends StatelessWidget {
  const ProjectsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const NavBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 100),
            // Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accentBlue.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      "PORTFOLIO",
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: AppColors.accentBlue,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  ShaderMask(
                    shaderCallback: (bounds) => const LinearGradient(
                      colors: [AppColors.accentBlue, AppColors.accentCyan],
                    ).createShader(bounds),
                    child: Text(
                      "All Projects",
                      style: theme.textTheme.headlineLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    "Everything I've built — from enterprise apps to experiments",
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.1, end: 0),
            ),

            const SizedBox(height: 60),

            // Projects grid
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  child: LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;
                      int columns = width > 1000
                          ? 3
                          : width > 600
                          ? 2
                          : 1;
                      const spacing = 24.0;
                      final cardWidth =
                          (width - spacing * (columns - 1)) / columns;

                      return Wrap(
                        spacing: spacing,
                        runSpacing: spacing,
                        alignment: WrapAlignment.center,
                        children: PortfolioData.projects
                            .asMap()
                            .entries
                            .map(
                              (entry) => SizedBox(
                                width: cardWidth.clamp(280.0, 420.0),
                                child: _ProjectItem(
                                  project: entry.value,
                                  index: entry.key,
                                ),
                              ),
                            )
                            .toList(),
                      );
                    },
                  ),
                ),
              ),
            ),

            const SizedBox(height: 80),
            const Footer(),
          ],
        ),
      ),
    );
  }
}

class _ProjectItem extends StatefulWidget {
  final Project project;
  final int index;
  const _ProjectItem({required this.project, required this.index});

  @override
  State<_ProjectItem> createState() => _ProjectItemState();
}

class _ProjectItemState extends State<_ProjectItem> {
  bool _isHovered = false;
  bool _imageLoaded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          cursor: SystemMouseCursors.click,
          child: GestureDetector(
            onTap: () => context.go('/project/${widget.project.id}'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..translate(0.0, _isHovered ? -8.0 : 0.0, 0.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: _isHovered
                        ? AppColors.primary.withValues(alpha: 0.25)
                        : Colors.black.withValues(alpha: 0.08),
                    blurRadius: _isHovered ? 30 : 15,
                    offset: Offset(0, _isHovered ? 15 : 8),
                    spreadRadius: _isHovered ? 2 : 0,
                  ),
                ],
              ),
              child: GlassContainer(
                padding: EdgeInsets.zero,
                enableHover: false,
                borderRadius: BorderRadius.circular(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // FIX: Actual project image instead of placeholder icon
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(20),
                      ),
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Stack(
                          children: [
                            // Actual image
                            Image.asset(
                              widget.project.imageUrl,
                              width: double.infinity,
                              height: double.infinity,
                              fit: BoxFit.cover,
                              frameBuilder:
                                  (
                                    context,
                                    child,
                                    frame,
                                    wasSynchronouslyLoaded,
                                  ) {
                                    if (wasSynchronouslyLoaded ||
                                        frame != null) {
                                      if (!_imageLoaded) {
                                        WidgetsBinding.instance
                                            .addPostFrameCallback((_) {
                                              if (mounted) {
                                                setState(
                                                  () => _imageLoaded = true,
                                                );
                                              }
                                            });
                                      }
                                      return AnimatedOpacity(
                                        opacity: _imageLoaded ? 1.0 : 0.0,
                                        duration: const Duration(
                                          milliseconds: 400,
                                        ),
                                        child: child,
                                      );
                                    }
                                    return _buildImagePlaceholder(theme);
                                  },
                              errorBuilder: (_, __, ___) =>
                                  _buildImagePlaceholder(theme),
                            ),
                            // Hover overlay
                            AnimatedOpacity(
                              opacity: _isHovered ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 300),
                              child: Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.topCenter,
                                    end: Alignment.bottomCenter,
                                    colors: [
                                      Colors.transparent,
                                      Colors.black.withValues(alpha: 0.7),
                                    ],
                                  ),
                                ),
                                child: Center(
                                  child: AnimatedScale(
                                    scale: _isHovered ? 1.0 : 0.8,
                                    duration: const Duration(milliseconds: 300),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 20,
                                        vertical: 10,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary,
                                        borderRadius: BorderRadius.circular(30),
                                        boxShadow: [
                                          BoxShadow(
                                            color: AppColors.primary.withValues(
                                              alpha: 0.4,
                                            ),
                                            blurRadius: 15,
                                          ),
                                        ],
                                      ),
                                      child: const Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Icon(
                                            Icons.visibility_rounded,
                                            color: Colors.white,
                                            size: 16,
                                          ),
                                          SizedBox(width: 6),
                                          Text(
                                            "View Details",
                                            style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 13,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Content
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Title row
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  widget.project.title,
                                  style: theme.textTheme.titleLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    // FIX: use theme-aware color
                                    color: theme.colorScheme.onSurface,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 8),
                              AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: _isHovered
                                      ? AppColors.primary
                                      : theme.colorScheme.surface.withValues(
                                          alpha: 0.5,
                                        ),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Icon(
                                  Icons.arrow_outward_rounded,
                                  size: 14,
                                  color: _isHovered
                                      ? Colors.white
                                      : theme.colorScheme.onSurface.withValues(
                                          alpha: 0.6,
                                        ),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 8),

                          // Description
                          Text(
                            widget.project.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              // FIX: use theme-aware color
                              color: theme.colorScheme.onSurface.withValues(
                                alpha: 0.7,
                              ),
                              height: 1.5,
                            ),
                          ),

                          const SizedBox(height: 14),

                          // Tags
                          Wrap(
                            spacing: 6,
                            runSpacing: 6,
                            children: widget.project.tags
                                .take(3)
                                .map(
                                  (tag) => Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.08,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.2,
                                        ),
                                      ),
                                    ),
                                    child: Text(
                                      tag,
                                      style: theme.textTheme.labelSmall
                                          ?.copyWith(
                                            color: AppColors.primary,
                                            fontWeight: FontWeight.w600,
                                          ),
                                    ),
                                  ),
                                )
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        )
        .animate(delay: (80 * widget.index).ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.15, end: 0);
  }

  Widget _buildImagePlaceholder(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentBlue.withValues(alpha: 0.15),
            AppColors.accentPurple.withValues(alpha: 0.15),
          ],
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.code_rounded,
              size: 40,
              color: AppColors.primary.withValues(alpha: 0.4),
            ),
            const SizedBox(height: 8),
            Text(
              widget.project.title,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
