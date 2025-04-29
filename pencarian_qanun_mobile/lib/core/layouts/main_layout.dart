import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/models/komisi.dart';
import 'package:pencarian_qanun_mobile/core/providers/connection_mode_provider.dart';
import 'package:pencarian_qanun_mobile/core/repositories/komisi_repository.dart';
import 'package:pencarian_qanun_mobile/core/viewmodels/qanun_viewmodel.dart';
import 'package:pencarian_qanun_mobile/features/home/views/home_page.dart';
import 'package:pencarian_qanun_mobile/features/pencarian/views/pencarian_page.dart';
import 'package:pencarian_qanun_mobile/routes.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_colors.dart';
import 'package:pencarian_qanun_mobile/shared/utils/app_utils.dart';
import 'package:provider/provider.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  Future<List<Komisi>>? _komisiFuture;
  bool _isReady = false;

  List<Widget> get _pages => [
        HomePage(
          komisiFuture: _komisiFuture!,
          changeIndex: _changeIndex,
        ),
        _HandleBack(
          changeIndex: _changeIndex,
          child: const PencarianPage(),
        ),
        _HandleBack(
          changeIndex: _changeIndex,
          child: const Center(
            child: Text("Chatbot"),
          ),
        ),
      ];

  final List<AppBar?> _appBars = [
    AppUtils.emptyAppBar(),
    AppUtils.emptyAppBar(),
    AppUtils.emptyAppBar(),
  ];

  _changeIndex(int index) {
    if (index == 2) {
      Navigator.pushNamed(context, Routes.chatbot);
      return;
    }
    setState(() => _currentIndex = index);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ConnectionModeProvider>().context = context;
      context.read<QanunViewmodel>().context = context;
      _komisiFuture ??= KomisiRepository(context).getKomisi();
      setState(() => _isReady = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_currentIndex],
      body: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        children: [
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 100),
              child: _isReady ? _pages[_currentIndex] : null,
            ),
          ),
          _BottomNav(
            currentIndex: _currentIndex,
            onChange: _changeIndex,
          ),
        ],
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.onChange,
  });

  final int currentIndex;
  final Function(int index) onChange;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomCenter,
      children: [
        Container(
          height: 60,
          color: AppColors.primary,
          child: Row(
            children: [
              _NavItem(
                icon: Icons.home_outlined,
                activeIcon: Icons.home,
                text: "Home",
                active: currentIndex == 0,
                onPressed: () => onChange(0),
              ),
              _NavItem(
                icon: null,
                activeIcon: null,
                onPressed: null,
                text: "Pencarian",
                active: currentIndex == 1,
              ),
              _NavItem(
                icon: Icons.face_outlined,
                activeIcon: Icons.face,
                text: "Chatbot",
                active: currentIndex == 2,
                onPressed: () => onChange(2),
              ),
            ],
          ),
        ),
        Container(
          height: 70,
          width: 70,
          margin: const EdgeInsets.only(bottom: 28),
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.primary,
            boxShadow: currentIndex != 1
                ? []
                : [
                    BoxShadow(
                      color: Color.alphaBlend(
                        Colors.white.withOpacity(.5),
                        AppColors.primary,
                      ),
                      offset: const Offset(0, 0),
                      blurRadius: 12,
                    ),
                  ],
          ),
          child: Container(
            height: double.infinity,
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            clipBehavior: Clip.hardEdge,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: AppColors.primary.withOpacity(.2),
                onTap: () => onChange(1),
                child: const Icon(
                  Icons.search,
                  color: AppColors.primary,
                  size: 40,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.text,
    required this.activeIcon,
    required this.active,
    required this.onPressed,
  });

  final IconData? icon;
  final IconData? activeIcon;
  final String text;
  final bool active;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: icon == null ? null : onPressed,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                active ? activeIcon : icon,
                size: 30,
                color: Colors.white,
              ),
              Text(
                text,
                style: TextStyle(
                  fontWeight: active ? FontWeight.w500 : FontWeight.normal,
                  color: Colors.white,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HandleBack extends StatelessWidget {
  const _HandleBack({
    required this.child,
    required this.changeIndex,
  });

  final Function(int index) changeIndex;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (_) => changeIndex(0),
      child: child,
    );
  }
}
