package me.carda.awesome_notifications.core.managers;

import androidx.lifecycle.GeneratedAdapter;
import androidx.lifecycle.Lifecycle;
import androidx.lifecycle.LifecycleOwner;
import androidx.lifecycle.MethodCallsLogger;
import java.lang.Override;

public class LifeCycleManager_LifecycleAdapter implements GeneratedAdapter {
  final LifeCycleManager mReceiver;

  LifeCycleManager_LifecycleAdapter(LifeCycleManager receiver) {
    this.mReceiver = receiver;
  }

  @Override
  public void callMethods(LifecycleOwner owner, Lifecycle.Event event, boolean onAny,
      MethodCallsLogger logger) {
    boolean hasLogger = logger != null;
    if (onAny) {
      return;
    }
    if (event == Lifecycle.Event.ON_CREATE) {
      if (!hasLogger || logger.approveCall("onCreated", 1)) {
        mReceiver.onCreated();
      }
      return;
    }
    if (event == Lifecycle.Event.ON_START) {
      if (!hasLogger || logger.approveCall("onStarted", 1)) {
        mReceiver.onStarted();
      }
      return;
    }
    if (event == Lifecycle.Event.ON_RESUME) {
      if (!hasLogger || logger.approveCall("onResumed", 1)) {
        mReceiver.onResumed();
      }
      return;
    }
    if (event == Lifecycle.Event.ON_PAUSE) {
      if (!hasLogger || logger.approveCall("onPaused", 1)) {
        mReceiver.onPaused();
      }
      return;
    }
    if (event == Lifecycle.Event.ON_STOP) {
      if (!hasLogger || logger.approveCall("onStopped", 1)) {
        mReceiver.onStopped();
      }
      return;
    }
    if (event == Lifecycle.Event.ON_DESTROY) {
      if (!hasLogger || logger.approveCall("onDestroyed", 1)) {
        mReceiver.onDestroyed();
      }
      return;
    }
  }
}
