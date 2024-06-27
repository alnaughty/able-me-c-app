import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';

mixin class Launcher {
  Future<bool> isLaunchable(String url) async {
    return await canLaunchUrl(Uri.parse(url));
  }

  Future<void> launchMyUrl(String url) async {
    if (await isLaunchable(url)) {
      await launchUrl(
        Uri.parse(url),
      );
    } else {
      Fluttertoast.showToast(msg: "Unable to launch $url");
      // throw;
    }
  }

  String? encodeQueryParameters(Map<String, String> params) {
    return params.entries
        .map((MapEntry<String, String> e) =>
            '${Uri.encodeComponent(e.key)}=${Uri.encodeComponent(e.value)}')
        .join('&');
  }

  Future<void> sendEmail(String email) async {
    final Uri emailLaunchUri = Uri(
      scheme: 'mailto',
      path: email,
      query: encodeQueryParameters(<String, String>{
        'subject': 'Problème avec l\'application Shapeyou.',
      }),
    );
    if (await canLaunchUrl(emailLaunchUri)) {
      await launchUrl(emailLaunchUri);
    }
  }
}
