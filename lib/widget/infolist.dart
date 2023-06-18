import 'package:flutter/material.dart';
import '../tool/infomodel.dart';

class InfoList extends StatefulWidget {
  const InfoList({super.key});

  @override
  State<InfoList> createState() => _InfoListState();
}

class _InfoListState extends State<InfoList> {
  @override
  void initState() {
    _init();
    super.initState();
  }

  void _init() async {
    await PackageInfoModel.init();
    // await DeviceInfoModel.init();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      // ListTile(
      //   title: const Text('App Name'),
      //   subtitle: Text(PackageInfoModel.appName),
      // ),
      // ListTile(
      //   title: const Text('Package Name'),
      //   subtitle: Text(PackageInfoModel.packageName),
      // ),
      ListTile(
        title: const Text('Version'),
        subtitle: Text(PackageInfoModel.version),
      ),
      // ListTile(
      //   title: const Text('Build Number'),
      //   subtitle: Text(PackageInfoModel.buildNumber),
      // ),
      ListTile(
        title: const Text('Build Signature'),
        subtitle: Text(PackageInfoModel.buildSignature),
      ),
      // ListTile(
      //   title: const Text('Install Store'),
      //   subtitle: Text(PackageInfoModel.installStore),
      // ),
      // ListTile(
      //   title: const Text('Device Name'),
      //   subtitle: Text(DeviceInfoModel.deviceName),
      // ),
      // ListTile(
      //   title: const Text('Device Model'),
      //   subtitle: Text(DeviceInfoModel.deviceModel),
      // ),
      // ListTile(
      //   title: const Text('Device Version'),
      //   subtitle: Text(DeviceInfoModel.deviceVersion),
      // ),
      // ListTile(
      //   title: const Text('Device SDK'),
      //   subtitle: Text(DeviceInfoModel.deviceSdk),
      // ),
      // ListTile(
      //   title: const Text('Device Is Physical Device'),
      //   subtitle: Text(DeviceInfoModel.deviceIsPhysicalDevice),
      // ),
      // ListTile(
      //   title: const Text('Device Android ID'),
      //   subtitle: Text(DeviceInfoModel.deviceAndroidId),
      // ),
      // ListTile(
      //   title: const Text('Device Codename'),
      //   subtitle: Text(DeviceInfoModel.devicecodename),
      // ),
    ]);
  }
}
