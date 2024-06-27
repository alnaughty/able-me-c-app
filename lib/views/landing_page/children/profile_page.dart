import 'package:able_me/app_config/palette.dart';
import 'package:able_me/helpers/context_ext.dart';
import 'package:able_me/models/profile/content_and_action.dart';
import 'package:able_me/models/user_model.dart';
import 'package:able_me/services/app_src/data_cacher.dart';
import 'package:able_me/services/firebase/apple_auth.dart';
import 'package:able_me/services/firebase/google_auth.dart';
import 'package:able_me/view_models/auth/user_provider.dart';
import 'package:able_me/view_models/theme_provider.dart';
import 'package:able_me/views/landing_page/children/profile_page_components/notification_toggler.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

class ProfilePage extends ConsumerStatefulWidget {
  const ProfilePage({super.key});

  @override
  ConsumerState<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends ConsumerState<ProfilePage>
    with ColorPalette, GoogleAuth, AppleAuth {
  final DataCacher _cacher = DataCacher.instance;
  @override
  Widget build(BuildContext context) {
    final UserModel? _udata = ref.watch(currentUser.notifier).state;
    final bool isDarkMode = ref.watch(darkModeProvider);
    final Color textColor = context.theme.secondaryHeaderColor;
    final List<ContentAndAction> profile = [
      ContentAndAction(
        icon: SvgPicture.asset(
          "assets/icons/profile.svg",
          color: textColor,
          width: 20,
        ),
        onPressed: () {},
        title: "Details",
      ),
      ContentAndAction(
          icon: SvgPicture.asset(
            "assets/icons/wallet.svg",
            color: textColor,
            width: 20,
          ),
          onPressed: () {},
          title: "Subscriptions"),
      ContentAndAction(
          icon: SvgPicture.asset(
            "assets/icons/history.svg",
            color: textColor,
            width: 20,
          ),
          onPressed: () {},
          title: "History"),
      ContentAndAction(
        icon: SvgPicture.asset(
          "assets/icons/address.svg",
          color: textColor,
          width: 20,
        ),
        onPressed: () {
          context.push('/profile-page/address');
        },
        title: "Addresses",
      ),
    ];
    final List<ContentAndAction> sec = [
      ContentAndAction(
        icon: SvgPicture.asset(
          "assets/icons/change_pass.svg",
          color: textColor,
          width: 20,
        ),
        onPressed: () {},
        title: "Change password",
      ),
      ContentAndAction(
          icon: SvgPicture.asset(
            "assets/icons/link.svg",
            color: textColor,
            width: 20,
          ),
          onPressed: () {},
          title: "Enable account linking"),
      ContentAndAction(
          icon: SvgPicture.asset(
            "assets/icons/delete_account.svg",
            color: textColor,
            width: 20,
          ),
          onPressed: () {},
          title: "Delete account"),
    ];
    return Scaffold(
      body: SafeArea(
        bottom: false,
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              Container(
                width: context.csize!.width,
                height: context.csize!.height * .3,
                decoration: BoxDecoration(
                  color: Colors.grey.shade200,
                  image: DecorationImage(
                    image: const NetworkImage(
                      "https://img.jagranjosh.com/images/2023/June/962023/students-with-disabilities.webp",
                    ),
                    colorFilter: ColorFilter.mode(
                        Colors.black.withOpacity(.5), BlendMode.srcATop),
                    fit: BoxFit.cover,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: SafeArea(
                  bottom: false,
                  child: Stack(
                    children: [
                      if (context.canPop()) ...{
                        Align(
                          alignment: Alignment.topLeft,
                          child: BackButton(
                            style: ButtonStyle(
                                minimumSize: WidgetStateProperty.resolveWith(
                                    (states) => const Size(60, 60)),
                                backgroundColor:
                                    WidgetStateProperty.resolveWith((states) =>
                                        purplePalette.withOpacity(.8)),
                                shape: WidgetStateProperty.resolveWith(
                                    (states) => RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(6)))),
                            color: Colors.white,
                            onPressed: () {
                              if (context.canPop()) {
                                context.pop();
                              }
                            },
                          ),
                        ),
                      },
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: SizedBox(
                          height: 65,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 60,
                                height: 60,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                  // border: Border.all(
                                  //   color: Colors.white,
                                  //   width: 3,
                                  // ),
                                  // image: DecorationImage(image: _udata?.avatar == null ? AssetImage("assets/images/logo.png") : NetworkImage(_udata!.avatar))
                                ),
                                child: Center(
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(100),
                                    child: _udata == null
                                        ? Container(
                                            width: 55,
                                            height: 55,
                                            color: Colors.grey.shade100,
                                            child: Image.asset(
                                              "assets/images/logo.png",
                                            ),
                                          )
                                        : Container(
                                            width: 55,
                                            height: 55,
                                            color: _udata.avatar == null
                                                ? context.theme.colorScheme
                                                    .background
                                                : Colors.white,
                                            child: _udata.avatar == null
                                                ? Center(
                                                    child: Text(
                                                      _udata.name[0]
                                                          .toUpperCase(),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: context
                                                                .fontTheme
                                                                .bodyLarge!
                                                                .fontSize! +
                                                            5,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                  )
                                                : CachedNetworkImage(
                                                    imageUrl: _udata.avatar!,
                                                    height: 55,
                                                    width: 55,
                                                  ),
                                          ),
                                  ),
                                ),
                              ),
                              const Gap(10),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    _udata?.fullname ?? "",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _udata?.email ?? "",
                                    style: const TextStyle(
                                        fontSize: 13, color: Colors.white),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.dark_mode,
                              color: textColor,
                            ),
                            const Gap(10),
                            Text(
                              "Dark Mode",
                              style: context.fontTheme.titleMedium!.copyWith(
                                fontWeight: FontWeight.bold,
                                color: context.theme.secondaryHeaderColor,
                              ),
                            ),
                          ],
                        ),
                        Switch.adaptive(
                          value: isDarkMode,
                          onChanged: (f) {
                            ref
                                .read(darkModeProvider.notifier)
                                .update((state) => f);
                            ThemeMode _themeMode = ThemeMode.system;
                            _themeMode = f ? ThemeMode.dark : ThemeMode.light;
                            if (mounted) setState(() {});
                          },
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: context.csize!.width,
                          child: Text(
                            "Profile",
                            style: context.fontTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: textColor.withOpacity(.5),
                            ),
                          ),
                        ),
                        Divider(
                          color: textColor.withOpacity(.5),
                        ),
                        ...profile.map(
                          (e) => ListTile(
                            onTap: e.onPressed,
                            leading: e.icon,
                            title: Text(e.title),
                            titleTextStyle:
                                context.fontTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: textColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: context.csize!.width,
                          child: Text(
                            "Security",
                            style: context.fontTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: textColor.withOpacity(.5),
                            ),
                          ),
                        ),
                        Divider(
                          color: textColor.withOpacity(.5),
                        ),
                        ...sec.map(
                          (e) => ListTile(
                            onTap: e.onPressed,
                            leading: e.icon,
                            title: Text(e.title),
                            titleTextStyle:
                                context.fontTheme.bodyMedium!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: textColor,
                            ),
                            trailing: Icon(
                              Icons.chevron_right,
                              color: textColor,
                            ),
                          ),
                        )
                      ],
                    ),
                    Column(
                      children: [
                        SizedBox(
                          width: context.csize!.width,
                          child: Text(
                            "Notifications",
                            style: context.fontTheme.titleSmall!.copyWith(
                              fontWeight: FontWeight.w600,
                              color: textColor.withOpacity(.5),
                            ),
                          ),
                        ),
                        Divider(
                          color: textColor.withOpacity(.5),
                        ),
                        const NotificationToggler(),
                      ],
                    ),
                  ],
                ),
              ),
              const Gap(30),
              ListTile(
                onTap: () async {
                  // await _cacher.re
                  final int signInMethod = await _cacher.getSignInMethod() ?? 0;
                  if (signInMethod == 0 || signInMethod == 3) {
                    await firebaseSignOut();
                  } else if (signInMethod == 1) {
                    // google sign in
                    await googleSignOut();
                  } else {
                    // fb sign Out
                  }
                  await _cacher.logout();
                  // ignore: use_build_context_synchronously
                  context.pushReplacement('/');
                  return;
                },
                leading: SvgPicture.asset(
                  "assets/icons/logout.svg",
                  color: Colors.red,
                  width: 20,
                ),
                title: const Text("Logout"),
                titleTextStyle: context.fontTheme.bodyMedium!.copyWith(
                  fontWeight: FontWeight.w600,
                  color: Colors.red,
                ),
                // trailing: Icon(
                //   Icons.chevron_right,
                //   color: textColor,
                // ),
              ),
              const SafeArea(
                top: false,
                child: Gap(30),
              )
            ],
          ),
        ),
      ),
    );
  }
}
