
import 'dart:ui' as ui;
import 'package:google_maps_flutter/google_maps_flutter.dart' show BitmapDescriptor;
import 'package:maps/markers/markers.dart';

Future<BitmapDescriptor> getStartCustomMarker( int minutes, String destination ) async {

  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas( recorder );

  const size = ui.Size( 350, 150 ); // Same as widget container (width, height)

  final startMarker = StartMarkerPainter(minutes: minutes, destination: destination);
  startMarker.paint(canvas, size);

  final picture = recorder.endRecording();
  final image = await picture.toImage( size.width.toInt(), size.height.toInt() );
  final byteData = await image.toByteData( format: ui.ImageByteFormat.png );

  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());

}

Future<BitmapDescriptor> getEndCustomMarker( int kilometers, String destination ) async {

  final recorder = ui.PictureRecorder();
  final canvas = ui.Canvas( recorder );

  const size = ui.Size( 350, 150 ); // Same as widget container (width, height)

  final endMarker = EndMarkerPainter(kilometers: kilometers, destination: destination);
  endMarker.paint(canvas, size);

  final picture = recorder.endRecording();
  final image = await picture.toImage( size.width.toInt(), size.height.toInt() );
  final byteData = await image.toByteData( format: ui.ImageByteFormat.png );

  return BitmapDescriptor.fromBytes(byteData!.buffer.asUint8List());

}
