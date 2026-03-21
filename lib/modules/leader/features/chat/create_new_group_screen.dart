import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'widgets/student_selection_card.dart';

class CreateNewGroupScreen extends StatefulWidget {
  const CreateNewGroupScreen({super.key});

  @override
  State<CreateNewGroupScreen> createState() => _CreateNewGroupScreenState();
}

class _CreateNewGroupScreenState extends State<CreateNewGroupScreen> {
  final List<Map<String, String>> _students = [
    {'name': 'Amit Patel', 'room': '102'},
    {'name': 'Sarah Jenkins', 'room': '205'},
    {'name': 'David Kumar', 'room': '108'},
    {'name': 'Maria Lopez', 'room': '312'},
    {'name': 'James Wong', 'room': '101'},
    {'name': 'Priya Chauhan', 'room': '202'},
  ];
  
  final Set<int> _selectedIndices = {};

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
        title: const Text('New Group', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
        actions: [
          TextButton(
            onPressed: _selectedIndices.isEmpty ? null : () => context.push('/leader/chat/finalize'),
            child: const Text('Next', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Selected members horizontal list
          if (_selectedIndices.isNotEmpty)
            Container(
              height: 100,
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: _selectedIndices.length + 1,
                itemBuilder: (context, index) {
                  if (index == _selectedIndices.length) {
                    return _buildAddButton();
                  }
                  int studentIdx = _selectedIndices.toList()[index];
                  return _buildSelectedMemberCircle(studentIdx);
                },
              ),
            ),
            
          // Search box
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search students...',
                prefixIcon: const Icon(Icons.search),
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Text(
              'ALL STUDENTS',
              style: TextStyle(color: Color(0xFF3D5A80), fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
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
          ),
        ],
      ),
      floatingActionButton: _selectedIndices.isNotEmpty
        ? FloatingActionButton(
            onPressed: () => context.push('/leader/chat/finalize'),
            backgroundColor: const Color(0xFF3D5A80),
            child: Stack(
              alignment: Alignment.center,
              children: [
                const Icon(Icons.check, color: Colors.white),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(color: Colors.red, shape: BoxShape.circle),
                    child: Text('${_selectedIndices.length}', style: const TextStyle(fontSize: 10, color: Colors.white)),
                  ),
                ),
              ],
            ),
          )
        : null,
    );
  }

  Widget _buildSelectedMemberCircle(int idx) {
    return Padding(
      padding: const EdgeInsets.only(right: 12),
      child: Stack(
        children: [
          Column(
            children: [
              CircleAvatar(
                radius: 28,
                backgroundColor: Colors.grey[200],
                child: const Icon(Icons.person, color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(_students[idx]['name']!.split(' ')[0], style: const TextStyle(fontSize: 10)),
            ],
          ),
          Positioned(
            right: 0,
            top: 0,
            child: GestureDetector(
              onTap: () => setState(() => _selectedIndices.remove(idx)),
              child: Container(
                padding: const EdgeInsets.all(2),
                decoration: const BoxDecoration(color: Color(0xFF3D5A80), shape: BoxShape.circle),
                child: const Icon(Icons.close, size: 12, color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAddButton() {
    return Column(
      children: [
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color: Colors.grey, style: BorderStyle.none), // Dashed in real app
            color: Colors.white.withOpacity(0.3),
          ),
          child: const Icon(Icons.person_add_alt_1, color: Colors.grey),
        ),
        const SizedBox(height: 4),
        const Text('Add', style: TextStyle(fontSize: 10)),
      ],
    );
  }
}
