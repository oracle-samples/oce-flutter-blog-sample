/*
 * Copyright (c) 2022, Oracle and/or its affiliates.
 * Licensed under the Universal Permissive License v 1.0 as shown at https://oss.oracle.com/licenses/upl/
 */
import 'package:flutter/material.dart';

//The generic component is used to encapsulate the body to make it scrollable.
class ScreenLayout extends StatelessWidget {
  const ScreenLayout({required this.body});

  final Widget body;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints viewportConstraints) {
          return SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: viewportConstraints.maxHeight,
              ),
              child: body,
            ),
          );
        },
      ),
    );
  }
}
