import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:mobileapp/api/user.dart';
import 'package:mobileapp/widgets/header.dart';
import 'package:mobileapp/widgets/page_content_progress_indicator.dart';
import 'package:mobileapp/model/user.dart';
import 'package:url_launcher/url_launcher_string.dart';

class UserDetails extends StatefulWidget {
  const UserDetails({super.key});

  @override
  State<UserDetails> createState() => _UserDetailsState();
}

class _UserDetailsState extends State<UserDetails> {
  late Future<List<dynamic>> futureUser;
  late User user;
  late User? mentor;

  Future<List> fetchUserData() async {
    List<dynamic> userData = await fetchUserDetails();

    user = userData[0];
    mentor = userData[1];

    return [user, mentor];
  }

  @override
  void initState() {
    super.initState();
    fetchUserDetails();
    futureUser = fetchUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.transparent,
      appBar: Header(
        bgColor: Theme.of(context).colorScheme.primary,
        titleColor: Theme.of(context).colorScheme.onSurface,
        title: const Text("Contactgegevens"),
      ),
      body: Container(
        height: double.infinity,
        color: Theme.of(context).colorScheme.primary,
        child: SingleChildScrollView(
          child: SafeArea(
            child: Container(
              color: Theme.of(context).colorScheme.primary,
              child: FutureBuilder<List<dynamic>>(
                future: futureUser,
                builder: (context, snapshot) {
                  if (snapshot.hasData && snapshot.connectionState == ConnectionState.done) {
                    User user = snapshot.data![0];
                    User? mentor = snapshot.data![1];
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildUserDetailsBox(user, "Cliënt"),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(0, 0, 18, 0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GestureDetector(
                                onTap: () {
                                  launchUrlString("https://www.dewaaiburgapp.eu/user");
                                },
                                child: Text(
                                  "Gegevens aanpassen",
                                  style: TextStyle(
                                    color: Theme.of(context).colorScheme.onPrimary,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Theme.of(context).colorScheme.onPrimary,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        mentor != null ? _buildUserDetailsBox(mentor, "Begeleider") : _buildNoMentorBox(),
                      ],
                    );
                  } else {
                    return const PageContentProgressIndicator();
                  }
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildUserDetailsBox(User? user, String title) {
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
              Text(title),
            ],
          ),
          const SizedBox(height: 15),
          UserDetailsItemLabel("Voornaam:", user?.firstname ?? ''),
          UserDetailsItemLabel("Achternaam:", user?.surname ?? ''),
          UserDetailsItemLabel("E-mail:", user?.email ?? ''),
          UserDetailsItemLabel(
            "Telefoonnummer:",
            user?.phoneNumber ?? 'Geen telefoonnummer opgegeven.',
          ),
          UserDetailsItemLabel("Adres:", getAddress(user)),
        ],
      ),
    );
  }

  Widget _buildNoMentorBox() {
    return Container(
      margin: const EdgeInsets.all(20.0),
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
              const Text("Begeleider"),
            ],
          ),
          const SizedBox(height: 15),
          const Text("Geen begeleider gekoppeld!"),
        ],
      ),
    );
  }
}

String getAddress(User? user) {
  if (user != null && user.street != null && user.houseNumber != null && user.zipcode != null && user.city != null) {
    return '${user.street} ${user.houseNumber},\n${user.zipcode} ${user.city}';
  } else {
    return 'Adresgegevens ontbreken';
  }
}

class UserDetailsItemLabel extends StatelessWidget {
  final String label;
  final String value;

  const UserDetailsItemLabel(this.label, this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Theme.of(context).colorScheme.secondary),
        ),
        const SizedBox(height: 3),
        Text(value),
        const SizedBox(height: 7),
      ],
    );
  }
}
