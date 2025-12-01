import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mobileapp/config/routes.dart';
import 'package:url_launcher/url_launcher_string.dart';

class HomeButton extends StatelessWidget {
  const HomeButton({
    super.key,
    required this.name,
    required this.icon,
    required this.iconColor,
    required this.sectionId,
    required this.route,
  });

  final String name;
  final IconData icon;
  final Color iconColor;
  final int sectionId;
  final String route;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (route.startsWith("https")) {
          launchUrlString(route);
          return;
        }
        // Use the route directly if it's a simple route (like /news, /tree)
        // Otherwise use infoSegmentsPath for section-based navigation
        if (sectionId > 0) {
          context.push(AppRoutes.infoSegmentsPath(sectionId));
        } else {
          context.push(route);
        }
      },
      child: Container(
        padding: const EdgeInsets.all(18.0),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
          borderRadius: const BorderRadius.all(
            Radius.circular(30),
          ),
        ),
        child: FittedBox(
          fit: BoxFit.scaleDown,
          child: Column(
            children: [
              FaIcon(
                icon,
                color: iconColor,
                size: 82,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 16),
                child: Text(
                  name,
                  style: GoogleFonts.poppins(fontSize: 18, fontWeight: FontWeight.w600, color: Colors.white, shadows: [
                    const Shadow(
                      blurRadius: 5,
                      color: Colors.black45,
                      offset: Offset(0, 2),
                    )
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
