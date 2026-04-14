import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hsh_app/modules/complain/domain/entities/complaint_model.dart';
import 'package:hsh_app/modules/complain/presentation/controllers/complain_controller.dart';
import 'package:hsh_app/modules/student/features/complaint/complaint_utils.dart';
import 'package:modern_ui_toolkit/uitoolkit.dart';

class AddComplaintScreen extends GetView<ComplainController> {
  const AddComplaintScreen({super.key});

  Future<void> _pickImage(String key, ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);
    if (pickedFile != null) {
      controller.updateIssueImage(key, pickedFile.path);
    }
  }

  void _showImagePickerModal(BuildContext context, String key) {
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
                Get.back();
                _pickImage(key, ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Camera'),
              onTap: () {
                Get.back();
                _pickImage(key, ImageSource.camera);
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return ModernScaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: ModernText(
          "Add Complaint",
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
          fontSize: 18,
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            controller.resetAddDraft();
            Get.back();
          },
        ),
      ),
      body: Obx(() {
        final selectedType = controller.selectedType.value;
        final hasSubComplaints =
            selectedType?.subComplaints.isNotEmpty ?? false;

        return SingleChildScrollView(
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
                  final isSelected = selectedType == itemType;

                  return InkWell(
                    onTap: () => controller.selectType(itemType),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      decoration: BoxDecoration(
                        color: isSelected ? scheme.primary : scheme.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              isSelected ? scheme.primary : Colors.grey[200]!,
                          width: 2,
                        ),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            ComplaintUtils.getComplaintTypeIcon(itemType.name),
                            color: isSelected
                                ? Colors.white
                                : Colors.grey[600]?.withValues(alpha: 0.8),
                            size: 28,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            itemType.name,
                            style: TextStyle(
                              color:
                                  isSelected ? Colors.white : Colors.grey[800],
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
              if (hasSubComplaints && selectedType != null) ...[
                Text('Select Specific Issue',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildSubComplaintSection(selectedType, scheme, context),
              ] else if (selectedType != null) ...[
                Text('Describe Issue',
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 12),
                _buildDirectDescriptionSection(
                    selectedType.name, scheme, context),
              ],
              const SizedBox(height: 32),
            ],
          ),
        );
      }),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Obx(() => ModernButton(
                text: 'Submit Complaint',
                onPressed: _canSubmit() ? () => _submit(context) : null,
                isLoading: controller.isLoading.value,
              )),
        ),
      ),
    );
  }

  Widget _buildSubComplaintSection(
      ComplaintType selectedType, ColorScheme scheme, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ...selectedType.subComplaints.map((subComplaint) {
          final isSelected =
              controller.selectedSubComplaints.contains(subComplaint);
          final issueData = controller.issues[subComplaint.name];

          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            decoration: BoxDecoration(
                color: isSelected ? const Color(0xFFF8F9FE) : Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                    color: isSelected
                        ? scheme.primary.withValues(alpha: 0.5)
                        : Colors.grey[200]!)),
            child: Column(
              children: [
                CheckboxListTile(
                  activeColor: scheme.primary,
                  title: Text(subComplaint.name,
                      style: TextStyle(
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal)),
                  value: isSelected,
                  onChanged: (value) =>
                      controller.toggleSubComplaint(subComplaint),
                ),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextField(
                          maxLines: 2,
                          decoration: InputDecoration(
                              hintText: 'Describe issue...',
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12))),
                          onChanged: (value) => controller
                              .updateIssueDescription(subComplaint.name, value),
                        ),
                        const SizedBox(height: 12),
                        _buildImagePicker(
                            subComplaint.name, issueData?.imagePath, context),
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
      String key, ColorScheme scheme, BuildContext context) {
    return Column(
      children: [
        TextField(
          maxLines: 5,
          decoration: InputDecoration(
              hintText: 'Describe issue...',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(16))),
          onChanged: (value) => controller.updateIssueDescription(key, value),
        ),
        const SizedBox(height: 12),
        _buildImagePicker(key, controller.issues[key]?.imagePath, context),
      ],
    );
  }

  Widget _buildImagePicker(
      String key, String? imagePath, BuildContext context) {
    if (imagePath == null) {
      return InkWell(
        onTap: () => _showImagePickerModal(context, key),
        child: Container(
          height: 100,
          width: double.infinity,
          decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey[300]!)),
          child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [Icon(Icons.add_a_photo), Text('Add Photo')]),
        ),
      );
    } else {
      return Stack(
        alignment: Alignment.topRight,
        children: [
          Image.file(File(imagePath),
              height: 150, width: double.infinity, fit: BoxFit.cover),
          IconButton(
              icon: const Icon(Icons.close, color: Colors.white),
              onPressed: () => controller.updateIssueImage(key, null)),
        ],
      );
    }
  }

  bool _canSubmit() {
    final selectedType = controller.selectedType.value;
    if (selectedType == null) return false;

    if (selectedType.subComplaints.isNotEmpty) {
      if (controller.selectedSubComplaints.isEmpty) return false;
      return controller.selectedSubComplaints.every((sub) {
        final desc = controller.issues[sub.name]?.description ?? '';
        return desc.trim().length >= 10;
      });
    } else {
      final desc = controller.issues[selectedType.name]?.description ?? '';
      return desc.trim().length >= 10;
    }
  }

  void _submit(BuildContext context) {
    controller.submitComplaint(context);
  }
}
