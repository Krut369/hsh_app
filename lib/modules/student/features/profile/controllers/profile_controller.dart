import 'package:get/get.dart';
import 'package:hsh_app/models/student_profile_model.dart';

class ProfileController extends GetxController {
  final profile = StudentProfile(
    name: 'Krutarth Solanki',
    college: 'DAIICT',
    room: '304',
    id: '202350010',
    group: 'Pavitra',
    imagePath: 'assets/profile_screen.jpg',
  ).obs;
}
