import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

/// Header with the login background image, matching every screen in the mockups.
class BrandHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showBack;
  final bool showTitle;
  final Widget? trailing;
  final Widget? leading;
  final double height;

  const BrandHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.showTitle = true,
    this.trailing,
    this.leading,
    this.height = 230,
  });

@override
Widget build(BuildContext context) {
  // Short headers crop the portrait background too aggressively and make
  // the embedded logo look close to an edge. Keep one consistent minimum.
  final headerHeight = height < 210 ? 210.0 : height;

  return SizedBox(
    width: double.infinity,
    height: headerHeight,
    child: ClipRRect(
      borderRadius: const BorderRadius.vertical(
        bottom: Radius.circular(32),
      ),
      child: Stack(
        fit: StackFit.expand,
        children: [
          // The image already contains the Hi Class logo and its text.
          // Do not add another logo and do not place a dark overlay above it.
          Image.asset(
            'assets/images/hi_class_login_background.jfif',
            fit: BoxFit.cover,
            alignment: Alignment.center,
          ),

          SafeArea(
            bottom: false,
            child: Stack(
              children: [
                if (showBack)
                  PositionedDirectional(
                    start: 16,
                    top: 8,
                    child: _RoundIconButton(
                      icon: Icons.arrow_back,
                      onTap: () => Navigator.of(context).maybePop(),
                    ),
                  ),

                // In RTL, start is the right side. This keeps the bell in
                // the same position as the reference image.
                if (leading != null)
                  PositionedDirectional(
                    start: 16,
                    top: 8,
                    child: leading!,
                  ),

                if (trailing != null)
                  PositionedDirectional(
                    end: 16,
                    top: 8,
                    child: trailing!,
                  ),

                // The page title is centered below the logo that is already
                // printed inside the background image.
                if (showTitle)
                  PositionedDirectional(
                    start: 20,
                    end: 20,
                    bottom: 18,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                color: Colors.black45,
                                blurRadius: 5,
                                offset: Offset(0, 2),
                              ),
                            ],
                          ),
                        ),
                        if (subtitle != null) ...[
                          const SizedBox(height: 4),
                          Text(
                            subtitle!,
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: AppColors.goldLight,
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    ),
  );
}

}

class _RoundIconButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onTap;
  const _RoundIconButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(30),
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          border: Border.all(color: AppColors.gold),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Icon(
          icon,
          textDirection: TextDirection.rtl,
          color: AppColors.gold,
        ),
      ),
    );
  }
}

/// A small pill badge used for roles ("مدير", "مصمم"...) at the top of dashboards.
class RolePill extends StatelessWidget {
  final String label;
  final IconData? icon;
  const RolePill({super.key, required this.label, this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        border: Border.all(color: AppColors.gold),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, color: AppColors.gold, size: 18),
            const SizedBox(width: 6),
          ],
          Text(
            label,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.gold,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

/// Stat card with icon, number, and label — used across all dashboards.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    this.color = AppColors.maroon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        constraints: const BoxConstraints(minHeight: 132),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 10),
        decoration: BoxDecoration(
          color: AppColors.cardBackground,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4)),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 18),
            ),
            const SizedBox(height: 8),
            Text(value,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: color, fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 6),
            Text(label,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 13,
                    height: 1.2,
                    fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

/// Labeled horizontal progress bar, e.g. "42% قيد التصميم".
class LabeledProgressBar extends StatelessWidget {
  final String label;
  final double percent; // 0..1
  final Color color;
  final IconData? icon;

  const LabeledProgressBar({
    super.key,
    required this.label,
    required this.percent,
    this.color = AppColors.maroon,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          // In RTL the first child is visually on the right.
          Text(
            label,
            textAlign: TextAlign.right,
            style: const TextStyle(
              color: AppColors.textDark,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (icon != null) ...[
            const SizedBox(width: 6),
            Icon(icon, color: color, size: 18),
          ],
          const SizedBox(width: 10),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: percent,
                minHeight: 8,
                backgroundColor: AppColors.greyBg,
                color: color,
              ),
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 46,
            child: Text(
              '${(percent * 100).round()}%',
              textAlign: TextAlign.left,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

/// Status "pill" for design/CNC status (colored background + text).
class StatusPill extends StatelessWidget {
  final String label;
  final Color color;
  final Color bgColor;
  final IconData? icon;
  const StatusPill(
      {super.key,
      required this.label,
      required this.color,
      required this.bgColor,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        textDirection: TextDirection.rtl,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            label,
            textAlign: TextAlign.left,
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
          if (icon != null) ...[
            const SizedBox(width: 4),
            Icon(icon, size: 15, color: color),
          ],
        ],
      ),
    );
  }
}

/// Bottom navigation bar. Tabs differ per role, so caller supplies items.
class AppBottomNav extends StatelessWidget {
  final int currentIndex;
  final List<BottomNavigationBarItem> items;
  final ValueChanged<int> onTap;

  const AppBottomNav({
    super.key,
    required this.currentIndex,
    required this.items,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardBackground,
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 10, offset: Offset(0, -2)),
        ],
      ),
      child: SafeArea(
        top: false,
        child: BottomNavigationBar(
          currentIndex: currentIndex,
          onTap: onTap,
          items: items,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: AppColors.gold,
          unselectedItemColor: AppColors.maroon.withValues(alpha: 0.6),
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedLabelStyle: const TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

Color designStatusColor(DesignStatus s) => s.color;

/// Simple round "+" floating action button styled like the gold FAB in mockups.
class GoldFab extends StatelessWidget {
  final VoidCallback onPressed;
  const GoldFab({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: AppColors.gold,
      foregroundColor: AppColors.maroonDark,
      child: const Icon(Icons.add, size: 30),
    );
  }
}