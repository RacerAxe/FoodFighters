import '/flutter_flow/flutter_flow_util.dart';
import 'profile_widget.dart' show ProfileWidget;
import 'package:flutter/material.dart';

/// Model class for the Profile page, extending FlutterFlowModel.
class ProfileModel extends FlutterFlowModel<ProfileWidget> {
  /// State fields for stateful widgets in this page.

  // Flag to indicate if data is currently being uploaded
  bool isDataUploading = false;

  // Stores the locally uploaded file
  FFUploadedFile uploadedLocalFile =
      FFUploadedFile(bytes: Uint8List.fromList([]));

  // URL of the uploaded file
  String uploadedFileUrl = '';

  /// Initialize the model.
  @override
  void initState(BuildContext context) {
    // Add any initialization logic here
  }

  /// Dispose of the model resources.
  @override
  void dispose() {
    // Add any cleanup logic here
  }
}
