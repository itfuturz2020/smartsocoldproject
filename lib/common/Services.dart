import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smart_society_new/common/Classlist.dart';
import 'package:smart_society_new/common/constant.dart' as constant;
import 'package:smart_society_new/common/constant.dart';
import 'package:xml2json/xml2json.dart';

Dio dio = new Dio();
Xml2Json xml2json = new Xml2Json();

class Services {
  static Future<SaveDataClass> Registration(body) async {
    print(body.toString());
    String url = API_URL + 'MemberRegistration';
    print("Registration url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0', IsRecord: false);

        print("Registration Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error Registration");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Registration : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  // Society code verify

  static Future<SaveDataClass> Societycodeverify(String Code) async {
    String url = API_URL + 'GetSocietyIdByCode?societyCode=$Code';
    print("Societycodeverify url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0', IsRecord: false);

        print("Societycodeverify Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error Societycodeverify");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Societycodeverify   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  // Get Notice

  static Future<List> GetNotice(String SocietyId) async {
    String url = API_URL + 'GetNotice?societyId=$SocietyId';
    print("GetNotice url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("GetNotice Response: " + response.data.toString());
        var NoticeData = response.data;
        if (NoticeData["IsSuccess"] == true) {
          print(NoticeData["Data"]);
          list = NoticeData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetNotice");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetNotice   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  // My Visitorlist

  static Future<List> GetMyVisitorList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MemberId = prefs.getString(constant.Session.Member_Id);
    String SocietyID = prefs.getString(constant.Session.SocietyId);
    String url = API_URL +
        'GetVisitorsByMemberId?societyId=$SocietyID&memberId=$MemberId';
    print("GetVisitorurl url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("GetVisitorurl Response: " + response.data.toString());
        var VisitorData = response.data;
        if (VisitorData["IsSuccess"] == true) {
          list = VisitorData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetVisitorurl");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetVisitorurl   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> MemberLogin(String MobileNumber) async {
    String url = API_URL + 'MemberLogin?mobile=$MobileNumber';
    print("getLogin url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];

        print("getLogin Response: " + response.data.toString());
        var MemberData = response.data;
        if (MemberData["IsSuccess"] == true) {
          print(MemberData["Data"]);
          list = MemberData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error getLogin");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error getLogin : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> SendVerficationCode(
      String mobile, String code) async {
    String url = API_URL + 'SendVerificationCode?mobileNo=$mobile&code=$code';
    print("SendVerficationCode URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: "");
        print("SendVerficationCode Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Wenr Wrong");
      }
    } catch (e) {
      print("SendVerficationCode Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> Checkverification(String MemberId) async {
    String url = API_URL + 'MemberOTPVerification?Id=$MemberId';
    print("MemberOTPVerification URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: "");
        print("MemberOTPVerification Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Wenr Wrong");
      }
    } catch (e) {
      print("MemberOTPVerification Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> AddVisitor(body) async {
    print(body.toString());
    String url = API_URL + 'SaveVisitorsV1';
    print("SaveVisitor : " + url);
    dio.options.contentType = Headers.formUrlEncodedContentType;
    dio.options.responseType = ResponseType.json;
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);

        print("SaveVisitor Response: " + responseData["ResultData"].toString());

        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess =
            responseData["ResultData"]["IsSuccess"].toString().toLowerCase() ==
                    "true"
                ? true
                : false;

        saveData.Data = responseData["ResultData"]["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> AddVisitorMultiple(body) async {
    print(body.toString());
    String url = API_URL + 'SaveMultipleVisitor';
    print("SaveMultipleVisitor url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0', IsRecord: false);

        print("SaveMultipleVisitor Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error SaveMultipleVisitor");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error SaveMultipleVisitor : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetServices() async {
    String url = API_URL + 'GetService';
    print("GetServices url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("GetServices Response: " + response.data.toString());
        var ServicesData = response.data;
        if (ServicesData["IsSuccess"] == true) {
          print(ServicesData["Data"]);
          list = ServicesData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetServices");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetServices   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  // Get Services List

  static Future<List> GetServicesData(String ServiceId) async {
    String url = API_URL + 'GetServicePackage?serviceId=$ServiceId';
    print("GetServicesData url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("GetServicesData Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetServicesData");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetServicesData   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetVendorData(String ServiceId) async {
    String url = API_URL + 'GetVendor?serviceId=$ServiceId';
    print("GetVendorData url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("GetVendorData Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetVendorData");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetVendorData   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> SaveComplain(body) async {
    print(body.toString());
    String url = API_URL + 'SaveComplain';
    print("SaveComplain Url url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0', IsRecord: false);

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);

        print("SaveVisitor Response: " + responseData["ResultData"].toString());

        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess =
            responseData["ResultData"]["IsSuccess"].toString().toLowerCase() ==
                    "true"
                ? true
                : false;
        saveData.Data = responseData["ResultData"]["Data"].toString();

        return saveData;
      } else {
        print("Error SaveComplain Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error SaveComplain Url : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  // Wing List

  static Future<List> GetWingData(String SocietyId) async {
    String url = API_URL + 'GetMemberCountByWingId?societyId=$SocietyId';
    print("GetWingData url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("GetWingData Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetWingData");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetWingData   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  //GetComplain By Member
  static Future<List> GetComplainByMember(String MemberId) async {
    String url = API_URL + 'GetComplainByMember?memberId=$MemberId';
    print("GetComplain url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("GetComplain Response: " + response.data.toString());
        var VisitorData = response.data;
        if (VisitorData["IsSuccess"] == true) {
          list = VisitorData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetComplain");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetComplain   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  // Gallery Module
  static Future<List> GetEventGallery(String SocietyId) async {
    String url = API_URL + 'GetEvent?societyId=$SocietyId';
    print("Get EventList url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("Get EventList Response: " + response.data.toString());
        var ServicesData = response.data;
        if (ServicesData["IsSuccess"] == true) {
          print(ServicesData["Data"]);
          list = ServicesData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error Get EventList");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Get EventList   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> EventPhotolist(String EventId) async {
    String url = API_URL + 'GetEventGallery?eventId=$EventId';
    print("EventGallery url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("EventGallery Response: " + response.data.toString());
        var ServicesData = response.data;
        if (ServicesData["IsSuccess"] == true) {
          print(ServicesData["Data"]);
          list = ServicesData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error EventGallery");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error EventGallery   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetSocietyRuls(String SocietyId) async {
    String url = API_URL + 'GetSocietyRules?societyId=$SocietyId';
    print("GetSocietyRules url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("GetSocietyRules Response: " + response.data.toString());
        var RulesData = response.data;
        if (RulesData["IsSuccess"] == true) {
          print(RulesData["Data"]);
          list = RulesData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetSocietyRules");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetSocietyRules   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetSocietyDocuments(String SocietyId) async {
    String url = API_URL + 'GetDocument?societyId=$SocietyId';
    print("GetDocument url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("GetDocument Response: " + response.data.toString());
        var RulesData = response.data;
        if (RulesData["IsSuccess"] == true) {
          print(RulesData["Data"]);
          list = RulesData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetDocument");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetDocument   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> UpdateMemberProfile(body) async {
    print(body.toString());
    String url = API_URL + 'UpdateMemberProfile';
    print("UpdateMemberProfile url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0', IsRecord: false);

        print("UpdateMemberProfile Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error UpdateMemberProfile");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error UpdateMemberProfile : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetMemberByWing(String SocietyId, String WingId) async {
    String url =
        API_URL + 'GetMemberByWing?societyId=$SocietyId&wingId=$WingId';
    print("GetMemberByWing url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("GetMemberByWing Response: " + response.data.toString());
        var RulesData = response.data;
        if (RulesData["IsSuccess"] == true) {
          print(RulesData["Data"]);
          list = RulesData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetMemberByWing");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetMemberByWing   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> AddVehicle(body) async {
    print(body.toString());
    String url = API_URL + 'SaveMemberVehicle';
    print("AddVehicle url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0', IsRecord: false);

        print("AddVehicle Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error AddVehicle");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error AddVehicle : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetVehicleData(String MemberId) async {
    String url = API_URL + 'GetMemberVehicleDetail?memberId=$MemberId';
    print("VehicleData url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("VehicleData Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error VehicleData");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error VehicleData   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> DeleteVehicleData(String vehicleId) async {
    String url = API_URL + 'DeleteMemberVehicle?id=$vehicleId';
    print("Delete VehicleData URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: "");
        print("Delete VehicleData Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("Delete VehicleData Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> AddFamilyMember(body) async {
    print(body.toString());
    String url = API_URL + 'SaveFamilyMamber';
    print("AddFamilyMember url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0', IsRecord: false);

        print("AddFamilyMember Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error AddFamilyMember");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error AddFamilyMember : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetFamilyMember(String parentId, String MemberId) async {
    String url =
        API_URL + 'GetFamilyMember?parentId=$parentId&memberId=$MemberId';
    print("FamilyMemberData url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("FamilyMemberData Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error FamilyMemberData");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error FamilyMemberData   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> UpdateFamilyMember(body) async {
    print(body.toString());
    String url = API_URL + 'UpdateFamilyMamber';
    print("UpdateFamilyMember url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0', IsRecord: false);

        print("UpdateFamilyMember Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error UpdateFamilyMember");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error UpdateFamilyMember : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> DeleteFamilyMember(String MemberId) async {
    String url = API_URL + 'DeleteMember?id=$MemberId';
    print("DeleteMember URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: "");
        print("DeleteMember Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("DeleteMember Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List<WingClass>> GetWinglistData(String SocietyId) async {
    String url = API_URL + 'GetWingBySocietyId?societyId=$SocietyId';
    print("getGroupData Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List<WingClass> member = [];
        print("getStudentData Response" + response.data.toString());

        final jsonResponse = response.data;
        WingClassData memberData = new WingClassData.fromJson(jsonResponse);

        member = memberData.Data;

        return member;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check getWinglistData Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> DeleteComplaint(String id) async {
    String url = API_URL + 'DeleteComplain?id=$id';
    print("DeleteComplaint URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: "");
        print("DeleteComplaint Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("DeleteComplaint Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetEmergency() async {
    String url = API_URL + 'GetEmergency';
    print("GetEmergency url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("GetEmergency Response: " + response.data.toString());
        var EmergencyNumber = response.data;
        if (EmergencyNumber["IsSuccess"] == true) {
          print(EmergencyNumber["Data"]);
          list = EmergencyNumber["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetEmergency");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetEmergency   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetPollingData(String SocietyId, String MemberId) async {
    String url =
        API_URL + 'GetPollingList?societyId=$SocietyId&memberId=$MemberId';
    print("GetPollingData url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("GetPollingData Response: " + response.data.toString());
        var GetPollingListData = response.data;
        if (GetPollingListData["IsSuccess"] == true) {
          print(GetPollingListData["Data"]);
          list = GetPollingListData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetPollingData");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetPollingData   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> SavePollingAnswer(body) async {
    print(body.toString());
    String url = API_URL + 'SavePollingAnswer';
    print("PollingAnswer url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0', IsRecord: false);

        print("PollingAnswer Response: " + response.data.toString());
        var memberDataClass = response.data;

        saveData.Message = memberDataClass["Message"];
        saveData.IsSuccess = memberDataClass["IsSuccess"];
        saveData.Data = memberDataClass["Data"].toString();

        return saveData;
      } else {
        print("Error PollingAnswer");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error PollingAnswer : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<String> GetVcardofMember(String MemberId) async {
    String url = API_URL + 'VcfFile?memberId=$MemberId';
    print("Vcard url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        String Vcard = "";
        print("Vcard Response: " + response.data.toString());
        var VisitorData = response.data;
        if (VisitorData["IsSuccess"] == true) {
          Vcard = VisitorData["Data"];
        } else {
          Vcard = "";
        }
        return Vcard;
      } else {
        print("Error Vcard");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error Vcard   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  // Get Paid Member Maintainance

  static Future<List> GetPaidMaintainance(String MemberId) async {
    String url = API_URL + 'GetMemberMaintenancePayment?memberId=$MemberId';
    print("getPaidMaintainanceData url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("getPaidMaintainanceData Response: " + response.data.toString());
        var GetMaintainanceData = response.data;
        if (GetMaintainanceData["IsSuccess"] == true) {
          print(GetMaintainanceData["Data"]);
          list = GetMaintainanceData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error getPaidMaintainanceData");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error getPaidMaintainanceData   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetAdvertiseFor(String type) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String SocietyId = prefs.getString(constant.Session.SocietyId);
    String url = API_URL +
        'GetAdvertisementDropDownDataByType?societyId=$SocietyId&type=$type';
    print("GetAdvertiseFor Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetAdvertiseFor Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check GetAdvertiseFor Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetPackages() async {
    String url = API_URL + 'GetPackage';
    print("GetPackage Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetPackage Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check GetPackage Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetPaymentDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String SocietyId = prefs.getString(constant.Session.SocietyId);
    String url = API_URL + 'GetPaymentDetail?societyId=$SocietyId';
    print("GetPaymentDetails Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetPaymentDetails Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check GetPackage Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> UpdateProfilephoto(body) async {
    print(body.toString());
    String url = API_URL + 'UpdateMemberPhoto';
    print("UpdateProfile Url url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0', IsRecord: false);

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);

        print("UpdateProfilephoto Response: " +
            responseData["ResultData"].toString());

        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess =
            responseData["ResultData"]["IsSuccess"].toString().toLowerCase() ==
                    "true"
                ? true
                : false;
        saveData.Data = responseData["ResultData"]["Data"].toString();

        return saveData;
      } else {
        print("Error UpdateProfile Url");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error UpdateProfile Url : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> SaveAdvertisement(body) async {
    print(body.toString());
    String url = API_URL + 'SaveAdvertisement';
    print("SaveAdvertisement url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0', IsRecord: false);

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);

        print("SaveAdvertisement Response: " +
            responseData["ResultData"].toString());

        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess =
            responseData["ResultData"]["IsSuccess"].toString().toLowerCase() ==
                    "true"
                ? true
                : false;
        saveData.Data = responseData["ResultData"]["Data"].toString();

        return saveData;
      } else {
        print("Error Registration");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error SaveAdvertisement : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> SaveAdvertisementForRenew(body) async {
    print(body.toString());
    String url = API_URL + 'RenewAdvertisement';
    print("RenewAdvertisement url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0', IsRecord: false);

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);

        print("RenewAdvertisement Response: " +
            responseData["ResultData"].toString());

        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess =
            responseData["ResultData"]["IsSuccess"].toString().toLowerCase() ==
                    "true"
                ? true
                : false;
        saveData.Data = responseData["ResultData"]["Data"].toString();

        return saveData;
      } else {
        print("Error Registration");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error RenewAdvertisement : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetMyAdvertisement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberId = prefs.getString(constant.Session.Member_Id);
    String url = API_URL + 'GetMyAdvertisement?memberId=$memberId';
    print("GetMyAdvertisement Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetMyAdvertisement Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check GetMyAdvertisement Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetAllAdvertisement() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String societyId = prefs.getString(constant.Session.SocietyId);
    String url = API_URL + 'GetAdvertisement?societyId=$societyId';
    print("GetAllAdvertisement Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetAllAdvertisement Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check GetAllAdvertisement Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> DeleteAdvertisement(String id) async {
    String url = API_URL + 'DeleteAdvertisement?id=$id';
    print("DeleteAdvertisement URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: "");
        print("DeleteAdvertisement Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("DeleteAdvertisement Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List<staffClass>> GetStaffTypes() async {
    String url = API_URL + 'GetStaffType';
    print("GetStaffType Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List<staffClass> member = [];
        print("GetStaffType Response" + response.data.toString());

        final jsonResponse = response.data;
        staffClassData responseData = new staffClassData.fromJson(jsonResponse);

        member = responseData.Data;

        return member;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check GetStaffType Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> SaveStaff(body) async {
    print(body.toString());
    String url = API_URL + 'SaveStaffDetail';
    print("SaveStaffDetail url : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, Data: '0', IsRecord: false);

        xml2json.parse(response.data.toString());
        var jsonData = xml2json.toParker();
        var responseData = json.decode(jsonData);

        print("SaveStaffDetail Response: " +
            responseData["ResultData"].toString());

        saveData.Message = responseData["ResultData"]["Message"].toString();
        saveData.IsSuccess =
            responseData["ResultData"]["IsSuccess"].toString().toLowerCase() ==
                    "true"
                ? true
                : false;
        saveData.Data = responseData["ResultData"]["Data"].toString();

        return saveData;
      } else {
        print("Error SaveStaffDetail");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error SaveStaffDetail : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> SendTokanToServer(String fcmToken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    String memberId = prefs.getString(Session.Member_Id);
    String mobileno = prefs.getString(Session.session_login);
    String SocietyId = prefs.getString(Session.SocietyId);

    String url =
        API_URL + 'NewUpdateMemberFCMToken?fcmToken=$fcmToken&mobileno=$mobileno&societyId=$SocietyId&memberId=$memberId';
    print("SendTokanToServer: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("Commities List URL: " + response.data.toString());
        var memberDataClass = response.data;
        if (memberDataClass["IsSuccess"] == true &&
            memberDataClass["IsRecord"] == true) {
          print(memberDataClass["Data"]);
          list = memberDataClass["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something went wrong");
      }
    } catch (e) {
      print("SendTokanToServer URL : " + e.toString());
      throw Exception("Something went wrong");
    }
  }

  static Future<List> GetCommittees() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String SocietyId = prefs.getString(constant.Session.SocietyId);
    String url = API_URL + 'GetCommittee?SocietyId=$SocietyId';
    print("GetCommittees url : " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetCommittees Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetCommittees");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetCommittees   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetAmenities() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String SocietyId = prefs.getString(constant.Session.SocietyId);
    String url = API_URL + 'GetAminitiesDetails?SocietyId=$SocietyId';
    print("GetAminitiesDetails url : " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetAminitiesDetails Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetAminitiesDetails");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetAminitiesDetails   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> GetProfilePer() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String memberID = prefs.getString(constant.Session.Member_Id);
    String url = API_URL + 'GetIncompleteProfile?UserId=$memberID';
    print("GetIncompleteProfile URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: "");
        print("GetIncompleteProfile Response: " + response.data.toString());
        var responseData = response.data;
        saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("GetIncompleteProfile Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetSearchData(String searchText) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String SocietyId = prefs.getString(constant.Session.SocietyId);
    String url = API_URL +
        'SocietySearchEngine?SocietyId=$SocietyId&SearchText=$searchText';
    print("GetSearchData url : " + url);
    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        var responseData = response.data;
        print(responseData);
        if (responseData["IsSuccess"] == true) {
          list.add(responseData["Data"]["members"]);
          list.add(responseData["Data"]["service"]);
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetSearchData");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetSearchData   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<List> GetMaidListing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String societyId = prefs.getString(constant.Session.SocietyId);
    String url = API_URL + 'GetMaidData?SocietyId=$societyId';
    print("GetMaidData Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetMaidData Response: " + response.data.toString());
        var responseData = response.data;

        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check GetMaidData Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetOtherListing() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String societyId = prefs.getString(constant.Session.SocietyId);
    String url = API_URL + 'GetStaffData?SocietyId=$societyId';
    print("GetStaffData Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List list = [];
        print("GetStaffData Response: " + response.data.toString());
        var responseData = response.data;

        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check GetStaffData Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List> GetGuestData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String MemberId = prefs.getString(constant.Session.Member_Id);
    String SocietyID = prefs.getString(constant.Session.SocietyId);
    String url =
        API_URL + 'GetGuestsByMemberId?societyId=$SocietyID&memberId=$MemberId';
    print("GetVisitorurl url : " + url);
    try {
      final response = await dio.get(
        url,
      );
      if (response.statusCode == 200) {
        List list = [];
        print("GetVisitorurl Response: " + response.data.toString());
        var VisitorData = response.data;
        if (VisitorData["IsSuccess"] == true) {
          list = VisitorData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        print("Error GetVisitorurl");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("Error GetVisitorurl   : ${e.toString()}");
      throw Exception(e.toString());
    }
  }
}
