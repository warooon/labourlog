import 'package:get/get.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ProfileController extends GetxController {
  final supabase = Supabase.instance.client;
  final name = ''.obs;
  final photoUrl = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAdminData();
  }

  void fetchAdminData() async {
    final user = supabase.auth.currentUser;
    if (user == null) return;

    final data =
        await supabase
            .from('admins')
            .select('name, photo_url')
            .eq('id', user.id)
            .maybeSingle();

    if (data != null) {
      name.value = data['name'] ?? '';
      photoUrl.value = data['photo_url'] ?? '';
    }
  }
}
