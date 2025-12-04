import 'package:flutter/material.dart';
import 'package:mobileapp/api/user.dart';
import 'package:mobileapp/screens/user_details/widgets/no_mentor_box.dart';
import 'package:mobileapp/screens/user_details/widgets/user_detail_box.dart';
import 'package:mobileapp/shared/widgets/header.dart';
import 'package:mobileapp/shared/widgets/page_content_loading_indicator.dart';
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
        titleColor: Theme.of(context).colorScheme.onPrimary,
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
                        UserDetailBox(title: "Cliënt", user: user),
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
                        mentor != null ? UserDetailBox(title: "Begeleider", user: mentor) : NoMentorBox(),
                      ],
                    );
                  } else {
                    return const PageContentLoadingIndicator();
                  }
                },
              ),
            ),
          ),
        ),
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
