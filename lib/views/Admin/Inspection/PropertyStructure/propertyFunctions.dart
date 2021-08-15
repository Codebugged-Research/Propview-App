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

  static List<String> getFacilitiesId(
      List<Facility> facilities, List<String> facilityName) {
    List<String> facilitiesId = [];
    for (var i = 0; i < facilityName.length; i++) {
      for (var j = 0; j < facilities.length; j++) {
        if (facilityName[i] == facilities[j].facilityName)
          facilitiesId.add(facilities[j].facilityId.toString());
      }
    }
    return facilitiesId;
  }
}
