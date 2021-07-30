// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
    Welcome({
        this.success,
        this.data,
    });

    bool success;
    Data data;

    factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        success: json["success"] == null ? null : json["success"],
        data: json["data"] == null ? null : Data.fromJson(json["data"]),
    );

    Map<String, dynamic> toJson() => {
        "success": success == null ? null : success,
        "data": data == null ? null : data.toJson(),
    };
}

class Data {
    Data({
        this.inspection,
    });

    List<Inspection> inspection;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        inspection: json["inspection"] == null ? null : List<Inspection>.from(json["inspection"].map((x) => Inspection.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "inspection": inspection == null ? null : List<dynamic>.from(inspection.map((x) => x.toJson())),
    };
}

class Inspection {
    Inspection({
        this.inspectionId,
        this.inspectType,
        this.maintenanceCharges,
        this.commonAreaElectricity,
        this.electricitySociety,
        this.electricityAuthority,
        this.powerBackup,
        this.pngLgp,
        this.club,
        this.water,
        this.propertyTax,
        this.anyOther,
        this.propertyId,
        this.employeeId,
        this.issueIdList,
    });

    int inspectionId;
    String inspectType;
    double maintenanceCharges;
    double commonAreaElectricity;
    double electricitySociety;
    double electricityAuthority;
    double powerBackup;
    double pngLgp;
    double club;
    double water;
    double propertyTax;
    double anyOther;
    int propertyId;
    int employeeId;
    String issueIdList;

    factory Inspection.fromJson(Map<String, dynamic> json) => Inspection(
        inspectionId: json["inspection_id"] == null ? null : json["inspection_id"],
        inspectType: json["inspect_type"] == null ? null : json["inspect_type"],
        maintenanceCharges: json["maintenance_charges"] == null ? null : json["maintenance_charges"].toDouble(),
        commonAreaElectricity: json["common_area_electricity"] == null ? null : json["common_area_electricity"].toDouble(),
        electricitySociety: json["electricity_society"] == null ? null : json["electricity_society"].toDouble(),
        electricityAuthority: json["electricity_authority"] == null ? null : json["electricity_authority"].toDouble(),
        powerBackup: json["power_backup"] == null ? null : json["power_backup"].toDouble(),
        pngLgp: json["png_lgp"] == null ? null : json["png_lgp"].toDouble(),
        club: json["club"] == null ? null : json["club"].toDouble(),
        water: json["water"] == null ? null : json["water"].toDouble(),
        propertyTax: json["property_tax"] == null ? null : json["property_tax"].toDouble(),
        anyOther: json["any_other"] == null ? null : json["any_other"].toDouble(),
        propertyId: json["property_id"] == null ? null : json["property_id"],
        employeeId: json["employee_id"] == null ? null : json["employee_id"],
        issueIdList: json["issue_id_list"] == null ? null : json["issue_id_list"],
    );

    Map<String, dynamic> toJson() => {
        "inspection_id": inspectionId == null ? null : inspectionId,
        "inspect_type": inspectType == null ? null : inspectType,
        "maintenance_charges": maintenanceCharges == null ? null : maintenanceCharges,
        "common_area_electricity": commonAreaElectricity == null ? null : commonAreaElectricity,
        "electricity_society": electricitySociety == null ? null : electricitySociety,
        "electricity_authority": electricityAuthority == null ? null : electricityAuthority,
        "power_backup": powerBackup == null ? null : powerBackup,
        "png_lgp": pngLgp == null ? null : pngLgp,
        "club": club == null ? null : club,
        "water": water == null ? null : water,
        "property_tax": propertyTax == null ? null : propertyTax,
        "any_other": anyOther == null ? null : anyOther,
        "property_id": propertyId == null ? null : propertyId,
        "employee_id": employeeId == null ? null : employeeId,
        "issue_id_list": issueIdList == null ? null : issueIdList,
    };
}
