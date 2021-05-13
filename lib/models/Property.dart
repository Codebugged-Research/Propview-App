// To parse this JSON data, do
//
//     final property = propertyFromJson(jsonString);

import 'dart:convert';

Property propertyFromJson(String str) => Property.fromJson(json.decode(str));

String propertyToJson(Property data) => json.encode(data.toJson());

class Property {
  Property({
    this.count,
    this.data,
  });

  int count;
  Data data;

  factory Property.fromJson(Map<String, dynamic> json) => Property(
    count: json["count"] == null ? null : json["count"],
    data: json["data"] == null ? null : Data.fromJson(json["data"]),
  );

  Map<String, dynamic> toJson() => {
    "count": count == null ? null : count,
    "data": data == null ? null : data.toJson(),
  };
}

class Data {
  Data({
    this.property,
  });

  List<PropertyElement> property;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    property: json["property"] == null ? null : List<PropertyElement>.from(json["property"].map((x) => PropertyElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "property": property == null ? null : List<dynamic>.from(property.map((x) => x.toJson())),
  };
}

class PropertyElement {
  PropertyElement({
    this.propertyId,
    this.propertyFor,
    this.propertyKind,
    this.ownerId,
    this.flagCategoryId,
    this.flagId,
    this.cid,
    this.sid,
    this.ccid,
    this.locid,
    this.socid,
    this.propertyType,
    this.unitNo,
    this.bhk,
    this.demand,
    this.demandSale,
    this.maintenance,
    this.maintenanceType,
    this.securityDeposit,
    this.bedrooms,
    this.bathrooms,
    this.balcony,
    this.bhkAdd,
    this.superArea,
    this.superPrefix,
    this.carpetArea,
    this.carpetPrefix,
    this.floorNumber,
    this.totalFloors,
    this.parkingOpen,
    this.parkingCovered,
    this.powerBackup,
    this.visitingHoursFrom,
    this.visitingHoursFromPrefix,
    this.visitingHoursTo,
    this.visitingHoursToPrefix,
    this.visitingDays,
    this.bboys,
    this.bgirls,
    this.pets,
    this.foodHabit,
    this.mainDoorFacing,
    this.overlooking,
    this.balconyFacing,
    this.furnishing,
    this.flatsFloor,
    this.ownership,
    this.propertyDescription,
    this.propertyDetail,
    this.propertyDetailId,
    this.propimage,
    this.status,
    this.addedBy,
    this.dateAdded,
    this.userId,
    this.tenantId,
    this.brokerId,
    this.rentDate,
    this.rentRenewalDate,
    this.inactiveDate,
    this.vacatingDate,
    this.firstInspection,
    this.qtr1Inspection,
    this.qtr2Inspection,
    this.qtr3Inspection,
    this.qtr4Inspection,
    this.rentPaymentMethod,
    this.rentInstructions,
    this.generalInstructions,
    this.keyInventory,
    this.brokerName,
    this.lastInspection,
    this.nextInspection,
    this.constructionAge,
    this.additionalInformation,
    this.moreInformation,
    this.plotArea,
    this.plotAreaPrefix,
    this.builtupArea,
    this.builtupAreaPrefix,
    this.lockin,
  });

  int propertyId;
  String propertyFor;
  String propertyKind;
  int ownerId;
  int flagCategoryId;
  int flagId;
  int cid;
  int sid;
  int ccid;
  int locid;
  int socid;
  String propertyType;
  String unitNo;
  String bhk;
  int demand;
  int demandSale;
  int maintenance;
  String maintenanceType;
  int securityDeposit;
  int bedrooms;
  int bathrooms;
  int balcony;
  String bhkAdd;
  int superArea;
  String superPrefix;
  int carpetArea;
  String carpetPrefix;
  int floorNumber;
  int totalFloors;
  int parkingOpen;
  int parkingCovered;
  String powerBackup;
  String visitingHoursFrom;
  String visitingHoursFromPrefix;
  String visitingHoursTo;
  String visitingHoursToPrefix;
  String visitingDays;
  int bboys;
  int bgirls;
  int pets;
  String foodHabit;
  String mainDoorFacing;
  String overlooking;
  String balconyFacing;
  String furnishing;
  int flatsFloor;
  String ownership;
  String propertyDescription;
  String propertyDetail;
  int propertyDetailId;
  String propimage;
  int status;
  int addedBy;
  String dateAdded;
  int userId;
  String tenantId;
  int brokerId;
  DateTime rentDate;
  DateTime rentRenewalDate;
  String inactiveDate;
  String vacatingDate;
  DateTime firstInspection;
  DateTime qtr1Inspection;
  DateTime qtr2Inspection;
  DateTime qtr3Inspection;
  DateTime qtr4Inspection;
  String rentPaymentMethod;
  String rentInstructions;
  String generalInstructions;
  String keyInventory;
  String brokerName;
  DateTime lastInspection;
  DateTime nextInspection;
  int constructionAge;
  String additionalInformation;
  String moreInformation;
  int plotArea;
  String plotAreaPrefix;
  int builtupArea;
  String builtupAreaPrefix;
  int lockin;

