import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/services/auth/user_data.dart';
import 'package:able_me/view_models/auth/kyc_provider.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class LandingPage extends ConsumerStatefulWidget {
  const LandingPage({super.key});
  @override
  ConsumerState<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends ConsumerState<LandingPage> with ColorPalette {
  final UserDataApi _userApi = UserDataApi();
  final DataCacher _cacher = DataCacher.instance;

  // KYCDataModel? status;
  Future<void> initialize() async {
    final String? token = _cacher.getUserToken();
    if (token == null) {
      context.pushReplacementNamed('/');
      return;
    }
    await _userApi.getUserDetails(token).then((value) {
      ref.watch(currentUser.notifier).update((state) => value);
    });
    await _userApi.getKYCStatus(token).then((value) {
      // status = value;
      ref.watch(kycStatusProvider.notifier).update((state) => value);
      if (mounted) setState(() {});
      if (value == null) {
        context.pushReplacementNamed('kyc');
      } else {
        if (value.status != 1) {
          context.pushReplacementNamed('kyc');
          return;
        }
        context.pushReplacement('/navigation-page/4');
      }
    });
  }

  @override
  void initState() {
    initialize();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    final TextTheme fontTheme = Theme.of(context).textTheme;
    final Color textColor = context.theme.secondaryHeaderColor;
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
            const Gap(40),
            const Center(
              child: CircularProgressIndicator.adaptive(),
            ),
            const Gap(30),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Please wait while we are processing your request",
                    textAlign: TextAlign.center,
                    style: fontTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.w500,
                      color: textColor,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
