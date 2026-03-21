import 'package:flutter/material.dart';
import 'package:hsh_app/core/theme/app_colors.dart';
import 'package:hsh_app/modules/laundry/presentation/controllers/laundry_controller.dart';
import 'package:get/get.dart';

class CostManagementScreen extends StatefulWidget {
  const CostManagementScreen({super.key});

  @override
  State<CostManagementScreen> createState() => _CostManagementScreenState();
}

class _CostManagementScreenState extends State<CostManagementScreen> {
  final LaundryController controller = Get.find<LaundryController>();
  late TextEditingController _washController;
  late TextEditingController _pressController;
  late TextEditingController _bothController;

  @override
  void initState() {
    super.initState();
    _washController = TextEditingController(
        text: controller.washPrice.value.toStringAsFixed(0));
    _pressController = TextEditingController(
        text: controller.pressPrice.value.toStringAsFixed(0));
    _bothController = TextEditingController(
        text: controller.bothPrice.value.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _washController.dispose();
    _pressController.dispose();
    _bothController.dispose();
    super.dispose();
  }

  void _saveCosts() {
    final wash = double.tryParse(_washController.text);
    final press = double.tryParse(_pressController.text);
    final both = double.tryParse(_bothController.text);

    controller.updateLaundryCost(wash: wash, press: press, both: both);

    Get.snackbar(
      'Success',
      'Costs updated successfully!',
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.green,
      colorText: Colors.white,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE3F2FD),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Row(
          children: const [
            Icon(Icons.settings_suggest, color: Colors.white),
            SizedBox(width: 8),
            Text(
              "Cost Management",
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Set Service Prices",
              style: TextStyle(
                color: AppColors.textPrimary,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "Update the cost per cloth for each service type.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            _buildCostCard(
              title: "Washing",
              icon: Icons.local_laundry_service_outlined,
              iconBgColor: const Color(0xFFD1E4F9),
              iconColor: const Color(0xFF1976D2),
              controller: _washController,
            ),
            const SizedBox(height: 16),
            _buildCostCard(
              title: "Pressing (Iron)",
              icon: Icons.iron,
              iconBgColor: const Color(0xFFD1FBF9),
              iconColor: const Color(0xFF0097A7),
              controller: _pressController,
            ),
            const SizedBox(height: 16),
            _buildCostCard(
              title: "Both (Wash + Press)",
              icon: Icons.checkroom,
              iconBgColor: const Color(0xFFFFEBD4),
              iconColor: const Color(0xFFE65100),
              controller: _bothController,
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 56,
              child: ElevatedButton(
                onPressed: _saveCosts,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  elevation: 2,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.save_outlined, color: Colors.white),
                    SizedBox(width: 8),
                    Text(
                      "Save Changes",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCostCard({
    required String title,
    required IconData icon,
    required Color iconBgColor,
    required Color iconColor,
    required TextEditingController controller,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: iconBgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: iconColor, size: 28),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F8FC),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Text(
                        "₹",
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
