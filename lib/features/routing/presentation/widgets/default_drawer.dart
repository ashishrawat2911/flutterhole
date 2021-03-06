import 'package:alice/alice.dart';
import 'package:flutter/material.dart';
import 'package:flutterhole/constants.dart';
import 'package:flutterhole/dependency_injection.dart';
import 'package:flutterhole/features/routing/presentation/notifiers/drawer_notifier.dart';
import 'package:flutterhole/features/routing/presentation/widgets/default_drawer_header.dart';
import 'package:flutterhole/features/routing/presentation/widgets/drawer_menu.dart';
import 'package:flutterhole/features/routing/presentation/widgets/drawer_tile.dart';
import 'package:flutterhole/features/routing/services/router_service.dart';
import 'package:flutterhole/features/settings/services/package_info_service.dart';
import 'package:flutterhole/features/settings/services/preference_service.dart';
import 'package:flutterhole/widgets/layout/notifications/dialogs.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

class DefaultDrawer extends StatelessWidget {
  const DefaultDrawer();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<DrawerNotifier>(
      create: (BuildContext context) => DrawerNotifier(),
      child: Drawer(
        child: Stack(
          children: <Widget>[
            ListView(
              padding: EdgeInsets.zero,
              children: <Widget>[
                DefaultDrawerHeader(),
                DrawerMenu(),
                DrawerTile(
                  routeName: RouterService.home,
                  title: Text('Dashboard'),
                  icon: Icon(KIcons.dashboard),
                ),
                DrawerTile(
                  routeName: RouterService.queryLog,
                  title: Text('Query log'),
                  icon: Icon(KIcons.queryLog),
                ),
                DrawerTile(
                  routeName: RouterService.settings,
                  title: Text('Settings'),
                  icon: Icon(KIcons.settings),
                ),
                Divider(),
                DrawerTile(
                  routeName: RouterService.about,
                  title: Text('About'),
                  icon: Icon(KIcons.about),
                ),
                ListTile(
                  title: Text('API Log'),
                  leading: Icon(KIcons.apiLog),
                  onTap: () {
                    getIt<Alice>().showInspector();
                  },
                ),
              ],
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: _Footer(),
            ),
          ],
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final String footerMessage = getIt<PreferenceService>().footerMessage;
    final PackageInfo packageInfo = getIt<PackageInfoService>().packageInfo;

    final textStyle = Theme.of(context).textTheme.caption;

    return ListTile(
      title: Text(
        '${packageInfo.appName} ${packageInfo.versionAndBuildString}',
        style: textStyle,
      ),
      leading: Image(
        image: AssetImage('assets/icon/logo.png'),
        width: 50,
        height: 50,
        color: textStyle.color,
      ),
      subtitle: footerMessage.isEmpty
          ? null
          : Text(
        '$footerMessage',
        style: textStyle,
      ),
      onLongPress: () {
        showAppDetailsDialog(context, packageInfo);
      },
    );
  }
}
