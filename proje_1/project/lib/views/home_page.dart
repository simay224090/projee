import 'package:flutter/material.dart';
import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:project/controller/bluetoot_controller.dart';
import 'package:get/get.dart';
import 'package:project/views/led.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GetBuilder<BluetootController>(
          init: BluetootController(),
          builder: (controller) {
            return SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    height: 180,
                    color: const Color(0xFF5481D0),
                    width: double.infinity,
                    child: const Center(
                      child: Text(
                        "BLE Scanner",
                        style: TextStyle(
                          fontSize: 30,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: ElevatedButton(
                      onPressed: () {
                        controller.scanDevices();
                        controller.update();
                        try {
                          controller.scanDevices();
                        } catch (e) {
                          print("Error while scanning devices: $e");
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                        minimumSize: const Size(350, 55),
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.all(Radius.circular(5))),
                      ),
                      child: Text(
                        "Scan",
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  StreamBuilder<List<ScanResult>>(
                      stream: controller.scanResults,
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          return ListView.builder(
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemCount: snapshot.data!.length,
                              itemBuilder: (context, index) {
                                final data = snapshot.data![index];
                                return Card(
                                  elevation: 2,
                                  child: ListTile(
                                    title: Text(
                                        data.device.platformName.isNotEmpty
                                            ? data.device.platformName
                                            : 'Unnamed Device'),
                                    subtitle: Text(data.device.obs.toString()),
                                    trailing: ElevatedButton(
                                        child: Text("connect"),
                                        onPressed: () async {
                                          await controller
                                              .connectToDevice(data);
                                          // Cihazla bağlantı kurulduktan sonra LightControlPage'e geç
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      LightControlPage(
                                                          device:
                                                              data.device)));
                                        }),
                                    leading: Icon(Icons.bluetooth_searching),
                                  ),
                                );
                              });
                        } else {
                          return const Center(
                            child: Text("No devices found"),
                          );
                        }
                      })
                ],
              ),
            );
          }),
    );
  }
}
