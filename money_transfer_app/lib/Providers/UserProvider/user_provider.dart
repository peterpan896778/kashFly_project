import 'dart:io';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:keicy_stripe_payment/keicy_stripe_payment.dart';
import 'package:provider/provider.dart';

import 'package:keicy_firebase_auth_0_18/keicy_firebase_auth_0_18.dart';
import 'package:keicy_fcm_for_mobile_7_0/keicy_fcm_for_mobile_7_0.dart';
import 'package:keicy_storage_for_mobile_4_0/keicy_storage_for_mobile_4_0.dart';
import 'package:keicy_utils/local_storage.dart';

import 'package:money_transfer_framework/money_transfer_framework.dart';

import 'index.dart';

class UserProvider extends ChangeNotifier {
  static UserProvider of(BuildContext context, {bool listen = false}) => Provider.of<UserProvider>(context, listen: listen);

  UserState _userState = UserState.init();
  UserState get userState => _userState;

  void setUserState(UserState userState, {bool isNotifiable = true}) {
    if (_userState != userState) {
      _userState = userState;
      if (isNotifiable) notifyListeners();
    }
  }

  Future<void> saveUserData({
    @required String userID,
    @required Map<String, dynamic> data,
    bool isNotifiable = true,
  }) async {
    try {
      var result = await UserRepository.updateUser(userID, data);

      if (result["success"]) {
        _userState = _userState.update(
          progressState: 2,
          errorString: "",
          userModel: _userState.userModel.update(result["data"]),
        );
      } else {
        _userState = _userState.update(
          progressState: -1,
          errorString: "Save Profile Error",
        );
      }
    } catch (e) {
      _userState = _userState.update(
        progressState: -1,
        errorString: "Save Profile Error",
      );
    }
    notifyListeners();
  }

  Future<void> registerUserData({
    @required UserModel userModel,
    bool isNotifiable = true,
  }) async {
    try {
      var result = await UserRepository.addUser(userModel);

      if (result["success"]) {
        _userState = _userState.update(
          progressState: 2,
          errorString: "",
          userModel: _userState.userModel.update(result["data"][0]),
        );
      } else {
        _userState = _userState.update(
          progressState: -1,
          errorString: "Save Profile Error",
        );
      }
    } catch (e) {
      _userState = _userState.update(
        progressState: -1,
        errorString: "Save Profile Error",
      );
    }
    notifyListeners();
  }

  Future<void> saveDocument({
    @required UserModel userModel,
    @required String documentType,
    @required File imageFile,
    @required File imageFile1,
    @required Map<String, dynamic> documentData,
    bool isSSN = false,
    bool isNotifiable = true,
  }) async {
    try {
      if (isSSN) {
        userModel.documents[documentType] = documentData;
      } else {
        String url = "";
        if (imageFile != null) {
          url = await KeicyStorageForMobile.instance.uploadFileObject(
            path: "/Documents/${userModel.id}/",
            fileName: "$documentType.jpg",
            file: imageFile,
          );
          if (documentData["imagePath"] != "") {
            await KeicyStorageForMobile.instance.deleteFile(path: documentData["imagePath"]);
          }
          documentData["imagePath"] = url;
        }

        if (imageFile1 != null) {
          url = "";

          url = await KeicyStorageForMobile.instance.uploadFileObject(
            path: "/Documents/${userModel.id}/",
            fileName: "${documentType}_1.jpg",
            file: imageFile1,
          );
          if ((imageFile1 != null && documentData["imagePath1"] != "") || documentData["subCategory"] != "driverLicense") {
            await KeicyStorageForMobile.instance.deleteFile(path: documentData["imagePath1"]);
          }

          documentData["imagePath1"] = url;
        } else {
          if ((imageFile1 != null && documentData["imagePath1"] != "") || documentData["subCategory"] != "driverLicense") {
            await KeicyStorageForMobile.instance.deleteFile(path: documentData["imagePath1"]);
          }
          documentData["imagePath1"] = "";
        }

        userModel.documents[documentType] = documentData;
      }

      var result = await UserRepository.updateUser(userModel.id, userModel.toJson());

      if (result["success"]) {
        _userState = _userState.update(
          progressState: 2,
          errorString: "",
          userModel: _userState.userModel.update(result["data"]),
        );
      } else {
        _userState = _userState.update(
          progressState: -1,
          errorString: "Save Profile Error",
        );
      }
    } catch (e) {
      _userState = _userState.update(
        progressState: -1,
        errorString: "Save Profile Error",
      );
    }
    notifyListeners();
  }
}