import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:rxdart/rxdart.dart';
import '../api/firebaseConnection.dart';
import '../classes/user.dart';

enum AuthStatus {
  notDetermined,
  notSignedIn,
  signedIn,
}

class BlocAuth extends BlocBase {
  final FirebaseConnection firebase = FirebaseConnection();
  User currentUser = User();

  BlocAuth(){
    firebase.currentUserUID().then((userId) async {
      currentUser = await firebase.getCurrentUserObject();
      inAuthStatus.add((userId == null) ? AuthStatus.notSignedIn : AuthStatus.signedIn);
    });
  }

  @override
  void dispose() {
    _authStatusController.close();
    super.dispose();
  }

  final BehaviorSubject<AuthStatus> _authStatusController = BehaviorSubject<AuthStatus>.seeded(AuthStatus.notDetermined);
  Stream<AuthStatus> get outAuthStatus => _authStatusController.stream;
  Sink<AuthStatus> get inAuthStatus => _authStatusController.sink;

  void signedIn() => inAuthStatus.add(AuthStatus.signedIn);
  void signedOut() {
    firebase.signOut(); 
    inAuthStatus.add(AuthStatus.notSignedIn);
  }
}