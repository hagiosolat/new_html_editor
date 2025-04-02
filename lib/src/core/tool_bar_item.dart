import 'package:flutter/material.dart';
import '../constants/image_constants.dart';

///[ToolBarItem] toolbaritem widget to show buttons based on style
@immutable
class ToolBarItem extends StatelessWidget {
  ///[style] to set the toolbar buttons by styles
  final ToolBarStyle style;

  ///[isActive] to highlight the toolbar buttons when active
  final bool isActive;

  ///[onTap] callback to set format on tap
  final GestureTapCallback? onTap;

  /// The amount of space by which to inset the child.
  final EdgeInsetsGeometry padding;

  ///[iconSize] to define the toolbar icon size
  final double iconSize;

  ///[iconColor] to define the toolbar icon color
  final Color iconColor;

  ///[activeIconColor] to define the active toolbar icon color
  final Color? activeIconColor;

  ///[ToolBarItem] toolbaritem widget to show buttons based on style
  const ToolBarItem({
    super.key,
    required this.style,
    required this.isActive,
    required this.padding,
    required this.iconSize,
    required this.iconColor,
    required this.activeIconColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
        waitDuration: const Duration(milliseconds: 800),
        message: style.name,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: padding,
            child: SizedBox(child: _getIconByStyle(style)),
          ),
        ));
  }

  Widget _getIconByStyle(ToolBarStyle style) {
    switch (style) {
      case ToolBarStyle.bold:
        return _getIconWidget(Icons.format_bold_sharp);
      case ToolBarStyle.italic:
        return _getIconWidget(Icons.format_italic_sharp);
      case ToolBarStyle.underline:
        return _getIconWidget(Icons.format_underline_sharp);
      case ToolBarStyle.strike:
        return _getIconWidget(Icons.format_strikethrough_sharp);
      case ToolBarStyle.blockQuote:
        return _getIconWidget(Icons.format_quote_sharp);
      case ToolBarStyle.codeBlock:
        return _getIconWidget(Icons.code_sharp);
      case ToolBarStyle.indentAdd:
        //isActive = false;
        return _getIconWidget(Icons.format_indent_increase_sharp);
      case ToolBarStyle.indentMinus:
        //  isActive = false;
        return _getIconWidget(Icons.format_indent_decrease_sharp);
      case ToolBarStyle.directionRtl:
        return _getIconWidget(Icons.format_textdirection_r_to_l_sharp);
      case ToolBarStyle.directionLtr:
        return _getIconWidget(Icons.format_textdirection_l_to_r_sharp);
      case ToolBarStyle.color:
        return _getIconWidget(Icons.format_bold_sharp);
      case ToolBarStyle.align:
        return _getIconWidget(Icons.format_align_left_sharp);
      case ToolBarStyle.clean:
        return _getIconWidget(Icons.format_clear_sharp);
      case ToolBarStyle.listOrdered:
        return _getIconWidget(Icons.format_list_numbered_sharp);
      case ToolBarStyle.listBullet:
        return _getIconWidget(Icons.format_list_bulleted_sharp);
      case ToolBarStyle.headerOne:
        return _getAssetImageWidget(ImageConstant.kiHeaderOneDarkPng);
      case ToolBarStyle.headerTwo:
        return _getAssetImageWidget(ImageConstant.kiHeaderTwoDarkPng);
      case ToolBarStyle.background:
        return _getIconWidget(Icons.font_download_sharp);
      case ToolBarStyle.image:
        return _getIconWidget(Icons.image);
      case ToolBarStyle.undo:
        return _getIconWidget(Icons.undo_sharp);
      case ToolBarStyle.redo:
        return _getIconWidget(Icons.redo_sharp);
      case ToolBarStyle.clearHistory:
        return _getIconWidget(Icons.layers_clear_sharp);
      case ToolBarStyle.link:
      case ToolBarStyle.video:
      case ToolBarStyle.size:
      case ToolBarStyle.addTable:
      case ToolBarStyle.editTable:
      case ToolBarStyle.separator:
        return const SizedBox();
    }
  }

  Icon _getIconWidget(IconData iconData) => Icon(
        iconData,
        color: isActive ? activeIconColor : iconColor,
        size: iconSize,
      );

  Widget _getAssetImageWidget(String imagePath) => SizedBox(
        width: iconSize,
        height: iconSize,
        child: Image.asset(
          imagePath,
          color: isActive ? activeIconColor : iconColor,
        ),
      );

  ///toolbar item copyWith function
  ToolBarItem copyWith({
    bool? isActive,
  }) {
    return ToolBarItem(
        style: style,
        isActive: isActive ?? this.isActive,
        padding: padding,
        iconSize: iconSize,
        iconColor: iconColor,
        activeIconColor: activeIconColor);
  }
}




///[ToolBarStyle] an enum with multiple toolbar styles, to define required toolbar styles in custom config

enum ToolBarStyle {
  ///[bold] sets bold format
  bold("Bold"),

  /// [italic] sets italic format

  italic("Italic"),

  /// [underline] sets underline to text

  underline("Underline"),

  /// [strike] makes the selected text strikethrough

  strike("Strikethrough"),

  /// [blockQuote] converts text to quote

  blockQuote("Block Quote"),

  /// [codeBlock] makes selected text code block

  codeBlock("Code Block"),

  /// [indentMinus] decreases the indent by given value

  indentMinus("Decrease the indent"),

  /// [indentAdd] increases the indent by given value

  indentAdd("Increase the indent"),

  /// [directionRtl] sets the direction of text from Right to Left

  directionRtl("Right to Left"),

  /// [directionLtr] sets the direction of text from Left to Right

  directionLtr("Left to Right"),

  /// [headerOne] makes the text H1

  headerOne("Header H1"),

  /// [headerTwo] makes the text H2

  headerTwo("Header H2"),

  /// [color] sets font color

  color("Font color"),

  /// [background] sets background color to text

  background("Background color"),

  /// [align] adds alignment to text, left, right, center, justify

  align("Alignment"),

  /// [listOrdered] adds numbered/alphabets list to the text

  listOrdered("Bullet numbers"),

  /// [listBullet] makes text as bullet points

  listBullet("Bullet points"),

  /// [size] sets fontSize of the text

  size("Font Size"),

  /// [link] sets hyperlink to selected text

  link("Hyperlink"),

  /// [image] embeds image to the editor

  image("Insert image"),

  /// [video] embeds Youtube, Vimeo or other network videos to editor

  video("Insert Youtube/Url"),

  /// [clean] clears all formats of editor, (for internal use case)
  clean("Clears all formats"),

  /// [undo] to undo the editor change
  undo("Undo"),

  /// [redo] to redo the editor change
  redo("Redo"),

  /// [clearHistory] to undo the editor change
  clearHistory("Clear History"),

  /// [addTable] to add table to the editor
  addTable("Add a table"),

  /// [editTable] to edit rows, columns or delete table
  editTable("Edit table"),

  ///[separator] to add divider between toolbar items
  separator("separator");

  ///font - later releases

  /// Represents the style of a toolbar in the editor.
  const ToolBarStyle(this.name);

  /// The `name` property specifies the name of the toolbar.
  final String name;
}
