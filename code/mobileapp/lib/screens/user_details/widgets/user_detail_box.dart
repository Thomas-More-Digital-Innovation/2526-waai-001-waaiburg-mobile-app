import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobileapp/model/user.dart';
import 'package:mobileapp/screens/user_details/user_details.dart';
import 'package:mobileapp/screens/user_details/widgets/user_detail_item_label.dart';

class UserDetailBox extends StatelessWidget {
  final String title;
  final User? user;
  const UserDetailBox({super.key, required this.title, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 10, 20, 10),
      padding: const EdgeInsets.fromLTRB(30, 18, 30, 18),
      width: double.infinity,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
        borderRadius: const BorderRadius.all(Radius.circular(30)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              FaIcon(
                FontAwesomeIcons.user,
                color: Theme.of(context).colorScheme.secondary,
                size: 17,
              ),
              const SizedBox(
                width: 7,
              ),
              Text(title, style: TextStyle(color: Theme.of(context).colorScheme.secondary, fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 15),
          UserDetailItemLabel("Voornaam:", user?.firstName ?? ''),
          UserDetailItemLabel("Achternaam:", user?.surname ?? ''),
          UserDetailItemLabel("E-mail:", user?.email ?? ''),
          UserDetailItemLabel(
            "Telefoonnummer:",
            user?.phoneNumber ?? 'Geen telefoonnummer opgegeven.',
          ),
          UserDetailItemLabel("Adres:", getAddress(user)),
        ],
      ),
    );
  }
}
