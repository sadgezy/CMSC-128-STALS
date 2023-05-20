import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:stals_frontend/utils/export_utils.dart';
import 'dart:convert';

class SignUpForm extends StatelessWidget {
  TextEditingController rectangleeightController = TextEditingController();

  TextEditingController rectangletwelveController = TextEditingController();

  TextEditingController rectanglethirteController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        extendBody: true,
        extendBodyBehindAppBar: true,
        resizeToAvoidBottomInset: false,
        body: Container(
          width: size.width,
          height: size.height,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment(
                0.5,
                0,
              ),
              end: Alignment(
                0.5,
                1,
              ),
              colors: [
                ColorConstant.gray100,
                ColorConstant.cyan900,
              ],
            ),
          ),
          child: Container(
            width: double.maxFinite,
            padding: getPadding(
              left: 79,
              top: 121,
              right: 79,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "Welcome",
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.left,
                  style: AppStyle.txtActorRegular45,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Padding(
                    padding: getPadding(
                      left: 18,
                      top: 31,
                    ),
                    child: Text(
                      "Name",
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.left,
                      style: AppStyle.txtInterRegular12,
                    ),
                  ),
                ),
                Padding(
                  padding: getPadding(
                    left: 19,
                    right: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        height: getVerticalSize(
                          23,
                        ),
                        width: getHorizontalSize(
                          57,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Surname",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInterRegular7,
                              ),
                            ),
                            CustomTextFormField(
                              width: getHorizontalSize(
                                57,
                              ),
                              focusNode: FocusNode(),
                              controller: rectangleeightController,
                              alignment: Alignment.center,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: getVerticalSize(
                          23,
                        ),
                        width: getHorizontalSize(
                          56,
                        ),
                        margin: getMargin(
                          left: 6,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "First Name",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInterRegular7,
                              ),
                            ),
                            CustomTextFormField(
                              width: getHorizontalSize(
                                56,
                              ),
                              focusNode: FocusNode(),
                              controller: rectangletwelveController,
                              alignment: Alignment.center,
                            ),
                          ],
                        ),
                      ),
                      Container(
                        height: getVerticalSize(
                          23,
                        ),
                        width: getHorizontalSize(
                          56,
                        ),
                        margin: getMargin(
                          left: 6,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.center,
                              child: Text(
                                "Middle Name",
                                overflow: TextOverflow.ellipsis,
                                textAlign: TextAlign.left,
                                style: AppStyle.txtInterRegular7,
                              ),
                            ),
                            CustomTextFormField(
                              width: getHorizontalSize(
                                56,
                              ),
                              focusNode: FocusNode(),
                              controller: rectanglethirteController,
                              textInputAction: TextInputAction.done,
                              alignment: Alignment.center,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  height: getVerticalSize(
                    26,
                  ),
                  width: getHorizontalSize(
                    181,
                  ),
                  margin: getMargin(
                    top: 23,
                    right: 3,
                  ),
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Align(
                        alignment: Alignment.center,
                        child: Text(
                          "E-mail",
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.left,
                          style: AppStyle.txtInterRegular12Black9007f,
                        ),
                      ),
                      Align(
                        alignment: Alignment.center,
                        child: Container(
                          height: getVerticalSize(
                            26,
                          ),
                          width: getHorizontalSize(
                            181,
                          ),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                              getHorizontalSize(
                                5,
                              ),
                            ),
                            border: Border.all(
                              color: ColorConstant.black900,
                              width: getHorizontalSize(
                                1,
                              ),
                            ),
                          ),
                        ),
                      ),
                      CustomTextFormField(
                        width: getHorizontalSize(
                          181,
                        ),
                        focusNode: FocusNode(),
                        controller: rectanglethirteController,
                        textInputAction: TextInputAction.done,
                        alignment: Alignment.center,
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: getPadding(
                    left: 18,
                    top: 23,
                    right: 3,
                    bottom: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      CustomButton(
                        height: getVerticalSize(
                          26,
                        ),
                        width: getHorizontalSize(
                          72,
                        ),
                        text: "Username",
                        variant: ButtonVariant.OutlineBlack900,
                        shape: ButtonShape.RoundedBorder5,
                        padding: ButtonPadding.PaddingAll5,
                        fontStyle: ButtonFontStyle.InterRegular9,
                      ),
                      Container(
                        height: getVerticalSize(
                          26,
                        ),
                        width: getHorizontalSize(
                          90,
                        ),
                        child: Stack(
                          alignment: Alignment.center,
                          children: [
                            Align(
                              alignment: Alignment.centerLeft,
                              child: Padding(
                                padding: getPadding(
                                  left: 5,
                                ),
                                child: Text(
                                  "Customer Type",
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.left,
                                  style: AppStyle.txtInterRegular9,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.center,
                              child: Card(
                                clipBehavior: Clip.antiAlias,
                                elevation: 0,
                                margin: EdgeInsets.all(0),
                                shape: RoundedRectangleBorder(
                                  side: BorderSide(
                                    color: ColorConstant.black900,
                                    width: getHorizontalSize(
                                      1,
                                    ),
                                  ),
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder5,
                                ),
                                child: Container(
                                  height: getVerticalSize(
                                    26,
                                  ),
                                  width: getHorizontalSize(
                                    90,
                                  ),
                                  padding: getPadding(
                                    left: 6,
                                    top: 9,
                                    right: 6,
                                    bottom: 9,
                                  ),
                                  decoration:
                                      AppDecoration.outlineBlack900.copyWith(
                                    borderRadius:
                                        BorderRadiusStyle.roundedBorder5,
                                  ),
                                  child: Stack(
                                    children: [
                                      CustomImageView(
                                        svgPath: ImageConstant.imgArrowdown,
                                        height: getSize(
                                          6,
                                        ),
                                        width: getSize(
                                          6,
                                        ),
                                        alignment: Alignment.centerRight,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
