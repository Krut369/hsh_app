import 'package:flutter/material.dart';

class FinalizeGroupScreen extends StatefulWidget {
  const FinalizeGroupScreen({super.key});

  @override
  State<FinalizeGroupScreen> createState() => _FinalizeGroupScreenState();
}

class _FinalizeGroupScreenState extends State<FinalizeGroupScreen> {
  final TextEditingController _nameController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFD6ECF7),
      appBar: AppBar(
        backgroundColor: const Color(0xFF3D5A80),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Finalize New Group', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Group Icon Upload
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.5),
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.white, width: 2), // Mock dashed
                    ),
                    child: Container(
                      margin: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFF90B4B4),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.groups, size: 50, color: Colors.white70),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: Color(0xFF3D5A80),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                  ),
                ],
              ),
            ),
            
            const SizedBox(height: 20),
            const Text(
              'Upload Group Icon',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF3D5A80)),
            ),
            const Text(
              'Admin profile or building photo',
              style: TextStyle(color: Color(0xFF5D90B3)),
            ),
            
            const SizedBox(height: 40),
            
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Group Name',
                  style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D5A80)),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _nameController,
                  decoration: InputDecoration(
                    hintText: 'e.g., Pavitra B-Block',
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFF3D5A80)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: const BorderSide(color: Color(0xFF3D5A80)),
                    ),
                  ),
                ),
              ],
            ),
            
            const SizedBox(height: 40),
            
            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Selected Members (12)',
                style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D5A80)),
              ),
            ),
            const SizedBox(height: 16),
            
            // Mock selected members grid
            GridView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: 8,
              itemBuilder: (context, index) {
                if (index == 7) {
                  return Column(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: Colors.white.withValues(alpha: 0.5),
                        child: const Text('+5', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF3D5A80))),
                      ),
                      const SizedBox(height: 4),
                      const Text('More', style: TextStyle(fontSize: 10)),
                    ],
                  );
                }
                return Column(
                  children: [
                    CircleAvatar(
                      radius: 28,
                      backgroundColor: Colors.grey[200],
                      child: const Icon(Icons.person, color: Colors.grey),
                    ),
                    const SizedBox(height: 4),
                    const Text('Student', style: TextStyle(fontSize: 10)),
                  ],
                );
              },
            ),
            
            const SizedBox(height: 40),
            
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Group created successfully!')),
                  );
                  Navigator.of(context).popUntil((route) => route.isFirst);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF3D5A80),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                ),
                child: const Text('Create Group', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
