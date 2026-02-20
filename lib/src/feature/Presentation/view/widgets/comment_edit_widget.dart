import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_html_editor/new_html_editor.dart';
import 'package:new_html_editor/src/feature/Presentation/view/widgets/mobile_comment_ui.dart';

class CommentTextField extends StatefulWidget {
  const CommentTextField({
    super.key,
    required this.onCommentClick,
    required this.onCancelPressed,
    this.focusField,
    this.focusNode,
    this.isEditingMode = false,
    this.commentBody,
    this.onEditUpdated,
  });
  final Function(String) onCommentClick;
  final bool? focusField;
  final FocusNode? focusNode;
  final Function() onCancelPressed;
  final bool isEditingMode;
  final String? commentBody;
  final Function(String)? onEditUpdated;

  @override
  State<CommentTextField> createState() => _CommentTextFieldState();
}

class _CommentTextFieldState extends State<CommentTextField> {
  TextEditingController commentController = TextEditingController();
  String? errorText;

  @override
  void initState() {
    if (widget.commentBody?.isNotEmpty == true) {
      commentController.text = widget.commentBody ?? '';
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.maxFinite,
      padding: const EdgeInsets.only(
        top: kIsWeb ? 8.0 : 0.0,
        right: 8.0,
        left: 8.0,
        bottom: 4.0,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(15),
          topRight: Radius.circular(15),
        ),
        color: kIsWeb ? Colors.grey.withAlpha(20) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).canvasColor,
            blurRadius: 0.1,
            spreadRadius: 0.4,
            offset: const Offset(2, 6),
          ),
        ],
      ),
      child: Wrap(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 14.0, left: 9, right: 9),
            child: Column(
              children: [
                TextField(
                  focusNode: widget.focusNode,
                  controller: commentController,
                  style: TextStyle(fontSize: 10),
                  decoration: InputDecoration(
                    contentPadding: EdgeInsets.symmetric(
                      vertical: 0,
                      horizontal: 8,
                    ),
                    hintText: 'Make your comment...',
                    hintStyle: TextStyle(fontSize: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                    errorText: errorText,
                  ),
                  onChanged: (value) {
                    if (value.isEmpty) {
                      setState(() {
                        errorText = "This field should not be empty";
                      });
                    } else {
                      setState(() {
                        errorText = null;
                      });
                    }
                  },
                ),
                const SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: widget.onCancelPressed,
                      child: const Text(
                        'Cancel',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                    ElevatedButton(
                      onPressed: () {
                        if (widget.commentBody?.isNotEmpty == true) {
                          if (commentController.text.isNotEmpty) {
                            widget.onEditUpdated!(commentController.text);
                          } else {
                            setState(() {
                              errorText = 'The field should not be empty';
                            });
                          }
                        } else {
                          if (commentController.text.isNotEmpty) {
                            widget.onCommentClick(commentController.text);
                          } else {
                            setState(() {
                              errorText = 'The field should not be empty';
                            });
                          }
                        }
                      },
                      child: const Text(
                        'Comment',
                        style: TextStyle(fontSize: 10),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

showCommentModalForMobile(
  BuildContext context,
  List<Comment> comment,
  QuillEditorController controller,
  String activeCommentId,
  bool isReply,
) {
  if (!kIsWeb) {
    showModalBottomSheet(
      enableDrag: true,
      barrierColor: Colors.transparent,
      showDragHandle: false,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      // elevation: 0.0,
      context: context,
      builder: (context) {
        return MobileCommentDragScreen(
          activeCommentId: activeCommentId,
          comment: comment,
          quillController: controller,
          initialPage: comment.indexWhere((e) => e.id == activeCommentId),
        );
      },
    );
  }
}
