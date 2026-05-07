import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
// import 'package:material_dialogs/shared/types.dart';

/// Displays Material dialog above the current contents of the app

class DialogWidget extends StatelessWidget {
  const DialogWidget({
    super.key,
    this.title,
    this.msg,
    this.actions,
    this.animationBuilder,
    this.customView = const SizedBox(),
    this.customViewPosition = CustomViewPosition.BEFORE_TITLE,
    this.titleStyle,
    this.msgStyle,
    this.titleAlign,
    this.msgAlign,
    this.dialogWidth,
    this.color,
  });

  /// [actions]Widgets to display a row of buttons after the [msg] widget.
  final List<Widget>? actions;

  /// [customView] a widget to display a custom widget instead of the animation view.
  final Widget customView;

  final CustomViewPosition customViewPosition;

  /// [title] your dialog title
  final String? title;

  /// [msg] your dialog description message
  final String? msg;

  /// [animationBuilder] lottie animations builder
  final LottieBuilder? animationBuilder;

  /// [titleStyle] dialog title text style
  final TextStyle? titleStyle;

  /// [animation] lottie animations path
  final TextStyle? msgStyle;

  /// [titleAlign] dialog title text alignment
  final TextAlign? titleAlign;

  /// [textAlign] dialog description text alignment
  final TextAlign? msgAlign;

  /// [color] dialog's backgorund color
  final Color? color;

  /// [dialogWidth] dialog's width compared to the screen width
  final double? dialogWidth;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: dialogWidth == null
          ? null
          : 1.sw * dialogWidth!,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          customViewPosition == CustomViewPosition.BEFORE_ANIMATION
              ? customView
              : const SizedBox(),
          if (animationBuilder != null)
            Container(
              padding: EdgeInsets.only(top: 20.h),
              height: 200.h,
              width: double.infinity,
              child: animationBuilder,
            ),
          customViewPosition == CustomViewPosition.BEFORE_TITLE
              ? customView
              : const SizedBox(),
          title != null
              ? Padding(
                  padding:
                      EdgeInsets.only(right: 20.w, left: 20.w, top: 24.0.h),
                  child: Text(
                    title!,
                    style: titleStyle,
                    textAlign: titleAlign,
                  ),
                )
              : SizedBox(
                  height: 4.h,
                ),
          customViewPosition == CustomViewPosition.BEFORE_MESSAGE
              ? customView
              : const SizedBox(),
          msg != null
              ? Padding(
                  padding:
                      EdgeInsets.only(right: 20.w, left: 20.w, top: 16.0.h),
                  child: Text(
                    msg!,
                    style: msgStyle,
                    textAlign: msgAlign,
                  ),
                )
              : SizedBox(
                  height: 20.h,
                ),
          customViewPosition == CustomViewPosition.BEFORE_ACTION
              ? customView
              : const SizedBox(),
          actions?.isNotEmpty == true
              ? buttons(context)
              : SizedBox(
                  height: 20.h,
                ),
          customViewPosition == CustomViewPosition.AFTER_ACTION
              ? customView
              : const SizedBox(),
        ],
      ),
    );
  }

  Widget buttons(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(right: 20.w, left: 20.w, top: 16.0.h, bottom: 20.0.h),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(actions!.length, (index) {
          final TextDirection direction = Directionality.of(context);
          double padding = index != 0 ? 8 : 0;
          double rightPadding = 0;
          double leftPadding = 0;
          direction == TextDirection.rtl
              ? rightPadding = padding
              : leftPadding = padding;
          return Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: leftPadding, right: rightPadding),
              child: actions![index],
            ),
          );
        }),
      ),
    );
  }
}
// import 'package:flutter/material.dart';

///[btnShape] buttons shape
RoundedRectangleBorder btnShape =
    RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.r)));

class IconsButton extends StatelessWidget {
  IconsButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.shape,
    this.padding,
    this.color,
    this.iconData,
    this.iconColor,
    this.textStyle,
  });

  /// [onPressed] Defines the button's click callback
  final Function onPressed;

  /// [shape] Defines the button's shape
  final ShapeBorder? shape;

  /// [color] Defines the button's background color
  final Color? color;

  /// [iconData] Defines the button's icon
  final IconData? iconData;

  /// [iconColor] Defines the button's icon color
  final Color? iconColor;

  /// [text] Defines the button's text
  final String text;

  /// [textStyle] Defines the button's base text style
  final TextStyle? textStyle;

  /// [padding] Defines the button's padding
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return MaterialButton(
      onPressed: onPressed as void Function()?,
      shape: shape ?? btnShape,
      color: color,
      padding: padding ?? EdgeInsets.all(4.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: iconData != null,
            child: Icon(
              iconData,
              color: iconColor,
              size: 18.sp,
            ),
          ),
          Visibility(
            visible: iconData != null,
            child: SizedBox(
              width: 4.w,
            ),
          ),
          Text(
            text,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}
// import 'package:flutter/material.dart';

class IconsOutlineButton extends StatelessWidget {
  IconsOutlineButton({
    super.key,
    required this.onPressed,
    required this.text,
    this.shape,
    this.color,
    this.iconData,
    this.padding,
    this.iconColor,
    this.textStyle,
  });

  /// [onPressed] Defines the button's click callback
  final Function onPressed;

  /// [shape] Defines the button's shape
  final OutlinedBorder? shape;

  /// [color] Defines the button's background color
  final Color? color;

  /// [iconData] Defines the button's icon
  final IconData? iconData;

  /// [iconColor] Defines the button's icon color
  final Color? iconColor;

  /// [text] Defines the button's text
  final String text;

  /// [textStyle] Defines the button's base text style
  final TextStyle? textStyle;

  /// [padding] Defines the button's padding
  final EdgeInsets? padding;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed as void Function()?,
      style: OutlinedButton.styleFrom(
          shape: shape, padding: padding ?? EdgeInsets.all(4.w), backgroundColor: color),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Visibility(
            visible: iconData != null,
            child: Icon(
              iconData,
              color: iconColor,
              size: 18.sp,
            ),
          ),
          Visibility(
            visible: iconData != null,
            child: SizedBox(
              width: 4.w,
            ),
          ),
          Text(
            text,
            style: textStyle,
          ),
        ],
      ),
    );
  }
}

enum CustomViewPosition {
  BEFORE_ANIMATION,
  BEFORE_TITLE,
  BEFORE_MESSAGE,
  BEFORE_ACTION,
  AFTER_ACTION,
}
