import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_html_editor/new_html_editor.dart';
import 'package:new_html_editor/src/feature/Presentation/view/widgets/comment_edit_widget.dart';

class CommentItemWidget extends StatefulWidget {
  const CommentItemWidget({
    super.key,
    required this.activeCommentId,
    required this.comment,
    required this.onCardClick,
    required this.controller,
    required this.onReplyPressed,
    required this.isReply,
    required this.enableCommentId,
    required this.onEditPressed,
    this.isEditingMode = false,
    this.updateLocalData,
    this.ondeleteButton,
  });
  final String activeCommentId;
  final Comment comment;
  final Function() onCardClick;
  final Function(bool) onReplyPressed;
  final QuillEditorController controller;
  final bool isReply;
  final Function(String) enableCommentId;
  final Function(bool) onEditPressed;
  final bool isEditingMode;
  final Function(String, String, int?)? updateLocalData;
  final Function(String, int)? ondeleteButton;

  @override
  State<CommentItemWidget> createState() => _CommentItemWidgetState();
}

class _CommentItemWidgetState extends State<CommentItemWidget> {
  String commentText = '';
  int threadIndex = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onCardClick,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color:
              widget.comment.id == widget.activeCommentId
                  ? Colors.amber.shade50
                  : Colors.white,
          border: Border.all(
            color:
                widget.comment.id == widget.activeCommentId
                    ? Colors.amber
                    : Colors.grey.shade300,
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            //Quoted Text
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.amber.shade100,
                borderRadius: BorderRadius.circular(4),
                border: Border(left: BorderSide(color: Colors.amber, width: 3)),
              ),
              child: Text(
                widget.comment.commentedText,
                style: TextStyle(
                  fontSize: 12,
                  fontStyle: FontStyle.italic,
                  color: Color(0xFF7A7060),
                ),
              ),
            ),
            const SizedBox(height: 12),
            //Thread of comments
            //   if (kIsWeb)
            ...widget.comment.thread.asMap().entries.map((element) {
              final index = element.key;
              final reply = element.value;
              return CommentReplyWidget(
                commentId: widget.comment.id,
                index: index,
                reply: reply,
                controller: widget.controller,
                onEditPressed: (value, index) {
                  widget.onEditPressed(true);
                  widget.enableCommentId(widget.comment.id);
                  widget.controller.setActiveComment(widget.comment.id);
                  setState(() {
                    commentText = value;
                    threadIndex = index;
                  });
                },
                ondeleteButton: widget.ondeleteButton,
              );
            }),
            //Add reply button
            const SizedBox(height: 8),
            widget.isReply && widget.activeCommentId == widget.comment.id
                ? CommentTextField(
                  commentBody:
                      widget.isEditingMode &&
                              widget.activeCommentId == widget.comment.id
                          ? commentText
                          : '',
                  onCommentClick: (value) {
                    widget.controller.addComment(
                      value,
                      commentId: widget.comment.id,
                    );
                    if (!kIsWeb) {
                      widget.updateLocalData!(value, widget.comment.id, null);
                    }
                    widget.onReplyPressed(false);
                  },
                  onCancelPressed: () {
                    widget.onEditPressed(false);
                    widget.onReplyPressed(false);
                  },
                  onEditUpdated: (value) {
                    widget.onEditPressed(false);
                    widget.controller.editComment(
                      widget.comment.id,
                      threadIndex,
                      value,
                    );
                    if (!kIsWeb) {
                      widget.updateLocalData!(
                        value,
                        widget.comment.id,
                        threadIndex,
                      );
                    }
                  },
                )
                : TextButton.icon(
                  onPressed: () {
                    widget.enableCommentId(widget.comment.id);
                    widget.onReplyPressed(true);
                    widget.controller.setActiveComment(widget.comment.id);
                  },
                  label: const Text("Reply"),
                  icon: const Icon(Icons.reply, size: 16),
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blue,
                    textStyle: const TextStyle(fontSize: 12),
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

class CommentReplyWidget extends StatelessWidget {
  const CommentReplyWidget({
    super.key,
    required this.commentId,
    required this.index,
    required this.reply,
    required this.controller,
    required this.onEditPressed,
    this.ondeleteButton,
  });
  final String commentId;
  final int index;
  final CommentReply reply;
  final QuillEditorController controller;
  final Function(String, int) onEditPressed;
  final Function(String, int)? ondeleteButton;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                reply.author,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                _formatTimestamp(reply.timestamp),
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
              ),
              if (reply.edited == true) ...[
                const SizedBox(width: 4),
                Text(
                  '(edited)',
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.grey.shade500,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
              const Spacer(),
              // Edit button
              IconButton(
                icon: const Icon(Icons.edit, size: 14),
                onPressed: () {
                  onEditPressed(reply.body, index);
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              // Delete button
              IconButton(
                icon: const Icon(Icons.delete, size: 14),
                onPressed: () {
                  controller.deleteCommentReply(commentId, index);
                  if (!kIsWeb) {
                    ondeleteButton!(commentId, index);
                  }
                },
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(reply.body, style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

String _formatTimestamp(String iso) {
  final dt = DateTime.parse(iso);
  final now = DateTime.now();
  final diff = now.difference(dt);

  if (diff.inMinutes < 1) return 'just now';
  if (diff.inHours < 1) return '${diff.inMinutes}m ago';
  if (diff.inDays < 1) return '${diff.inHours}h ago';
  return '${diff.inDays}d ago';
}
