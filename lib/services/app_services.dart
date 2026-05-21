import '../data/local_data_store.dart';
import 'local_admin_service.dart';
import 'local_feedback_service.dart';
import 'local_order_service.dart';
import 'local_product_service.dart';

/// Local-only service bundle (no Firebase).
class AppServices {
  AppServices._({
    required this.store,
    required this.productService,
    required this.orderService,
    required this.feedbackService,
    required this.adminService,
  });

  final LocalDataStore store;
  final LocalProductService productService;
  final LocalOrderService orderService;
  final LocalFeedbackService feedbackService;
  final LocalAdminService adminService;

  static Future<AppServices> create() async {
    final store = LocalDataStore.instance;
    await store.init();
    return fromStore(store);
  }

  static AppServices fromStore(LocalDataStore store) {
    return AppServices._(
      store: store,
      productService: LocalProductService(store),
      orderService: LocalOrderService(store),
      feedbackService: LocalFeedbackService(store),
      adminService: LocalAdminService(store),
    );
  }
}
