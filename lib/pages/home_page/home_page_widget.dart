// Import necessary packages and files
import '/auth/firebase_auth/auth_util.dart';
import '/backend/backend.dart';
import '/flutter_flow/flutter_flow_charts.dart';
import '/flutter_flow/flutter_flow_icon_button.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/flutter_flow/custom_functions.dart' as functions;
import 'dart:math' as math;
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'home_page_model.dart';
export 'home_page_model.dart';

// Define the HomePageWidget as a StatefulWidget
class HomePageWidget extends StatefulWidget {
  const HomePageWidget({super.key});

  @override
  State<HomePageWidget> createState() => _HomePageWidgetState();
}

class _HomePageWidgetState extends State<HomePageWidget> {
  late HomePageModel _model;
  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => HomePageModel());

    // Execute actions after the widget is fully rendered
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      // Fetch user preferences
      _model.userPrefData = await queryUserPrefRecordOnce(
        queryBuilder: (userPrefRecord) => userPrefRecord.where(
          'uid',
          isEqualTo: currentUserReference,
        ),
        singleRecord: true,
      ).then((s) => s.firstOrNull);

      if (_model.userPrefData != null) {
        await Future.wait([
          // Fetch and process today's meal data
          Future(() async {
            // Retrieve today's meals
            _model.todayMeals = await queryMealTrackingRecordOnce(
              queryBuilder: (mealTrackingRecord) => mealTrackingRecord
                  .where('uid', isEqualTo: currentUserReference)
                  .where('date', isGreaterThanOrEqualTo: functions.getTodayMidnightTime()),
            );

            // Calculate and update nutritional data
            _model.proteinData = _calculateNutrientTotal(_model.todayMeals!, (e) => e.protein);
            _model.carbsData = _calculateNutrientTotal(_model.todayMeals!, (e) => e.carbs);
            _model.fatData = _calculateNutrientTotal(_model.todayMeals!, (e) => e.fat);
            _model.caloriesData = _calculateNutrientTotal(_model.todayMeals!, (e) => e.calories);

            // Set calorie goal and calculate remaining calories
            _model.calorieGoal = functions.getCalorieGoal(_model.userPrefData!);
            _model.remaining = functions.calculateRemaining(_model.calorieGoal, _model.caloriesData!);
          }),

          // Fetch and process current week's meal data
          Future(() async {
            // Retrieve current week's meals
            _model.currWeekMeals = await queryMealTrackingRecordOnce(
              queryBuilder: (mealTrackingRecord) => mealTrackingRecord
                  .where('uid', isEqualTo: currentUserReference)
                  .where('date', isGreaterThanOrEqualTo: functions.getMonday()),
            );

            // Update weekly calorie data for bar chart
            _model.weeklyCalories = functions.getWeeklyCalories(_model.currWeekMeals?.toList())
                .toList()
                .cast<double>();
          }),
        ]);
      } else {
        // Redirect to User Form if user preferences are not set
        context.goNamed('User_Form');
      }
    });
  }

  // Helper method to calculate nutrient totals
  String _calculateNutrientTotal(List<MealTrackingRecord> meals, double? Function(MealTrackingRecord) getValue) {
    return (meals.map(getValue).whereType<double>().reduce((a, b) => a + b).toStringAsFixed(1));
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        key: scaffoldKey,
        backgroundColor: FlutterFlowTheme.of(context).primaryBackground,
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () async {
            context.pushNamed('Enter_Ingredients');
          },
          backgroundColor: FlutterFlowTheme.of(context).primary,
          elevation: 8.0,
          label: Row(
            mainAxisSize: MainAxisSize.max,
            children: [
              Icon(
                Icons.lightbulb_rounded,
                color: FlutterFlowTheme.of(context).info,
                size: 20.0,
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(5.0, 0.0, 0.0, 0.0),
                child: Text(
                  'Recipe Idea',
                  style: FlutterFlowTheme.of(context).titleSmall.override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ],
          ),
        ),
        appBar: AppBar(
          backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
          automaticallyImplyLeading: false,
          title: Text(
            'Dashboard',
            style: FlutterFlowTheme.of(context).headlineMedium.override(
                  fontFamily: 'Outfit',
                  letterSpacing: 0.0,
                ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 12.0, 0.0),
              child: FlutterFlowIconButton(
                borderColor: Colors.transparent,
                borderRadius: 30.0,
                borderWidth: 1.0,
                buttonSize: 60.0,
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: FlutterFlowTheme.of(context).primary,
                  size: 30.0,
                ),
                onPressed: () async {
                  context.pushNamed('Profile');
                },
              ),
            ),
          ],
          centerTitle: false,
          elevation: 0.0,
        ),
        body: SafeArea(
          top: true,
          child: Align(
            alignment: const AlignmentDirectional(0.0, 0.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                // Daily summary container
                Container(
                  width: double.infinity,
                  height: 140.0,
                  constraints: const BoxConstraints(
                    maxHeight: 140.0,
                  ),
                  decoration: BoxDecoration(
                    color: FlutterFlowTheme.of(context).secondaryBackground,
                    boxShadow: const [
                      BoxShadow(
                        blurRadius: 3.0,
                        color: Color(0x33000000),
                        offset: Offset(0.0, 1.0),
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 4.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 0.0, 0.0),
                          child: Text(
                            'Daily summary',
                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0.0,
                                ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                            child: ListView(
                              padding: EdgeInsets.zero,
                              primary: false,
                              shrinkWrap: true,
                              scrollDirection: Axis.horizontal,
                              children: [
                                // Protein summary
                                _buildNutrientSummary(
                                  context: context,
                                  value: _model.proteinData ?? '',
                                  label: 'Protein',
                                  color: FlutterFlowTheme.of(context).primaryText,
                                ),
                                // Carbs summary
                                _buildNutrientSummary(
                                  context: context,
                                  value: _model.carbsData ?? '',
                                  label: 'Carbs',
                                  color: FlutterFlowTheme.of(context).tertiary,
                                ),
                                // Fat summary
                                _buildNutrientSummary(
                                  context: context,
                                  value: _model.fatData ?? '',
                                  label: 'Fat',
                                  color: FlutterFlowTheme.of(context).secondary,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Today's consumption container
                Flexible(
                  child: Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(16.0, 12.0, 16.0, 24.0),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: FlutterFlowTheme.of(context).secondaryBackground,
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 3.0,
                            color: Color(0x33000000),
                            offset: Offset(0.0, 1.0),
                          )
                        ],
                        borderRadius: BorderRadius.circular(8.0),
                        border: Border.all(
                          color: FlutterFlowTheme.of(context).alternate,
                          width: 1.0,
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                              child: Text(
                                'Today\'s Consumption',
                                style: FlutterFlowTheme.of(context).headlineMedium.override(
                                      fontFamily: 'Outfit',
                                      letterSpacing: 0.0,
                                      fontWeight: FontWeight.w500,
                                    ),
                              ),
                            ),
                            Text(
                              'Total Calories/Daily Goal',
                              style: FlutterFlowTheme.of(context).labelMedium.override(
                                    fontFamily: 'Readex Pro',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                            Padding(
                              padding: const EdgeInsetsDirectional.fromSTEB(0.0, 12.0, 0.0, 12.0),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Column(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      _buildCalorieProgressText(context),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                        child: _buildCalorieProgressBar(context),
                                      ),
                                      Padding(
                                        padding: const EdgeInsetsDirectional.fromSTEB(0.0, 8.0, 0.0, 0.0),
                                        child: _buildRemainingCaloriesText(context),
                                      ),
                                    ].divide(const SizedBox(height: 4.0)),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Weekly activities container
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16.0, 0.0, 16.0, 24.0),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: FlutterFlowTheme.of(context).secondaryBackground,
                      boxShadow: const [
                        BoxShadow(
                          blurRadius: 3.0,
                          color: Color(0x33000000),
                          offset: Offset(0.0, 1.0),
                        )
                      ],
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.max,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(0.0, 0.0, 0.0, 8.0),
                            child: Text(
                              'Weekly Activities',
                              style: FlutterFlowTheme.of(context).headlineSmall.override(
                                    fontFamily: 'Outfit',
                                    letterSpacing: 0.0,
                                  ),
                            ),
                          ),
                          Text(
                            'Overview of calories breakdown',
                            style: FlutterFlowTheme.of(context).labelMedium.override(
                                  fontFamily: 'Readex Pro',
                                  letterSpacing: 0.0,
                                ),
                          ),
                          Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(16.0, 16.0, 16.0, 5.0),
                            child: SizedBox(
                              width: double.infinity,
                              height: 150.0,
                              child: _buildWeeklyCaloriesChart(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // Helper method to build nutrient summary widget
  Widget _buildNutrientSummary({
    required BuildContext context,
    required String value,
    required String label,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12.0, 0.0, 16.0, 8.0),
      child: Container(
        width: 120.0,
        height: 100.0,
        decoration: BoxDecoration(
          color: FlutterFlowTheme.of(context).secondaryBackground,
          borderRadius: BorderRadius.circular(8.0),
          border: Border.all(
            color: const Color(0xFFE0E3E7),
            width: 2.0,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: FlutterFlowTheme.of(context).displaySmall.override(
                      fontFamily: 'Outfit',
                      color: color,
                      letterSpacing: 0.0,
                    ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(0.0, 4.0, 0.0, 0.0),
                child: Text(
                  label,
                  style: FlutterFlowTheme.of(context).labelMedium.override(
                        fontFamily: 'Readex Pro',
                        letterSpacing: 0.0,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build calorie progress text
  Widget _buildCalorieProgressText(BuildContext context) {
    return RichText(
      textScaler: MediaQuery.of(context).textScaler,
      text: TextSpan(
        children: [
          TextSpan(
            text: valueOrDefault<String>(
              double.parse(double.parse((_model.caloriesData!)).toStringAsFixed(1)).toString(),
              '0',
            ),
            style: const TextStyle(),
          ),
          const TextSpan(
            text: '/',
            style: TextStyle(),
          ),
          TextSpan(
            text: valueOrDefault<String>(
              _model.calorieGoal,
              '0',
            ),
            style: FlutterFlowTheme.of(context).labelLarge.override(
                  fontFamily: 'Readex Pro',
                  letterSpacing: 0.0,
                ),
          )
        ],
        style: FlutterFlowTheme.of(context).displaySmall.override(
              fontFamily: 'Outfit',
              letterSpacing: 0.0,
            ),
      ),
    );
  }

  // Helper method to build calorie progress bar
  Widget _buildCalorieProgressBar(BuildContext context) {
    return LinearPercentIndicator(
      percent: valueOrDefault<double>(
        math.min(double.parse((_model.caloriesData!)) / double.parse(_model.calorieGoal), 1.0),
        0.0,
      ),
      width: MediaQuery.sizeOf(context).width * 0.85,
      lineHeight: 12.0,
      animation: true,
      animateFromLastPercent: true,
      progressColor: FlutterFlowTheme.of(context).primary,
      backgroundColor: FlutterFlowTheme.of(context).accent1,
      barRadius: const Radius.circular(16.0),
      padding: EdgeInsets.zero,
    );
  }

  // Helper method to build remaining calories text
  Widget _buildRemainingCaloriesText(BuildContext context) {
    return RichText(
      textScaler: MediaQuery.of(context).textScaler,
      text: TextSpan(
        children: [
          const TextSpan(
            text: 'Remaining: ',
            style: TextStyle(),
          ),
          TextSpan(
            text: valueOrDefault<String>(
              double.parse(math.max(double.parse(_model.calorieGoal) - double.parse((_model.caloriesData!)), 0).toStringAsFixed(1)).toString(),
              '0',
            ),
            style: FlutterFlowTheme.of(context).bodyMedium.override(
                  fontFamily: 'Readex Pro',
                  letterSpacing: 0.0,
                  fontWeight: FontWeight.bold,
                ),
          )
        ],
        style: FlutterFlowTheme.of(context).labelMedium.override(
              fontFamily: 'Readex Pro',
              letterSpacing: 0.0,
            ),
      ),
    );
  }

  // Helper method to build weekly calories chart
  Widget _buildWeeklyCaloriesChart(BuildContext context) {
    return FlutterFlowBarChart(
      barData: [
        FFBarChartData(
          yData: _model.weeklyCalories,
          color: FlutterFlowTheme.of(context).primary,
        )
      ],
      xLabels: _model.weekLetter,
      barWidth: 30.0,
      barBorderRadius: const BorderRadius.only(
        bottomLeft: Radius.circular(0.0),
        bottomRight: Radius.circular(0.0),
        topLeft: Radius.circular(0.0),
        topRight: Radius.circular(0.0),
      ),
      groupSpace: 15.0,
      chartStylingInfo: ChartStylingInfo(
        enableTooltip: true,
        backgroundColor: FlutterFlowTheme.of(context).secondaryBackground,
        showBorder: false,
      ),
      axisBounds: const AxisBounds(),
      xAxisLabelInfo: const AxisLabelInfo(
        showLabels: true,
        labelTextStyle: TextStyle(),
        labelInterval: 10.0,
      ),
      yAxisLabelInfo: const AxisLabelInfo(),
    );
  }
}
