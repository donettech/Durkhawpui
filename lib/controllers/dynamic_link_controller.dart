// import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

class DynamicLinkController extends GetxController {
  // FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  final String dynamicLink = 'https://test-app/helloworld';
  final String link = 'https://reactnativefirebase.page.link/bFkn';

  // Future handleDynamicLinks() async {
  //   final PendingDynamicLinkData? data =
  //       await FirebaseDynamicLinks.instance.getInitialLink();
  //   if (data != null) {
  //     return _handleDeepLink(data);
  //   }
  //   FirebaseDynamicLinks.instance.onLink.listen((event) {
  //     _handleDeepLink(event);
  //   });
  // }

  // _handleDeepLink(PendingDynamicLinkData data) {
  //   final Uri deepLink = data.link;
  //   if (deepLink.pathSegments.length > 0 &&
  //       deepLink.pathSegments[0] == "post") {
  //     // Get.off();
  //     /* _navigationService.replaceNavWith(SinglePostDetailsDlinkRoute,
  //           arguments: {"postID": deepLink.pathSegments[1]}); */
  //   } else if (deepLink.pathSegments.length > 0 &&
  //       deepLink.pathSegments[0] == "live") {
  //     /* _navigationService.replaceNavWith(DlinkLiveTextpageRoute,
  //           arguments: {"id": deepLink.pathSegments[1]}); */
  //   } else if (deepLink.queryParameters['category'] == "post") {
  //     /* _navigationService.replaceNavWith(SinglePostDetailsDlinkRoute,
  //           arguments: {"postID": deepLink.queryParameters['id']}); */
  //   }
  // }

  // Future<String> createDynamicLink({
  //   required String title,
  //   required String desc,
  // }) async {
  //   final DynamicLinkParameters parameters = DynamicLinkParameters(
  //     uriPrefix: 'https://durtlang.page.link',
  //     link: Uri.parse(dynamicLink),
  //     androidParameters: const AndroidParameters(
  //       packageName: 'com.durtlang.app',
  //       minimumVersion: 0,
  //     ),
  //     iosParameters: const IOSParameters(
  //       bundleId: 'com.durtlang.app',
  //       minimumVersion: '0',
  //     ),
  //   );
  //   Uri url;
  //   final ShortDynamicLink shortLink =
  //       await dynamicLinks.buildShortLink(parameters);
  //   url = shortLink.shortUrl;
  //   String _linkMessage = url.toString();
  //   return _linkMessage;
  // }
}
