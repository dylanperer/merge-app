import 'package:app/components/app_error.dart';
import 'package:app/components/app_interactive_label.dart';
import 'package:app/components/button/button_component.dart';
import 'package:app/components/checkbox/checkbox_component.dart';
import 'package:app/components/text/text_component.dart';
import 'package:app/external/api.dart';
import 'package:app/external/app_api.dart';
import 'package:app/nav/app_router.dart';
import 'package:app/theme/app_spacing.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:go_router/go_router.dart';

import '../../components/app_safe_area.dart';
import '../../components/app_third_part_auth.dart';
import '../../components/input-field/input_field_component.dart';
import '../../icons/app_icons_icons.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  late String? _error;

  @override
  void initState() {
    super.initState();
    _error = null;
  }

  Future<void> _onSignIn() async {
    context.go(AppRouter.route(AppRoute.discover));

    return;
    setState(() {
      _error = null;
    });
    var authenticationApi =
        AuthenticationApi(ApiClient(basePath: 'http://192.168.18.39:6969'));
    var request = SignInRequest(email: 'email', password: 'password');

    await AppApi.mutate(
        () =>
            authenticationApi.authenticationSignInPost(signInRequest: request),
        (result) {
      print(result);
    }, (error) {
      setState(() {
        _error = error;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return AppSafeArea(
      child: Flex(
        direction: Axis.vertical,
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Align(
            child: SvgPicture.asset('assets/svg/logo1.svg'),
          ),
          const Align(
            alignment: Alignment.centerLeft,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextComponent(
                  text: 'Sign in',
                  size: AppSpacing.space_28,
                  fontWeight: FontWeight.w700,
                ),
                TextComponent(
                  text: 'Hello there, lets get back into it.',
                  size: AppSpacing.space_18,
                )
              ],
            ),
          ),
          Column(
            children: [
              const InputFieldComponent(
                hintText: 'email',
                prefixIcon: Icon(Icons.alternate_email),
              ),
              const Gap(AppSpacing.space_16),
              const InputFieldComponent(
                hintText: 'password',
                suffixText: 'Forgot?',
                prefixIcon: Icon(
                  AppIcons.lock,
                  size: 20,
                ),
              ),
              const Gap(AppSpacing.space_16),
              AppError(error: _error)
            ],
          ),
          Align(
              alignment: Alignment.centerLeft,
              child: CheckboxComponent(isDefaultChecked: true, textPostfix: 'Remember me', onChange: (value) => print(''))),
          ButtonComponent(
            text: 'Sign in',
            onTap: () async => {await _onSignIn()},
          ),
          AppThirdPartAuth(
            prefix: const TextComponent(text: 'Or, login with...'),
            postfix: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const TextComponent(text: 'Don\'t have one yet? '),
                AppInteractiveLabel(
                  text: 'Create account',
                  onTap: () {
                    context.go(AppRouter.route(AppRoute.signUp));
                  },
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
