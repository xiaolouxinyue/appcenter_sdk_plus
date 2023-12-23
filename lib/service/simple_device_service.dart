import '../domain/device.dart';
import 'device_service.dart';

class SimpleDeviceService implements DeviceService {
  @override
  final Device device;

  SimpleDeviceService(this.device);
}
