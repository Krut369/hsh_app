import 'package:flutter/material.dart';
import 'package:hsh_app/modules/leader/presentation/leader_auto_router.dart';
import 'package:auto_route/auto_route.dart';
import 'widgets/student_selection_card.dart';

@RoutePage()
class CreateNewGroupScreen extends StatefulWidget {
  const CreateNewGroupScreen({super.key});

  @override
  State<CreateNewGroupScreen> createState() => _CreateNewGroupScreenState();
}

class _CreateNewGroupScreenState extends State<CreateNewGroupScreen> {
  final List<Map<String, String>> _students = [
    {'name': 'Arjun Sharma', 'room': 'B-204'},
    {'name': 'Priya Verma', 'room': 'A-112'},
    {'name': 'Rohan Das', 'room': 'C-305'},
    {'name': 'Kavya Singh', 'room': 'B-108'},
    {'name': 'Aditya Patel', 'room': 'C-101'},
    {'name': 'Meera Reddy', 'room': 'A-202'},
  ];
  
  final Set<int> _selectedIndices = {};
  String _selectedCategory = 'General';
  final List<String> _categories = ['General', 'Study', 'Sports', 'Mess'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA), // Very light grey
      body: Column(
        children: [
          // Custom App Bar
          Container(
            padding: EdgeInsets.only(
              top: MediaQuery.of(context).padding.top + 16, 
              left: 16, 
              right: 24, 
              bottom: 24
            ),
            decoration: const BoxDecoration(
              color: Color(0xFF1D3557), // Deep Navy
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(30),
                bottomRight: Radius.circular(30),
              ),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => context.router.back(),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'Create New Group',
                    style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ),
                const Text(
                  'HostelHub',
                  style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Set Group Icon configuration
                  Center(
                    child: Column(
                      children: [
                        Stack(
                          children: [
                            Container(
                              width: 100,
                              height: 100,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: const Color(0xFFE8ECEF),
                                border: Border.all(color: Colors.white, width: 4),
                              ),
                              child: const Icon(Icons.groups, size: 40, color: Color(0xFF1D3557)),
                            ),
                            Positioned(
                              bottom: 0,
                              right: 0,
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0D253F),
                                  shape: BoxShape.circle,
                                  border: Border.all(color: Colors.white, width: 2),
                                ),
                                child: const Icon(Icons.camera_alt, color: Colors.white, size: 14),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        const Text('Set Group Icon', style: TextStyle(color: Color(0xFF6B7A8A), fontSize: 14)),
                      ],
                    ),
                  ),
                  
                  const SizedBox(height: 24),

                  // Group Name Base
                  const Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 8),
                    child: Text('Group Name', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF4A5568))),
                  ),
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Enter a descriptive name',
                      hintStyle: const TextStyle(color: Color(0xFFA0AEC0)),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Choose Category
                  const Padding(
                    padding: EdgeInsets.only(left: 8, bottom: 12),
                    child: Text('Choose Category', style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF4A5568))),
                  ),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: _categories.map((category) {
                      bool isSelected = _selectedCategory == category;
                      return GestureDetector(
                        onTap: () => setState(() => _selectedCategory = category),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected ? const Color(0xFF0D253F) : const Color(0xFFDCE6F1),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            category,
                            style: TextStyle(
                              color: isSelected ? Colors.white : const Color(0xFF4A5568),
                              fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 32),

                  // Add Members Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Add Members', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
                      Text('${_selectedIndices.length} Selected', style: const TextStyle(fontSize: 12, color: Color(0xFF6B7A8A))),
                    ],
                  ),
                  const SizedBox(height: 16),
                  
                  // Integrated Search Bar
                  TextField(
                    decoration: InputDecoration(
                      hintText: 'Search students by name or room...',
                      hintStyle: const TextStyle(color: Color(0xFFA0AEC0), fontSize: 14),
                      prefixIcon: const Icon(Icons.search, color: Color(0xFFA0AEC0)),
                      filled: true,
                      fillColor: const Color(0xFFF1F4F8), // Slightly darker grey to contrast base scaffold
                      contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Unified list representation wrapping student cards dynamically
                  ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: _students.length,
                    itemBuilder: (context, index) {
                      final student = _students[index];
                      bool isSelected = _selectedIndices.contains(index);
                      
                      return StudentSelectionCard(
                        name: student['name']!,
                        room: student['room']!,
                        isSelected: isSelected,
                        onTap: () {
                          setState(() {
                            if (isSelected) {
                              _selectedIndices.remove(index);
                            } else {
                              _selectedIndices.add(index);
                            }
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),

          // Primary create button strictly anchored gracefully at bottom
          Container(
            padding: EdgeInsets.fromLTRB(24, 16, 24, MediaQuery.of(context).padding.bottom + 24),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              boxShadow: [
                 BoxShadow(color: Colors.white.withValues(alpha: 0.8), blurRadius: 20, spreadRadius: 10, offset: const Offset(0, -10))
              ],
            ),
            child: SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _selectedIndices.isEmpty || _selectedCategory.isEmpty 
                  ? null 
                  : () {
                      // Functional finish block mapping directly back since FinalizeGroup was merged
                      context.router.back();
                    },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D253F),
                  disabledBackgroundColor: const Color(0xFF9BABBB),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: const Text('Create Group', style: TextStyle(color: Colors.white, fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
