import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:get/get.dart';

import '../ui/home/NoticeDetails/notice_detail_link.dart';

class DynamicLinkController extends GetxController {
  FirebaseDynamicLinks dynamicLinks = FirebaseDynamicLinks.instance;

  final String defaultLink =
      'https://firebasestorage.googleapis.com/v0/b/durkhawpui.appspot.com/o/durtlang.jpg?alt=media&token=1522c25f-93a5-4536-9e8a-797ad0a93bf7';
  final String dynamicLink2 = "https://www.inkhel.com/";
  Future handleDynamicLinks() async {
    final PendingDynamicLinkData? data =
        await FirebaseDynamicLinks.instance.getInitialLink();
    if (data != null) {
      return _handleDeepLink(data);
    }
    FirebaseDynamicLinks.instance.onLink.listen((event) {
      _handleDeepLink(event);
    });
  }

  _handleDeepLink(PendingDynamicLinkData data) {
    final Uri deepLink = data.link;
    if (deepLink.pathSegments.length > 0 &&
        deepLink.pathSegments[0] == "post") {
      Get.to(() => NoticeDetailLink(noticeId: deepLink.pathSegments[1]));
      // Get.off();
      /* _navigationService.replaceNavWith(SinglePostDetailsDlinkRoute,
            arguments: {"postID": deepLink.pathSegments[1]}); */
    }
  }

  Future<String> createDynamicLink({
    required String title,
    required String desc,
    required String itemId,
    String? imageUrl,
  }) async {
    final DynamicLinkParameters parameters = DynamicLinkParameters(
      uriPrefix: 'https://durkhawpui.page.link',
      link: Uri.parse(dynamicLink2 + "post/$itemId"),
      androidParameters: const AndroidParameters(
        packageName: 'com.durtlang.app',
        minimumVersion: 0,
      ),
      iosParameters: const IOSParameters(
        bundleId: 'com.durtlang.app',
        minimumVersion: '0',
      ),
      socialMetaTagParameters: SocialMetaTagParameters(
        title: title,
        description: desc,
        imageUrl: imageUrl == null ? null : Uri.parse(imageUrl),
      ),
    );
    Uri url;
    final ShortDynamicLink shortLink =
        await dynamicLinks.buildShortLink(parameters);
    url = shortLink.shortUrl;
    String _linkMessage = url.toString();
    return _linkMessage;
  }
}
