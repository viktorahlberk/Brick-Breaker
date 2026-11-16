abstract class BonusEffect {
  void Function()? onExpired;

  bool get isActive => false;
  void onApply();
  void onUpdate(double dt);
  void onRemove();
  void dispose() {}
}
