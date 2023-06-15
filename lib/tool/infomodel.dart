import 'package:package_info_plus/package_info_plus.dart';
import 'package:device_info_plus/device_info_plus.dart';

class PackageInfoModel {
  static late String appName;
  static late String packageName;
  static late String version;
  static late String buildNumber;
  static late String buildSignature;
  static late String installStore;
  static bool isInit = false;

  static init() async {
    if (isInit) {
      return;
    }
    final info = await PackageInfo.fromPlatform();
    appName = info.appName;
    packageName = info.packageName;
    version = info.version;
    buildNumber = info.buildNumber;
    buildSignature = info.buildSignature;
    installStore = info.installerStore ?? 'Unknown';
    isInit = true;
  }
}

class DeviceInfoModel {
  static late String deviceName;
  static late String deviceModel;
  static late String deviceVersion;
  static late String deviceSdk;
  static late String deviceIsPhysicalDevice;
  static late String deviceAndroidId;
  static late String devicecodename;
  static bool isInit = false;

  static init() async {
    if (isInit) {
      return;
    }
    final info = await DeviceInfoPlugin().androidInfo;
    deviceName = info.device;
    deviceModel = info.model;
    deviceVersion = info.version.release;
    deviceSdk = info.version.sdkInt.toString();
    deviceIsPhysicalDevice = info.isPhysicalDevice.toString();
    deviceAndroidId = info.serialNumber;
    devicecodename = info.version.codename;
    isInit = true;
  }
}
