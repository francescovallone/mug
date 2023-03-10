import 'dart:io';

import 'package:mug/mug.dart';

class NotFoundException extends MugException{
  const NotFoundException({String message = "Not Found!", Uri? uri}) : super(
    message: message, 
    uri: uri, 
    statusCode: HttpStatus.notFound
  );
}