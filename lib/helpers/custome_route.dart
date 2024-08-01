import 'package:flutter/material.dart';

class CustomeRoute<T> extends MaterialPageRoute<T> {
  CustomeRoute({required super.builder, super.settings});

  @override
  Widget buildTransitions(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    if(isFirst){
      return child;
    }
    return FadeTransition(opacity: animation, child: child,);
  }
}

class CustomPageTransitionBuilder extends PageTransitionsBuilder {
  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context, 
    Animation<double> animation, 
    Animation<double> secondaryAnimation, 
    Widget child) {
    if(route.isFirst){
      return child;
    }
    return FadeTransition(opacity: animation, child: child,);
  }
}