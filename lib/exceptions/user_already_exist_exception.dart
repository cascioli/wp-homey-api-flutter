// Copyright (c) 2024, WooSignal Ltd.
// All rights reserved.
//
// Redistribution and use in source and binary forms are permitted
// provided that the above copyright notice and this paragraph are
// duplicated in all such forms and that any documentation,
// advertising materials, and other materials related to such
// distribution and use acknowledge that the software was developed
// by the WooSignal. The name of the
// WooSignal may not be used to endorse or promote products derived
// from this software without specific prior written permission.
// THIS SOFTWARE IS PROVIDED ``AS IS'' AND WITHOUT ANY EXPRESS OR
// IMPLIED WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED
// WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE.

import 'package:wp_homey_api/l10n/wp_homey_strings.dart';
import 'package:wp_homey_api/wp_homey_api.dart';

class UserAlreadyExistException implements Exception {
  String message;
  UserAlreadyExistException([String? customMessage])
      : message = customMessage ??
            WPHomeyStrings.get(
              'user_exists',
              locale: WPHomeyAPI.currentLocale,
            );
}
