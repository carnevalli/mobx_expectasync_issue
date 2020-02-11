import 'package:flutter_modular/flutter_modular_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mobx/mobx.dart';

import 'package:mobx_autorun_test/app/app_controller.dart';
import 'package:mobx_autorun_test/app/app_module.dart';

void main() {
  initModule(AppModule());
  AppController app;

  setUp(() {
    app = AppModule.to.get<AppController>();
    app.value = 0;
  });

  group('AppController Test', () {
    test("First Test", () {
      expect(app, isInstanceOf<AppController>());
    });

    test("Set Value", () {
      expect(app.value, equals(0));
      app.increment();
      expect(app.value, equals(1));
    });

    // The problem occurs here
    test("Mobx Reaction", () {
      ReactionDisposer disposer = reaction((_) => app.value, expectAsync1((_){
        // prints value ok
        print('Value: ${app.value}');
        // should throw an error, but passes
        expect(true, isFalse);
        // should throw an error, but passes
        expect(app.value, equals(10));
      }, count: 1));

      app.increment();
      disposer();
    });
  });
}
