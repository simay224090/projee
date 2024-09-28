import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';

class BluetootController extends GetxController {
  // Bluetooth instance
  FlutterBluePlus flutterBlue = new FlutterBluePlus();

  List<BluetoothService>? services;
  // Bluetooth cihazlarını tarar
  Future scanDevices() async {
    // Cihazları taramaya başla, 4 saniye süreyle
    await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));
    // Tarama tamamlandıktan sonra otomatik olarak duracak
  }

  // Mevcut tarama sonuçlarını almak için stream
  Stream<List<ScanResult>> get scanResults => FlutterBluePlus.scanResults;

  Future<void> connectToDevice(ScanResult scanResult) async {
    try {
      // Bağlanmak istediğiniz cihaz
      BluetoothDevice device = scanResult.device;

      // Cihaza bağlanma
      await device.connect();
      print("Connected to ${device.platformName}");

      services = await device.discoverServices();
      for (var service in services!) {
        print("Service UUID: ${service.uuid}");
        for (var characteristic in service.characteristics) {
          print("Characteristic UUID: ${characteristic.uuid}");
        }
      }
    } catch (e) {
      print("Error connecting to device: $e");
    }
  }

  Future<List<BluetoothService>> getDeviceServices(
      BluetoothDevice device) async {
    return await device.discoverServices();
  }

  void toggleLight(bool turnOn, List<BluetoothService> services) async {
    for (BluetoothService service in services) {
      for (BluetoothCharacteristic characteristic in service.characteristics) {
        if (characteristic.properties.write) {
          List<int> command = turnOn
              ? [0x01]
              : [0x00]; // Işık açmak için 0x01, kapatmak için 0x00
          await characteristic.write(command);
        }
      }
    }
  }
}