  factory PropertyElement.fromJson(Map<String, dynamic> json) => PropertyElement(
    propertyId: json["property_id"] == null ? null : json["property_id"],
    propertyFor: json["property_for"] == null ? null : json["property_for"],
    propertyKind: json["property_kind"] == null ? null : json["property_kind"],
    ownerId: json["owner_id"] == null ? null : json["owner_id"],
    flagCategoryId: json["flag_category_id"] == null ? null : json["flag_category_id"],
    flagId: json["flag_id"] == null ? null : json["flag_id"],
    cid: json["cid"] == null ? null : json["cid"],
    sid: json["sid"] == null ? null : json["sid"],
    ccid: json["ccid"] == null ? null : json["ccid"],
    locid: json["locid"] == null ? null : json["locid"],
    socid: json["socid"] == null ? null : json["socid"],
    propertyType: json["property_type"] == null ? null : json["property_type"],
    unitNo: json["unit_no"] == null ? null : json["unit_no"],
    bhk: json["bhk"] == null ? null : json["bhk"],
    demand: json["demand"] == null ? null : json["demand"],
    demandSale: json["demand_sale"] == null ? null : json["demand_sale"],
    maintenance: json["maintenance"] == null ? null : json["maintenance"],
    maintenanceType: json["maintenance_type"] == null ? null : json["maintenance_type"],
    securityDeposit: json["security_deposit"] == null ? null : json["security_deposit"],
    bedrooms: json["bedrooms"] == null ? null : json["bedrooms"],
    bathrooms: json["bathrooms"] == null ? null : json["bathrooms"],
    balcony: json["balcony"] == null ? null : json["balcony"],
    bhkAdd: json["bhk_add"] == null ? null : json["bhk_add"],
    superArea: json["super_area"] == null ? null : json["super_area"],
    superPrefix: json["super_prefix"] == null ? null : json["super_prefix"],
    carpetArea: json["carpet_area"] == null ? null : json["carpet_area"],
    carpetPrefix: json["carpet_prefix"] == null ? null : json["carpet_prefix"],
    floorNumber: json["floor_number"] == null ? null : json["floor_number"],
    totalFloors: json["total_floors"] == null ? null : json["total_floors"],
    parkingOpen: json["parking_open"] == null ? null : json["parking_open"],
    parkingCovered: json["parking_covered"] == null ? null : json["parking_covered"],
    powerBackup: json["power_backup"] == null ? null : json["power_backup"],
    visitingHoursFrom: json["visiting_hours_from"] == null ? null : json["visiting_hours_from"],
    visitingHoursFromPrefix: json["visiting_hours_from_prefix"] == null ? null : json["visiting_hours_from_prefix"],
    visitingHoursTo: json["visiting_hours_to"] == null ? null : json["visiting_hours_to"],
    visitingHoursToPrefix: json["visiting_hours_to_prefix"] == null ? null : json["visiting_hours_to_prefix"],
    visitingDays: json["visiting_days"] == null ? null : json["visiting_days"],
    bboys: json["bboys"] == null ? null : json["bboys"],
    bgirls: json["bgirls"] == null ? null : json["bgirls"],
    pets: json["pets"] == null ? null : json["pets"],
    foodHabit: json["food_habit"] == null ? null : json["food_habit"],
    mainDoorFacing: json["main_door_facing"] == null ? null : json["main_door_facing"],
    overlooking: json["overlooking"] == null ? null : json["overlooking"],
    balconyFacing: json["balcony_facing"] == null ? null : json["balcony_facing"],
    furnishing: json["furnishing"] == null ? null : json["furnishing"],
    flatsFloor: json["flats_floor"] == null ? null : json["flats_floor"],
    ownership: json["ownership"] == null ? null : json["ownership"],
    propertyDescription: json["property_description"] == null ? null : json["property_description"],
    propertyDetail: json["property_detail"] == null ? null : json["property_detail"],
    propertyDetailId: json["property_detail_id"] == null ? null : json["property_detail_id"],
    propimage: json["propimage"] == null ? null : json["propimage"],
    status: json["status"] == null ? null : json["status"],
    addedBy: json["added_by"] == null ? null : json["added_by"],
    dateAdded: json["date_added"] == null ? null : json["date_added"],
    userId: json["user_id"] == null ? null : json["user_id"],
    tenantId: json["tenant_id"] == null ? null : json["tenant_id"],
    brokerId: json["broker_id"] == null ? null : json["broker_id"],
    rentDate: json["rent_date"] == null ? null : DateTime.parse(json["rent_date"]),
    rentRenewalDate: json["rent_renewal_date"] == null ? null : DateTime.parse(json["rent_renewal_date"]),
    inactiveDate: json["inactive_date"] == null ? null : json["inactive_date"],
    vacatingDate: json["vacating_date"] == null ? null : json["vacating_date"],
    firstInspection: json["first_inspection"] == null ? null : DateTime.parse(json["first_inspection"]),
    qtr1Inspection: json["qtr1_inspection"] == null ? null : DateTime.parse(json["qtr1_inspection"]),
    qtr2Inspection: json["qtr2_inspection"] == null ? null : DateTime.parse(json["qtr2_inspection"]),
    qtr3Inspection: json["qtr3_inspection"] == null ? null : DateTime.parse(json["qtr3_inspection"]),
    qtr4Inspection: json["qtr4_inspection"] == null ? null : DateTime.parse(json["qtr4_inspection"]),
    rentPaymentMethod: json["rent_payment_method"] == null ? null : json["rent_payment_method"],
    rentInstructions: json["rent_instructions"] == null ? null : json["rent_instructions"],
    generalInstructions: json["general_instructions"] == null ? null : json["general_instructions"],
    keyInventory: json["key_inventory"] == null ? null : json["key_inventory"],
    brokerName: json["broker_name"] == null ? null : json["broker_name"],
    lastInspection: json["last_inspection"] == null ? null : DateTime.parse(json["last_inspection"]),
    nextInspection: json["next_inspection"] == null ? null : DateTime.parse(json["next_inspection"]),
    constructionAge: json["construction_age"] == null ? null : json["construction_age"],
    additionalInformation: json["additional_information"] == null ? null : json["additional_information"],
    moreInformation: json["more_information"] == null ? null : json["more_information"],
    plotArea: json["plot_area"] == null ? null : json["plot_area"],
    plotAreaPrefix: json["plot_area_prefix"] == null ? null : json["plot_area_prefix"],
    builtupArea: json["builtup_area"] == null ? null : json["builtup_area"],
    builtupAreaPrefix: json["builtup_area_prefix"] == null ? null : json["builtup_area_prefix"],
    lockin: json["lockin"] == null ? null : json["lockin"],
  );

