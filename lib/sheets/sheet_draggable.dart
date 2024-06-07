import 'package:flutter/material.dart';
// import 'package:flutter_application_1/main.dart';
import 'package:flutter_application_1/models/service_model.dart';
import 'package:flutter_application_1/widgets/service.dart';

final services = [
  ServiceModel(
      image: "assets/cars/Simple.png",
      title: "Simple",
      description: "Илүү хүртээмжтэй",
      price: 1500),
  ServiceModel(
      image: "assets/cars/Standart.png",
      title: "Standart",
      description: "1-р эгнээгээр зорчдог",
      price: 1500),
  ServiceModel(
      image: "assets/cars/Black.png",
      title: "Black",
      description: "Ая тухтай",
      price: 1500),
  ServiceModel(
      image: "assets/cars/Simple.png",
      title: "Minivan",
      description: "Илүү хүртээмжтэй",
      price: 1500),
];

class SheetDraggable extends StatelessWidget {
  const SheetDraggable({super.key});

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.2,
      minChildSize: 0.2,
      maxChildSize: 0.7,
      builder: (context, controller) => Container(
        // padding: EdgeInsets.symmetric(horizontal: 16),
        decoration: const BoxDecoration(
            color: Colors.green,
            borderRadius: BorderRadiusDirectional.only(
                topStart: Radius.circular(16), topEnd: Radius.circular(16))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: ListView.builder(
            itemCount: services.length,
            controller: controller,
            itemBuilder: (context, index) {
              return ServiceWidget(service: services[index]);
            },
          ),
        ),
      ),
    );
  }
}
