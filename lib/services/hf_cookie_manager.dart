import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class HFCookieManager {
  static final CookieManager _cookieManager = CookieManager.instance();

  static Future<void> setHFAuthCookie(String accessToken) async {
    try {
      await _cookieManager.setCookie(
        url: WebUri('https://huggingface.co'),
        name: 'token',
        value: accessToken,
        domain: '.huggingface.co',
        path: '/',
        isSecure: true,
        isHttpOnly: true,
        sameSite: HTTPCookieSameSitePolicy.LAX,
      );

    } catch (e) {

    }
  }

  static Future<void> clearHFCookies() async {
    try {
      await _cookieManager.deleteCookies(
        url: WebUri('https://huggingface.co'),
        domain: '.huggingface.co',
      );

      await _cookieManager.deleteCookies(
        url: WebUri('https://huggingface.co/chat'),
        domain: '.huggingface.co',
      );

    } catch (e) {

    }
  }

  static Future<String?> getHFAuthCookie() async {
    try {
      final cookies = await _cookieManager.getCookies(
        url: WebUri('https://huggingface.co'),
      );

      for (final cookie in cookies) {
        if (cookie.name == 'token') {
          return cookie.value;
        }
      }

      return null;
    } catch (e) {

      return null;
    }
  }

  static Future<bool> isLoggedInViaCookie() async {
    final cookie = await getHFAuthCookie();
    return cookie != null && cookie.isNotEmpty;
  }
}
