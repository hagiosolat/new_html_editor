import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:new_html_editor/new_html_editor.dart';
import 'package:new_html_editor/src/feature/Presentation/view/widgets/comment_item_widget.dart';

class MobileCommentDragScreen extends StatefulWidget {
  const MobileCommentDragScreen({
    super.key,
    required this.comment,
    required this.quillController,
    required this.activeCommentId,
    required this.initialPage,
  });
  final List<Comment> comment;
  final QuillEditorController quillController;
  final String activeCommentId;
  final int initialPage;

  @override
  State<MobileCommentDragScreen> createState() => _MobileCommentScreenState();
}

class _MobileCommentScreenState extends State<MobileCommentDragScreen> {
  PageController? _pageController;
  bool isReply = false;
  bool isEditingMode = false;
  String activeCommentId = '';
  List<Comment> comments = [];

  @override
  void initState() {
    activeCommentId = widget.activeCommentId;
    comments = widget.comment;
    _pageController = PageController(initialPage: widget.initialPage);
    super.initState();
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isKeyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    return DraggableScrollableSheet(
      initialChildSize: isKeyboardVisible ? 0.7 : 0.5,
      minChildSize: 0.3,
      maxChildSize: 0.95,
      snap: true,
      snapSizes: isKeyboardVisible ? [0.8, 0.95] : [0.3, 0.5, 0.95],
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            children: [
              //Custom drag handle
              Container(
                margin: EdgeInsets.symmetric(vertical: 12),
                width: 40,
                height: 5,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              //This should have the list of the comments to be shown here
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  itemCount: comments.length,
                  itemBuilder: (context, index) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      padding: EdgeInsets.all(12),
                      child: Column(
                        children: [
                          // MobileCommentItem(comment: widget.comment),
                          CommentItemWidget(
                            updateLocalData: (
                              newCommentText,
                              commentId,
                              threadIndex,
                            ) {
                              if (!kIsWeb) {
                                setState(() {
                                  for (var comment in comments) {
                                    if (comment.id == commentId) {
                                      if (threadIndex != null) {
                                        //Editing the existing comment
                                        comment.thread[threadIndex].body =
                                            newCommentText;
                                        comment.thread[threadIndex].edited =
                                            true;
                                        comment.thread[threadIndex].editedAt =
                                            DateTime.now().toIso8601String();
                                      } else {
                                        //Add new comment to the ID

                                        comment.thread.add(
                                          CommentReply(
                                            author: 'userName',
                                            body: newCommentText,
                                            timestamp:
                                                DateTime.now()
                                                    .toIso8601String(),
                                          ),
                                        );
                                      }
                                    }
                                  }
                                });
                              }
                            },
                            ondeleteButton: (commentId, threadIndex) {
                              setState(() {
                                for (var comment in comments) {
                                  if (comment.id == commentId) {
                                    if (comment.thread.length == 1) {
                                      comments.removeWhere(
                                        (element) => element.id == comment.id,
                                      );
                                      return;
                                    } else {
                                      comment.thread.removeAt(threadIndex);
                                    }
                                  }
                                }
                              });
                            },
                            activeCommentId: activeCommentId,
                            isEditingMode: isEditingMode,
                            comment: comments[index],
                            onCardClick: () {},
                            controller: widget.quillController,
                            onReplyPressed: (value) {
                              setState(() {
                                isReply = value;
                              });
                            },
                            isReply: isReply,
                            enableCommentId: (value) {
                              setState(() {
                                activeCommentId = value;
                              });
                            },
                            onEditPressed: (value) {
                              setState(() {
                                isReply = value;
                                isEditingMode = value;
                              });
                            },
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).viewInsets.bottom,
                          ),
                        ],
                      ),
                    );
                  },
                  onPageChanged: (index) {
                    // _pageController.nextPage(duration: duration, curve: curve)
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

void mobileDeleteCommentUI(BuildContext context, Function() ondelete) {
  showDialog(
    context: context,
    builder:
        (ctx) => AlertDialog(
          // backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          content: const Text(
            'Are you sure you want to delete the comment?',
            style: TextStyle(height: 1.5),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('CANCEL'),
            ),
            ElevatedButton(
              onPressed: ondelete,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text('DELETE', style: TextStyle(letterSpacing: 1.1)),
            ),
          ],
        ),
  );
}
