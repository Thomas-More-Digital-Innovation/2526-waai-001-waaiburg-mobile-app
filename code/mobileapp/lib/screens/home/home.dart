import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:go_router/go_router.dart';
import 'package:mobileapp/config/routes.dart';
import 'package:mobileapp/screens/home/widgets/home_button.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<bool> isLoggedIn() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userToken = prefs.getString('userToken');
  return userToken != null;
}

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  bool userLoggedIn = false;

  @override
  void initState() {
    super.initState();
    loadLoggedInState();
  }

  Future<void> loadLoggedInState() async {
    bool loggedIn = await isLoggedIn();
    setState(() {
      userLoggedIn = loggedIn;
    });
  }

  void logOut() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    // Remove the user token from SharedPreferences
    prefs.remove('userToken');

    // Update the userLoggedIn state to false
    setState(() {
      userLoggedIn = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double screenHeight = MediaQuery.of(context).size.height;
    final double logoVerticalOffset = screenHeight * 0.01;

    return Scaffold(
      body: Container(
        color: Theme.of(context).colorScheme.primary,
        child: Container(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: logoVerticalOffset),
                child: Center(
                  child: SvgPicture.asset(
                    'assets/WAAIBURG_DEFINITIEF_vector_RGB_Tekengebied 1-01.svg',
                    colorFilter: ColorFilter.mode(Theme.of(context).colorScheme.onPrimary, BlendMode.srcIn),
                    semanticsLabel: 'Waaiburg Logo',
                    height: 150,
                  ),
                ),
              ),
              Expanded(
                child: SizedBox(
                  height: MediaQuery.of(context).size.height,
                  width: MediaQuery.of(context).size.width,
                  child: GridView.count(
                    crossAxisCount: 2,
                    mainAxisSpacing: 20,
                    crossAxisSpacing: 18,
                    childAspectRatio: 1,
                    primary: false,
                    shrinkWrap: false,
                    children: [
                      HomeButton(
                        name: "JONGEREN",
                        icon: FontAwesomeIcons.child,
                        iconColor: Theme.of(context).colorScheme.secondary,
                        sectionId: 2,
                        route: "/infosegment",
                      ),
                      HomeButton(
                        name: "VOLWASSENEN",
                        icon: FontAwesomeIcons.userTie,
                        iconColor: Theme.of(context).colorScheme.primaryContainer,
                        sectionId: 1,
                        route: "/infosegment",
                      ),
                      HomeButton(
                        name: "NIEUWTJES",
                        icon: FontAwesomeIcons.newspaper,
                        iconColor: Theme.of(context).colorScheme.primaryContainer,
                        sectionId: 0,
                        route: AppRoutes.news,
                      ),
                      HomeButton(
                        name: "WEBSITE",
                        icon: FontAwesomeIcons.globe,
                        iconColor: Theme.of(context).colorScheme.secondary,
                        sectionId: 1,
                        route: "https://www.dewaaiburg.be/",
                      ),
                      if (userLoggedIn) ...[
                        HomeButton(
                          name: "LEVENSBOOM",
                          icon: FontAwesomeIcons.tree,
                          iconColor: Theme.of(context).colorScheme.primaryContainer,
                          sectionId: 0,
                          route: AppRoutes.treeHome,
                        ),
                        HomeButton(
                          name: "GEGEVENS",
                          icon: FontAwesomeIcons.user,
                          iconColor: Theme.of(context).colorScheme.secondary,
                          sectionId: 0,
                          route: AppRoutes.userDetails,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
              SizedBox(
                width: screenHeight,
                child: TextButton(
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.all(18.0),
                    backgroundColor: Theme.of(context).colorScheme.surfaceContainer,
                    shape: const RoundedRectangleBorder(
                      borderRadius: BorderRadius.all(Radius.circular(30)),
                    ),
                  ),
                  onPressed: () {
                    userLoggedIn ? logOut() : context.push(AppRoutes.login);
                  },
                  child: Text(
                    userLoggedIn ? 'Uitloggen' : 'Inloggen',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      shadows: [
                        Shadow(
                          blurRadius: 5,
                          color: Colors.black45,
                          offset: Offset(0, 2),
                        )
                      ],
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
