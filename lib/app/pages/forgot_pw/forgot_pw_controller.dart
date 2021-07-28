import 'package:flutter/material.dart';
import 'package:flutter_clean_architecture/flutter_clean_architecture.dart';
import 'package:hnh/app/pages/forgot_pw/forgot_pw_presenter.dart';
import 'package:hnh/app/utils/constants.dart';

class ForgotPwController extends Controller {
  late TextEditingController email;
  ForgotPwPresenter _forgotPwPresenter;
  bool isLoading = false;

  ForgotPwController(authRepo)
      : _forgotPwPresenter = ForgotPwPresenter(authRepo) {
    email = TextEditingController();
  }

  @override
  void initListeners() {
    _forgotPwPresenter.forgotOnComplete = () {
      dismissLoading();
      showGenericSnackbar(getStateKey(), 'Email has been send!');
      Navigator.of(getContext()).pop();
    };

    _forgotPwPresenter.forgotOnError = (e) {
      dismissLoading();
      showGenericSnackbar(getStateKey(), e.message, isError: true);
    };
  }

  void checkForm(Map<String, dynamic> params) {
    dynamic formKey = params['formKey'];

    // Validate params
    assert(formKey is GlobalKey<FormState>);

    if (formKey.currentState.validate()) {
      isLoading = true;
      refreshUI();
      _forgotPwPresenter.forgotPassword(email: email.text);
    } else {
      showGenericSnackbar(getStateKey(), Strings.registrationFormIncomplete,
          isError: true);
    }
  }

  void dismissLoading() {
    isLoading = false;
    refreshUI();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
