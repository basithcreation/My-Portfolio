import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../data/portfolio_data.dart';
import '../../theme/app_theme.dart';
import '../common/glass_container.dart';

class ProjectsSection extends StatelessWidget {
  const ProjectsSection({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 100, horizontal: 24),
      child: Column(
        children: [
          // Section header
          _buildSectionHeader(theme),
          const SizedBox(height: 60),

          // Responsive Projects grid
          _buildProjectsGrid(screenWidth),

          const SizedBox(height: 48),

          // View all button
          _ViewAllButton(onTap: () => context.go('/projects')),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(ThemeData theme) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
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
            "Featured Projects",
            style: theme.textTheme.headlineLarge?.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
        const SizedBox(height: 12),
        Text(
          "Some of my recent work that showcase my skills",
          style: theme.textTheme.bodyLarge?.copyWith(
            color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
          ),
          textAlign: TextAlign.center,
        ),
      ],
    ).animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0);
  }

  Widget _buildProjectsGrid(double screenWidth) {
    final projects = PortfolioData.projects.take(4).toList();

    // Responsive columns
    int crossAxisCount;
    double maxWidth;
    double spacing;

    if (screenWidth > 1200) {
      crossAxisCount = 3;
      maxWidth = 1400;
      spacing = 32;
    } else if (screenWidth > 800) {
      crossAxisCount = 2;
      maxWidth = 900;
      spacing = 24;
    } else {
      crossAxisCount = 1;
      maxWidth = 500;
      spacing = 20;
    }

    return Center(
      child: ConstrainedBox(
        constraints: BoxConstraints(maxWidth: maxWidth),
        child: LayoutBuilder(
          builder: (context, constraints) {
            final availableWidth = constraints.maxWidth;
            final cardWidth =
                (availableWidth - (spacing * (crossAxisCount - 1))) /
                crossAxisCount;

            return Wrap(
              spacing: spacing,
              runSpacing: spacing,
              alignment: WrapAlignment.center,
              children: projects.asMap().entries.map((entry) {
                return SizedBox(
                  width: cardWidth.clamp(280, 450),
                  child: ProjectCard(project: entry.value, index: entry.key),
                );
              }).toList(),
            );
          },
        ),
      ),
    );
  }
}

/// Reusable Project Card Widget
class ProjectCard extends StatefulWidget {
  final Project project;
  final int index;
  final bool showFullDescription;

  const ProjectCard({
    super.key,
    required this.project,
    required this.index,
    this.showFullDescription = false,
  });

  @override
  State<ProjectCard> createState() => _ProjectCardState();
}

class _ProjectCardState extends State<ProjectCard> {
  bool _isHovered = false;
  bool _imageLoaded = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: () => context.go('/project/${widget.project.id}'),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOutCubic,
              transform: Matrix4.identity()
                ..translate(0.0, _isHovered ? -8.0 : 0.0, 0.0),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: _isHovered
                          ? AppColors.primary.withValues(alpha: 0.3)
                          : Colors.black.withValues(alpha: 0.1),
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
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Project image with overlay
                      _buildImageSection(theme),

                      // Content section
                      Padding(
                        padding: const EdgeInsets.all(20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Title with arrow indicator
                            _buildTitle(theme),
                            const SizedBox(height: 10),

                            // Description
                            _buildDescription(theme),
                            const SizedBox(height: 16),

                            // Tech stack tags
                            _buildTechTags(theme),
                            const SizedBox(height: 16),

                            // Action buttons
                            _buildActionButtons(theme),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        )
        .animate(delay: (100 * widget.index).ms)
        .fadeIn(duration: 500.ms)
        .slideY(begin: 0.15, end: 0);
  }

