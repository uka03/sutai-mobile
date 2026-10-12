import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sutai/core/components/general_scaffold.dart';
import 'package:sutai/core/shared/colors.dart';
import 'package:sutai/core/shared/custom_app_bar.dart';
import 'package:sutai/core/shared/custom_button.dart';
import 'package:sutai/core/shared/custom_text_field.dart';
import 'package:sutai/core/shared/spacer.dart';
import 'package:sutai/core/shared/text_styles.dart';
import 'package:sutai/core/shared/toasts.dart';
import 'package:sutai/core/utils/formatters.dart';
import 'package:sutai/page/auth/provider/auth_provider.dart';
import 'package:sutai/page/cart/provider/cart_provider.dart';
import 'package:sutai/page/order/model/create_order_request.dart';
import 'package:sutai/page/order/model/order_action_exception.dart';
import 'package:sutai/page/order/provider/my_orders_provider.dart';

class CreateOrderPage extends ConsumerStatefulWidget {
  const CreateOrderPage({super.key});

  static const path = '/checkout';

  @override
  ConsumerState<CreateOrderPage> createState() => _CreateOrderPageState();
}

class _CreateOrderPageState extends ConsumerState<CreateOrderPage> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _noteController = TextEditingController();
  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authProvider);
    final user = authState is AuthStateAuthenticated ? authState.user : null;
    _nameController = TextEditingController(text: user?.name ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submitOrder() async {
    final cart = ref.read(cartProvider);
    if (_isSubmitting ||
        cart.isEmpty ||
        !(_formKey.currentState?.validate() ?? false)) {
      return;
    }

    setState(() => _isSubmitting = true);
    final request = CreateOrderRequest(
      customerName: _nameController.text.trim(),
      customerPhone: _phoneController.text.trim(),
      shippingAddress: _addressController.text.trim(),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
      items: cart.items
          .map(
            (entry) => CreateOrderItemRequest(
              productId: entry.product.id,
              quantity: entry.quantity,
            ),
          )
          .toList(),
    );

    try {
      await ref.read(orderActionsProvider).createOrder(request);
      if (!mounted) return;
      ref.read(cartProvider.notifier).clear();
      Toast.success(context, description: 'Захиалга амжилттай үүслээ.');
      context.pop();
    } catch (error) {
      if (!mounted) return;
      final message = error is OrderActionException
          ? error.message
          : 'Захиалга үүсгэхэд алдаа гарлаа.';
      Toast.error(context, description: message);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    return GeneralScaffold(
      padding: EdgeInsets.zero,
      appBar: CustomAppBar(
        title: Text(
          'Захиалга баталгаажуулах',
          style: GeneralTextStyle.titleText(fontSize: 18),
        ),
      ),
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 28),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Хүргэлтийн мэдээлэл',
                style: GeneralTextStyle.titleText(fontSize: 18),
              ),
              VSpacer(),
              CustomTextField(
                controller: _nameController,
                hintText: 'Хүлээн авагчийн нэр',
                withIcon: false,
                keyboardType: TextInputType.name,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Нэрээ оруулна уу.'
                    : null,
              ),
              VSpacer.sm(),
              CustomTextField(
                controller: _phoneController,
                hintText: 'Утасны дугаар',
                withIcon: false,
                keyboardType: TextInputType.phone,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Утасны дугаараа оруулна уу.'
                    : null,
              ),
              VSpacer.sm(),
              CustomTextField(
                controller: _addressController,
                hintText: 'Хүргэлтийн хаяг',
                withIcon: false,
                keyboardType: TextInputType.streetAddress,
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Хүргэлтийн хаягаа оруулна уу.'
                    : null,
              ),
              VSpacer.sm(),
              CustomTextField(
                controller: _noteController,
                hintText: 'Нэмэлт тэмдэглэл (заавал биш)',
                withIcon: false,
                keyboardType: TextInputType.multiline,
                maxLines: 3,
              ),
              VSpacer.lg(),
              Text(
                'Захиалгын дүн',
                style: GeneralTextStyle.titleText(fontSize: 18),
              ),
              VSpacer.sm(),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: GeneralColors.primaryBGColor,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${cart.itemCount} бараа',
                      style: GeneralTextStyle.bodyText(fontSize: 14),
                    ),
                    Text(
                      formatPrice(cart.total),
                      style: GeneralTextStyle.titleText(fontSize: 16),
                    ),
                  ],
                ),
              ),
              VSpacer.lg(),
              CustomButton(
                onTap: _submitOrder,
                enabled: !_isSubmitting && !cart.isEmpty,
                borderRadius: BorderRadius.circular(14),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  decoration: BoxDecoration(
                    color: _isSubmitting || cart.isEmpty
                        ? GeneralColors.grayColor
                        : GeneralColors.primaryColor,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: _isSubmitting
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(
                            'Захиалга үүсгэх',
                            style: GeneralTextStyle.titleText(
                              fontSize: 15,
                              textColor: Colors.white,
                            ),
                          ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

}
