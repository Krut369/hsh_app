import 'package:get/get.dart';
import 'package:hsh_app/models/student_profile_model.dart';

class ProfileController extends GetxController {
  final profile = StudentProfile(
    name: 'Parth Prajapati',
    college: 'V.P. & R.P.T.P. Science College',
    room: '3000',
    id: '367',
    imagePath: 'assets/profile_screen.jpg',
  ).obs;
}
