import 'package:flutter/material.dart';
import 'package:hsh_app/core/constants/app_text.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/models/student_profile_model.dart';
import 'package:uitoolkit/uitoolkit.dart' hide AppColors;

class ProfileCard extends StatelessWidget {
  final StudentProfile profile;

  // Unused params kept for backward compatibility if needed, or remove them.
  // The caller (ProfileScreen) might still be passing them, so we can make them optional or ignore them.
  // Ideally, we should update the caller to stop passing animations.
  // For now, I'll update the constructor to accept them as optional/ignored to avoid breaking the build immediately,
  // but I plan to clean up ProfileScreen too.

  const ProfileCard({
    required this.profile,
    // Animations are no longer needed
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    print(profile.imagePath);
   return ModernCard(
     color: Colors.white,
     padding: EdgeInsetsGeometry.all(16),
     child: Row(
       children: [
          ModernAvatar(
            backgroundColor: Colors.white,
            imageUrl: profile.imagePath.contains("http") ? profile.imagePath : "https://i.pravatar.cc/40",
            size: 65,
          ),
         const SizedBox(width: 16),
         Expanded(
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               ModernText(
                 '${AppText.goodMorning}, ${profile.name.split(' ').first}',
                 color: Colors.black87,
                 fontWeight: FontWeight.w600,
                 fontSize: 18,
               ),
               const SizedBox(height: 8),
               Row(
                 children: [
                   Container(
                     padding: const EdgeInsets.symmetric(
                       horizontal: 12,
                       vertical: 6,
                     ),
                     decoration: BoxDecoration(
                       color: AppColors.primary.withOpacity(0.1),
                       borderRadius: BorderRadius.circular(20),
                     ),
                     child: Row(
                       mainAxisSize: MainAxisSize.min,
                       children: [
                         Icon(Icons.meeting_room_outlined,
                             size: 14, color: AppColors.primary),
                         const SizedBox(width: 4),
                         ModernText(
                             'Room ${profile.room}',
                           color: AppColors.primary,
                           fontSize: 12,
                           fontWeight: FontWeight.bold,
                         ),
                       ],
                     ),
                   ),
                   const SizedBox(width: 12),
                   const Flexible(
                     child: ModernText(
                       AppText.premiumResident,
                       overflow: TextOverflow.ellipsis,
                       maxLines: 1,
                       color: Colors.grey,
                       fontSize: 13,
                       fontWeight: FontWeight.w500,
                     ),
                   )
                 ],
               ),
             ],
           ),
         ),
       ],
     ),
   );
    // return Container(
    //   width: double.infinity,
    //   padding: const EdgeInsets.all(20),
    //   decoration: BoxDecoration(
    //     color: Colors.white,
    //     borderRadius: BorderRadius.circular(24),
    //     boxShadow: [
    //       BoxShadow(
    //         color: Colors.black.withOpacity(0.05),
    //         blurRadius: 10,
    //         offset: const Offset(0, 4),
    //       ),
    //     ],
    //   ),
    //   child: Row(
    //     children: [
    //       Container(
    //         decoration: BoxDecoration(
    //           shape: BoxShape.circle,
    //           border: Border.all(
    //               color: AppColors.primary.withOpacity(0.2), width: 2),
    //         ),
    //         padding: const EdgeInsets.all(2),
    //         child: CircleAvatar(
    //           radius: 35,
    //           backgroundColor: const Color(0xFFFFF3E0),
    //           backgroundImage: AssetImage(profile.imagePath),
    //           onBackgroundImageError: (_, __) => const Icon(Icons.person),
    //         ),
    //       ),
    //       const SizedBox(width: 16),
    //       Expanded(
    //         child: Column(
    //           crossAxisAlignment: CrossAxisAlignment.start,
    //           children: [
    //             Text(
    //               '${AppText.goodMorning}, ${profile.name.split(' ').first}',
    //               style: Theme.of(context).textTheme.titleLarge?.copyWith(
    //                     fontWeight: FontWeight.bold,
    //                     color: Colors.black87,
    //                   ),
    //             ),
    //             const SizedBox(height: 8),
    //             Row(
    //               children: [
    //                 Container(
    //                   padding: const EdgeInsets.symmetric(
    //                     horizontal: 12,
    //                     vertical: 6,
    //                   ),
    //                   decoration: BoxDecoration(
    //                     color: AppColors.primary.withOpacity(0.1),
    //                     borderRadius: BorderRadius.circular(20),
    //                   ),
    //                   child: Row(
    //                     mainAxisSize: MainAxisSize.min,
    //                     children: [
    //                       const Icon(Icons.meeting_room_outlined,
    //                           size: 14, color: AppColors.primary),
    //                       const SizedBox(width: 4),
    //                       Text(
    //                         'Room ${profile.room}',
    //                         style: const TextStyle(
    //                           color: AppColors.primary,
    //                           fontWeight: FontWeight.bold,
    //                           fontSize: 12,
    //                         ),
    //                       ),
    //                     ],
    //                   ),
    //                 ),
    //                 const SizedBox(width: 12),
    //                 const Flexible(
    //                   child: Text(
    //                     AppText.premiumResident,
    //                     overflow: TextOverflow.ellipsis,
    //                     maxLines: 1,
    //                     style: TextStyle(
    //                       color: Colors.grey,
    //                       fontSize: 13,
    //                       fontWeight: FontWeight.w500,
    //                     ),
    //                   ),
    //                 )
    //               ],
    //             ),
    //           ],
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}
