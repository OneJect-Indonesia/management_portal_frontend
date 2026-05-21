import 'dart:math' as math;
import 'dart:ui' as ui;
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:hexagonal/hexagonal.dart';
import '../../models/dashboard_model.dart';
import '../../providers/dashboard_provider.dart';
import '../../../../core/theme/app_colors.dart';

class HoneycombMenu extends StatefulWidget {
  final List<MenuItem> items;
  final double hexSize;
  final double gap;

  const HoneycombMenu({
    super.key,
    required this.items,
    required this.hexSize,
    required this.gap,
  });

  @override
  State<HoneycombMenu> createState() => _HoneycombMenuState();
}

class _HoneycombMenuState extends State<HoneycombMenu> {
  late ScrollController _horizontalController;
  late ScrollController _verticalController;
  final Set<String> _hoveredIds = {};

  @override
  void initState() {
    super.initState();
    _horizontalController = ScrollController();
    _verticalController = ScrollController();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCenter();
    });
  }

  void _scrollToCenter() {
    if (_horizontalController.hasClients) {
      final maxScrollX = _horizontalController.position.maxScrollExtent;
      _horizontalController.jumpTo(maxScrollX / 2);
    }
    if (_verticalController.hasClients) {
      final maxScrollY = _verticalController.position.maxScrollExtent;
      _verticalController.jumpTo(maxScrollY / 2);
    }
  }

  @override
  void dispose() {
    _horizontalController.dispose();
    _verticalController.dispose();
    super.dispose();
  }

  Future<void> _handleMenuTap(BuildContext context, MenuItem item) async {
    // Show transparent loading indicator
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.white.withOpacity(0.5),
      builder: (BuildContext context) => const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
        ),
      ),
    );

    final dashboardProvider = context.read<DashboardProvider>();
    bool isDialogDismissed = false;

    try {
      final ssoUrl = await dashboardProvider.prepareSsoUrl(item);

      if (context.mounted) {
        Navigator.of(context).pop();
        isDialogDismissed = true;
      }

      final uri = Uri.parse(ssoUrl);
      if (await canLaunchUrl(uri)) {
        if (kIsWeb) {
          await launchUrl(uri, webOnlyWindowName: '_self');
        } else {
          await launchUrl(uri);
        }
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Could not open ${item.module.moduleName}'),
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal mendapatkan akses: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (!isDialogDismissed && context.mounted) {
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final dataList = <Map<String, dynamic>>[
      {'type': 'center', 'data': null}, // Center logo
      ...widget.items.map((item) => {'type': 'menu', 'data': item}),
    ];

    int rings = 0;
    if (dataList.length > 1) {
      if (dataList.length <= 7) {
        rings = 1;
      } else if (dataList.length <= 19) {
        rings = 2;
      } else if (dataList.length <= 37) {
        rings = 3;
      } else {
        rings = 4;
      }
    }

    final double apothem = widget.hexSize * math.sqrt(3) / 2;
    final double maxRadius = rings * (apothem * 2 + widget.gap);
    final double gridWidth = maxRadius * 2 + widget.hexSize * 2;
    final double gridHeight = maxRadius * 2 + widget.hexSize * 2;

    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasWidth = math.max(constraints.maxWidth, gridWidth + 100);
        final canvasHeight = math.max(constraints.maxHeight, gridHeight + 100);
        final centerX = canvasWidth / 2;
        final centerY = canvasHeight / 2;

        final hexWidgets = DataDrivenHexGenerator.generate(
          DataDrivenHexConfig<Map<String, dynamic>>(
            data: dataList,
            pattern: HexLayoutPattern.honeycomb,
            startPosition: Offset(centerX, centerY),
            hexSize: widget.hexSize,
            gap: widget.gap,
            honeycombRings: rings,
            hexBuilder: (item, hexagon, index) {
              if (item['type'] == 'center') {
                final isHovered = _hoveredIds.contains('center_logo');
                return EnhancedFreeHexWidget(
                  id: 'center_logo',
                  hexagon: hexagon,
                  fillStyle: const ImageFill(
                    AssetImage('assets/images/Oneject-Vertical.png'),
                    fit: BoxFit.cover,
                  ),
                  borderStyle: HexBorderStyle(
                    color: isHovered
                        ? Colors.white.withOpacity(0.9)
                        : Colors.white.withOpacity(0.3),
                    width: isHovered ? 3.0 : 2.0,
                  ),
                  clickAnimation: HexClickAnimation.glow,
                  onHover: (hovering) {
                    setState(() {
                      if (hovering) {
                        _hoveredIds.add('center_logo');
                      } else {
                        _hoveredIds.remove('center_logo');
                      }
                    });
                  },
                );
              } else {
                final menuItem = item['data'] as MenuItem;
                final isHovered = _hoveredIds.contains(menuItem.id.toString());
                return EnhancedFreeHexWidget(
                  id: 'menu_${menuItem.id}',
                  hexagon: hexagon,
                  clipContent: true,
                  borderStyle: HexBorderStyle(
                    color: isHovered
                        ? Colors.white.withOpacity(0.7)
                        : Colors.white.withOpacity(0.25),
                    width: isHovered ? 2.5 : 1.5,
                  ),
                  clickAnimation: HexClickAnimation.scale,
                  onHover: (hovering) {
                    setState(() {
                      if (hovering) {
                        _hoveredIds.add(menuItem.id.toString());
                      } else {
                        _hoveredIds.remove(menuItem.id.toString());
                      }
                    });
                  },
                  onTap: () => _handleMenuTap(context, menuItem),
                  child: TweenAnimationBuilder<double>(
                    tween: Tween<double>(
                      begin: 12.0,
                      end: isHovered ? 25.0 : 12.0,
                    ),
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutCubic,
                    builder: (context, blurValue, child) {
                      return BackdropFilter(
                        filter: ui.ImageFilter.blur(
                          sigmaX: blurValue,
                          sigmaY: blurValue,
                        ),
                        child: child,
                      );
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      curve: Curves.easeOutCubic,
                      alignment: Alignment.center,
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      color: isHovered
                          ? Colors.white.withOpacity(0.3)
                          : Colors.white.withOpacity(0.15),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.apps_rounded,
                            color: isHovered
                                ? Colors.white
                                : Colors.white.withOpacity(0.9),
                            size: 20,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            menuItem.module.moduleName,
                            style: TextStyle(
                              color: isHovered
                                  ? Colors.white
                                  : Colors.white.withOpacity(0.9),
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              shadows: const [
                                Shadow(
                                  color: Colors.black26,
                                  blurRadius: 4,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }
            },
          ),
        );

        return SingleChildScrollView(
          controller: _verticalController,
          scrollDirection: Axis.vertical,
          child: SingleChildScrollView(
            controller: _horizontalController,
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: canvasWidth,
              height: canvasHeight,
              child: Stack(
                children: hexWidgets.asMap().entries.map((entry) {
                  final index = entry.key;
                  final w = entry.value;
                  final isHovered = _hoveredIds.contains(w.id);

                  return EntranceHexCell(
                    index: index,
                    startPosition: Offset(centerX, centerY),
                    targetPosition: w.hexagon.center,
                    hexSize: w.hexagon.size,
                    isHovered: isHovered,
                    hexagon: w.hexagon,
                    disableHoverScale: w.id == 'center_logo',
                    child: EnhancedHexagonRenderer(config: w),
                  );
                }).toList(),
              ),
            ),
          ),
        );
      },
    );
  }
}

class EntranceHexCell extends StatefulWidget {
  final Widget child;
  final Offset startPosition;
  final Offset targetPosition;
  final double hexSize;
  final int index;
  final bool isHovered;
  final FreeHexagon hexagon;
  final bool disableHoverScale;

  const EntranceHexCell({
    super.key,
    required this.child,
    required this.startPosition,
    required this.targetPosition,
    required this.hexSize,
    required this.index,
    required this.isHovered,
    required this.hexagon,
    this.disableHoverScale = false,
  });

  @override
  State<EntranceHexCell> createState() => _EntranceHexCellState();
}

class _EntranceHexCellState extends State<EntranceHexCell>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _positionAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _opacityAnimation;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Stagger based on index
    final int delayMs = widget.index * 60; // 60ms delay per cell
    _timer = Timer(Duration(milliseconds: delayMs), () {
      if (mounted) {
        _controller.forward();
      }
    });

    _positionAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutBack, // bouncy spring landing!
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.8, curve: Curves.easeOutCubic),
      ),
    );

    _opacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );
  }

  @override
  void dispose() {
    _timer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final double progress = _positionAnimation.value;
        final double currentX =
            widget.startPosition.dx +
            (widget.targetPosition.dx - widget.startPosition.dx) * progress;
        final double currentY =
            widget.startPosition.dy +
            (widget.targetPosition.dy - widget.startPosition.dy) * progress;

        final double entranceScale = _scaleAnimation.value;
        final double opacity = _opacityAnimation.value;

        // Apply a custom shadow that matches the hexagon shape using PhysicalShape
        Widget shapedChild = PhysicalShape(
          color: Colors.transparent, // Background inside the shape
          shadowColor: widget.isHovered
              ? Colors.black.withOpacity(0.5)
              : Colors.black.withOpacity(0.2),
          elevation: widget.isHovered ? 16.0 : 6.0,
          clipper: HexPathClipper(widget.hexagon),
          child: widget.child,
        );

        // Then apply hover scaling over the entire shadowed shape
        Widget hoverScaledChild = AnimatedScale(
          scale: (widget.isHovered && !widget.disableHoverScale) ? 1.15 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOutCubic,
          child: shapedChild,
        );

        return Positioned(
          left: currentX - widget.hexSize,
          top: currentY - widget.hexSize,
          child: Opacity(
            opacity: opacity,
            child: Transform.scale(
              scale: entranceScale,
              child: SizedBox(
                width: widget.hexSize * 2,
                height: widget.hexSize * 2,
                child: hoverScaledChild,
              ),
            ),
          ),
        );
      },
    );
  }
}

class HexPathClipper extends CustomClipper<Path> {
  final FreeHexagon hexagon;

  HexPathClipper(this.hexagon);

  @override
  Path getClip(Size size) {
    final path = Path();
    final corners = hexagon.getCorners();
    final center = Offset(size.width / 2, size.height / 2);

    for (int i = 0; i < corners.length; i++) {
      final corner = corners[i];
      final adjusted = Offset(
        corner.dx - hexagon.center.dx + center.dx,
        corner.dy - hexagon.center.dy + center.dy,
      );
      if (i == 0) {
        path.moveTo(adjusted.dx, adjusted.dy);
      } else {
        path.lineTo(adjusted.dx, adjusted.dy);
      }
    }
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => true;
}
