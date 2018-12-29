import 'package:fluro/fluro.dart';
import 'package:yana/Routes/RouteHandlers.dart';

class Routes {
  static String root = "/";
  static String notesScreen = "/notesScreen";
  static String newNote = "/newNote";
  static String editNote = "/editNote";

  static void configureRoutes(Router router) {
    router.define(newNote, handler: newNoteHandler);
    router.define(editNote,handler: editNoteHandler);
  }
}
