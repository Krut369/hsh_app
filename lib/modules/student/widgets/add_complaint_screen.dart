import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hsh_app/models/complaint_model.dart';
import '../../../providers/complaint_provider.dart';

class AddComplaintScreen extends ConsumerWidget {
  const AddComplaintScreen({super.key});

  IconData _getComplaintTypeIcon(String typeName) {
    switch (typeName) {
      case 'Carpentry':
        return Icons.handyman;
      case 'Electrical':
        return Icons.electrical_services;
      case 'Plumbing':
        return Icons.water_damage;
      case 'Housekeeping':
        return Icons.cleaning_services;
      case 'Internet':
        return Icons.wifi;
      case 'Others':
        return Icons.miscellaneous_services;
      default:
        return Icons.build;
    }
  }

  IconData _getSubComplaintIcon(String typeName, String subName) {
    if (typeName == 'Electrical') {
      switch (subName) {
        case 'Fan':
          return Icons.wind_power;
        case 'Light':
          return Icons.lightbulb;
        case 'Geyser':
          return Icons.hot_tub;
        case 'Switch Board':
          return Icons.power;
        default:
          return Icons.electrical_services;
      }
    } else if (typeName == 'Plumbing') {
      switch (subName) {
        case 'Tap':
          return Icons.water_drop;
        case 'Flush':
          return Icons.water;
        case 'Jet Spray':
          return Icons.shower;
        default:
          return Icons.plumbing;
      }
    } else if (typeName == 'Carpentry') {
      switch (subName) {
        case 'Bed':
          return Icons.bed;
        case 'Door':
          return Icons.door_back_door_outlined;
        case 'Cupboard':
          return Icons.door_sliding;
        default:
          return Icons.carpenter;
      }
    }
    return Icons.build;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedComplaintTypeProvider);
    final hasSubComplaints = ref.watch(hasSubComplaintsProvider);
    final subComplaints = ref.watch(subComplaintsForTypeProvider);
    final selectedSubComplaints = ref.watch(selectedSubComplaintsProvider);
    final descriptions = ref.watch(complaintDescriptionsProvider);
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Complaint'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Type Selector
            _buildComplaintTypeSelector(context, ref, selectedType, scheme),

            // Sub-Complaint Selector (if applicable)
            if (hasSubComplaints)
              _buildSubComplaintSection(ref, selectedType!, subComplaints, selectedSubComplaints, descriptions, scheme),

            // Direct Description (if no sub-complaints)
            if (selectedType != null && !hasSubComplaints)
              _buildDirectDescriptionSection(ref, selectedType, descriptions, scheme),

            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.send),
              label: const Text('Submit Complaint'),
              onPressed: _canSubmit(selectedType, hasSubComplaints, selectedSubComplaints, descriptions)
                  ? () => _submitComplaint(context, ref, selectedType!, descriptions, scheme)
                  : null,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintTypeSelector(BuildContext context, WidgetRef ref, ComplaintType? selectedType, ColorScheme scheme) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Select Complaint Type',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: scheme.primary,
                  fontWeight: FontWeight.bold,
                )),
            const SizedBox(height: 12),
            DropdownButtonHideUnderline(
              child: DropdownButton<ComplaintType>(
                isExpanded: true,
                value: selectedType,
                hint: const Text('Select type'),
                items: complaintTypes.map((type) {
                  return DropdownMenuItem(
                    value: type,
                    child: Row(
                      children: [
                        Icon(_getComplaintTypeIcon(type.name), color: scheme.primary),
                        const SizedBox(width: 12),
                        Text(type.name),
                      ],
                    ),
                  );
                }).toList(),
                onChanged: (value) {
                  ref.read(selectedComplaintTypeProvider.notifier).state = value as ComplaintType?;
                  ref.read(selectedSubComplaintsProvider.notifier).state = [];
                  ref.read(complaintDescriptionsProvider.notifier).state = {};
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSubComplaintSection(
      WidgetRef ref,
      ComplaintType selectedType,
      List<SubComplaint> subComplaints,
      List<SubComplaint> selectedSubComplaints,
      Map<String, String> descriptions,
      ColorScheme scheme,
      ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: 16),
        ...subComplaints.map((subComplaint) {
          final isSelected = selectedSubComplaints.contains(subComplaint);
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
              side: BorderSide(color: isSelected ? scheme.primary : scheme.outline.withOpacity(0.2)),
            ),
            child: Column(
              children: [
                CheckboxListTile(
                  title: Row(
                    children: [
                      Icon(_getSubComplaintIcon(selectedType.name, subComplaint.name), color: scheme.primary),
                      const SizedBox(width: 12),
                      Text(subComplaint.name),
                    ],
                  ),
                  value: isSelected,
                  onChanged: (value) {
                    final updated = List<SubComplaint>.from(selectedSubComplaints);
                    if (value == true) {
                      updated.add(subComplaint);
                    } else {
                      updated.remove(subComplaint);
                      final updatedDesc = Map<String, String>.from(descriptions)..remove(subComplaint.name);
                      ref.read(complaintDescriptionsProvider.notifier).state = updatedDesc;
                    }
                    ref.read(selectedSubComplaintsProvider.notifier).state = updated;
                  },
                ),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: TextField(
                      maxLines: 3,
                      decoration: InputDecoration(
                        hintText: 'Describe issue with ${subComplaint.name}...',
                      ),
                      onChanged: (value) {
                        final updated = Map<String, String>.from(descriptions)
                          ..[subComplaint.name] = value;
                        ref.read(complaintDescriptionsProvider.notifier).state = updated;
                      },
                    ),
                  ),
              ],
            ),
          );
        }),
      ],
    );
  }

  Widget _buildDirectDescriptionSection(
      WidgetRef ref,
      ComplaintType selectedType,
      Map<String, String> descriptions,
      ColorScheme scheme,
      ) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: scheme.outline.withOpacity(0.2)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: 'Describe your ${selectedType.name.toLowerCase()} complaint in detail...',
          ),
          onChanged: (value) {
            final updated = Map<String, String>.from(descriptions)
              ..[selectedType.name] = value;
            ref.read(complaintDescriptionsProvider.notifier).state = updated;
          },
        ),
      ),
    );
  }

  bool _canSubmit(
      ComplaintType? type,
      bool hasSubComplaints,
      List<SubComplaint> selected,
      Map<String, String> descriptions,
      ) {
    if (type == null) return false;
    if (hasSubComplaints) {
      return selected.isNotEmpty && selected.every((sc) => descriptions[sc.name]?.isNotEmpty == true);
    } else {
      return descriptions[type.name]?.isNotEmpty == true;
    }
  }

  void _submitComplaint(
      BuildContext context,
      WidgetRef ref,
      ComplaintType type,
      Map<String, String> descriptions,
      ColorScheme scheme,
      ) {
    final complaints = ref.read(complaintsProvider);
    final newComplaint = Complaint(
      id: (complaints.length + 1).toString(),
      dateTime: DateTime.now(),
      complaintType: type.name,
      descriptions: descriptions,
    );
    ref.read(complaintsProvider.notifier).state = [newComplaint, ...complaints];

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle, color: Colors.white),
            SizedBox(width: 12),
            Text('Complaint submitted successfully!'),
          ],
        ),
        backgroundColor: Colors.green,
      ),
    );

    ref.read(selectedComplaintTypeProvider.notifier).state = null;
    ref.read(selectedSubComplaintsProvider.notifier).state = [];
    ref.read(complaintDescriptionsProvider.notifier).state = {};

    Navigator.pop(context);
  }
}
