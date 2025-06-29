import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'package:image_cropper/image_cropper.dart';
import '../employee/employee_controller.dart';

class EmployeeEditController extends GetxController {
  late Map employee;
  late bool isEditing;

  final nameController = TextEditingController();
  final advanceController = TextEditingController();
  final wageAmountController = TextEditingController();

  RxString wageType = 'daily'.obs;
  RxString category = 'labour'.obs;
  Rx<File?> selectedImage = Rx<File?>(null);
  Rx<Uint8List?> webImageBytes = Rx<Uint8List?>(null);
  RxString imageUrl = ''.obs;
  RxBool isImageLoading = false.obs;

  final supabase = Supabase.instance.client;
  final employeeListController = Get.find<EmployeeController>();
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    final args = Get.arguments as Map<String, dynamic>? ?? {};

    employee = args['employee'] ?? {};
    isEditing = args['isEditing'] ?? true;

    nameController.text = employee['name'] ?? '';
    category.value = employee['category'] ?? 'labour';
    wageType.value = employee['wage_type'] ?? 'daily';
    imageUrl.value = employee['photo_url'] ?? '';

    wageAmountController.text =
        (wageType.value == 'daily'
                ? employee['daily_wage']
                : employee['monthly_wage'])
            ?.toString() ??
        '';

    if (!isEditing) {
      advanceController.text = employee['advance_balance']?.toString() ?? '0';
    }
  }

  String getInitials() {
    final trimmed = nameController.text.trim();
    if (trimmed.isEmpty) return 'NA';

    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.length == 1) {
      return parts[0].substring(0, parts[0].length >= 2 ? 2 : 1).toUpperCase();
    } else {
      final first = parts[0].isNotEmpty ? parts[0][0] : '';
      final second = parts[1].isNotEmpty ? parts[1][0] : '';
      return (first + second).toUpperCase();
    }
  }

  void onWageTypeChanged(String? value) {
    if (value == null) return;

    wageType.value = value;
    final wageAmount =
        value == 'daily' ? employee['daily_wage'] : employee['monthly_wage'];
    wageAmountController.text = wageAmount?.toString() ?? '0';
  }

  Future<bool> requestStoragePermission() async {
    if (kIsWeb) return true;

    if (Platform.isAndroid) {
      if (await Permission.photos.isGranted ||
          await Permission.storage.isGranted) {
        return true;
      }

      final photosStatus = await Permission.photos.request();
      final storageStatus = await Permission.storage.request();

      return photosStatus.isGranted || storageStatus.isGranted;
    } else if (Platform.isIOS) {
      final status = await Permission.photos.request();
      return status.isGranted;
    }
    return false;
  }

  Future<void> pickImage() async {
    try {
      isImageLoading.value = true;

      selectedImage.value?.delete().catchError((_) {});
      selectedImage.value = null;
      webImageBytes.value = null;

      final hasPermission = await requestStoragePermission();
      if (!hasPermission) {
        Get.snackbar(
          'Permission',
          'Storage access is required to select an image',
        );
        return;
      }

      await Future.delayed(const Duration(milliseconds: 200));

      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 60,
        maxWidth: 1000,
        maxHeight: 1000,
      );

      if (picked != null) {
        if (kIsWeb) {
          final bytes = await picked.readAsBytes();
          webImageBytes.value = bytes;
          imageUrl.value = '';
          debugPrint("Web image selected: ${bytes.length} bytes");
        } else {
          final cropped = await ImageCropper().cropImage(
            sourcePath: picked.path,
            compressQuality: 75,
            maxWidth: 800,
            maxHeight: 800,
            aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
            uiSettings: [
              AndroidUiSettings(
                toolbarTitle: '\nCrop Your Image',
                toolbarColor: Colors.black,
                statusBarColor: Colors.black,
                backgroundColor: Colors.black,
                toolbarWidgetColor: Colors.white,
                activeControlsWidgetColor: Colors.white,
                cropFrameColor: Colors.white,
                cropGridColor: Colors.grey,
                dimmedLayerColor: Colors.black54,
                lockAspectRatio: false,
                showCropGrid: true,
                initAspectRatio: CropAspectRatioPreset.square,
                hideBottomControls: false,
              ),
              IOSUiSettings(
                title: 'Crop Your Image',
                aspectRatioLockEnabled: false,
                rotateButtonsHidden: false,
                resetButtonHidden: false,
              ),
            ],
          );

          if (cropped != null && await File(cropped.path).exists()) {
            final tempDir = await getTemporaryDirectory();
            final tempPath =
                '${tempDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';
            final tempFile = await File(cropped.path).copy(tempPath);

            selectedImage.value = tempFile;
            imageUrl.value = '';
            debugPrint("Image cropped and selected: ${tempFile.path}");
          } else {
            Get.snackbar('Cancelled', 'Image cropping cancelled');
          }
        }
      } else {
        Get.snackbar('Error', 'Failed to access selected image');
      }
    } catch (e) {
      debugPrint("Image pick/crop error: $e");
      Get.snackbar('Error', 'Failed to pick or crop image');
    } finally {
      isImageLoading.value = false;
    }
  }

  Future<void> saveEdits() async {
    try {
      String? uploadedImageUrl = imageUrl.value;

      if (selectedImage.value != null || webImageBytes.value != null) {
        final fileName =
            'employee_${DateTime.now().millisecondsSinceEpoch}.jpg';
        final path = fileName;

        try {
          final bytes =
              selectedImage.value != null
                  ? await selectedImage.value!.readAsBytes()
                  : webImageBytes.value!;

          debugPrint("Uploading image: ${bytes.length} bytes");

          await supabase.storage
              .from('employee-photos')
              .uploadBinary(
                path,
                bytes,
                fileOptions: const FileOptions(
                  upsert: true,
                  cacheControl: '3600',
                ),
              );

          uploadedImageUrl = supabase.storage
              .from('employee-photos')
              .getPublicUrl(path);

          debugPrint("Image uploaded: $uploadedImageUrl");
        } catch (uploadError) {
          debugPrint("Upload error: $uploadError");
          Get.snackbar('Upload Error', 'Failed to upload image');
          return;
        }
      }

      final wageAmount = int.tryParse(wageAmountController.text) ?? 0;

      final data = {
        'name': nameController.text.trim(),
        'category': category.value,
        'wage_type': wageType.value,
        'advance_balance': int.tryParse(advanceController.text) ?? 0,
        'daily_wage': wageType.value == 'daily' ? wageAmount : null,
        'monthly_wage': wageType.value == 'monthly' ? wageAmount : null,
        'photo_url': uploadedImageUrl,
      };

      if (isEditing) {
        await supabase.from('employees').update(data).eq('id', employee['id']);
      } else {
        await supabase.from('employees').insert(data);
      }

      employeeListController.fetchEmployees();
      Get.back();
      Get.snackbar(
        'Success',
        isEditing
            ? 'Employee updated successfully'
            : 'Employee added successfully',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      debugPrint("Save error: $e");
      Get.snackbar(
        'Error',
        'Failed to ${isEditing ? 'update' : 'add'} employee',
      );
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    advanceController.dispose();
    wageAmountController.dispose();

    if (!kIsWeb) {
      selectedImage.value?.delete().catchError((_) {});
    }

    super.onClose();
  }
}
