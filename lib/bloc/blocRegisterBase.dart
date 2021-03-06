import 'dart:async';
import 'package:bloc_pattern/bloc_pattern.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import '../classes/defaultResponse.dart';

class BlocRegisterBase extends BlocBase {
  String url;
  final dataObject=null;
  TabController tabController;
  DefaultResponse registerState = DefaultResponse(code: "ERROR", value: "Inserido com sucesso!");

  BlocRegisterBase(){
    _tabControllIndex.stream.listen((data){
      if (data!=null)
        tabController.animateTo(data);
    });
  }

  @override
  void dispose() {
    _tabControllIndex.close();
    _nextButtonVisibility.close();
    _error.close();
    super.dispose();
  }  

  void moveToStep(int tabIndex) => inTabControllIndex.add(tabIndex);

  final BehaviorSubject<int> _tabControllIndex= BehaviorSubject<int>();
  Stream<int> get outTabControllIndex => _tabControllIndex.stream;
  Sink<int> get inTabControllIndex => _tabControllIndex.sink;
 
  final BehaviorSubject<bool> _nextButtonVisibility= BehaviorSubject<bool>.seeded(true);
  Stream<bool> get outNextButtonVisibility => _nextButtonVisibility.stream;
  Sink<bool> get inNextButtonVisibility => _nextButtonVisibility.sink;
  bool nextButtonVisibilityValue() => _nextButtonVisibility.value;

  final BehaviorSubject<DefaultResponse> _error = BehaviorSubject<DefaultResponse>();
  Stream<DefaultResponse> get outError => _error.stream;
  Sink<DefaultResponse> get inError => _error.sink;

  Future<DefaultResponse> save() async {
    if (registerState.code=="ERROR")
      inError.add(registerState);

    return registerState;
  }
}