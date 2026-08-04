import 'package:flutter/material.dart';
import '../models/models.dart';
import '../theme/app_theme.dart';

class RoomPricesScreen extends StatelessWidget {
  const RoomPricesScreen({super.key, required this.hotel});
  final Hotel hotel;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Цены на номера')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text(hotel.name, style: const TextStyle(fontSize: 26, fontWeight: FontWeight.w900)),
          const Text('Актуальные цены Ugur', style: TextStyle(color: AppColors.muted)),
          const SizedBox(height: 18),
          ...hotel.rooms.map((room) => Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Card(
              child: ListTile(
                contentPadding: const EdgeInsets.all(14),
                leading: const CircleAvatar(child: Icon(Icons.bed_rounded)),
                title: Text(room.name, style: const TextStyle(fontWeight: FontWeight.w900)),
                subtitle: Text(room.tag == null ? room.capacity : '${room.capacity}\n${room.tag}'),
                trailing: Text('${room.price} TMT', style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
              ),
            ),
          )),
          const Card(child: Padding(padding: EdgeInsets.all(16), child: Text('Цены зафиксированы командой Ugur. Актуальное наличие уточняется отдельно.'))),
        ],
      ),
    );
  }
}
