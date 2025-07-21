import 'package:flutter/material.dart';
import 'package:littrack_desktop/providers/auth_provider.dart';
import 'package:littrack_desktop/widgets/admin_sidebar.dart';

class MasterScreen extends StatefulWidget {
  final String title;
  final Widget child;

  const MasterScreen({super.key, required this.title, required this.child});

  @override
  State<MasterScreen> createState() => _MasterScreenState();
}

class _MasterScreenState extends State<MasterScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        children: [
          if (AuthProvider.uloge != null &&
              AuthProvider.uloge!.contains("Admin"))
            const AdminSidebar(),
          Expanded(
            child: Container(
              color: const Color(0xFFF6F4F3),
              padding: const EdgeInsets.only(top: 22, left: 32, right: 32, bottom: 25),
              child: LayoutBuilder(
                builder: (context, constraints) {
                  final double screenWidth = constraints.maxWidth;
                  final double logoSize = screenWidth < 500 ? 38 : 53;
                  final double litTrackFontSize = screenWidth < 500 ? 20 : 28;
                  final double titleFontSize = screenWidth < 500 ? 18 : 25;

                  return SingleChildScrollView(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraints.maxHeight),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Center(
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/images/logo.png",
                                  width: logoSize,
                                  height: logoSize,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "LitTrack",
                                  style: TextStyle(
                                    fontSize: litTrackFontSize,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2D3C39),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 30),
                          Text(
                            widget.title,
                            style: TextStyle(
                              fontSize: titleFontSize,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF2D3C39),
                            ),
                          ),
                          const SizedBox(height: 15),
                          widget.child,
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}