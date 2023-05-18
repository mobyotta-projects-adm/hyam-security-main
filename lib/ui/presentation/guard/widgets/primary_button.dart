import 'package:flutter/material.dart';
import '../../../../constants/theme.dart';
import '../../../../utils/typedef.dart';


class PrimaryButton extends StatelessWidget {
  const PrimaryButton(
      {Key? key,
      required this.onTap,
      required this.title,
      required this.disable,this.buttonColor})
      : super(key: key);
  final VoidFunctionCallbackWithNoParam onTap;
  final String title;
  final bool disable;
  final Color? buttonColor;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: !disable ? onTap : null,
      child: Opacity(
        opacity: disable ? 0.5 : 1,
        child: Container(
          padding: const EdgeInsets.only(left: 20, right: 20,top: 15,bottom: 15),
          decoration: BoxDecoration(
              color: buttonColor ?? theme.primaryColor,
              borderRadius:
              const BorderRadius.all(Radius.circular(15))),
          child: Align(
            alignment: Alignment.center,
            child: Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: whiteshade),
            ),
          ),
        ),
      ),
    );
  }
}
