import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

enum AuthStatus { authenticated, unauthenticated, authenticating }

class AuthCubit extends Cubit<AuthStatus> {
  AuthCubit() : super(AuthStatus.unauthenticated);

  final FirebaseAuth _auth = FirebaseAuth.instance;

  void signUp(String email, String password) async {
    emit(AuthStatus.authenticating);
    try {
      await _auth.createUserWithEmailAndPassword(email: email, password: password);
      emit(AuthStatus.authenticated);
    } catch (_) {
      emit(AuthStatus.unauthenticated);
    }
  }

  void signIn(String email, String password) async {
    emit(AuthStatus.authenticating);
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
      emit(AuthStatus.authenticated);
    } catch (_) {
      emit(AuthStatus.unauthenticated);
    }
  }

  void signOut() async {
    await _auth.signOut();
    emit(AuthStatus.unauthenticated);
  }
}