  Map<String, dynamic> toJson() => {
    "property_id": propertyId == null ? null : propertyId,
    "property_for": propertyFor == null ? null : propertyFor,
    "property_kind": propertyKind == null ? null : propertyKind,
    "owner_id": ownerId == null ? null : ownerId,
    "flag_category_id": flagCategoryId == null ? null : flagCategoryId,
    "flag_id": flagId == null ? null : flagId,
    "cid": cid == null ? null : cid,
    "sid": sid == null ? null : sid,
    "ccid": ccid == null ? null : ccid,
    "locid": locid == null ? null : locid,
    "socid": socid == null ? null : socid,
    "property_type": propertyType == null ? null : propertyType,
    "unit_no": unitNo == null ? null : unitNo,
    "bhk": bhk == null ? null : bhk,
    "demand": demand == null ? null : demand,
    "demand_sale": demandSale == null ? null : demandSale,
    "maintenance": maintenance == null ? null : maintenance,
    "maintenance_type": maintenanceType == null ? null : maintenanceType,
    "security_deposit": securityDeposit == null ? null : securityDeposit,
    "bedrooms": bedrooms == null ? null : bedrooms,
    "bathrooms": bathrooms == null ? null : bathrooms,
    "balcony": balcony == null ? null : balcony,
    "bhk_add": bhkAdd == null ? null : bhkAdd,
    "super_area": superArea == null ? null : superArea,
    "super_prefix": superPrefix == null ? null : superPrefix,
    "carpet_area": carpetArea == null ? null : carpetArea,
    "carpet_prefix": carpetPrefix == null ? null : carpetPrefix,
    "floor_number": floorNumber == null ? null : floorNumber,
    "total_floors": totalFloors == null ? null : totalFloors,
    "parking_open": parkingOpen == null ? null : parkingOpen,
    "parking_covered": parkingCovered == null ? null : parkingCovered,
    "power_backup": powerBackup == null ? null : powerBackup,
    "visiting_hours_from": visitingHoursFrom == null ? null : visitingHoursFrom,
    "visiting_hours_from_prefix": visitingHoursFromPrefix == null ? null : visitingHoursFromPrefix,
    "visiting_hours_to": visitingHoursTo == null ? null : visitingHoursTo,
    "visiting_hours_to_prefix": visitingHoursToPrefix == null ? null : visitingHoursToPrefix,
    "visiting_days": visitingDays == null ? null : visitingDays,
    "bboys": bboys == null ? null : bboys,
    "bgirls": bgirls == null ? null : bgirls,
    "pets": pets == null ? null : pets,
    "food_habit": foodHabit == null ? null : foodHabit,
    "main_door_facing": mainDoorFacing == null ? null : mainDoorFacing,
    "overlooking": overlooking == null ? null : overlooking,
    "balcony_facing": balconyFacing == null ? null : balconyFacing,
    "furnishing": furnishing == null ? null : furnishing,
    "flats_floor": flatsFloor == null ? null : flatsFloor,
    "ownership": ownership == null ? null : ownership,
    "property_description": propertyDescription == null ? null : propertyDescription,
    "property_detail": propertyDetail == null ? null : propertyDetail,
    "property_detail_id": propertyDetailId == null ? null : propertyDetailId,
    "propimage": propimage == null ? null : propimage,
    "status": status == null ? null : status,
    "added_by": addedBy == null ? null : addedBy,
    "date_added": dateAdded == null ? null : dateAdded,
    "user_id": userId == null ? null : userId,
    "tenant_id": tenantId == null ? null : tenantId,
    "broker_id": brokerId == null ? null : brokerId,
    "rent_date": rentDate == null ? null : rentDate.toIso8601String(),
    "rent_renewal_date": rentRenewalDate == null ? null : rentRenewalDate.toIso8601String(),
    "inactive_date": inactiveDate == null ? null : inactiveDate,
    "vacating_date": vacatingDate == null ? null : vacatingDate,
    "first_inspection": firstInspection == null ? null : firstInspection.toIso8601String(),
    "qtr1_inspection": qtr1Inspection == null ? null : qtr1Inspection.toIso8601String(),
    "qtr2_inspection": qtr2Inspection == null ? null : qtr2Inspection.toIso8601String(),
    "qtr3_inspection": qtr3Inspection == null ? null : qtr3Inspection.toIso8601String(),
    "qtr4_inspection": qtr4Inspection == null ? null : qtr4Inspection.toIso8601String(),
    "rent_payment_method": rentPaymentMethod == null ? null : rentPaymentMethod,
    "rent_instructions": rentInstructions == null ? null : rentInstructions,
    "general_instructions": generalInstructions == null ? null : generalInstructions,
    "key_inventory": keyInventory == null ? null : keyInventory,
    "broker_name": brokerName == null ? null : brokerName,
    "last_inspection": lastInspection == null ? null : lastInspection.toIso8601String(),
    "next_inspection": nextInspection == null ? null : nextInspection.toIso8601String(),
    "construction_age": constructionAge == null ? null : constructionAge,
    "additional_information": additionalInformation == null ? null : additionalInformation,
    "more_information": moreInformation == null ? null : moreInformation,
    "plot_area": plotArea == null ? null : plotArea,
    "plot_area_prefix": plotAreaPrefix == null ? null : plotAreaPrefix,
    "builtup_area": builtupArea == null ? null : builtupArea,
    "builtup_area_prefix": builtupAreaPrefix == null ? null : builtupAreaPrefix,
    "lockin": lockin == null ? null : lockin,
  };
}
