import 'dart:convert';
import 'package:agora_rtm/agora_rtm.dart';

class SignalingService {
  final String appId;
  final String userId;
  final String channelName;

  late RtmClient _client;

  Function(String fromUserId, String message)? onMessageReceived;

  SignalingService({
    required this.appId,
    required this.userId,
    required this.channelName,
  });

  Future<void> init() async {
    final (status, client) = await RTM(appId, userId);
    if (status.error) {
      print("RTM init failed: ${status.reason}");
      return;
    }

    _client = client;

    _client.addListener(
      message: (event) {
        final msg = utf8.decode(event.message!);
        print("📩 Message from ${event.publisher}: $msg");
        onMessageReceived?.call(event.publisher ?? '', msg);
      },
      linkState: (event) {
        print('🔗 Link state changed: ${event.previousState} -> ${event.currentState}');
      },
    );

    final loginStatus = await _client.login(appId);
    if (loginStatus.$1.error) {
      print("RTM login failed: ${loginStatus.$1.reason}");
      return;
    }

    final subscribeStatus = await _client.subscribe(channelName);
    if (subscribeStatus.$1.error) {
      print("RTM subscribe failed: ${subscribeStatus.$1.reason}");
      return;
    }

    print("✅ RTM Initialized and Subscribed to $channelName");
  }

  Future<void> sendMessage(String message) async {
    final (status, _) = await _client.publish(
      channelName,
      message,
      channelType: RtmChannelType.message,
      customType: 'PlainText',
    );

    if (status.error) {
      print("❌ Failed to send message: ${status.reason}");
    } else {
      print("📤 Sent message: $message");
    }
  }

  Future<void> dispose() async {
    await _client.unsubscribe(channelName);
    await _client.logout();
  }
}
