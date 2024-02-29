import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  final DataCacher _cacher = DataCacher.instance;
  Future<void> initCheck() async {
    final String? _accessToken = _cacher.getUserToken();
    ref.read(accessTokenProvider.notifier).update((state) => _accessToken);
    await Future.delayed(1000.ms);
    if (_accessToken != null) {
      // ignore: use_build_context_synchronously
      context.pushReplacement(
        '/landing-page/0',
      );
      return;
    }

    // ignore: use_build_context_synchronously
    context.replaceNamed('login-auth', extra: "splash-tag");
    print("GO TO LOGIN");
  }

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await initCheck();
    });
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme fontTheme = Theme.of(context).textTheme;
    return Scaffold(
      body: Align(
        alignment: Alignment.center,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: "splash",
              child: Image.asset(
                "assets/images/logo.png",
                gaplessPlayback: true,
                isAntiAlias: true,
                width: size.width * .4,
                fit: BoxFit.fitWidth,
              )
                  .animate(
                    onPlay: (controller) => controller.repeat(reverse: true),
                  )
                  .rotate(duration: 2000.ms),
            ),
            const Gap(30),
            Column(
              children: [
                Text(
                  "ABLE ME",
                  style: fontTheme.headlineLarge!.copyWith(
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  "Inclusive Transportation",
                  style: fontTheme.bodyLarge!.copyWith(
                    color: Colors.grey.shade600,
                  ),
                )
              ],
            )
                .animate(
                  delay: const Duration(milliseconds: 2000),
                  onPlay: (controller) => controller.repeat(reverse: true),
                )
                .fade(
                  duration: const Duration(milliseconds: 2000),
                )
                .scale()
          ],
        ),
      ),
    );
  }
}
