import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hsh_app/models/complaint_model.dart';
import 'package:hsh_app/modules/complain/providers/complaint_provider.dart';
import 'package:hsh_app/services/service_provider.dart'; // For creating complaint directly or via provider
import 'package:hsh_app/modules/student/features/complaint/complaint_utils.dart';

import 'package:hsh_app/widgets/custom_button.dart';

class AddComplaintScreen extends ConsumerWidget {
  const AddComplaintScreen({super.key});

  Future<void> _pickImage(WidgetRef ref, String key, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      ref
          .read(addComplaintProvider.notifier)
          .updateIssueImage(key, pickedFile.path);
    }
  }

  void _showImagePickerModal(BuildContext context, WidgetRef ref, String key) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ref, key, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ref, key, ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addComplaintProvider);
    final notifier = ref.read(addComplaintProvider.notifier);

    final type = state.selectedType;
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final hasSubComplaints = type?.subComplaints.isNotEmpty ?? false;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Add Complaint',
            style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            notifier.reset();
            context.pop();
          },
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              'Select Complaint Type',
              style: theme.textTheme.titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            // Updated Grid Selector
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.0,
              ),
              itemCount: complaintTypes.length,
              itemBuilder: (context, index) {
                final itemType = complaintTypes[index];
                final isSelected = type == itemType;

                return InkWell(
                  onTap: () => notifier.selectType(itemType),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSelected ? scheme.primary : scheme.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected ? scheme.primary : Colors.grey[200]!,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                  color: scheme.primary.withOpacity(0.3),
                                  blurRadius: 8,
                                  offset: const Offset(0, 4))
                            ]
                          : [],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          ComplaintUtils.getComplaintTypeIcon(itemType.name),
                          color: isSelected ? Colors.white : Colors.grey[600],
                          size: 28,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          itemType.name,
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.grey[800],
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),

            const SizedBox(height: 24),

            // Sub-Complaint Selector (if applicable)
            if (hasSubComplaints && type != null) ...[
              Text(
                'Select Specific Issue',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              _buildSubComplaintSection(
                  ref, type, state.selectedSubComplaints, state.issues, scheme),
            ] else if (type != null) ...[
              Text(
                'Describe Issue',
                style: theme.textTheme.titleMedium
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 12),
              // Use type name as key for direct complaints
              _buildDirectDescriptionSection(
                  ref, type.name, state.issues[type.name], scheme),
            ],

            const SizedBox(height: 32),
          ],
        ),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: SizedBox(
            height: 56,
            child: CustomButton(
              text: 'Submit Complaint',
              onPressed: _canSubmit(state)
                  ? () => _submitComplaint(context, ref, state)
                  : null,
              borderRadius: 16,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSubComplaintSection(
    WidgetRef ref,
    ComplaintType selectedType,
    List<SubComplaint> selectedSubComplaints,
    Map<String, ComplaintIssueData> issues,
    ColorScheme scheme,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...selectedType.subComplaints.map((subComplaint) {
          final isSelected = selectedSubComplaints.contains(subComplaint);
          final issueData = issues[subComplaint.name];

          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF8F9FE) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isSelected
                        ? scheme.primary.withOpacity(0.5)
                        : Colors.grey[200]!)),
            child: Column(
              children: [
                CheckboxListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
                  activeColor: scheme.primary,
                  title: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? scheme.primary.withOpacity(0.1)
                              : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          ComplaintUtils.getSubComplaintIcon(
                              selectedType.name, subComplaint.name),
                          color: isSelected ? scheme.primary : Colors.grey[600],
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        subComplaint.name,
                        style: TextStyle(
                            fontWeight: isSelected
                                ? FontWeight.bold
                                : FontWeight.normal,
                            color: Colors.black87),
                      ),
                    ],
                  ),
                  value: isSelected,
                  onChanged: (value) {
                    ref
                        .read(addComplaintProvider.notifier)
                        .toggleSubComplaint(subComplaint);
                  },
                ),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          maxLines: 2,
                          controller: TextEditingController.fromValue(
                              TextEditingValue(
                                  text: issueData?.description ?? '',
                                  selection: TextSelection.collapsed(
                                      offset: (issueData?.description ?? '')
                                          .length))), // Simple way to keep cursor at end for now
                          decoration: InputDecoration(
                            hintText:
                                'Describe issue with ${subComplaint.name}...',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: Colors.grey[300]!),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide(color: scheme.primary),
                            ),
                            contentPadding: const EdgeInsets.all(12),
                          ),
                          style: const TextStyle(fontSize: 14),
                          onChanged: (value) {
                            ref
                                .read(addComplaintProvider.notifier)
                                .updateIssueDescription(
                                    subComplaint.name, value);
                          },
                        ),
                        const SizedBox(height: 12),
                        // Image for this sub-complaint
                        _buildImagePicker(
                            ref, subComplaint.name, issueData?.imagePath),
                      ],
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
    String key,
    ComplaintIssueData? issueData,
    ColorScheme scheme,
  ) {
    return Column(
      children: [
        TextField(
          maxLines: 5,
          controller: TextEditingController.fromValue(TextEditingValue(
              text: issueData?.description ?? '',
              selection: TextSelection.collapsed(
                  offset: (issueData?.description ?? '').length))),
          decoration: InputDecoration(
            hintText: 'Describe your complaint in detail...',
            filled: true,
            fillColor: Colors.grey[50],
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: Colors.grey[300]!),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(color: scheme.primary),
            ),
            contentPadding: const EdgeInsets.all(16),
          ),
          onChanged: (value) {
            ref
                .read(addComplaintProvider.notifier)
                .updateIssueDescription(key, value);
          },
        ),
        const SizedBox(height: 12),
        _buildImagePicker(ref, key, issueData?.imagePath),
      ],
    );
  }

  Widget _buildImagePicker(WidgetRef ref, String key, String? imagePath) {
    if (imagePath == null) {
      return InkWell(
        onTap: () => _showImagePickerModal(ref.context, ref, key),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(12),
            border:
                Border.all(color: Colors.grey[300]!), // Fixed dashPattern error
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add_a_photo, size: 24, color: Colors.grey[400]),
              const SizedBox(height: 4),
              Text(
                'Add Photo',
                style: TextStyle(color: Colors.grey[600], fontSize: 12),
              ),
            ],
          ),
        ),
      );
    } else {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.file(
              File(imagePath),
              height: 150,
              width: double.infinity,
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CircleAvatar(
              backgroundColor: Colors.black.withOpacity(0.5),
              radius: 14,
              child: IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
                icon: const Icon(Icons.close, size: 16, color: Colors.white),
                onPressed: () {
                  ref
                      .read(addComplaintProvider.notifier)
                      .updateIssueImage(key, null);
                },
              ),
            ),
          ),
        ],
      );
    }
  }

  bool _canSubmit(AddComplaintState state) {
    if (state.selectedType == null) return false;
    final hasSub = state.selectedType!.subComplaints.isNotEmpty;

    if (hasSub) {
      // Must select at least one sub-complaint
      if (state.selectedSubComplaints.isEmpty) return false;
      
      // Check if all selected sub-complaints have valid descriptions
      for (var sub in state.selectedSubComplaints) {
        final desc = state.issues[sub.name]?.description ?? '';
        if (desc.trim().length < 10) return false;
      }
      return true;
    } else {
      // For direct complaints
      final key = state.selectedType!.name;
      final desc = state.issues[key]?.description ?? '';
      return desc.trim().length >= 10;
    }
  }

  Future<void> _submitComplaint(
    BuildContext context,
    WidgetRef ref,
    AddComplaintState state,
  ) async {
    final notifier = ref.read(addComplaintProvider.notifier);
    
    // Show loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final List<Map<String, dynamic>> issuesList = [];
      
      // Collect issues
      if (state.selectedType!.subComplaints.isNotEmpty) {
        for (var sub in state.selectedSubComplaints) {
          final issueData = state.issues[sub.name];
          if (issueData != null && issueData.description.isNotEmpty) {
            issuesList.add({
              'sub_category': sub.name,
              'description': issueData.description,
              'imagePath': issueData.imagePath, // Service will handle upload
            });
          }
        }
      } else {
        // Direct complaint (no sub-category)
        final key = state.selectedType!.name;
        final issueData = state.issues[key];
        if (issueData != null && issueData.description.isNotEmpty) {
           issuesList.add({
            'description': issueData.description,
             'imagePath': issueData.imagePath,
          });
        }
      }

      if (issuesList.isEmpty) {
        Navigator.pop(context); // Close loading
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please add at least one issue description')),
        );
        return;
      }

      print('🚀 Submitting Complaint...');
      print('📦 Payload: Type=${state.selectedType!.name}, Issues=$issuesList');

      final response = await serviceProvider.complaint.createComplaint(
        complaintType: state.selectedType!.name, 
        issues: issuesList,
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📡 Response Message: ${response.message}');
      print('📡 Response Data: ${response.data}');

      Navigator.pop(context); // Close loading

      if (response.success) {
        // Refresh complaints list and stats
        ref.refresh(complaintsListProvider); 
        ref.refresh(complaintStatsProvider);
        
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
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            margin: const EdgeInsets.all(16),
          ),
        );

        notifier.reset();
        context.pop();
      } else {
        print('❌ Submission Failed: ${response.message}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to submit: ${response.message ?? "Unknown error"} \nData: ${response.data}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 5),
          ),
        );
      }
    } catch (e) {
      Navigator.pop(context); // Close loading
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}
