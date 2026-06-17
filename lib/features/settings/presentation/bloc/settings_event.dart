abstract class SettingsEvent {
  const SettingsEvent();
}

class LoadSettingsInfoRequested extends SettingsEvent {}

class WipeAllUserDataRequested extends SettingsEvent {}
