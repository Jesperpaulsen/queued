import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String _title;
  CustomAppBar(this._title);

  @override
  Size get preferredSize => Size.fromHeight(60);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: Theme.of(context).primaryColor,
        ),
        onPressed: () {},
      ),
      centerTitle: true,
      title: Text(_title),
      backgroundColor: Theme.of(context).accentColor,
      elevation: 0,
    );
  }
}
