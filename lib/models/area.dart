class Area {
  late bool isActive;
  late String areaName;

  Area(String areaName_)
      : areaName = areaName_,
        isActive = true;

  @override
  int get hashCode => areaName.hashCode;

  // Method to check object equality (optional)
  bool equals(Area other) =>
      other.areaName == areaName && other.isActive == isActive;

  @override
  String toString() => 'Area{areaName: $areaName, isActive: $isActive}';
}
