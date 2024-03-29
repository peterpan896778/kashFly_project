import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:date_time_format/date_time_format.dart';
import 'package:money_transfer_framework/money_transfer_framework.dart';

import 'apis.dart';

class JubaTransactionDataProvider {
  static Future<Map<String, dynamic>> sendTransaction({@required JubaTransactionModel jubaTransactionModel}) async {
    print(JubaConfig.baseUrl + JubaApis.sendTransaction);

    print(jubaTransactionModel.toJson());

    try {
      var response = await http.post(
        JubaConfig.baseUrl + JubaApis.sendTransaction,
        headers: {
          'Authorization': "Basic ${base64Encode((JubaConfig.userName + ":" + JubaConfig.password).toString().codeUnits)}",
          'X-Version': JubaConfig.xVersion,
          'Content-Type': 'application/json',
        },
        body: json.encode(jubaTransactionModel.toJson()),
      );

      return json.decode(response.body);
    } on PlatformException catch (e) {
      return {
        "Response": {"Code": "404", "Message": e.message},
      };
    } catch (e) {
      print(e);
      return {
        "Response": {"Code": "404", "Message": "${JubaApis.sendTransaction} api error"},
      };
    }
  }

  static Future<Map<String, dynamic>> cancelTransaction({
    @required String referenceNum,
    @required String remarks,
  }) async {
    try {
      var response = await http.post(
        JubaConfig.baseUrl + JubaApis.cancelRemittance,
        headers: {
          'Authorization': "Basic ${base64Encode((JubaConfig.userName + ":" + JubaConfig.password).toString().codeUnits)}",
          'X-Version': JubaConfig.xVersion,
          'Content-Type': 'application/json',
        },
        body: json.encode({
          "ReferenceNum": referenceNum,
          "Remarks": remarks,
        }),
      );

      return json.decode(response.body);
    } on PlatformException catch (e) {
      return {
        "Response": {"Code": "404", "Message": e.message},
      };
    } catch (e) {
      print(e);
      return {
        "Response": {"Code": "404", "Message": "${JubaApis.sendTransaction} api error"},
      };
    }
  }
}
