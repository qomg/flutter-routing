import 'package:flutter_driver/flutter_driver.dart';
import 'package:integration_test/integration_test.dart';
import 'package:test/test.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('app test', () {
    FlutterDriver? driver;

    setUpAll(() async {
      // 连接app
      driver = await FlutterDriver.connect();
    });

    tearDownAll(() async {
      if (driver != null) {
        // 关闭连接
        driver?.close();
      }
    });

    test('measure', () async {
      // 记录闭包中的performance timeline
      Timeline timeline = await driver!.traceAction(() async {
        // Find the scrollable user list
        SerializableFinder userList = find.byValueKey('user-list');
        // TODO
      });

      // The `timeline` object contains all the performance data recorded during
      // the scrolling session. It can be digested into a handful of useful
      // aggregate numbers, such as "average frame build time".
      TimelineSummary summary = TimelineSummary.summarize(timeline);
      summary.writeTimelineToFile('stocks_routing_perf', pretty: true);
    });
  });
}
