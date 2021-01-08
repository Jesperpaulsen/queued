import 'package:flutter/material.dart';
import 'package:queued/configs/colors.dart';

import 'join.dart';

class LoggedOut extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.secondary,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 30, 0, 30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                flex: 5,
                child: Container(
                  padding: EdgeInsets.only(bottom: 50),
                  alignment: Alignment.bottomCenter,
                  child: Text(
                    'queued',
                    style: TextStyle(fontSize: 40),
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Join(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
