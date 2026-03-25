import 'package:flutter/material.dart';
import 'package:uitoolkit/uitoolkit.dart';
import 'package:hsh_app/modules/laundry/presentation/controllers/laundry_controller.dart';
import 'package:get/get.dart';

class CostManagementScreen extends StatefulWidget {
  const CostManagementScreen({super.key});

  @override
  State<CostManagementScreen> createState() => _CostManagementScreenState();
}

class _CostManagementScreenState extends State<CostManagementScreen> {
  final LaundryController controller = Get.find<LaundryController>();

  void _saveCosts() {
    controller.updateLaundryCost(
      wash: controller.washPrice.value,
      press: controller.pressPrice.value,
      both: controller.bothPrice.value,
    );

    ModernToast.show(
      message: 'Costs updated successfully!',
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    return ModernScaffold(
      title: 'Cost Management',
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const ModernText(
              'Revenue Overview',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const SizedBox(height: 16),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildStatCard(
                    title: 'This Month',
                    value: '₹2,450',
                    icon: Icons.currency_rupee,
                    color: Colors.tealAccent.shade700,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    title: 'Orders',
                    value: '24',
                    icon: Icons.inventory_2_outlined,
                    color: Colors.indigoAccent,
                  ),
                  const SizedBox(width: 12),
                  _buildStatCard(
                    title: 'Avg. Order',
                    value: '₹102',
                    icon: Icons.trending_up,
                    color: Colors.orange,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            const ModernText(
              'Service Prices',
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
            const ModernText(
              'Set cost per cloth for each service',
              fontSize: 12,
              isSecondary: true,
            ),
            const SizedBox(height: 24),
            Obx(() => Column(
                  children: [
                    _buildServicePriceCard(
                      title: 'Washing',
                      subtitle: 'Wash only',
                      icon: Icons.local_laundry_service_outlined,
                      price: controller.washPrice.value,
                      accentColor: Colors.blue,
                      onChanged: (val) => controller.washPrice.value = val,
                    ),
                    const SizedBox(height: 16),
                    _buildServicePriceCard(
                      title: 'Pressing (Iron)',
                      subtitle: 'Iron only',
                      icon: Icons.auto_awesome_outlined,
                      price: controller.pressPrice.value,
                      accentColor: Colors.tealAccent.shade700,
                      onChanged: (val) => controller.pressPrice.value = val,
                    ),
                    const SizedBox(height: 16),
                    _buildServicePriceCard(
                      title: 'Both (Wash + Press)',
                      subtitle: 'Full service',
                      icon: Icons.checkroom_outlined,
                      price: controller.bothPrice.value,
                      accentColor: Colors.orange,
                      onChanged: (val) => controller.bothPrice.value = val,
                    ),
                  ],
                )),
            const SizedBox(height: 32),
            ModernButton(
              text: 'Save Changes',
              icon: Icons.save_outlined,
              onPressed: _saveCosts,
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      width: 110,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          ModernText(
            value,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
          const SizedBox(height: 4),
          ModernText(
            title,
            fontSize: 10,
            isSecondary: true,
          ),
        ],
      ),
    );
  }

  Widget _buildServicePriceCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required double price,
    required Color accentColor,
    required Function(double) onChanged,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 5,
              decoration: BoxDecoration(
                color: accentColor,
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(20),
                  bottomLeft: Radius.circular(20),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: accentColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(icon, color: accentColor, size: 24),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ModernText(
                            title,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                          const SizedBox(height: 2),
                          ModernText(
                            subtitle,
                            fontSize: 11,
                            isSecondary: true,
                          ),
                        ],
                      ),
                    ),
                    Row(
                      children: [
                        _PriceStepperButton(
                          icon: Icons.remove,
                          onPressed: () => onChanged(price > 0 ? price - 1 : 0),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 12),
                          child: ModernText(
                            '₹${price.toStringAsFixed(0)}',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        _PriceStepperButton(
                          icon: Icons.add,
                          isPrimary: true,
                          onPressed: () => onChanged(price + 1),
                        ),
                      ],
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
}

class _PriceStepperButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;
  final bool isPrimary;

  const _PriceStepperButton({
    required this.icon,
    required this.onPressed,
    this.isPrimary = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isPrimary ? const Color(0xFF1E293B) : Colors.grey.shade100,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          icon,
          size: 18,
          color: isPrimary ? Colors.white : Colors.grey.shade600,
        ),
      ),
    );
  }
}
