import 'package:go_router/go_router.dart';
import 'package:hsh_app/modules/laundry/presentation/screens/laundry_main_shell.dart';
import 'package:hsh_app/modules/laundry/presentation/screens/chat/laundry_chat_details_screen.dart';
import 'package:hsh_app/modules/laundry/presentation/screens/orders/laundry_order_detail_screen.dart';
import 'package:hsh_app/modules/laundry/domain/entities/laundry_entities.dart';

class LaundryRoutes {
  static const String laundryMain = '/laundry';
  static const String laundryChatDetails = '/laundry/chat/details';
  static const String laundryOrderDetail = '/laundry/order-detail';

  static final List<RouteBase> routes = [
    GoRoute(
      path: laundryMain,
      builder: (context, state) => const LaundryMainShell(),
      routes: [
        GoRoute(
          path: 'chat/details',
          builder: (context, state) {
            final convId = state.extra as String?;
            return LaundryChatDetailsScreen(conversationId: convId);
          },
        ),
        GoRoute(
          path: 'order-detail',
          builder: (context, state) {
            final order = state.extra as LaundryOrderEntity;
            return LaundryOrderDetailScreen(order: order);
          },
        ),
      ],
    ),
  ];
}
