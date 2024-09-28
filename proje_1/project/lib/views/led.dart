import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:get/get.dart';
import 'package:project/controller/bluetoot_controller.dart';

class LightControlPage extends StatelessWidget {
  final BluetoothDevice device;

  LightControlPage({required this.device});

  final BluetootController bluetoothController = Get.find();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(184, 145, 219, 1.0),
        title: Text("Light Control"),
      ),
      body: FutureBuilder<List<BluetoothService>>(
        future: bluetoothController.getDeviceServices(device),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Servisleri keşfederken hata oluştu"));
          } else {
            final services = snapshot.data;
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/blue.jpg',
                    width: 50,
                  ),
                  ElevatedButton(
                    onPressed: () {
                      bluetoothController.toggleLight(true, services!);
                    },
                    child: Text("Open the Led"),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      bluetoothController.toggleLight(false, services!);
                    },
                    child: Text("Close the Led"),
                  ),
                ],
              ),
            );
          }
        },
      ),
    );
  }
}
