import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:new_html_editor/new_html_editor.dart';
import '../utils/hex_color.dart';
import 'el_tooltip/el_tooltip.dart';

import 'webviewx/src/models/selection_model.dart';

///[InputUrlWidget] class to show widget that capture video/hyperlink urls
class InputUrlWidget extends StatefulWidget {
  ///[onSubmit] callback when user submits the url input
  final Function(String) onSubmit;

  ///[UrlInputType] for input types video, hyperlink
  final UrlInputType type;

  ///[controller] editor controller to access internal apis
  final QuillEditorController controller;

  ///[isActive] to highlight icon on selection
  final bool isActive;

  ///[iconWidget] icon for url picker
  final Widget iconWidget;

  ///[InputUrlWidget] constructor of input url widget to capture, video/hyperlink urls
  const InputUrlWidget(
      {super.key,
      required this.onSubmit,
      required this.type,
      required this.controller,
      required this.isActive,
      required this.iconWidget});

  @override
  State<StatefulWidget> createState() {
    return _InputUrlWidgetState();
  }
}

class _InputUrlWidgetState extends State<InputUrlWidget> {
  /// declare a GlobalKey
  final _formKey = GlobalKey<FormState>();

  /// declare a variable to keep track of the input text
  String? _inputValue = '';

  ///[_toolTipKey] key to access tooltip methods
  late GlobalKey<ElTooltipState> _toolTipKey;

  ///[selection] selected text length to perform validations
  int selection = -1;
  int onDoneLastClicked = 0;
  int onCloseLastClicked = 0;

  ///[_inputFieldTextController] controller to the input text field
  final TextEditingController _inputFieldTextController =
      TextEditingController();

  @override
  void initState() {
    _toolTipKey = GlobalKey<ElTooltipState>(
        debugLabel: widget.controller.hashCode.toString());
    _inputFieldTextController.clear();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return getWidgetByPlatform(context);
  }

  Widget getWidgetByPlatform(BuildContext context) {
    if (kIsWeb) {
      SelectionModel? selectionMap;
      return ElTooltip(
        onTap: () async {
          selectionMap = await widget.controller.getSelectionRange();
          if (_toolTipKey.currentState != null) {
            _toolTipKey.currentState!.showOverlayOnTap();
          }
        },
        key: _toolTipKey,
        content: _getTextFieldBytType(
            true, onDoneLastClicked, onCloseLastClicked, selectionMap, context),
        child: widget.iconWidget,
      );
    } else {
      return InkWell(
        onTap: () async {
          await widget.controller.getSelectionRange().then((selectionModel) {
            showModalBottomSheet(
                context: context,
                isScrollControlled: true,
                builder: (context) {
                  return _getTextFieldBytType(false, onDoneLastClicked,
                      onCloseLastClicked, selectionModel, context);
                });
          });
        },
        child: widget.iconWidget,
      );
    }
  }

  Widget _getTextFieldBytType(
      bool isToolTip,
      int onDoneLastClicked,
      int onCloseLastClicked,
      SelectionModel? selectionModel,
      BuildContext context) {
    return WebViewAware(
      child: Form(
          key: _formKey,
          child: Padding(
            padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom),
            child: Container(
                height: 60,
                alignment: Alignment.center,
                child: Row(
                  children: [
                    const SizedBox(
                      width: 10,
                    ),
                    Flexible(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 4.0, vertical: 0),
                        child: Container(
                          decoration: BoxDecoration(
                              color: HexColor.fromHex('#E7F0FE'),
                              borderRadius: BorderRadius.circular(10)),
                          child: TextFormField(
                            controller: _inputFieldTextController,
                            minLines: 1,
                            onChanged: (v) {
                              setState(() => _inputValue = v);
                            },
                            validator: (text) {
                              if (text == null || text.isEmpty) {
                                return 'Can\'t be empty';
                              }
                              return null;
                            },
                            decoration: InputDecoration(
                                isDense: true,
                                suffixIcon: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    clickableText("Paste", () async {
                                      ClipboardData? clipboardData =
                                          await Clipboard.getData(
                                              Clipboard.kTextPlain);
                                      if (clipboardData != null) {
                                        _inputFieldTextController.text =
                                            clipboardData.text?.trim() ?? "";
                                        setState(() => _inputValue =
                                            clipboardData.text?.trim() ?? "");
                                      }
                                    })
                                  ],
                                ),
                                contentPadding: EdgeInsets.symmetric(
                                    horizontal: 5, vertical: 8),
                                errorBorder: InputBorder.none,
                                hintText: ' Type URL',
                                alignLabelWithHint: true,
                                hintStyle: TextStyle(fontSize: 10),
                                border: InputBorder.none),
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        final now = DateTime.now().millisecondsSinceEpoch;
                        if (now - onDoneLastClicked < 500) {
                          return;
                        }
                        onDoneLastClicked = now;
                        if (_formKey.currentState!.validate()) {
                          if (selectionModel != null) {
                            widget.controller.setSelectionRange(
                                selectionModel.index ?? 0,
                                selectionModel.length ?? 0);
                          }

                          Future.delayed(const Duration(milliseconds: 10))
                              .then((value) {
                            widget.onSubmit(_inputValue ?? '');
                            if (isToolTip) {
                              _toolTipKey.currentState!.hideOverlay();
                            } else {
                              Navigator.pop(context);
                            }
                          });
                        } else {
                          _inputValue = null;
                          setState(() {});
                        }
                      },
                      icon: const Icon(
                        Icons.check_rounded,
                        color: Colors.green,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                    IconButton(
                      onPressed: () {
                        final now = DateTime.now().millisecondsSinceEpoch;
                        if (now - onCloseLastClicked < 500) {
                          return;
                        }
                        onCloseLastClicked = now;
                        if (isToolTip) {
                          _toolTipKey.currentState!.hideOverlay();
                        } else {
                          Navigator.pop(context);
                        }
                      },
                      icon: const Icon(
                        Icons.close_rounded,
                        color: Colors.red,
                      ),
                    ),
                    const SizedBox(
                      width: 5,
                    ),
                  ],
                )),
          )),
    );
  }

  ///[clickableText] method to paste a text on the InputURLWidgetTextField
  Widget clickableText(String text, void Function() onClick) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 0),
      child: IconButton(
        onPressed: () {
          onClick();
        },
        icon: Text(
          text,
          overflow: TextOverflow.ellipsis,
          textAlign: TextAlign.start,
          style: const TextStyle(
            fontSize: 16,
            color: Color(0XFF2C14DD),
            decoration: TextDecoration.none,
            decorationColor: Color(0XFF2752E7),
          ),
        ),
      ),
    );
  }
}

///[UrlInputType] enum for input types
enum UrlInputType {
  ///[video] type for embedding video url to editor
  video,

  ///[hyperlink] type for embedding hyperlink to selection in editor
  hyperlink
}
