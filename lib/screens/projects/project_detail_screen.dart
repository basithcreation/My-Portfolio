import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:go_router/go_router.dart';
import '../../data/portfolio_data.dart';
import '../../theme/app_theme.dart';
import '../../widgets/common/animated_button.dart';
import '../../widgets/common/glass_container.dart';
import '../../widgets/common/responsive_wrapper.dart';
import '../../widgets/layout/footer.dart';
import '../../widgets/layout/nav_bar.dart';
import 'package:url_launcher/url_launcher.dart';

class ProjectDetailScreen extends StatelessWidget {
  final String projectId;
  const ProjectDetailScreen({super.key, required this.projectId});

  @override
  Widget build(BuildContext context) {
    final project = PortfolioData.projects.firstWhere(
      (p) => p.id == projectId,
      orElse: () => PortfolioData.projects.first,
    );

    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: const NavBar(),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          children: [
            const SizedBox(height: 80),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 40),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1000),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Back Button
                      TextButton.icon(
                        onPressed: () => context.go('/'),
                        icon: const Icon(Icons.arrow_back_rounded),
                        label: const Text("Back to Home"),
                        style: TextButton.styleFrom(
                          foregroundColor: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Title & Tags
                      Text(
                        project.title,
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: theme.colorScheme.onSurface,
                        ),
                      ).animate().fadeIn().moveY(begin: 20, end: 0),

                      const SizedBox(height: 16),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: project.tags.map((tag) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  AppColors.primary.withValues(alpha: 0.12),
                                  AppColors.accentCyan.withValues(alpha: 0.06),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                color: AppColors.primary.withValues(
                                  alpha: 0.25,
                                ),
                              ),
                            ),
                            child: Text(
                              tag,
                              style: theme.textTheme.labelSmall?.copyWith(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 40),

                      // Main project image — FIX: load actual image from assets
                      _ProjectMainImage(project: project),

                      const SizedBox(height: 40),

                      // Screenshot Gallery — FIX: show actual screenshots
                      if (project.screenshots.isNotEmpty) ...[
                        Text(
                          "Tap to see the full Screenshort",
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        _ScreenshotGallery(screenshots: project.screenshots),
                        const SizedBox(height: 40),
                      ],

                      // Description & Links
                      ResponsiveWrapper(
                        mobile: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            _buildAbout(context, project),
                            const SizedBox(height: 40),
                            if (project.githubUrl != null ||
                                project.liveUrl != null)
                              _buildLinks(context, project),
                          ],
                        ),
                        desktop: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 2,
                              child: _buildAbout(context, project),
                            ),
                            if (project.githubUrl != null ||
                                project.liveUrl != null) ...[
                              const SizedBox(width: 40),
                              Expanded(
                                flex: 1,
                                child: _buildLinks(context, project),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),
            ),
            const Footer(),
          ],
        ),
      ),
    );
  }

  Widget _buildAbout(BuildContext context, Project project) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "About the Project",
          style: theme.textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          project.description,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.8,
            color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
          ),
        ),
        const SizedBox(height: 24),
        Text(
          "Technologies Used",
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          project.tags.join(" • "),
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildLinks(BuildContext context, Project project) {
    return GlassContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Project Links",
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          if (project.liveUrl != null) ...[
            AnimatedButton(
              text: "View Live",
              icon: Icons.launch_rounded,
              onTap: () => launchUrl(Uri.parse(project.liveUrl!)),
            ),
            const SizedBox(height: 16),
          ],
          if (project.githubUrl != null)
            AnimatedButton(
              text: "View Code",
              icon: Icons.code_rounded,
              isOutlined: true,
              onTap: () => launchUrl(Uri.parse(project.githubUrl!)),
            ),
        ],
      ),
    );
  }
}

