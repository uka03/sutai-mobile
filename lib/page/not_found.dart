import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sutai/core/components/general_scaffold.dart';
import 'package:sutai/core/shared/empty_state_view.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) => GeneralScaffold(
    child: EmptyStateView(
      icon: Icons.link_off_rounded,
      title: '404 · Хуудас олдсонгүй',
      message: 'Таны хайсан хуудас байхгүй эсвэл хаяг нь өөрчлөгдсөн байна.',
      actionLabel: 'Нүүр хуудас руу буцах',
      onAction: () => context.go('/main'),
    ),
  );
}
