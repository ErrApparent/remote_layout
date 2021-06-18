/*
 * Copyright (c) 2021. Jed Brewer
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:remote_layout/layout_helpers.dart';

import 'package:remote_layout/remote_layout.dart';

const _refSize = Size(150, 200);
const _screenSize = Size(600, 800);

void setScreenSize(WidgetTester tester) =>
    tester.binding.window.physicalSizeTestValue =
        _screenSize * tester.binding.window.devicePixelRatio;

void main() {
  testWidgets('Size match for size => BoxConstraints.loose(size)',
      (WidgetTester tester) async {
    setScreenSize(tester);
    await tester.pumpWidget(
        RemoteLayoutTester((constraints, size) => BoxConstraints.loose(size)));
    expect(find.byType(TesterReference).first.evaluate().first.size, _refSize);
    expect(find.byType(TesterDependant).first.evaluate().first.size, _refSize);
  });

  testWidgets(
      'Size match for size => BoxConstraintsPlus.looseFor(height: size.height)',
      (WidgetTester tester) async {
    setScreenSize(tester);
    await tester.pumpWidget(RemoteLayoutTester((constraints, size) =>
        BoxConstraintsPlus.looseFor(height: size.height)));
    expect(find.byType(TesterReference).first.evaluate().first.size, _refSize);
    expect(find.byType(TesterDependant).first.evaluate().first.size,
        Size(_screenSize.width, _refSize.height));
  });

  testWidgets(
      'Size match for size => BoxConstraintsPlus.looseFor(width: size.width)',
      (WidgetTester tester) async {
    setScreenSize(tester);
    await tester.pumpWidget(RemoteLayoutTester(
        (constraints, size) => BoxConstraintsPlus.looseFor(width: size.width)));
    expect(find.byType(TesterReference).first.evaluate().first.size, _refSize);
    expect(find.byType(TesterDependant).first.evaluate().first.size,
        Size(_refSize.width, _screenSize.height));
  });

  testWidgets('Size match for size => BoxConstraints()',
      (WidgetTester tester) async {
    setScreenSize(tester);
    await tester.pumpWidget(
        RemoteLayoutTester((constraints, size) => BoxConstraints()));
    expect(find.byType(TesterReference).first.evaluate().first.size, _refSize);
    expect(
        find.byType(TesterDependant).first.evaluate().first.size, _screenSize);
  });
}

class RemoteLayoutTester extends StatelessWidget {
  RemoteLayoutTester(this.adaptor) {
    controller =
        RemoteLayoutController(destination: constraints, adaptor: adaptor);
  }

  final BoxConstraints Function(BoxConstraints constraints, Size size) adaptor;
  final RemoteBoxConstraints constraints = RemoteBoxConstraints();
  late final RemoteLayoutController controller;

  @override
  Widget build(BuildContext context) {
    final referenceBox = TesterReference(RemoteLayoutTransmitter(
      controller: controller,
      child: SizedBox(width: _refSize.width, height: _refSize.height),
    ));

    final dependantBox = TesterDependant(
        ConstrainedBox(constraints: constraints, child: Container()));

    return MaterialApp(
      home: Scaffold(
          body: Container(
              // width: _stackSize.width,
              // height: _stackSize.height,
              child: Stack(children: [referenceBox, dependantBox]))),
    );
  }
}

class TesterReference extends StatelessWidget {
  TesterReference(this.child);
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}

class TesterDependant extends StatelessWidget {
  TesterDependant(this.child);
  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