/// FIX: Loads actual project image from assets with proper fallback
class _ProjectMainImage extends StatelessWidget {
  final Project project;
  const _ProjectMainImage({required this.project});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ClipRRect(
      borderRadius: BorderRadius.circular(20),
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: Image.asset(
          project.imageUrl,
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => _buildPlaceholder(theme, project),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildPlaceholder(ThemeData theme, Project project) {
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
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.code_rounded,
            size: 64,
            color: AppColors.primary.withValues(alpha: 0.5),
          ),
          const SizedBox(height: 12),
          Text(
            project.title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
          ),
        ],
      ),
    );
  }
}

/// FIX: Full screenshot gallery with horizontal scroll and lightbox tap
class _ScreenshotGallery extends StatefulWidget {
  final List<String> screenshots;
  const _ScreenshotGallery({required this.screenshots});

  @override
  State<_ScreenshotGallery> createState() => _ScreenshotGalleryState();
}

class _ScreenshotGalleryState extends State<_ScreenshotGallery> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      children: [
        // Main selected screenshot
        GestureDetector(
          onTap: () => _openLightbox(context, _selectedIndex),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SizedBox(
              height: 500,
              width: 500,
              child: AspectRatio(
                aspectRatio: 9 / 16,
                child: Image.asset(
                  widget.screenshots[_selectedIndex],
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    decoration: BoxDecoration(
                      color: theme.colorScheme.surfaceContainerHighest,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Center(
                      child: Icon(
                        Icons.image_rounded,
                        size: 48,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        const SizedBox(height: 16),

        // Thumbnail strip
        SizedBox(
          height: 80,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: widget.screenshots.length,
            itemBuilder: (context, index) {
              final isSelected = index == _selectedIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedIndex = index),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 120,
                  margin: EdgeInsets.only(
                    right: 10,
                    bottom: isSelected ? 0 : 4,
                    top: isSelected ? 0 : 4,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary
                          : theme.colorScheme.onSurface.withValues(alpha: 0.1),
                      width: isSelected ? 2 : 1,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.3),
                              blurRadius: 8,
                            ),
                          ]
                        : null,
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.asset(
                      widget.screenshots[index],
                      fit: BoxFit.cover,
                      errorBuilder: (_, __, ___) => Container(
                        color: theme.colorScheme.surfaceContainerHighest,
                        child: Icon(
                          Icons.image_rounded,
                          size: 24,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _openLightbox(BuildContext context, int initialIndex) {
    showDialog(
      context: context,
      barrierColor: Colors.black87,
      builder: (context) => _LightboxDialog(
        screenshots: widget.screenshots,
        initialIndex: initialIndex,
      ),
    );
  }
}

class _LightboxDialog extends StatefulWidget {
  final List<String> screenshots;
  final int initialIndex;

  const _LightboxDialog({
    required this.screenshots,
    required this.initialIndex,
  });

  @override
  State<_LightboxDialog> createState() => _LightboxDialogState();
}

class _LightboxDialogState extends State<_LightboxDialog> {
  late int _currentIndex;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
    _pageController = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.all(24),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "${_currentIndex + 1} / ${widget.screenshots.length}",
                style: const TextStyle(color: Colors.white70, fontSize: 14),
              ),
              IconButton(
                onPressed: () => Navigator.pop(context),
                icon: const Icon(Icons.close_rounded, color: Colors.white),
              ),
            ],
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.7,
            child: PageView.builder(
              controller: _pageController,
              itemCount: widget.screenshots.length,
              onPageChanged: (i) => setState(() => _currentIndex = i),
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      widget.screenshots[index],
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Center(
                        child: Icon(
                          Icons.broken_image_rounded,
                          color: Colors.white54,
                          size: 64,
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                onPressed: _currentIndex > 0
                    ? () => _pageController.previousPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      )
                    : null,
                icon: Icon(
                  Icons.arrow_back_ios_rounded,
                  color: _currentIndex > 0 ? Colors.white : Colors.white30,
                ),
              ),
              const SizedBox(width: 16),
              IconButton(
                onPressed: _currentIndex < widget.screenshots.length - 1
                    ? () => _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeInOut,
                      )
                    : null,
                icon: Icon(
                  Icons.arrow_forward_ios_rounded,
                  color: _currentIndex < widget.screenshots.length - 1
                      ? Colors.white
                      : Colors.white30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
