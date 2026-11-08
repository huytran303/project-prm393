import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../../core/theme.dart';

class AppLogo extends StatelessWidget {
  const AppLogo({super.key, this.size = 88});
  final double size;
  @override
  Widget build(BuildContext context) => Container(
        width: size,
        height: size,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: AppColors.ink, borderRadius: BorderRadius.circular(size * 0.24)),
        child: Text('B', style: TextStyle(color: Colors.white, fontSize: size * 0.5, fontWeight: FontWeight.w700)),
      );
}

/// S01: shown while the saved session is checked; the router then redirects.
class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        body: SafeArea(
          child: Column(children: [
            const Spacer(flex: 3),
            const AppLogo(),
            const SizedBox(height: 16),
            const Text('BrewBoss', style: TextStyle(fontSize: 26, fontWeight: FontWeight.w700)),
            const SizedBox(height: 4),
            const Text('Quản lý quán cà phê', style: TextStyle(color: AppColors.muted)),
            const SizedBox(height: 32),
            const CircularProgressIndicator(),
            const Spacer(flex: 4),
            FutureBuilder(
              future: PackageInfo.fromPlatform(),
              builder: (_, snap) => Text('Phiên bản ${snap.data?.version ?? ''}',
                  style: const TextStyle(color: AppColors.muted, fontSize: 13)),
            ),
            const SizedBox(height: 24),
          ]),
        ),
      );
}
