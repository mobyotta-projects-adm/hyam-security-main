import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/sign_in_cubit/signin_cubit.dart';
import '../widgets/primary_button.dart';
import '../widgets/custom_form_text_field.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({Key? key}) : super(key: key);

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _signFormKey = GlobalKey<FormState>();
  late final SignInCubit signInCubit;

  @override
  void initState() {
    signInCubit = context.read<SignInCubit>();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<SignInCubit, SignInState>(
      builder: (context, state) {
        return
        Scaffold(
          body:   Center(
            child: Form(
              key: _signFormKey,
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      height: 250,
                      width: MediaQuery.of(context).size.width * 0.8,
                      margin: EdgeInsets.only(
                          left: MediaQuery.of(context).size.width * 0.09),
                      child: Image.asset("assets/images/logo.png"),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: CustomTextFormField(
                        validationCallback: (value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          }
                          return 'Email is required!';
                        },
                        onChangedCallback: signInCubit.onEmailInputChanged,
                        onSavedCallback: (value) {},
                        hintText: tr('email'),
                        isLast: false,
                        onSubmitCallback: (String? value) {},
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      margin: const EdgeInsets.only(left: 20, right: 20),
                      child: CustomTextFormField(
                        validationCallback: (value) {
                          if (value != null && value.isNotEmpty) {
                            return null;
                          }
                          return 'Password is required!';
                        },
                        obSecurePassword: true,
                        onChangedCallback:
                        signInCubit.onPasswordInputChanged,
                        onSavedCallback: (value) {},
                        hintText: tr('password'),
                        isLast: true,
                        onSubmitCallback: (String? value) {},
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20,right: 20),
                      child: PrimaryButton(
                        onTap: () {
                          signInCubit.loginFunc();
                        },
                        title: state.isProcessing
                            ? tr('processing_message')
                            : tr('sign_in'),
                        disable: isDisable(),
                      ),
                    ),

                    const SizedBox(
                      height: 40,
                    ),
                  ],
                ),
              ),),
          )
        );
      },
    );
  }

  isDisable() {
    if (_signFormKey.currentState?.validate() ?? false) {
      return false;
    }
    return true;
  }
}

