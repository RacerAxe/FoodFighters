import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_util.dart';
import 'home_page_widget.dart' show HomePageWidget;
import 'package:flutter/material.dart';

/// Model class for the HomePage, extending FlutterFlowModel.
class HomePageModel extends FlutterFlowModel<HomePageWidget> {
  /// Local state fields for this page.

  // Nutritional data fields
  String? proteinData = '0';
  String? carbsData = '0';
  String? fatData = '0';
  String? caloriesData = '0';

  // Calorie goal and remaining calories
  String calorieGoal = '0';
  String? remaining;

  // Weekly calorie tracking
  List<double> weeklyCalories = [0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0];

  // Helper methods for weeklyCalories list
  void addToWeeklyCalories(double item) => weeklyCalories.add(item);
  void removeFromWeeklyCalories(double item) => weeklyCalories.remove(item);
  void removeAtIndexFromWeeklyCalories(int index) => weeklyCalories.removeAt(index);
  void insertAtIndexInWeeklyCalories(int index, double item) => weeklyCalories.insert(index, item);
  void updateWeeklyCaloriesAtIndex(int index, Function(double) updateFn) =>
      weeklyCalories[index] = updateFn(weeklyCalories[index]);

  // Week number list
  List<String> week = ['1', '2', '3', '4', '5', '6', '7'];

  // Helper methods for week list
  void addToWeek(String item) => week.add(item);
  void removeFromWeek(String item) => week.remove(item);
  void removeAtIndexFromWeek(int index) => week.removeAt(index);
  void insertAtIndexInWeek(int index, String item) => week.insert(index, item);
  void updateWeekAtIndex(int index, Function(String) updateFn) =>
      week[index] = updateFn(week[index]);

  // Week day abbreviations
  List<String> weekLetter = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];

  // Helper methods for weekLetter list
  void addToWeekLetter(String item) => weekLetter.add(item);
  void removeFromWeekLetter(String item) => weekLetter.remove(item);
  void removeAtIndexFromWeekLetter(int index) => weekLetter.removeAt(index);
  void insertAtIndexInWeekLetter(int index, String item) =>
      weekLetter.insert(index, item);
  void updateWeekLetterAtIndex(int index, Function(String) updateFn) =>
      weekLetter[index] = updateFn(weekLetter[index]);

  /// State fields for stateful widgets in this page.

  // Stores user preference data from Firestore
  UserPrefRecord? userPrefData;

  // Stores today's meals from Firestore
  List<MealTrackingRecord>? todayMeals;

  // Stores current week's meals from Firestore
  List<MealTrackingRecord>? currWeekMeals;

  @override
  void initState(BuildContext context) {
    // Initialize any necessary state here
  }

  @override
  void dispose() {
    // Clean up any resources or subscriptions here
  }
}
