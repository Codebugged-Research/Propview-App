import 'package:propview/models/Facility.dart';

class PropertyFunctions {
  static getFacilityName(List<Facility> facilities) {
    return facilities
        .map((facility) => facility.facilityName.toString())
        .toList();
  }

  static List<String> getFlooringType() {
    return ['Vitrified Tiles', 'Marble', 'Wooden'];
  }
}
