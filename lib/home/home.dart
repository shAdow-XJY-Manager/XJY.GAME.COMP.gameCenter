import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:responsive_builder/responsive_builder.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_common/flutter_common.dart';

import '../redux/action/theme_action.dart';
import '../redux/app_state/state.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  final List<Map<String, String>> navigationObj = [
    {'gameName': 'Super Mario', 'imageUrl': 'assets/images/Super Mario.png'},
    {'gameName': 'Portal', 'imageUrl': 'assets/images/Portal.png'},
    {'gameName': 'UE5 Role Animation', 'imageUrl': 'assets/images/unknown.png'},
  ];

  final List<Map<String, String>> websiteObj = [
    {'gameName': 'Tic Tac Toe', 'imageUrl': 'assets/images/tic_tac_toe.png', 'linkUrl': 'https://shadowplusing.website/tic_tac_toe/'},
    {'gameName': 'Snake Game', 'imageUrl': 'assets/images/snake_game.png', 'linkUrl': 'https://shadowplusing.website/snake_game/'},
    {'gameName': 'Rock Paper Scissors', 'imageUrl': 'assets/images/rock_paper_scissors.png', 'linkUrl': 'https://shadowplusing.website/rock_paper_scissors/'},
    {'gameName': 'Parkour Game', 'imageUrl': 'assets/images/parkour_game.png', 'linkUrl': 'https://shadowplusing.website/parkour_game/'},
  ];

  int crossAxisCount = 5;

  bool dayMode = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: siteBackground,
      appBar: AppBar(
        title: const Text('Shadow\'s Game Center'),
        centerTitle: true,
        leading: StoreConnector<AppState, VoidCallback>(
          converter: (Store store) {
            return () => {
              dayMode = store.state.themeModel.getDayMode(),
              store.dispatch(SetThemeDataAction(brightness: dayMode ? Brightness.dark : Brightness.light,))
            };
          },
          builder: (BuildContext context, VoidCallback callback) {
            return IconButton(
              onPressed: () {
                callback();
              },
              tooltip: 'day/night',
              icon: dayMode ? const Icon(Icons.sunny) : const Icon(Icons.brightness_2),
            );
          },
        ),
        actions: [
          IconButton(
            icon: const ImageIcon(AssetImage('assets/images/GitHub.png')),
            onPressed: () {
              launchUrl(Uri.parse('https://github.com/shAdow-XJY/own_game_web_show'));
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: ResponsiveBuilder(
          builder: (context, sizingInformation){
            if (sizingInformation.deviceScreenType == DeviceScreenType.mobile){
              crossAxisCount = 1;
            }else if(sizingInformation.deviceScreenType == DeviceScreenType.tablet){
              crossAxisCount = 3;
            }
            return GridView.builder(
              itemCount: navigationObj.length + websiteObj.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: crossAxisCount,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (BuildContext context, int index) {
                if (index < navigationObj.length) {
                  var game = navigationObj[index];
                  return GameCard(
                    imageProvider: AssetImage(game['imageUrl'] ?? 'assets/images/unknown.png'),
                    title: game['gameName'] ?? 'unknown',
                    tag: 'Repository',
                    onTap: () {
                      Navigator.pushNamed(context, '/markdownPage', arguments: game['gameName']);
                    },
                  );
                } else {
                  var game = websiteObj[index - navigationObj.length];
                  return GameCard(
                    imageProvider: AssetImage(game['imageUrl'] ?? ''),
                    title: game['gameName'] ?? '',
                    tag: 'Website',
                    onTap: () {
                      launchUrl(Uri.parse(game['linkUrl'] ?? ''));
                    },
                  );
                }
              },
            );
          },
        ),
      ),
    );
  }
}
