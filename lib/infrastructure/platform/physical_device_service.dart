import 'dart:io';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:logging/logging.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../../domain/device.dart';
import '../../service/device_service.dart';

/// Used to determine physical device details
class PhysicalDeviceService implements DeviceService {
  static final Logger _log = Logger((PhysicalDeviceService).toString());
  final PackageInfo _packageInfo;
  final BaseDeviceInfo _deviceInfo;

  static Future<PhysicalDeviceService> create() async {
    var packageInfo = await PackageInfo.fromPlatform();
    var deviceInfo = await DeviceInfoPlugin().deviceInfo;
    return PhysicalDeviceService._internal(packageInfo, deviceInfo);
  }

  PhysicalDeviceService._internal(this._packageInfo, this._deviceInfo);

  @override
  Device get device {
    String screenSize = _buildScreenSize();
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return _buildDeviceInfoForAndroid(screenSize);
      case TargetPlatform.iOS:
        return _buildDeviceInfoForIos(screenSize);
      case TargetPlatform.macOS:
        return _buildDeviceInfoForMac(screenSize);
      case TargetPlatform.windows:
        return _buildDeviceInfoForWindows(screenSize);
      default:
        return _buildDeviceInfoDefault(screenSize);
    }
  }

  String _buildScreenSize() {
    try {
      var physicalSize =
          WidgetsBinding.instance.platformDispatcher.views.first.physicalSize;
      var width = physicalSize.width.toStringAsFixed(0);
      var height = physicalSize.height.toStringAsFixed(0);
      return "${width}x$height";
    } catch (e, s) {
      _log.warning("Cannot get screen size", e, s);
      return "unknown";
    }
  }

  Device _buildDeviceInfoDefault(String screenSize) {
    return Device(
      model: "unknown",
      oemName: "unknown",
      osName: Platform.operatingSystem,
      osVersion: Platform.operatingSystemVersion,
      locale: Platform.localeName,
      screenSize: screenSize,
      appVersion: _packageInfo.version,
      appBuild: _packageInfo.buildNumber,
      appNamespace: _packageInfo.packageName,
    );
  }

  Device _buildDeviceInfoForWindows(String screenSize) {
    var winDeviceInfo = _deviceInfo as WindowsDeviceInfo;
    return Device(
      model: winDeviceInfo.productName,
      oemName: winDeviceInfo.registeredOwner,
      osName: Platform.operatingSystem,
      osVersion: Platform.operatingSystemVersion,
      locale: Platform.localeName,
      screenSize: screenSize,
      appVersion: _packageInfo.version,
      appBuild: _packageInfo.buildNumber,
      appNamespace: _packageInfo.packageName,
    );
  }

  Device _buildDeviceInfoForMac(String screenSize) {
    var macDeviceInfo = _deviceInfo as MacOsDeviceInfo;
    return Device(
      model: macDeviceInfo.model,
      oemName: "Apple",
      osName: Platform.operatingSystem,
      osVersion: Platform.operatingSystemVersion,
      locale: Platform.localeName,
      screenSize: screenSize,
      appVersion: _packageInfo.version,
      appBuild: _packageInfo.buildNumber,
      appNamespace: _packageInfo.packageName,
    );
  }

  Device _buildDeviceInfoForIos(String screenSize) {
    var iosDeviceInfo = _deviceInfo as IosDeviceInfo;
    return Device(
      model: iosDeviceInfo.model,
      oemName: "Apple",
      osName: Platform.operatingSystem,
      osVersion: Platform.operatingSystemVersion,
      locale: Platform.localeName,
      screenSize: screenSize,
      appVersion: _packageInfo.version,
      appBuild: _packageInfo.buildNumber,
      appNamespace: _packageInfo.packageName,
    );
  }

  Device _buildDeviceInfoForAndroid(String screenSize) {
    var androidDeviceInfo = _deviceInfo as AndroidDeviceInfo;
    return Device(
      model: androidDeviceInfo.model,
      oemName: androidDeviceInfo.manufacturer,
      osName: Platform.operatingSystem,
      osVersion: Platform.operatingSystemVersion,
      locale: Platform.localeName,
      screenSize: screenSize,
      appVersion: _packageInfo.version,
      appBuild: _packageInfo.buildNumber,
      appNamespace: _packageInfo.packageName,
    );
  }
}
