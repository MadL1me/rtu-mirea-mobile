import 'package:flutter/material.dart';
import 'package:rtu_mirea_app/presentation/colors.dart';
import 'package:rtu_mirea_app/presentation/theme.dart';

class SocialIconButton extends StatelessWidget {
  const SocialIconButton(this.assetImage, this.onClick);
  final AssetImage assetImage;
  final Function onClick;

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.transparent),
        shadowColor: MaterialStateProperty.all<Color>(Colors.transparent),
        shape: MaterialStateProperty.all<RoundedRectangleBorder>(
          RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24.0),
            side: BorderSide(color: DarkThemeColors.deactive),
          ),
        ),
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 60, vertical: 16),
        child: Image(
          image: assetImage,
          height: 16.0,
        ),
      ),
      onPressed: () {
        onClick();
      },
    );
  }
}
