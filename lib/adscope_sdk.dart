import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

/// Flutter层公用的Channel优化版
class AdscopeSdk {
  static const MethodChannel _channel = MethodChannel('adscope_sdk');
  // 使用 Map 代替 Set，通过 Key 来保证唯一性，防止重复注册
  static final Map<String, Future<dynamic> Function(MethodCall)> _handlers = {};
  static bool _isInitialized = false;

  AdscopeSdk._();

  /// 注册 MethodCall 回调，增加 key 标识
  static void addMethodCallHandler(String key, Future<dynamic> Function(MethodCall call) handler) {
    _handlers[key] = handler; // 如果 key 相同，会自动覆盖旧的，防止队列膨胀
    if (!_isInitialized) {
      _isInitialized = true;
      _channel.setMethodCallHandler((MethodCall call) async {
        final List<Function> targets = _handlers.values.toList();
        for (var handle in targets) {
          try {
            await handle(call);
          } catch (e) {
            debugPrint('AdscopeSdk Handler Error: $e');
          }
        }
      });
    }
  }

  /// 移除回调
  static void removeMethodCallHandler(String key) {
    _handlers.remove(key);
  }

  static Future<T?> invokeMethod<T>(String method, [dynamic arguments]) {
    return _channel.invokeMethod<T>(method, arguments);
  }

  static Future<Future> invokeMapMethod(String interstitialGetMediaExtraInfo) async {
    return _channel.invokeMethod(interstitialGetMediaExtraInfo);
  }
}
