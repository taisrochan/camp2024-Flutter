import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {}

class LoginError extends LoginState {}

class LoginCubit extends Cubit<LoginState> {
  LoginCubit() : super(LoginInitial());

  Future<void> login(String username, String password) async {
    emit(LoginLoading());
    const shouldFakeLogin = true;
    if (shouldFakeLogin) {
      Future.delayed(const Duration(seconds: 3), () {
        emit(LoginInitial());
        emit(LoginSuccess());
      });
    } else {
      _doTheRealLogin();
    }
  }

  Future<void> _doTheRealLogin() async {
    final url = Uri.parse(
        'https://keyclock.cluster-dev.ioasys.com.br/realms/camp-ioasys-2024/protocol/openid-connect/token');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/x-www-form-urlencoded',
        },
        body: jsonEncode({
          'grant_type': 'password',
          'client_id': 'camp-ioasys-2024',
          'client_secret': 'BiKzHxr9ZoZRDlLjx6qG7QfnDhIoQdIf',
          'username': 'camp@ioasys.com.br',
          'password': 'tph4hyk!BZC2txm*mcb',
        }),
      );

      if (response.statusCode == 200) {
        print('return: ${jsonDecode(response.body)}');
        emit(LoginInitial());
        emit(LoginSuccess());
      } else {
        emit(LoginInitial());
        emit(LoginError());
      }
    } catch (e) {
      print('error: $e');
      emit(LoginInitial());
      emit(LoginError());
    }
  }
}
