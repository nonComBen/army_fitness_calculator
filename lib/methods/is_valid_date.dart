bool isValidDate(String date) {
  RegExp regExp = RegExp(r'^\d{4}(0[1-9]|1[012])(0[1-9]|[12][0-9]|3[01])$');
  return regExp.hasMatch(date);
}