  Widget _buildImageSection(ThemeData theme) {
    return Stack(
      children: [
        // Project image
        ClipRRect(
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          child: AspectRatio(
            aspectRatio: 16 / 9,
            child: Image.asset(
              widget.project.imageUrl,
              fit: BoxFit.cover,
              frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
                if (wasSynchronouslyLoaded || frame != null) {
                  if (!_imageLoaded) {
                    WidgetsBinding.instance.addPostFrameCallback((_) {
                      if (mounted) setState(() => _imageLoaded = true);
                    });
                  }
                  return child
                      .animate(target: _imageLoaded ? 1 : 0)
                      .fadeIn(duration: 400.ms)
                      .scale(
                        begin: const Offset(1.05, 1.05),
                        end: const Offset(1, 1),
                        duration: 400.ms,
                      );
                }
                return _buildPlaceholder(theme);
              },
              errorBuilder: (_, __, ___) => _buildPlaceholder(theme),
            ),
          ),
        ),

        // Hover overlay with actions (web only)
        if (kIsWeb)
          Positioned.fill(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: _isHovered ? 1 : 0,
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.transparent,
                        Colors.black.withValues(alpha: 0.8),
                      ],
                    ),
                  ),
                  child: Center(
                    child: AnimatedScale(
                      scale: _isHovered ? 1 : 0.8,
                      duration: const Duration(milliseconds: 300),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.4),
                              blurRadius: 20,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.visibility_rounded,
                              color: Colors.white,
                              size: 18,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              "View Details",
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildPlaceholder(ThemeData theme) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.accentBlue.withValues(alpha: 0.2),
            AppColors.accentPurple.withValues(alpha: 0.2),
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.code_rounded,
          size: 48,
          color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
        ),
      ),
    );
  }

  Widget _buildTitle(ThemeData theme) {
    return Row(
      children: [
        Expanded(
          child: Text(
            widget.project.title,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.bold,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: _isHovered
                ? AppColors.primary
                : theme.colorScheme.surface.withValues(alpha: 0.5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: AnimatedRotation(
            turns: _isHovered ? 0.0 : 0.0,
            duration: const Duration(milliseconds: 200),
            child: Icon(
              Icons.arrow_outward_rounded,
              size: 16,
              color: _isHovered ? Colors.white : theme.colorScheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDescription(ThemeData theme) {
    return Text(
      widget.project.description,
      maxLines: widget.showFullDescription ? 5 : 2,
      overflow: TextOverflow.ellipsis,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
        height: 1.5,
      ),
    );
  }

  Widget _buildTechTags(ThemeData theme) {
    final tags = widget.project.tags.take(4).toList();

    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: tags.asMap().entries.map((entry) {
        final index = entry.key;
        final tag = entry.value;

        return Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    AppColors.primary.withValues(alpha: 0.1),
                    AppColors.accentCyan.withValues(alpha: 0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.2),
                ),
              ),
              child: Text(
                tag,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            )
            .animate(delay: (50 * (widget.index + index)).ms)
            .fadeIn(duration: 300.ms)
            .scale(begin: const Offset(0.8, 0.8), end: const Offset(1, 1));
      }).toList(),
    );
  }

  Widget _buildActionButtons(ThemeData theme) {
    final hasGitHub = widget.project.githubUrl != null;
    final hasLive = widget.project.liveUrl != null;

    if (!hasGitHub && !hasLive) return const SizedBox.shrink();

    return Row(
      children: [
        if (hasGitHub)
          _ActionIconButton(
            icon: Icons.code_rounded,
            tooltip: "GitHub",
            onTap: () => _launchUrl(widget.project.githubUrl!),
          ),
        if (hasGitHub && hasLive) const SizedBox(width: 12),
        if (hasLive)
          _ActionIconButton(
            icon: Icons.open_in_new_rounded,
            tooltip: "Live Demo",
            onTap: () => _launchUrl(widget.project.liveUrl!),
          ),
      ],
    );
  }

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }
}

class _ActionIconButton extends StatefulWidget {
  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;

  const _ActionIconButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
  });

  @override
  State<_ActionIconButton> createState() => _ActionIconButtonState();
}

class _ActionIconButtonState extends State<_ActionIconButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: widget.tooltip,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTap: widget.onTap,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _isHovered
                  ? AppColors.primary.withValues(alpha: 0.1)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: _isHovered
                    ? AppColors.primary
                    : AppColors.primary.withValues(alpha: 0.3),
              ),
            ),
            child: Icon(
              widget.icon,
              size: 18,
              color: _isHovered
                  ? AppColors.primary
                  : AppColors.primary.withValues(alpha: 0.7),
            ),
          ),
        ),
      ),
    );
  }
}

class _ViewAllButton extends StatefulWidget {
  final VoidCallback onTap;

  const _ViewAllButton({required this.onTap});

  @override
  State<_ViewAllButton> createState() => _ViewAllButtonState();
}

class _ViewAllButtonState extends State<_ViewAllButton> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
          cursor: SystemMouseCursors.click,
          onEnter: (_) => setState(() => _isHovered = true),
          onExit: (_) => setState(() => _isHovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              decoration: BoxDecoration(
                gradient: _isHovered
                    ? LinearGradient(
                        colors: [AppColors.primary, AppColors.accentCyan],
                      )
                    : null,
                color: _isHovered ? null : Colors.transparent,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: _isHovered
                      ? Colors.transparent
                      : AppColors.primary.withValues(alpha: 0.5),
                  width: 2,
                ),
                boxShadow: _isHovered
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          blurRadius: 20,
                          spreadRadius: 2,
                        ),
                      ]
                    : [],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "View All Projects",
                    style: TextStyle(
                      color: _isHovered ? Colors.white : AppColors.primary,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  AnimatedSlide(
                    offset: _isHovered ? const Offset(0.2, 0) : Offset.zero,
                    duration: const Duration(milliseconds: 200),
                    child: Icon(
                      Icons.arrow_forward_rounded,
                      color: _isHovered ? Colors.white : AppColors.primary,
                      size: 20,
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
        .animate()
        .fadeIn(delay: 500.ms, duration: 400.ms)
        .slideY(begin: 0.2, end: 0);
  }
}
