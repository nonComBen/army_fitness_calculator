String getAgeGroup(int age) {
  if (age < 22) {
    return '17-21';
  }
  if (age < 27) {
    return '22-26';
  }
  if (age < 32) {
    return '27-31';
  }
  if (age < 37) {
    return '32-36';
  }
  if (age < 42) {
    return '37-41';
  }
  if (age < 47) {
    return '42-46';
  }
  if (age < 52) {
    return '47-51';
  }
  if (age < 57) {
    return '52-56';
  }
  if (age < 62) {
    return '57-61';
  }
  return '62+';
}
