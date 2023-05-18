import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../../../../constants/theme.dart';

class ProfileListItem extends StatelessWidget {
  final IconData? icon;
  final String? text;
  final String? subText;
  final bool? hasNavigation;
  final VoidCallback? onTap;

  const ProfileListItem({
    Key? key,
    this.icon,
    this.text,
    this.subText,
    this.hasNavigation = false,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 10,
        ).copyWith(
          bottom: 10,
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: Theme.of(context).backgroundColor,
        ),
        child: Row(
          children: <Widget>[
            Icon(
              icon,
              size: 25,
              color: Colors.black,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: text,
                      style: kTitleTextStyle.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    TextSpan(
                      text: subText ?? '',
                      style: kTitleTextStyle.copyWith(
                        fontWeight: FontWeight.w400,
                        color: Colors.black,
                      ),
                    )
                  ],
                ),
              ),
            ),
            Visibility(
              visible: hasNavigation ?? false,
              child: const Icon(Icons.arrow_right_alt_outlined),
            )
          ],
        ),
      ),
    );
  }
}
