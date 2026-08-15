import 'presence_web_hooks_base.dart';

class StubPresenceWebHooksHandle implements PresenceWebHooksHandle {
  @override
  Future<void> dispose() async {}
}

PresenceWebHooksHandle registerPresenceWebHooks({
  required String uid,
}) {
  return StubPresenceWebHooksHandle();
}