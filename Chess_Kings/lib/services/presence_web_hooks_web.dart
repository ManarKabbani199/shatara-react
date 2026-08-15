import 'dart:async';
import 'dart:html' as html;

import 'package:cloud_firestore/cloud_firestore.dart';

import 'presence_web_hooks_base.dart';

class WebPresenceWebHooksHandle implements PresenceWebHooksHandle {
  WebPresenceWebHooksHandle(this._subscriptions);

  final List<StreamSubscription> _subscriptions;

  @override
  Future<void> dispose() async {
    for (final sub in _subscriptions) {
      await sub.cancel();
    }
    _subscriptions.clear();
  }
}

PresenceWebHooksHandle registerPresenceWebHooks({
  required String uid,
}) {
  final ref = FirebaseFirestore.instance.collection('users').doc(uid);

  Future<void> setOffline() async {
    try {
      await ref.set({
        'online': false,
        'lastSeen': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (_) {}
  }

  final subscriptions = <StreamSubscription>[];

  subscriptions.add(
    html.document.onVisibilityChange.listen((_) {
      if (html.document.visibilityState == 'hidden') {
        unawaited(setOffline());
      }
    }),
  );

  subscriptions.add(
    html.window.onPageHide.listen((_) {
      unawaited(setOffline());
    }),
  );

  subscriptions.add(
    html.window.onBeforeUnload.listen((_) {
      unawaited(setOffline());
    }),
  );

  return WebPresenceWebHooksHandle(subscriptions);
}