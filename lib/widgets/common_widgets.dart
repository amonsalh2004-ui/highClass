import 'package:flutter/material.dart';
import '../theme/app_theme.dart';
import '../models/models.dart';

/// Maroon header with the flower logo, matching every screen in the mockups.
class BrandHeader extends StatelessWidget {
  final String title;
  final String? subtitle;
  final bool showBack;
  final Widget? trailing;
  final Widget? leading;
  final double height;

  const BrandHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBack = false,
    this.trailing,
    this.leading,
    this.height = 230,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: height,
      padding: const EdgeInsets.symmetric(horizontal: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [AppColors.maroon, AppColors.maroonDark],
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Stack(
          children: [
            if (showBack)
              Positioned(
                right: 0,
                top: 8,
                child: _RoundIconButton(
                  icon: Icons.arrow_forward,
                  onTap: () => Navigator.of(context).maybePop(),
                ),
              ),
            if (leading != null) Positioned(left: 0, top: 8, child: leading!),
            if (trailing != null)
              Positioned(left: 0, top: 8, child: trailing!),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const _FlowerLogo(),
                  const SizedBox(height: 10),
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (subtitle != null) ...[
                    const SizedBox(height: 6),
                    Text(
                      subtitle!,
                      style: const TextStyle(
                        color: AppColors.goldLight,
                        fontSize: 14,
                      ),
                    ),
                  ],
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
        child: Icon(icon, color: AppColors.gold),
      ),
    );
  }
}

class _FlowerLogo extends StatelessWidget {
  const _FlowerLogo();
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Icon(Icons.spa, color: AppColors.gold, size: 46),
        const SizedBox(height: 2),
        const Text(
          'هاي كلاس',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const Text(
          'للمطابخ و الديكور',
          style: TextStyle(color: AppColors.gold, fontSize: 11),
        ),
      ],
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
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(label,
              style: const TextStyle(
                  color: AppColors.gold, fontWeight: FontWeight.bold)),
          if (icon != null) ...[
            const SizedBox(width: 6),
            Icon(icon, color: AppColors.gold, size: 18),
          ],
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
        padding: const EdgeInsets.symmetric(vertical: 22, horizontal: 14),
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
          children: [
            Text(label,
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: AppColors.textDark, fontWeight: FontWeight.w600)),
            const SizedBox(height: 10),
            Text(value,
                style: TextStyle(
                    color: color, fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            CircleAvatar(
              radius: 20,
              backgroundColor: color.withValues(alpha: 0.12),
              child: Icon(icon, color: color, size: 20),
            ),
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
          SizedBox(
            width: 46,
            child: Text('${(percent * 100).round()}%',
                style: TextStyle(color: color, fontWeight: FontWeight.bold)),
          ),
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
          if (icon != null) Icon(icon, color: color, size: 18),
          const SizedBox(width: 6),
          Text(label,
              style: const TextStyle(
                  color: AppColors.textDark, fontWeight: FontWeight.w600)),
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
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 15, color: color),
            const SizedBox(width: 4),
          ],
          Text(label,
              style: TextStyle(color: color, fontWeight: FontWeight.bold)),
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
