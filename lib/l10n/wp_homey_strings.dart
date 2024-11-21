class WPHomeyStrings {
  static final Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'invalid_login': 'Invalid login details',
      'something_wrong': 'Something went wrong',
      'invalid_username': 'Invalid username',
      'username_taken': 'Username already taken, try another.',
      'invalid_password': 'Invalid password',
      'invalid_email': 'Invalid email',
      'invalid_token': 'Invalid token',
      'invalid_params': 'Invalid parameters',
      'user_exists': 'User already exists',
      'empty_username': 'Username cannot be empty',
      'login_successful': 'Login successful',
      'registration_successful': 'Registration successful',
    },
    'it': {
      'invalid_login': 'Credenziali non valide',
      'something_wrong': 'Qualcosa è andato storto',
      'invalid_username': 'Username non valido',
      'username_taken': 'Username già utilizzato, prova un altro.',
      'invalid_password': 'Password non valida',
      'invalid_email': 'Email non valida',
      'invalid_token': 'Token non valido',
      'invalid_params': 'Parametri non validi',
      'user_exists': 'Utente già esistente',
      'empty_username': 'Username non può essere vuoto',
      'login_successful': 'Login effettuato con successo',
      'registration_successful': 'Registrazione completata con successo',
    },
  };

  static String get(String key, {String locale = 'it'}) {
    if (!_localizedValues.containsKey(locale)) {
      locale = 'it';
    }
    return _localizedValues[locale]?[key] ?? key;
  }
}
