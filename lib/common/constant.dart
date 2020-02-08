import 'package:flutter/material.dart';

const String API_URL = "http://smartsociety.itfuturz.com/api/AppAPI/";
const String Image_Url = "http://smartsociety.itfuturz.com";
const Inr_Rupee = "₹";

const String whatsAppLink = "https://wa.me/#mobile?text=#msg";

class Session {
  static const String session_login = "Login_data";
  static const String Member_Id = "Member_id";
  static const String SocietyId = "Society_id";
  static const String Name = "Member_Name";
  static const String Profile = "Profile";
  static const String CompanyName = "Companyname";
  static const String Designation = "BusinessJob";
  static const String BusinessDescription = "Description";
  static const String BloodGroup = "Bloodgroup";
  static const String Gender = "Gender";
  static const String DOB = "Dob";
  static const String ResidenceType = "ResidenceType";
  static const String FlatNo = "FlatNo";
  static const String Wing = "Wing";
  static const String WingId = "WingId";
  static const String Address = "Address";
  static const String isPrivate = "isPrivate";
  static const String ParentId = "ParentId";
  static const String ProfileUpdateFlag = "ProfileUpdateFlag";

  static const String EventId = "EventId";
  static const String IsVerified = "is_verified";
}

Map<int, Color> appprimarycolors = {
  50: Color.fromRGBO(114,34, 169, .1),
  100: Color.fromRGBO(114,34, 169, .2),
  200: Color.fromRGBO(114,34, 169, .3),
  300: Color.fromRGBO(114,34, 169, .4),
  400: Color.fromRGBO(114,34, 169, .5),
  500: Color.fromRGBO(114,34, 169, .6),
  600: Color.fromRGBO(114,34, 169, .7),
  700: Color.fromRGBO(114,34, 169, .8),
  800: Color.fromRGBO(114,34, 169, .9),
  900: Color.fromRGBO(114,34, 169, 1)
};

MaterialColor appPrimaryMaterialColor =
    MaterialColor(0xFF7222A9, appprimarycolors);
