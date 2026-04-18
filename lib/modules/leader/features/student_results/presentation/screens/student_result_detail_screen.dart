import 'package:flutter/material.dart';
import '../../../../../../models/student_result_model.dart';
import 'performance_insights_screen.dart';
import 'package:get/get.dart';

class StudentResultDetailScreen extends StatefulWidget {
  final StudentResult result;

  const StudentResultDetailScreen({super.key, required this.result});

  @override
  State<StudentResultDetailScreen> createState() => _StudentResultDetailScreenState();
}

class _StudentResultDetailScreenState extends State<StudentResultDetailScreen> {
  late String _selectedSemester;
  final List<String> _semesters = [
    'Semester 1',
    'Semester 2',
    'Semester 3',
    'Semester 4',
    'Semester 5',
    'Semester 6'
  ];

  @override
  void initState() {
    super.initState();
    _selectedSemester = widget.result.semester;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Student Records',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: const Color(0xFF1D3557),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Profile Section
            Container(
              padding: const EdgeInsets.only(bottom: 32),
              decoration: const BoxDecoration(
                color: Color(0xFF1D3557),
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  bottomRight: Radius.circular(40),
                ),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8),
                  Stack(
                    alignment: Alignment.bottomRight,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Colors.white, shape: BoxShape.circle),
                        child: const CircleAvatar(
                          radius: 50,
                          backgroundColor: Color(0xFFF1F5F9),
                          child: Icon(Icons.person, size: 50, color: Color(0xFF1D3557)),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(color: Color(0xFF1D3557), shape: BoxShape.circle),
                        child: const Icon(Icons.verified, color: Color(0xFF38BDF8), size: 24),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    widget.result.studentName,
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      _buildInfoTag('ID: ${widget.result.id}', Colors.white.withValues(alpha: 0.1)),
                      const SizedBox(width: 12),
                      _buildSemesterDropdown(),
                    ],
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                children: [
                  // Summary Stats
                  Row(
                    children: [
                      Expanded(
                        child: _buildSummaryCard(
                          label: 'CGPA',
                          value: '${widget.result.cgpa}',
                          subValue: '/10',
                          icon: Icons.auto_graph,
                          color: const Color(0xFFF8FAFC),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildSummaryCard(
                          label: 'GRADE',
                          value: widget.result.grade,
                          subValue: 'Exemplary',
                          icon: Icons.star_border_rounded,
                          color: const Color(0xFF1D3557),
                          isDark: true,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 32),

                  // Subject Performance Section
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Subject Performance',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D3557)),
                      ),
                      TextButton(
                        onPressed: () => Get.to(() => PerformanceInsightsScreen(result: widget.result)),
                        child: const Row(
                          children: [
                            Text('View Insights', style: TextStyle(color: Color(0xFF1D3557), fontWeight: FontWeight.w600)),
                            Icon(Icons.chevron_right, size: 18, color: Color(0xFF1D3557)),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  ...widget.result.subjects.values.map((s) => _buildSubjectPerformanceCard(s)),

                  const SizedBox(height: 32),

                  // Advisor's Remarks
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.info_outline, color: Color(0xFF64748B), size: 20),
                            SizedBox(width: 8),
                            Text('Advisor\'s Remarks', style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
                          ],
                        ),
                        const SizedBox(height: 12),
                        Text(
                          widget.result.advisorRemarks,
                          style: const TextStyle(color: Color(0xFF64748B), height: 1.5, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSemesterDropdown() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 36,
      decoration: BoxDecoration(
        color: const Color(0xFFFEF3C7),
        borderRadius: BorderRadius.circular(20),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: _selectedSemester,
          dropdownColor: const Color(0xFFFEF3C7),
          icon: const Icon(Icons.arrow_drop_down, color: Color(0xFFD97706), size: 20),
          style: const TextStyle(color: Color(0xFFD97706), fontWeight: FontWeight.bold, fontSize: 13, fontFamily: 'Inter'),
          onChanged: (String? newValue) {
            if (newValue != null) {
              setState(() {
                _selectedSemester = newValue;
              });
            }
          },
          items: _semesters.map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildInfoTag(String text, Color bgColor, {Color textColor = Colors.white}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      decoration: BoxDecoration(color: bgColor, borderRadius: BorderRadius.circular(20)),
      child: Text(text, style: TextStyle(color: textColor, fontWeight: FontWeight.bold, fontSize: 13)),
    );
  }

  Widget _buildSummaryCard({required String label, required String value, required String subValue, required IconData icon, required Color color, bool isDark = false}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(color: isDark ? Colors.white70 : const Color(0xFF94A3B8), fontWeight: FontWeight.bold, fontSize: 11, letterSpacing: 1)),
              Icon(icon, color: isDark ? Colors.white70 : const Color(0xFF1D3557), size: 18),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(value, style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold, color: isDark ? Colors.white : const Color(0xFF1D3557))),
              Text(subValue, style: TextStyle(fontSize: 14, color: isDark ? Colors.white70 : const Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSubjectPerformanceCard(SubjectResult s) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.02), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(color: const Color(0xFFF1F5F9), borderRadius: BorderRadius.circular(12)),
            child: Icon(s.icon, color: const Color(0xFF1D3557), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(s.subjectName, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
                Text(s.subTitle, style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text('${s.marks.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1D3557))),
                  const Text('/100', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8))),
                ],
              ),
              const SizedBox(height: 8),
              SizedBox(
                width: 60,
                height: 4,
                child: LinearProgressIndicator(
                  value: s.marks / 100,
                  backgroundColor: const Color(0xFFF1F5F9),
                  color: const Color(0xFF1D3557),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
