import 'package:flutter_test/flutter_test.dart';
import 'package:studyplanner/main.dart';

void main() {
  testWidgets('Splash page renders correctly', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StudyPlannerApp());

    // Verify that splash branding is present.
    expect(find.textContaining('Study'), findsWidgets);
    expect(find.textContaining('PLAN  •  STUDY  •  ACHIEVE'), findsOneWidget);
  });
}
