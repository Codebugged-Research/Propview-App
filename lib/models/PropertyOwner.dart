// To parse this JSON data, do
//
//     final propertyOwner = propertyOwnerFromJson(jsonString);

import 'dart:convert';

PropertyOwner propertyOwnerFromJson(String str) => PropertyOwner.fromJson(json.decode(str));

String propertyOwnerToJson(PropertyOwner data) => json.encode(data.toJson());

class PropertyOwner {
  PropertyOwner({
    this.count,
    this.data,
  });

  int count;
  Data data;

  factory PropertyOwner.fromJson(Map<String, dynamic> json) => PropertyOwner(
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
    this.propertyOwner,
  });

  List<PropertyOwnerElement> propertyOwner;

  factory Data.fromJson(Map<String, dynamic> json) => Data(
    propertyOwner: json["propertyOwner"] == null ? null : List<PropertyOwnerElement>.from(json["propertyOwner"].map((x) => PropertyOwnerElement.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "propertyOwner": propertyOwner == null ? null : List<dynamic>.from(propertyOwner.map((x) => x.toJson())),
  };
}

class PropertyOwnerElement {
  PropertyOwnerElement({
    this.ownerId,
    this.salutation,
    this.ownerName,
    this.ownerNumber,
    this.whatsappNumber,
    this.ownerEmail,
    this.ownerAddress,
    this.ownerPassword,
    this.ownerName1,
    this.ownerEmail1,
    this.ownerNumber1,
    this.country,
    this.accountName,
    this.bankName,
    this.accountNumber,
    this.bankIfsc,
    this.accountType,
    this.panNumber,
    this.panNumber1,
    this.aadhaar,
    this.aadhaar1,
    this.instruction,
    this.refName,
    this.refEmail,
    this.refNumber,
    this.refRelation,
    this.refAddress,
    this.poaName,
    this.poaNumber,
    this.poaEmail,
    this.poaRelation,
    this.poaAddress,
    this.forRef,
    this.addedon,
    this.status,
    this.sendmail,
    this.newsletter,
  });

  int ownerId;
  String salutation;
  String ownerName;
  String ownerNumber;
  String whatsappNumber;
  String ownerEmail;
  String ownerAddress;
  String ownerPassword;
  String ownerName1;
  String ownerEmail1;
  String ownerNumber1;
  String country;
  String accountName;
  String bankName;
  String accountNumber;
  String bankIfsc;
  String accountType;
  String panNumber;
  String panNumber1;
  String aadhaar;
  String aadhaar1;
  String instruction;
  String refName;
  String refEmail;
  String refNumber;
  String refRelation;
  String refAddress;
  String poaName;
  String poaNumber;
  String poaEmail;
  String poaRelation;
  String poaAddress;
  String forRef;
  String addedon;
  int status;
  int sendmail;
  int newsletter;

  factory PropertyOwnerElement.fromJson(Map<String, dynamic> json) => PropertyOwnerElement(
    ownerId: json["owner_id"] == null ? null : json["owner_id"],
    salutation: json["salutation"] == null ? null : json["salutation"],
    ownerName: json["owner_name"] == null ? null : json["owner_name"],
    ownerNumber: json["owner_number"] == null ? null : json["owner_number"],
    whatsappNumber: json["whatsapp_number"] == null ? null : json["whatsapp_number"],
    ownerEmail: json["owner_email"] == null ? null : json["owner_email"],
    ownerAddress: json["owner_address"] == null ? null : json["owner_address"],
    ownerPassword: json["owner_password"] == null ? null : json["owner_password"],
    ownerName1: json["owner_name1"] == null ? null : json["owner_name1"],
    ownerEmail1: json["owner_email1"] == null ? null : json["owner_email1"],
    ownerNumber1: json["owner_number1"] == null ? null : json["owner_number1"],
    country: json["country"] == null ? null : json["country"],
    accountName: json["account_name"] == null ? null : json["account_name"],
    bankName: json["bank_name"] == null ? null : json["bank_name"],
    accountNumber: json["account_number"] == null ? null : json["account_number"],
    bankIfsc: json["bank_ifsc"] == null ? null : json["bank_ifsc"],
    accountType: json["account_type"] == null ? null : json["account_type"],
    panNumber: json["pan_number"] == null ? null : json["pan_number"],
    panNumber1: json["pan_number1"] == null ? null : json["pan_number1"],
    aadhaar: json["aadhaar"] == null ? null : json["aadhaar"],
    aadhaar1: json["aadhaar1"] == null ? null : json["aadhaar1"],
    instruction: json["instruction"] == null ? null : json["instruction"],
    refName: json["ref_name"] == null ? null : json["ref_name"],
    refEmail: json["ref_email"] == null ? null : json["ref_email"],
    refNumber: json["ref_number"] == null ? null : json["ref_number"],
    refRelation: json["ref_relation"] == null ? null : json["ref_relation"],
    refAddress: json["ref_address"] == null ? null : json["ref_address"],
    poaName: json["poa_name"] == null ? null : json["poa_name"],
    poaNumber: json["poa_number"] == null ? null : json["poa_number"],
    poaEmail: json["poa_email"] == null ? null : json["poa_email"],
    poaRelation: json["poa_relation"] == null ? null : json["poa_relation"],
    poaAddress: json["poa_address"] == null ? null : json["poa_address"],
    forRef: json["for_ref"] == null ? null : json["for_ref"],
    addedon: json["addedon"] == null ? null : json["addedon"],
    status: json["status"] == null ? null : json["status"],
    sendmail: json["sendmail"] == null ? null : json["sendmail"],
    newsletter: json["newsletter"] == null ? null : json["newsletter"],
  );

  Map<String, dynamic> toJson() => {
    "owner_id": ownerId == null ? null : ownerId,
    "salutation": salutation == null ? null : salutation,
    "owner_name": ownerName == null ? null : ownerName,
    "owner_number": ownerNumber == null ? null : ownerNumber,
    "whatsapp_number": whatsappNumber == null ? null : whatsappNumber,
    "owner_email": ownerEmail == null ? null : ownerEmail,
    "owner_address": ownerAddress == null ? null : ownerAddress,
    "owner_password": ownerPassword == null ? null : ownerPassword,
    "owner_name1": ownerName1 == null ? null : ownerName1,
    "owner_email1": ownerEmail1 == null ? null : ownerEmail1,
    "owner_number1": ownerNumber1 == null ? null : ownerNumber1,
    "country": country == null ? null : country,
    "account_name": accountName == null ? null : accountName,
    "bank_name": bankName == null ? null : bankName,
    "account_number": accountNumber == null ? null : accountNumber,
    "bank_ifsc": bankIfsc == null ? null : bankIfsc,
    "account_type": accountType == null ? null : accountType,
    "pan_number": panNumber == null ? null : panNumber,
    "pan_number1": panNumber1 == null ? null : panNumber1,
    "aadhaar": aadhaar == null ? null : aadhaar,
    "aadhaar1": aadhaar1 == null ? null : aadhaar1,
    "instruction": instruction == null ? null : instruction,
    "ref_name": refName == null ? null : refName,
    "ref_email": refEmail == null ? null : refEmail,
    "ref_number": refNumber == null ? null : refNumber,
    "ref_relation": refRelation == null ? null : refRelation,
    "ref_address": refAddress == null ? null : refAddress,
    "poa_name": poaName == null ? null : poaName,
    "poa_number": poaNumber == null ? null : poaNumber,
    "poa_email": poaEmail == null ? null : poaEmail,
    "poa_relation": poaRelation == null ? null : poaRelation,
    "poa_address": poaAddress == null ? null : poaAddress,
    "for_ref": forRef == null ? null : forRef,
    "addedon": addedon == null ? null : addedon,
    "status": status == null ? null : status,
    "sendmail": sendmail == null ? null : sendmail,
    "newsletter": newsletter == null ? null : newsletter,
  };
}
