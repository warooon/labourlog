import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class PasswordUpdateDialog extends StatefulWidget {
  const PasswordUpdateDialog({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PasswordUpdateDialogState createState() => _PasswordUpdateDialogState();
}

class _PasswordUpdateDialogState extends State<PasswordUpdateDialog> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();
  bool _isLoading = false;
  bool _isPasswordHidden = true;

  Future<void> _updatePassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);
    final supabase = Supabase.instance.client;

    try {
      await supabase.auth.updateUser(
        UserAttributes(password: _passwordController.text),
      );

      Get.back();
      Get.snackbar('Success', 'Password updated successfully');
    } catch (e) {
      Get.snackbar('Error', 'Failed to update password');
      debugPrint('Password update error: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return AlertDialog(
      backgroundColor: isDark ? Colors.grey[900] : Colors.white,
      title: Text(
        'Update Password',
        style: TextStyle(color: isDark ? Colors.white : Colors.black),
      ),
      content: Form(
        key: _formKey,
        child: Theme(
          data: Theme.of(context).copyWith(
            textSelectionTheme: TextSelectionThemeData(
              selectionHandleColor: (isDark ? Colors.white : Colors.black),
            ),
          ),
          child: TextFormField(
            controller: _passwordController,
            obscureText: _isPasswordHidden,
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
            cursorColor: (isDark ? Colors.white : Colors.black),
            decoration: InputDecoration(
              labelText: 'New Password',
              labelStyle: TextStyle(
                color: isDark ? Colors.white70 : Colors.grey[700],
              ),
              enabledBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? Colors.white38 : Colors.black45,
                ),
              ),
              focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(
                  color: isDark ? Colors.white : Colors.black,
                ),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordHidden ? Icons.visibility_off : Icons.visibility,
                  color: isDark ? Colors.white : Colors.black,
                ),
                onPressed: () {
                  setState(() {
                    _isPasswordHidden = !_isPasswordHidden;
                  });
                },
              ),
            ),
            validator: (value) {
              if (value == null || value.length < 6) {
                return 'Password must be at least 6 characters';
              }
              return null;
            },
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: Get.back,
          child: Text(
            'Cancel',
            style: TextStyle(color: isDark ? Colors.white : Colors.black),
          ),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: isDark ? Colors.white : Colors.black,
            foregroundColor: isDark ? Colors.black : Colors.white,
          ),
          onPressed: _isLoading ? null : _updatePassword,
          child:
              _isLoading
                  ? SizedBox(
                    height: 16,
                    width: 16,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        isDark ? Colors.black : Colors.white,
                      ),
                    ),
                  )
                  : Text('Update'),
        ),
      ],
    );
  }
}