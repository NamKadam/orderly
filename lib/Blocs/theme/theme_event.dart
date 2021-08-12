
import 'package:orderly/Configs/theme.dart';
import 'package:orderly/Models/model_theme.dart';
import 'package:meta/meta.dart';

@immutable
abstract class ThemeEvent {}

class OnChangeTheme extends ThemeEvent {
  final ThemeModel theme;
  final String font;
  final DarkOption darkOption;

  OnChangeTheme({
    this.theme,
    this.font,
    this.darkOption,
  });
}
