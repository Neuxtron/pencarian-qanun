import 'package:flutter/material.dart';
import 'package:pencarian_qanun_mobile/core/models/komisi.dart';
import 'package:pencarian_qanun_mobile/core/repositories/komisi_repository.dart';
import 'package:pencarian_qanun_mobile/features/home/views/home_page.dart';
import 'package:pencarian_qanun_mobile/shared/styles/app_colors.dart';

class MainLayout extends StatefulWidget {
  const MainLayout({super.key});

  @override
  State<MainLayout> createState() => _MainLayoutState();
}

class _MainLayoutState extends State<MainLayout> {
  int _currentIndex = 0;
  late Future<List<Komisi>> _komisiFuture;

  List<Widget> get _pages => [
        HomePage(
          komisiFuture: _komisiFuture,
          changeIndex: _changeIndex,
        ),
        const Center(
          child: Text("Pencarian"),
        ),
        const Center(
          child: Text("Chatbot"),
        ),
      ];

  final List<AppBar?> _appBars = [
    null,
    null,
    null,
  ];

  _changeIndex(int index) {
    setState(() => _currentIndex = index);
  }

  @override
  void initState() {
    super.initState();
    _komisiFuture = KomisiRepository().getKomisi();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBars[_currentIndex],
      body: Stack(
        alignment: Alignment.bottomCenter,
        fit: StackFit.expand,
        children: [
          SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 100),
                child: _pages[_currentIndex],
              ),
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
