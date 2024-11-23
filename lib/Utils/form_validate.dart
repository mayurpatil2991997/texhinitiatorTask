
class FormValidate {
  static Pattern emailPattern =
      r"^((([a-zA-Z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+(\.([a-zA-Z]|\d|[!#\$%&'\*\+\-\/=\?\^_`{\|}~]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])+)*)|((\x22)((((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(([\x01-\x08\x0b\x0c\x0e-\x1f\x7f]|\x21|[\x23-\x5b]|[\x5d-\x7e]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(\\([\x01-\x09\x0b\x0c\x0d-\x7f]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF]))))*(((\x20|\x09)*(\x0d\x0a))?(\x20|\x09)+)?(\x22)))@((([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|\d|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))\.)+(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])|(([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])([a-z]|\d|-|\.|_|~|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])*([a-z]|[\u00A0-\uD7FF\uF900-\uFDCF\uFDF0-\uFFEF])))$";
  static RegExp emailRegEx = RegExp(emailPattern.toString());

  // Validates an email address.
  static bool isEmail(String value) {
    if (emailRegEx.hasMatch(value.trim())) {
      return true;
    }
    return false;
  }

  /*
   * Returns an error message if email does not validate.
   */
  static String? validateEmail(String? value, String? errorMsg) {
    String email = value!.trim();
    if (email.isEmpty) {
      return errorMsg;
    }
    if (!isEmail(email)) {
      return errorMsg;
    }
    return null;
  }

  /*
   * Returns an error message if email does not validate.
   */
  static String? validatePassword(String? value, String? errorMsg) {
    String password = value!;
    if (password.isEmpty) {
      return errorMsg;
    }
    if (password.length < 4) {
      return errorMsg;
    }
    return null;
  }

  /*
   * Returns an error message if confirm pass does not match.
   */
  static String? matchPassword(
      String password,
      String confirmPassword, {
        String? errorMsg,
      }) {
    if (confirmPassword.isEmpty) {
      return 'Confirm password is required.';
    }

    if (password.trim() != confirmPassword.trim()) {
      return errorMsg ?? 'Password not matched.';
    }
    return null;
  }

  /*
   * Returns an error message if required field is empty.
   */
  static String? requiredField(String? value, String message) {
    if (value == null || value.trim().isEmpty) {
      return message;
    }
    return null;
  }

  static String? deleteAccountValidation(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "\"Delete\" keyword is required.";
    } else if (value != "Delete") {
      return "\"Delete\" keyword only allow";
    }
    return null;
  }


  static bool isValidEmail(String email) {
    // Regular expression for basic email validation
    String emailRegex = r'^[\w+.-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';
    RegExp regExp = RegExp(emailRegex);
    return regExp.hasMatch(email);
  }

  /*
   * Returns an error message if required field is empty.
   */
  static String? checkLength(
      String? value,
      int requiredLength,
      String? errorMsg,
      ) {
    if (value?.length == requiredLength) {
      return null;
    } else {
      return errorMsg;
    }
  }


  static String? checkCharacterCount(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "Input cannot be empty.";
    } else if (value.length < 25) {
      return "Input should contain at least 25 characters.";
    } else if (value.length > 200) {
      return "Input should contain less than 200 characters.";
    }
    return null;
  }
}

// comment