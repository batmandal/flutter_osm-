import 'package:flutter/material.dart';
import 'package:flutter_application_1/models/service_model.dart';

class ServiceWidget extends StatelessWidget {
  final ServiceModel service;
  const ServiceWidget({super.key, required this.service});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              color: Color.fromARGB(247, 247, 247, 1)),
          child: ListTile(
            leading: Image.asset(service.image),
            title: Text(service.title),
            subtitle: Text(service.description),
            trailing: Text("${service.price}"),
          ),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }
}
