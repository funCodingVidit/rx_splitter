import 'package:jwt_decoder/jwt_decoder.dart';

class TokenDecoder {
  Map<String, dynamic> decoder(String token) {
    return JwtDecoder.decode(token);
  }
}