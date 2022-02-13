/*
 * Copyright (c) 2021. Jed Brewer
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

// ignore: must_be_immutable
class RemoteBoxConstraints extends BoxConstraints {
  BoxConstraints get _constraints {
    if (__constraints == null)
      throw StateError('remote constraints not hydrated');
    return __constraints!;
  }

  BoxConstraints? __constraints;

  @override
  bool debugAssertIsValid(
      {bool isAppliedConstraint = false,
      InformationCollector? informationCollector}) {
    if (__constraints == null) return true;
    return super.debugAssertIsValid(
        isAppliedConstraint: isAppliedConstraint,
        informationCollector: informationCollector);
  }

  @override
  double get minWidth => _constraints.minWidth;

  @override
  double get maxWidth => _constraints.maxWidth;

  @override
  double get minHeight => _constraints.minHeight;

  @override
  double get maxHeight => _constraints.maxHeight;
}

class RemoteLayoutController {
  RemoteLayoutController({required this.destination, required this.adaptor});

  final RemoteBoxConstraints destination;
  final BoxConstraints Function(BoxConstraints constraints, Size size) adaptor;

  _update(BoxConstraints constraints, Size size) =>
      destination.__constraints = adaptor(constraints, size);
}

class RemoteLayoutTransmitter extends SingleChildRenderObjectWidget {
  RemoteLayoutTransmitter({required this.controller, required Widget child})
      : super(child: child);

  final RemoteLayoutController controller;

  @override
  RenderRemoteLayoutTransmitter createRenderObject(BuildContext context) =>
      RenderRemoteLayoutTransmitter(controller);
}

class RenderRemoteLayoutTransmitter extends RenderProxyBox {
  RenderRemoteLayoutTransmitter(this.controller, [RenderBox? child])
      : super(child);

  final RemoteLayoutController controller;

  @override
  bool get sizedByParent => child!.sizedByParent;

  @override
  void setupParentData(covariant RenderObject child) {
    // If the child of the associated widget is a ParentDataWidget, this allows the parent to interact correctly with it.
    // eg, Expanded ← RemoteLayoutTransmitter ← Row
    child.parentData = parentData;
  }

  @override
  void performResize() {
    super.performResize();
    controller._update(constraints, size);
  }

  @override
  void performLayout() {
    super.performLayout();
    controller._update(constraints, size);
  }
}
