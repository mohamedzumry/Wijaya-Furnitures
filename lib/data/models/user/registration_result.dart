enum RegistrationStatus {
  success,
  emailAlreadyInUse,
  invalidEmail,
  weakPassword,
  error
}

class RegistrationResult {
  final RegistrationStatus status;
  final String? errorMessage;

  const RegistrationResult({required this.status, this.errorMessage});
}
