import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'employee_edit_controller.dart';
import 'package:flutter/foundation.dart';

class EditEmployeeView extends GetView<EmployeeEditController> {
  final Map employee;
  final bool isEditing;

  const EditEmployeeView({
    super.key,
    required this.employee,
    this.isEditing = true,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        title: Text(
          isEditing ? 'EDIT EMPLOYEE' : 'ADD EMPLOYEE',
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Get.back(),
        ),
      ),
      body: SafeArea(
        child: Obx(
          () => SingleChildScrollView(
            padding: const EdgeInsets.all(16).copyWith(bottom: 100),
            child: Column(
              children: [
                // Image Preview
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(24),
                      child: SizedBox(
                        height: 120,
                        width: 120,
                        child: _buildImageDisplay(isDark),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.camera_alt, color: Colors.red),
                      onPressed:
                          () => _showImagePickerOptions(context, controller),
                    ),
                  ],
                ),
                const SizedBox(height: 30),

                // Form Fields
                _buildTextField(
                  context,
                  'Name',
                  controller.nameController,
                  isDark,
                ),
                _buildDropdown(
                  label: 'Category',
                  value: controller.category.value,
                  items: ['mistri', 'munshi', 'labour'],
                  onChanged: (val) => controller.category.value = val!,
                  isDark: isDark,
                ),
                _buildDropdown(
                  label: 'Wage Type',
                  value: controller.wageType.value,
                  items: ['daily', 'monthly'],
                  onChanged: controller.onWageTypeChanged,
                  isDark: isDark,
                ),
                _buildTextField(
                  context,
                  'Wage Amount',
                  controller.wageAmountController,
                  isDark,
                  inputType: TextInputType.number,
                ),
                if (!isEditing)
                  _buildTextField(
                    context,
                    'Advance Balance',
                    controller.advanceController,
                    isDark,
                    inputType: TextInputType.number,
                  ),
              ],
            ),
          ),
        ),
      ),

      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 12),
        child: ElevatedButton(
          onPressed: controller.saveEdits,
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Colors.white : Colors.black,
            foregroundColor: isDark ? Colors.black : Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text('Save Changes'),
        ),
      ),
    );
  }

  Widget _buildImageDisplay(bool isDark) {
    final selectedImage = controller.selectedImage.value;
    final webImageBytes = controller.webImageBytes.value;
    final imageUrl = controller.imageUrl.value;

    if (selectedImage != null) {
      return Image.file(selectedImage, fit: BoxFit.cover);
    } else if (webImageBytes != null) {
      return Image.memory(webImageBytes, fit: BoxFit.cover);
    } else if (imageUrl.isNotEmpty) {
      return Image.network(imageUrl, fit: BoxFit.cover);
    } else {
      return CircleAvatar(
        radius: 60,
        backgroundColor: isDark ? Colors.white : Colors.black,
        child: Text(
          controller.getInitials(),
          style: TextStyle(
            fontSize: 40,
            fontWeight: FontWeight.bold,
            color: isDark ? Colors.black : Colors.white,
          ),
        ),
      );
    }
  }

  Widget _buildTextField(
    BuildContext context,
    String label,
    TextEditingController controller,
    bool isDark, {
    TextInputType inputType = TextInputType.text,
  }) {
    final borderColor = isDark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Theme(
        data: Theme.of(context).copyWith(
          textSelectionTheme: TextSelectionThemeData(
            selectionHandleColor: (isDark ? Colors.white : Colors.black),
          ),
        ),
        child: TextField(
          controller: controller,
          keyboardType: inputType,
          cursorColor: borderColor,
          style: TextStyle(color: isDark ? Colors.white : Colors.black),
          decoration: InputDecoration(
            labelText: label,
            labelStyle: TextStyle(
              color: isDark ? Colors.white70 : Colors.black87,
            ),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: borderColor, width: 2.0),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
    required bool isDark,
  }) {
    final borderColor = isDark ? Colors.white : Colors.black;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: DropdownButtonFormField<String>(
        value: value,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: isDark ? Colors.white70 : Colors.black87,
          ),
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: borderColor, width: 2.0),
          ),
        ),
        dropdownColor: isDark ? Colors.grey[900] : Colors.white,
        items:
            items
                .map(
                  (item) => DropdownMenuItem(
                    value: item,
                    child: Text(item.capitalizeFirst!),
                  ),
                )
                .toList(),
        onChanged: onChanged,
      ),
    );
  }

  void _showImagePickerOptions(
    BuildContext context,
    EmployeeEditController controller,
  ) async {
    if (kIsWeb) {
      // Directly pick image on web
      await controller.pickImage();
      return;
    }

    // Show bottom sheet only on mobile
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder:
          (_) => SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Pick from Gallery'),
                  onTap: () async {
                    Get.back();
                    await controller.pickImage();
                  },
                ),
              ],
            ),
          ),
    );
  }
}
