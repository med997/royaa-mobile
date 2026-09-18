import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../app/theme.dart';

class MeasurementsScreen extends StatefulWidget {
  const MeasurementsScreen({super.key});

  @override
  State<MeasurementsScreen> createState() => _MeasurementsScreenState();
}

class _MeasurementsScreenState extends State<MeasurementsScreen> with SingleTickerProviderStateMixin {
  late final _tabs = TabController(length: 2, vsync: this);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('my_prescriptions'.tr()),
        bottom: TabBar(
          controller: _tabs,
          tabs: [Tab(text: 'face_measurement'.tr()), Tab(text: 'prescription'.tr())],
        ),
      ),
      body: TabBarView(controller: _tabs, children: const [_FaceMeasurementTab(), _PrescriptionTab()]),
    );
  }
}

class _FaceMeasurementTab extends StatelessWidget {
  const _FaceMeasurementTab();

  Future<void> _start(BuildContext context) async {
    final status = await Permission.camera.request();
    if (!status.isGranted) {
      if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('camera_permission_denied'.tr())));
      return;
    }
    if (context.mounted) ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('coming_soon'.tr())));
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            height: 260,
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [Color(0xFFE3E6E2), Color(0xFFC7CFC9)], begin: Alignment.topLeft, end: Alignment.bottomRight),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Container(
                width: 150,
                height: 200,
                decoration: BoxDecoration(border: Border.all(color: Colors.white, width: 3, style: BorderStyle.solid), shape: BoxShape.rectangle, borderRadius: BorderRadius.circular(100)),
              ),
            ),
          ),
          const SizedBox(height: 20),
          Text('face_measurement_title'.tr(), style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          const SizedBox(height: 8),
          Text('face_measurement_hint'.tr(), textAlign: TextAlign.center, style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          const SizedBox(height: 20),
          FilledButton(onPressed: () => _start(context), child: Text('start_measurement'.tr())),
        ],
      ),
    );
  }
}

class _PrescriptionTab extends StatefulWidget {
  const _PrescriptionTab();

  @override
  State<_PrescriptionTab> createState() => _PrescriptionTabState();
}

class _PrescriptionTabState extends State<_PrescriptionTab> {
  final _fields = List.generate(4, (_) => TextEditingController());
  final _pd = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text('prescription_hint'.tr(), style: const TextStyle(color: AppColors.muted, fontSize: 12)),
          const SizedBox(height: 16),
          InkWell(
            onTap: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('coming_soon'.tr()))),
            child: Container(
              height: 130,
              decoration: BoxDecoration(border: Border.all(color: AppColors.line, width: 1.5), borderRadius: BorderRadius.circular(16)),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.upload_file_outlined, color: AppColors.muted),
                  const SizedBox(height: 6),
                  Text('upload_prescription'.tr(), style: const TextStyle(fontWeight: FontWeight.w600)),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.6,
            children: [
              TextField(controller: _fields[0], decoration: InputDecoration(labelText: 'sph_right'.tr(), isDense: true)),
              TextField(controller: _fields[1], decoration: InputDecoration(labelText: 'cyl_right'.tr(), isDense: true)),
              TextField(controller: _fields[2], decoration: InputDecoration(labelText: 'sph_left'.tr(), isDense: true)),
              TextField(controller: _fields[3], decoration: InputDecoration(labelText: 'cyl_left'.tr(), isDense: true)),
            ],
          ),
          const SizedBox(height: 10),
          TextField(controller: _pd, decoration: InputDecoration(labelText: 'pd_distance'.tr())),
          const SizedBox(height: 20),
          FilledButton(
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('save'.tr()))),
            child: Text('save'.tr()),
          ),
        ],
      ),
    );
  }
}
