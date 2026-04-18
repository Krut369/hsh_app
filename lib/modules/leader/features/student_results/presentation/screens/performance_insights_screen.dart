import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:auto_route/auto_route.dart';
import '../../../../../../models/student_result_model.dart';

@RoutePage()
class PerformanceInsightsScreen extends StatelessWidget {
  final StudentResult result;

  const PerformanceInsightsScreen({super.key, required this.result});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text('Performance Insights',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18, color: Colors.white)),
        backgroundColor: const Color(0xFF1D3557),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Student Header Summary
             Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 8)),
                ],
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    radius: 35,
                    backgroundColor: Color(0xFFF1F5F9),
                    child: Icon(Icons.person, size: 35, color: Color(0xFF1D3557)),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(result.studentName, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
                        Text('ID: ${result.id}', style: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8))),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text('${result.cgpa}', style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
                      const Text('CGPA', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF94A3B8))),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Academic Progress Graph Section
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
                boxShadow: [
                  BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 15, offset: const Offset(0, 8)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                   Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('Academic Progress', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
                      Row(
                        children: [
                          const Icon(Icons.show_chart, color: Color(0xFF10B981), size: 16),
                          const SizedBox(width: 4),
                          Text('+0.4 vs Last Year', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: const Color(0xFF10B981))),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                  SizedBox(
                    height: 200,
                    child: LineChart(
                      LineChartData(
                        gridData: const FlGridData(show: false),
                        titlesData: FlTitlesData(
                          bottomTitles: AxisTitles(
                            sideTitles: SideTitles(
                              showTitles: true,
                              getTitlesWidget: (value, meta) {
                                switch (value.toInt()) {
                                  case 0: return const Text('SEM 1', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold));
                                  case 1: return const Text('SEM 2', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold));
                                  case 2: return const Text('SEM 3', style: TextStyle(fontSize: 10, color: Color(0xFF94A3B8), fontWeight: FontWeight.bold));
                                  case 3: return const Text('SEM 4', style: TextStyle(fontSize: 10, color: Color(0xFF1D3557), fontWeight: FontWeight.bold));
                                }
                                return const Text('');
                              },
                              reservedSize: 22,
                            ),
                          ),
                          leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
                        ),
                        borderData: FlBorderData(show: false),
                        lineBarsData: [
                          LineChartBarData(
                            spots: result.semesterGpas.asMap().entries.map((e) => FlSpot(e.key.toDouble(), e.value)).toList(),
                            isCurved: true,
                            color: const Color(0xFF1D3557),
                            barWidth: 3,
                            dotData: const FlDotData(show: true),
                            belowBarData: BarAreaData(
                              show: true,
                              color: const Color(0xFF1D3557).withValues(alpha: 0.1),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Subject Breakdown Grid
            const Text('Subject Breakdown', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
            const SizedBox(height: 16),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              mainAxisSpacing: 16,
              crossAxisSpacing: 16,
              childAspectRatio: 1.4,
              children: result.subjects.values.map((s) => _buildSubjectBreakdownCard(s)).toList(),
            ),

            const SizedBox(height: 32),

            // Key Strengths
            const Text('Key Strengths', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
            const SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: result.strengths.map((s) => _buildInsightTag(s, isStrength: true)).toList(),
            ),

            const SizedBox(height: 32),

            // Areas for Improvement
            const Text('Areas for Improvement', style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
            const SizedBox(height: 12),
            ...result.improvements.map((imp) => Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFF1F5F9),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(color: const Color(0xFFFEE2E2), borderRadius: BorderRadius.circular(12)),
                    child: const Icon(Icons.flash_on, color: Color(0xFFEF4444), size: 20),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(imp, style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF1D3557))),
                        const Text('Focus on formatting and technical diagrams', style: TextStyle(fontSize: 12, color: Color(0xFF64748B))),
                      ],
                    ),
                  ),
                ],
              ),
            )),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSubjectBreakdownCard(SubjectResult s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.03), blurRadius: 10, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Icon(s.icon, color: const Color(0xFF64748B), size: 20),
              Text('${s.marks.toInt()}%', style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16, color: Color(0xFF1D3557))),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(s.subjectName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1D3557))),
              Text(s.subTitle, style: const TextStyle(fontSize: 11, color: Color(0xFF94A3B8))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInsightTag(String text, {bool isStrength = true}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: isStrength ? const Color(0xFFF0FDFA) : const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(color: isStrength ? const Color(0xFFCCFBF1) : const Color(0xFFE2E8F0)),
      ),
      child: Text(text, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF1D3557))),
    );
  }
}
