/*
 * Copyright (c) 2021. Jed Brewer
 * Use of this source code is governed by a MIT-style license that can be
 * found in the LICENSE file.
 */

import 'package:flutter/rendering.dart';

class BoxConstraintsPlus extends BoxConstraints {
  const BoxConstraintsPlus.looseFor({
    double? width,
    double? height,
  }) : super(
            minWidth: 0.0,
            maxWidth: width ?? double.infinity,
            minHeight: 0.0,
            maxHeight: height ?? double.infinity);
}
