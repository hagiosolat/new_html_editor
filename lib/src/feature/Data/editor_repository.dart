import 'dart:isolate';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:new_html_editor/src/utils/hex_color.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../new_html_editor.dart';
import '../../utils/string_util.dart';
part 'editor_repository.g.dart';

@riverpod
EditorRepository editorRepository(Ref ref) => const EditorRepository();

class EditorRepository {
  const EditorRepository();
  Future<String> getJavaScriptFunctions() async {
    String response;
    if (kIsWeb) {
      response = await rootBundle.loadString(
        "packages/new_html_editor/assets/scripts/custom_quill.js",
      );
    } else {
      response = await rootBundle.loadString(
        "packages/new_html_editor/assets/scripts/custom_quill.js",
      );
    }
    return response;
  }

  // void loadHtmlContent(SendPort sendPort) async {
  //   //Receive messages from main thread
  //   final ReceivePort receivePort = ReceivePort();
  //   sendPort.send(receivePort.sendPort);

  //   await for (final message in receivePort) {
  //     if (message is Map<String, dynamic>) {
  //       String htmlContent = htmlLoader(message);
  //       message["responsePort"].send(htmlContent);
  //     }
  //   }
  // }

  String htmlLoader(Map<String, dynamic> params) {
    String fontFamily = params['fontFamily'];
    Color backgroundColor = params['backgroundColor'];
    String encodedStyle = params['encodedStyle'];
    EdgeInsets? hintTextPadding = params['hintTextPadding'];
    TextStyle? hintTextStyle = params['hintTextStyle'];
    TextStyle? textStyle = params['textStyle'];
    TextAlign? hintTextAlign = params['hintTextAlign'];
    double minHeight = params['minHeight'];
    EdgeInsets? padding = params['padding'];
    bool isEnabled = params['isEnabled'];
    String? hintText = params['hintText'];
    String quillJsScript = params['script'];
    InputAction? inputAction = params['inputAction'];
    return """
       <!DOCTYPE html>
        <html>
        <head>
        <link href="https://fonts.googleapis.com/css?family=$encodedStyle:400,400i,700,700i" rel="stylesheet">
        <meta name="viewport" content="width=device-width, initial-scale=1, minimum-scale=1, maximum-scale=1">    
        
       <!-- Include the Quill library --> 
      <script src="https://cdn.jsdelivr.net/npm/quill@2.0.3/dist/quill.js"></script>
        <script src = "https://www.youtube.com/iframe_api">
        </script>
        <script>
        $quillJsScript
        </script>
        <style>
        /*!
       * Quill Editor v2.0.0-dev.3
       * https://quilljs.com/
       * Copyright (c) 2014, Jason Chen
       * Copyright (c) 2013, salesforce.com
       */
      .ql-container{box-sizing:border-box;font-family:Helvetica,Arial,sans-serif;font-size:13px;height:100%;margin:0;position:relative}.ql-container.ql-disabled .ql-tooltip{visibility:hidden}.ql-container:not(.ql-disabled) li[data-list=checked]>.ql-ui,.ql-container:not(.ql-disabled) li[data-list=unchecked]>.ql-ui{cursor:pointer}.ql-clipboard{left:-100000px;height:1px;overflow-y:hidden;position:absolute;top:50%}.ql-clipboard p{margin:0;padding:0}.ql-editor{box-sizing:border-box;counter-reset:list-0;line-height:1.42;height:100%;outline:0;overflow-y:auto;padding:12px 15px;tab-size:4;-moz-tab-size:4;text-align:left;white-space:pre-wrap;word-wrap:break-word}.ql-editor>*{cursor:text}.ql-editor blockquote,.ql-editor h1,.ql-editor h2,.ql-editor h3,.ql-editor h4,.ql-editor h5,.ql-editor h6,.ql-editor ol,.ql-editor p,.ql-editor pre{margin:0;padding:0}.ql-editor h1,.ql-editor h2,.ql-editor h3,.ql-editor h4,.ql-editor h5,.ql-editor h6,.ql-editor p{counter-reset:list-0 list-1 list-2 list-3 list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor table{border-collapse:collapse}.ql-editor td{border:1px solid #000;padding:2px 5px}.ql-editor ol{padding-left:1.5em}.ql-editor li{list-style-type:none;padding-left:1.5em;position:relative}.ql-editor li>.ql-ui:before{display:inline-block;margin-left:-1.5em;margin-right:.3em;text-align:right;white-space:nowrap;width:1.2em}.ql-editor li[data-list=checked]>.ql-ui,.ql-editor li[data-list=unchecked]>.ql-ui{color:#777}.ql-editor li[data-list=bullet]>.ql-ui:before{content:'\\2022'}.ql-editor li[data-list=checked]>.ql-ui:before{content:'\\2611'}.ql-editor li[data-list=unchecked]>.ql-ui:before{content:'\\2610'}.ql-editor li[data-list=ordered]{counter-reset:list-1 list-2 list-3 list-4 list-5 list-6 list-7 list-8 list-9;counter-increment:list-0}.ql-editor li[data-list=ordered]>.ql-ui:before{content:counter(list-0,decimal) '. '}.ql-editor li[data-list=ordered].ql-indent-1{counter-increment:list-1}.ql-editor li[data-list=ordered].ql-indent-1>.ql-ui:before{content:counter(list-1,lower-alpha) '. '}.ql-editor li[data-list=ordered].ql-indent-1{counter-reset:list-2 list-3 list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor li[data-list=ordered].ql-indent-2{counter-increment:list-2}.ql-editor li[data-list=ordered].ql-indent-2>.ql-ui:before{content:counter(list-2,lower-roman) '. '}.ql-editor li[data-list=ordered].ql-indent-2{counter-reset:list-3 list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor li[data-list=ordered].ql-indent-3{counter-increment:list-3}.ql-editor li[data-list=ordered].ql-indent-3>.ql-ui:before{content:counter(list-3,decimal) '. '}.ql-editor li[data-list=ordered].ql-indent-3{counter-reset:list-4 list-5 list-6 list-7 list-8 list-9}.ql-editor li[data-list=ordered].ql-indent-4{counter-increment:list-4}.ql-editor li[data-list=ordered].ql-indent-4>.ql-ui:before{content:counter(list-4,lower-alpha) '. '}.ql-editor li[data-list=ordered].ql-indent-4{counter-reset:list-5 list-6 list-7 list-8 list-9}.ql-editor li[data-list=ordered].ql-indent-5{counter-increment:list-5}.ql-editor li[data-list=ordered].ql-indent-5>.ql-ui:before{content:counter(list-5,lower-roman) '. '}.ql-editor li[data-list=ordered].ql-indent-5{counter-reset:list-6 list-7 list-8 list-9}.ql-editor li[data-list=ordered].ql-indent-6{counter-increment:list-6}.ql-editor li[data-list=ordered].ql-indent-6>.ql-ui:before{content:counter(list-6,decimal) '. '}.ql-editor li[data-list=ordered].ql-indent-6{counter-reset:list-7 list-8 list-9}.ql-editor li[data-list=ordered].ql-indent-7{counter-increment:list-7}.ql-editor li[data-list=ordered].ql-indent-7>.ql-ui:before{content:counter(list-7,lower-alpha) '. '}.ql-editor li[data-list=ordered].ql-indent-7{counter-reset:list-8 list-9}.ql-editor li[data-list=ordered].ql-indent-8{counter-increment:list-8}.ql-editor li[data-list=ordered].ql-indent-8>.ql-ui:before{content:counter(list-8,lower-roman) '. '}.ql-editor li[data-list=ordered].ql-indent-8{counter-reset:list-9}.ql-editor li[data-list=ordered].ql-indent-9{counter-increment:list-9}.ql-editor li[data-list=ordered].ql-indent-9>.ql-ui:before{content:counter(list-9,decimal) '. '}.ql-editor .ql-indent-1:not(.ql-direction-rtl){padding-left:3em}.ql-editor li.ql-indent-1:not(.ql-direction-rtl){padding-left:4.5em}.ql-editor .ql-indent-1.ql-direction-rtl.ql-align-right{padding-right:3em}.ql-editor li.ql-indent-1.ql-direction-rtl.ql-align-right{padding-right:4.5em}.ql-editor .ql-indent-2:not(.ql-direction-rtl){padding-left:6em}.ql-editor li.ql-indent-2:not(.ql-direction-rtl){padding-left:7.5em}.ql-editor .ql-indent-2.ql-direction-rtl.ql-align-right{padding-right:6em}.ql-editor li.ql-indent-2.ql-direction-rtl.ql-align-right{padding-right:7.5em}.ql-editor .ql-indent-3:not(.ql-direction-rtl){padding-left:9em}.ql-editor li.ql-indent-3:not(.ql-direction-rtl){padding-left:10.5em}.ql-editor .ql-indent-3.ql-direction-rtl.ql-align-right{padding-right:9em}.ql-editor li.ql-indent-3.ql-direction-rtl.ql-align-right{padding-right:10.5em}.ql-editor .ql-indent-4:not(.ql-direction-rtl){padding-left:12em}.ql-editor li.ql-indent-4:not(.ql-direction-rtl){padding-left:13.5em}.ql-editor .ql-indent-4.ql-direction-rtl.ql-align-right{padding-right:12em}.ql-editor li.ql-indent-4.ql-direction-rtl.ql-align-right{padding-right:13.5em}.ql-editor .ql-indent-5:not(.ql-direction-rtl){padding-left:15em}.ql-editor li.ql-indent-5:not(.ql-direction-rtl){padding-left:16.5em}.ql-editor .ql-indent-5.ql-direction-rtl.ql-align-right{padding-right:15em}.ql-editor li.ql-indent-5.ql-direction-rtl.ql-align-right{padding-right:16.5em}.ql-editor .ql-indent-6:not(.ql-direction-rtl){padding-left:18em}.ql-editor li.ql-indent-6:not(.ql-direction-rtl){padding-left:19.5em}.ql-editor .ql-indent-6.ql-direction-rtl.ql-align-right{padding-right:18em}.ql-editor li.ql-indent-6.ql-direction-rtl.ql-align-right{padding-right:19.5em}.ql-editor .ql-indent-7:not(.ql-direction-rtl){padding-left:21em}.ql-editor li.ql-indent-7:not(.ql-direction-rtl){padding-left:22.5em}.ql-editor .ql-indent-7.ql-direction-rtl.ql-align-right{padding-right:21em}.ql-editor li.ql-indent-7.ql-direction-rtl.ql-align-right{padding-right:22.5em}.ql-editor .ql-indent-8:not(.ql-direction-rtl){padding-left:24em}.ql-editor li.ql-indent-8:not(.ql-direction-rtl){padding-left:25.5em}.ql-editor .ql-indent-8.ql-direction-rtl.ql-align-right{padding-right:24em}.ql-editor li.ql-indent-8.ql-direction-rtl.ql-align-right{padding-right:25.5em}.ql-editor .ql-indent-9:not(.ql-direction-rtl){padding-left:27em}.ql-editor li.ql-indent-9:not(.ql-direction-rtl){padding-left:28.5em}.ql-editor .ql-indent-9.ql-direction-rtl.ql-align-right{padding-right:27em}.ql-editor li.ql-indent-9.ql-direction-rtl.ql-align-right{padding-right:28.5em}.ql-editor li.ql-direction-rtl{padding-right:1.5em}.ql-editor li.ql-direction-rtl>.ql-ui:before{margin-left:.3em;margin-right:-1.5em;text-align:left}.ql-editor table{table-layout:fixed;width:100%}.ql-editor table td{outline:0}.ql-editor .ql-code-block-container{font-family:monospace}.ql-editor .ql-video{display:block;max-width:100%}.ql-editor .ql-video.ql-align-center{margin:0 auto}.ql-editor .ql-video.ql-align-right{margin:0 0 0 auto}.ql-editor .ql-bg-black{background-color:#000}.ql-editor .ql-bg-red{background-color:#e60000}.ql-editor .ql-bg-orange{background-color:#f90}.ql-editor .ql-bg-yellow{background-color:#ff0}.ql-editor .ql-bg-green{background-color:#008a00}.ql-editor .ql-bg-blue{background-color:#06c}.ql-editor .ql-bg-purple{background-color:#93f}.ql-editor .ql-color-white{color:#fff}.ql-editor .ql-color-red{color:#e60000}.ql-editor .ql-color-orange{color:#f90}.ql-editor .ql-color-yellow{color:#ff0}.ql-editor .ql-color-green{color:#008a00}.ql-editor .ql-color-blue{color:#06c}.ql-editor .ql-color-purple{color:#93f}.ql-editor .ql-font-serif{font-family:Georgia,Times New Roman,serif}.ql-editor .ql-font-monospace{font-family:Monaco,Courier New,monospace}.ql-editor .ql-size-small{font-size:.75em}.ql-editor .ql-size-large{font-size:1.5em}.ql-editor .ql-size-huge{font-size:2.5em}.ql-editor .ql-direction-rtl{direction:rtl;text-align:inherit}.ql-editor .ql-align-center{text-align:center}.ql-editor .ql-align-justify{text-align:justify}.ql-editor .ql-align-right{text-align:right}.ql-editor .ql-ui{position:absolute}.ql-editor.ql-blank::before{color:rgba(0,0,0,.6);content:attr(data-placeholder);font-style:italic;left:15px;pointer-events:none;position:absolute;right:15px}.ql-snow .ql-toolbar:after,.ql-snow.ql-toolbar:after{clear:both;content:'';display:table}.ql-snow .ql-toolbar button,.ql-snow.ql-toolbar button{background:0 0;border:none;cursor:pointer;display:inline-block;float:left;height:24px;padding:3px 5px;width:28px}.ql-snow .ql-toolbar button svg,.ql-snow.ql-toolbar button svg{float:left;height:100%}.ql-snow .ql-toolbar button:active:hover,.ql-snow.ql-toolbar button:active:hover{outline:0}.ql-snow .ql-toolbar input.ql-image[type=file],.ql-snow.ql-toolbar input.ql-image[type=file]{display:none}.ql-snow .ql-toolbar .ql-picker-item.ql-selected,.ql-snow .ql-toolbar .ql-picker-item:hover,.ql-snow .ql-toolbar .ql-picker-label.ql-active,.ql-snow .ql-toolbar .ql-picker-label:hover,.ql-snow .ql-toolbar button.ql-active,.ql-snow .ql-toolbar button:focus,.ql-snow .ql-toolbar button:hover,.ql-snow.ql-toolbar .ql-picker-item.ql-selected,.ql-snow.ql-toolbar .ql-picker-item:hover,.ql-snow.ql-toolbar .ql-picker-label.ql-active,.ql-snow.ql-toolbar .ql-picker-label:hover,.ql-snow.ql-toolbar button.ql-active,.ql-snow.ql-toolbar button:focus,.ql-snow.ql-toolbar button:hover{color:#06c}.ql-snow .ql-toolbar .ql-picker-item.ql-selected .ql-fill,.ql-snow .ql-toolbar .ql-picker-item.ql-selected .ql-stroke.ql-fill,.ql-snow .ql-toolbar .ql-picker-item:hover .ql-fill,.ql-snow .ql-toolbar .ql-picker-item:hover .ql-stroke.ql-fill,.ql-snow .ql-toolbar .ql-picker-label.ql-active .ql-fill,.ql-snow .ql-toolbar .ql-picker-label.ql-active .ql-stroke.ql-fill,.ql-snow .ql-toolbar .ql-picker-label:hover .ql-fill,.ql-snow .ql-toolbar .ql-picker-label:hover .ql-stroke.ql-fill,.ql-snow .ql-toolbar button.ql-active .ql-fill,.ql-snow .ql-toolbar button.ql-active .ql-stroke.ql-fill,.ql-snow .ql-toolbar button:focus .ql-fill,.ql-snow .ql-toolbar button:focus .ql-stroke.ql-fill,.ql-snow .ql-toolbar button:hover .ql-fill,.ql-snow .ql-toolbar button:hover .ql-stroke.ql-fill,.ql-snow.ql-toolbar .ql-picker-item.ql-selected .ql-fill,.ql-snow.ql-toolbar .ql-picker-item.ql-selected .ql-stroke.ql-fill,.ql-snow.ql-toolbar .ql-picker-item:hover .ql-fill,.ql-snow.ql-toolbar .ql-picker-item:hover .ql-stroke.ql-fill,.ql-snow.ql-toolbar .ql-picker-label.ql-active .ql-fill,.ql-snow.ql-toolbar .ql-picker-label.ql-active .ql-stroke.ql-fill,.ql-snow.ql-toolbar .ql-picker-label:hover .ql-fill,.ql-snow.ql-toolbar .ql-picker-label:hover .ql-stroke.ql-fill,.ql-snow.ql-toolbar button.ql-active .ql-fill,.ql-snow.ql-toolbar button.ql-active .ql-stroke.ql-fill,.ql-snow.ql-toolbar button:focus .ql-fill,.ql-snow.ql-toolbar button:focus .ql-stroke.ql-fill,.ql-snow.ql-toolbar button:hover .ql-fill,.ql-snow.ql-toolbar button:hover .ql-stroke.ql-fill{fill:#06c}.ql-snow .ql-toolbar .ql-picker-item.ql-selected .ql-stroke,.ql-snow .ql-toolbar .ql-picker-item.ql-selected .ql-stroke-miter,.ql-snow .ql-toolbar .ql-picker-item:hover .ql-stroke,.ql-snow .ql-toolbar .ql-picker-item:hover .ql-stroke-miter,.ql-snow .ql-toolbar .ql-picker-label.ql-active .ql-stroke,.ql-snow .ql-toolbar .ql-picker-label.ql-active .ql-stroke-miter,.ql-snow .ql-toolbar .ql-picker-label:hover .ql-stroke,.ql-snow .ql-toolbar .ql-picker-label:hover .ql-stroke-miter,.ql-snow .ql-toolbar button.ql-active .ql-stroke,.ql-snow .ql-toolbar button.ql-active .ql-stroke-miter,.ql-snow .ql-toolbar button:focus .ql-stroke,.ql-snow .ql-toolbar button:focus .ql-stroke-miter,.ql-snow .ql-toolbar button:hover .ql-stroke,.ql-snow .ql-toolbar button:hover .ql-stroke-miter,.ql-snow.ql-toolbar .ql-picker-item.ql-selected .ql-stroke,.ql-snow.ql-toolbar .ql-picker-item.ql-selected .ql-stroke-miter,.ql-snow.ql-toolbar .ql-picker-item:hover .ql-stroke,.ql-snow.ql-toolbar .ql-picker-item:hover .ql-stroke-miter,.ql-snow.ql-toolbar .ql-picker-label.ql-active .ql-stroke,.ql-snow.ql-toolbar .ql-picker-label.ql-active .ql-stroke-miter,.ql-snow.ql-toolbar .ql-picker-label:hover .ql-stroke,.ql-snow.ql-toolbar .ql-picker-label:hover .ql-stroke-miter,.ql-snow.ql-toolbar button.ql-active .ql-stroke,.ql-snow.ql-toolbar button.ql-active .ql-stroke-miter,.ql-snow.ql-toolbar button:focus .ql-stroke,.ql-snow.ql-toolbar button:focus .ql-stroke-miter,.ql-snow.ql-toolbar button:hover .ql-stroke,.ql-snow.ql-toolbar button:hover .ql-stroke-miter{stroke:#06c}@media (pointer:coarse){.ql-snow .ql-toolbar button:hover:not(.ql-active),.ql-snow.ql-toolbar button:hover:not(.ql-active){color:#444}.ql-snow .ql-toolbar button:hover:not(.ql-active) .ql-fill,.ql-snow .ql-toolbar button:hover:not(.ql-active) .ql-stroke.ql-fill,.ql-snow.ql-toolbar button:hover:not(.ql-active) .ql-fill,.ql-snow.ql-toolbar button:hover:not(.ql-active) .ql-stroke.ql-fill{fill:#444}.ql-snow .ql-toolbar button:hover:not(.ql-active) .ql-stroke,.ql-snow .ql-toolbar button:hover:not(.ql-active) .ql-stroke-miter,.ql-snow.ql-toolbar button:hover:not(.ql-active) .ql-stroke,.ql-snow.ql-toolbar button:hover:not(.ql-active) .ql-stroke-miter{stroke:#444}}.ql-snow{box-sizing:border-box}.ql-snow *{box-sizing:border-box}.ql-snow .ql-hidden{display:none}.ql-snow .ql-out-bottom,.ql-snow .ql-out-top{visibility:hidden}.ql-snow .ql-tooltip{position:absolute;transform:translateY(10px)}.ql-snow .ql-tooltip a{cursor:pointer;text-decoration:none}.ql-snow .ql-tooltip.ql-flip{transform:translateY(-10px)}.ql-snow .ql-formats{display:inline-block;vertical-align:middle}.ql-snow .ql-formats:after{clear:both;content:'';display:table}.ql-snow .ql-stroke{fill:none;stroke:#444;stroke-linecap:round;stroke-linejoin:round;stroke-width:2}.ql-snow .ql-stroke-miter{fill:none;stroke:#444;stroke-miterlimit:10;stroke-width:2}.ql-snow .ql-fill,.ql-snow .ql-stroke.ql-fill{fill:#444}.ql-snow .ql-empty{fill:none}.ql-snow .ql-even{fill-rule:evenodd}.ql-snow .ql-stroke.ql-thin,.ql-snow .ql-thin{stroke-width:1}.ql-snow .ql-transparent{opacity:.4}.ql-snow .ql-direction svg:last-child{display:none}.ql-snow .ql-direction.ql-active svg:last-child{display:inline}.ql-snow .ql-direction.ql-active svg:first-child{display:none}.ql-snow .ql-editor h1{font-size:2em}.ql-snow .ql-editor h2{font-size:1.5em}.ql-snow .ql-editor h3{font-size:1.17em}.ql-snow .ql-editor h4{font-size:1em}.ql-snow .ql-editor h5{font-size:.83em}.ql-snow .ql-editor h6{font-size:.67em}.ql-snow .ql-editor a{text-decoration:underline}.ql-snow .ql-editor blockquote{border-left:4px solid #ccc;margin-bottom:5px;margin-top:5px;padding-left:16px}.ql-snow .ql-editor .ql-code-block-container,.ql-snow .ql-editor code{background-color:#f0f0f0;border-radius:3px}.ql-snow .ql-editor .ql-code-block-container{margin-bottom:5px;margin-top:5px;padding:5px 10px}.ql-snow .ql-editor code{font-size:85%;padding:2px 4px}.ql-snow .ql-editor .ql-code-block-container{background-color:#23241f;color:#f8f8f2;overflow:visible}.ql-snow .ql-editor img{max-width:100%}.ql-snow .ql-picker{color:#444;display:inline-block;float:left;font-size:14px;font-weight:500;height:24px;position:relative;vertical-align:middle}.ql-snow .ql-picker-label{cursor:pointer;display:inline-block;height:100%;padding-left:8px;padding-right:2px;position:relative;width:100%}.ql-snow .ql-picker-label::before{display:inline-block;line-height:22px}.ql-snow .ql-picker-options{background-color:#fff;display:none;min-width:100%;padding:4px 8px;position:absolute;white-space:nowrap}.ql-snow .ql-picker-options .ql-picker-item{cursor:pointer;display:block;padding-bottom:5px;padding-top:5px}.ql-snow .ql-picker.ql-expanded .ql-picker-label{color:#ccc;z-index:2}.ql-snow .ql-picker.ql-expanded .ql-picker-label .ql-fill{fill:#ccc}.ql-snow .ql-picker.ql-expanded .ql-picker-label .ql-stroke{stroke:#ccc}.ql-snow .ql-picker.ql-expanded .ql-picker-options{display:block;margin-top:-1px;top:100%;z-index:1}.ql-snow .ql-color-picker,.ql-snow .ql-icon-picker{width:28px}.ql-snow .ql-color-picker .ql-picker-label,.ql-snow .ql-icon-picker .ql-picker-label{padding:2px 4px}.ql-snow .ql-color-picker .ql-picker-label svg,.ql-snow .ql-icon-picker .ql-picker-label svg{right:4px}.ql-snow .ql-icon-picker .ql-picker-options{padding:4px 0}.ql-snow .ql-icon-picker .ql-picker-item{height:24px;width:24px;padding:2px 4px}.ql-snow .ql-color-picker .ql-picker-options{padding:3px 5px;width:152px}.ql-snow .ql-color-picker .ql-picker-item{border:1px solid transparent;float:left;height:16px;margin:2px;padding:0;width:16px}.ql-snow .ql-picker:not(.ql-color-picker):not(.ql-icon-picker) svg{position:absolute;margin-top:-9px;right:0;top:50%;width:18px}.ql-snow .ql-picker.ql-font .ql-picker-item[data-label]:not([data-label=''])::before,.ql-snow .ql-picker.ql-font .ql-picker-label[data-label]:not([data-label=''])::before,.ql-snow .ql-picker.ql-header .ql-picker-item[data-label]:not([data-label=''])::before,.ql-snow .ql-picker.ql-header .ql-picker-label[data-label]:not([data-label=''])::before,.ql-snow .ql-picker.ql-size .ql-picker-item[data-label]:not([data-label=''])::before,.ql-snow .ql-picker.ql-size .ql-picker-label[data-label]:not([data-label=''])::before{content:attr(data-label)}.ql-snow .ql-picker.ql-header{width:98px}.ql-snow .ql-picker.ql-header .ql-picker-item::before,.ql-snow .ql-picker.ql-header .ql-picker-label::before{content:'Normal'}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="1"]::before,.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="1"]::before{content:'Heading 1'}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="2"]::before,.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="2"]::before{content:'Heading 2'}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="3"]::before,.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="3"]::before{content:'Heading 3'}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="4"]::before,.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="4"]::before{content:'Heading 4'}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="5"]::before,.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="5"]::before{content:'Heading 5'}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="6"]::before,.ql-snow .ql-picker.ql-header .ql-picker-label[data-value="6"]::before{content:'Heading 6'}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="1"]::before{font-size:2em}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="2"]::before{font-size:1.5em}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="3"]::before{font-size:1.17em}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="4"]::before{font-size:1em}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="5"]::before{font-size:.83em}.ql-snow .ql-picker.ql-header .ql-picker-item[data-value="6"]::before{font-size:.67em}.ql-snow .ql-picker.ql-font{width:108px}.ql-snow .ql-picker.ql-font .ql-picker-item::before,.ql-snow .ql-picker.ql-font .ql-picker-label::before{content:'Sans Serif'}.ql-snow .ql-picker.ql-font .ql-picker-item[data-value=serif]::before,.ql-snow .ql-picker.ql-font .ql-picker-label[data-value=serif]::before{content:'Serif'}.ql-snow .ql-picker.ql-font .ql-picker-item[data-value=monospace]::before,.ql-snow .ql-picker.ql-font .ql-picker-label[data-value=monospace]::before{content:'Monospace'}.ql-snow .ql-picker.ql-font .ql-picker-item[data-value=serif]::before{font-family:Georgia,Times New Roman,serif}.ql-snow .ql-picker.ql-font .ql-picker-item[data-value=monospace]::before{font-family:Monaco,Courier New,monospace}.ql-snow .ql-picker.ql-size{width:98px}.ql-snow .ql-picker.ql-size .ql-picker-item::before,.ql-snow .ql-picker.ql-size .ql-picker-label::before{content:'Normal'}.ql-snow .ql-picker.ql-size .ql-picker-item[data-value=small]::before,.ql-snow .ql-picker.ql-size .ql-picker-label[data-value=small]::before{content:'Small'}.ql-snow .ql-picker.ql-size .ql-picker-item[data-value=large]::before,.ql-snow .ql-picker.ql-size .ql-picker-label[data-value=large]::before{content:'Large'}.ql-snow .ql-picker.ql-size .ql-picker-item[data-value=huge]::before,.ql-snow .ql-picker.ql-size .ql-picker-label[data-value=huge]::before{content:'Huge'}.ql-snow .ql-picker.ql-size .ql-picker-item[data-value=small]::before{font-size:10px}.ql-snow .ql-picker.ql-size .ql-picker-item[data-value=large]::before{font-size:18px}.ql-snow .ql-picker.ql-size .ql-picker-item[data-value=huge]::before{font-size:32px}.ql-snow .ql-color-picker.ql-background .ql-picker-item{background-color:#fff}.ql-snow .ql-color-picker.ql-color .ql-picker-item{background-color:#000}.ql-code-block-container{position:relative}.ql-code-block-container .ql-ui{right:5px;top:5px}.ql-toolbar.ql-snow{border:1px solid #ccc;box-sizing:border-box;font-family:'Helvetica Neue',Helvetica,Arial,sans-serif;padding:8px}.ql-toolbar.ql-snow .ql-formats{margin-right:15px}.ql-toolbar.ql-snow .ql-picker-label{border:1px solid transparent}.ql-toolbar.ql-snow .ql-picker-options{border:1px solid transparent;box-shadow:rgba(0,0,0,.2) 0 2px 8px}.ql-toolbar.ql-snow .ql-picker.ql-expanded .ql-picker-label{border-color:#ccc}.ql-toolbar.ql-snow .ql-picker.ql-expanded .ql-picker-options{border-color:#ccc}.ql-toolbar.ql-snow .ql-color-picker .ql-picker-item.ql-selected,.ql-toolbar.ql-snow .ql-color-picker .ql-picker-item:hover{border-color:#000}.ql-toolbar.ql-snow+.ql-container.ql-snow{border-top:0}.ql-snow .ql-tooltip{background-color:#fff;border:1px solid #ccc;box-shadow:0 0 5px #ddd;color:#444;padding:5px 12px;white-space:nowrap}.ql-snow .ql-tooltip::before{content:"Visit URL:";line-height:26px;margin-right:8px}.ql-snow .ql-tooltip input[type=text]{display:none;border:1px solid #ccc;font-size:13px;height:26px;margin:0;padding:3px 5px;width:170px}.ql-snow .ql-tooltip a.ql-preview{display:inline-block;max-width:200px;overflow-x:hidden;text-overflow:ellipsis;vertical-align:top}.ql-snow .ql-tooltip a.ql-action::after{border-right:1px solid #ccc;content:'Edit';margin-left:16px;padding-right:8px}.ql-snow .ql-tooltip a.ql-remove::before{content:'Remove';margin-left:8px}.ql-snow .ql-tooltip a{line-height:26px}.ql-snow .ql-tooltip.ql-editing a.ql-preview,.ql-snow .ql-tooltip.ql-editing a.ql-remove{display:none}.ql-snow .ql-tooltip.ql-editing input[type=text]{display:inline-block}.ql-snow .ql-tooltip.ql-editing a.ql-action::after{border-right:0;content:'Save';padding-right:0}.ql-snow .ql-tooltip[data-mode=link]::before{content:"Enter link:"}.ql-snow .ql-tooltip[data-mode=formula]::before{content:"Enter formula:"}.ql-snow .ql-tooltip[data-mode=video]::before{content:"Enter video:"}.ql-snow a{color:#06c}.ql-container.ql-snow{border:1px solid #ccc}
        
        body {
        max-width: 100%;
        overflow-x: hidden;
        }, html{
         font-family: "$fontFamily", sans-serif !important;
        -webkit-user-select: text !important;
        margin:0px !important;
        background-color:${backgroundColor.toRGBA()};
        color: ${backgroundColor.toRGBA()};
        }
        .ql-font-roboto {
           font-family: '$fontFamily', sans-serif;
          }
        .ql-editor.ql-blank::before{
         font-family: "$fontFamily", sans-serif !important;
        -webkit-user-select: text !important;
          padding-left:${hintTextPadding?.left ?? '0'}px !important;
          padding-right:${hintTextPadding?.right ?? '0'}px !important;
          padding-top:${hintTextPadding?.top ?? '0'}px !important;
          padding-bottom:${hintTextPadding?.bottom ?? '0'}px !important;
          position: center;
          left:0px;
          text-align: ${StringUtil.getCssTextAlign(hintTextAlign)};
          font-size: ${hintTextStyle?.fontSize ?? '14'}px;
          color:${(hintTextStyle?.color ?? Colors.black).toRGBA()};
          background-color:${backgroundColor.toRGBA()};
          font-style: ${StringUtil.getCssFontStyle(hintTextStyle?.fontStyle)};
          font-weight: ${StringUtil.getCssFontWeight(hintTextStyle?.fontWeight)};
          
        }
        .ql-container.ql-snow{
         font-family: "$fontFamily", sans-serif !important;
        -webkit-user-select: text !important;
          white-space:nowrap !important;
          margin-top:0px !important;
          margin-bottom:0px !important;
          margin:0px !important;
          width:100%;
          border:none;
          font-style: ${StringUtil.getCssFontStyle(textStyle?.fontStyle)};
          font-size: ${textStyle?.fontSize ?? '14'}px;
          color:${(textStyle!.color ?? Colors.black).toRGBA()};
          background-color:${backgroundColor.toRGBA()};
          font-weight: ${StringUtil.getCssFontWeight(textStyle.fontWeight)};
          padding-left:${padding?.left ?? '0'}px;
          padding-right:${padding?.right ?? '0'}px;
          padding-top:${padding?.top ?? '0'}px;
          padding-bottom:${padding?.bottom ?? '0'}px;
          min-height:100%;
          min-width:100%        
          contenteditable: true !important;
          data-gramm: false !important;
         
        }
        .ql-editor { 
         font-family: "$fontFamily", sans-serif !important;
          -webkit-user-select: text !important;
          padding-left:${padding?.left ?? '0'}px !important;
          padding-right:${padding?.right ?? '0'}px !important;
          padding-top:${padding?.top ?? '0'}px !important;
          padding-bottom:${padding?.bottom ?? '0'}px !important;
        }
        .ql-toolbar { 
          position: absolute; 
          top: 0;
          left:0;
          right:0
        }
        .ql-tooltip{
          display:none; 
        }   
        .ql-editor.ql-blank:focus::before {
          content: '';
          }
        #toolbar-container{
         display:none;
        }     
        #scrolling-container {  
        overflow-y: scroll  !important;
          min-height: ${minHeight}px !important;
          -webkit-user-select: text !important;
           scrollbar-width: none !important; 
         } 
         #scroll-container::-webkit-scrollbar {
            display: none !important; /* For Chrome, Safari, and Opera */
          }
         ::-webkit-scrollbar {
          width: 0;  /* Remove scrollbar space */
          background: transparent;  /* Optional: just make scrollbar invisible */
          } 
        </style>
   
        </head>
        <body>
         <script>
           const resizeObserver = new ResizeObserver(entries =>{
            ///console.log("Offset height has changed:", (entries[0].target.clientHeight).toString())
                if($kIsWeb) {
                  EditorResizeCallback((entries[0].target.clientHeight).toString());
                } else {
                  EditorResizeCallback.postMessage((entries[0].target.clientHeight).toString());
                }            
            })
            resizeObserver.observe(document.body)
          </script>
         <script>
          let isTextSelectionInProgress = false;

          // Event handler for text selection start
          function handleTextSelectionStart() {
              isTextSelectionInProgress = true;
             // console.log("Text selection started.");
          }
  
          // Event handler for text selection end
          function handleTextSelectionEnd() {
              isTextSelectionInProgress = false;
             // console.log("Text selection ended.");
          }
  
          // Check if text is being selected while dragging the mouse
          function handleMouseMove(event) {
              if (isTextSelectionInProgress) {
                  // Do something when the text is being selected (dragging the mouse while text is selected)
                  window.getSelection();
              }
          }
  
          // Attach event listeners
          document.addEventListener("mousedown", handleTextSelectionStart);
          document.addEventListener("mouseup", handleTextSelectionEnd);
          document.addEventListener("mousemove", handleMouseMove);
         
         </script> 
        <!-- Create the toolbar container -->
        <div id="scrolling-container">
        <div id="toolbar-container"></div>
        
        <!-- Create the editor container -->
        <div style="position:relative;margin-top:0em;">
        <div id="editorcontainer" style= "min-height:${minHeight}px;margin-top:0em;">
        <div id="editor" style="min-height:${minHeight}px; width:100%;"></div>
        </div>
        </div> 
        </div>
      
        <!-- Initialize Quill editor -->
        <script>                       
            // Retrieve the Quill editor container element by its ID
            var quillContainer = document.getElementById('scrolling-container');
            
            // Add the focusout event listener to the Quill editor container
            quillContainer.addEventListener('focusout', function() {
                 if($kIsWeb) {
                FocusChanged(false);
              } else {
                FocusChanged.postMessage(false);
              }
            });
            
             quillContainer.addEventListener('focusin', () => {
               if($kIsWeb) {
                FocusChanged(true);
              } else {
                FocusChanged.postMessage(true);
              }
             });
             quillContainer.addEventListener('click', function() {
              quilleditor.focus(); // Set focus on the Quill editor
              });
             
             /*quilleditor.root.addEventListener("blur", function() {
               if($kIsWeb) {
                FocusChanged(false);
                } else {
                var focus  = quilleditor.hasFocus();
                  FocusChanged.postMessage(isQuillFocused());
                }
            });
            
            quilleditor.root.addEventListener("focus", function() {
               if($kIsWeb) {
                FocusChanged(true);
              } else {
              var focus  = quilleditor.hasFocus();
                FocusChanged.postMessage(isQuillFocused());
              }
            });*/
         
            function applyGoogleKeyboardWorkaround(editor) {
              try {
              
                let isIOS = /iPad|iPhone|iPod/.test(navigator.platform) || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1)

                if($kIsWeb || isIOS){
                  return;
                }
                if(editor.applyGoogleKeyboardWorkaround) {
                  return
                }
                editor.applyGoogleKeyboardWorkaround = true
                editor.on('editor-change', function(eventName, ...args) {
                  try {
                    // args[0] will be delta
                    var ops = args[0]['ops']
                    if(ops === null) {
                      return
                    }
                    var oldSelection = editor.getSelection(true)
                    var oldPos = oldSelection.index
                    var oldSelectionLength = oldSelection.length
                    if( ops[0]["retain"] === undefined || !ops[1] || !ops[1]["insert"] || !ops[1]["insert"] || ops[1]["list"] === "bullet" || ops[1]["list"] === "ordered" || ops[1]["insert"] != "\\n" || oldSelectionLength > 0) {
                      return
                    }
                    
                    setTimeout(function() {
                      var newPos = editor.getSelection(true).index
                      if(newPos === oldPos) {
                      console.log('newPos oldPos');
                        editor.setSelection(editor.getSelection(true).index + 1, 0)
                      }
                    }, 30);
                    //onRangeChanged();
                  } catch(e) {
                    console.log('applyGoogleKeyboardWorkaround - editor-change', e);
                  }
                });
              } catch(e) {
                console.log('applyGoogleKeyboardWorkaround', e);
              } 
            }
            
            /// observer to listen to the editor div changes 
            // select the target node
            var target = document.querySelector('#editor');
            
            // create an observer instance
            var tempText = "";
            var observer = new MutationObserver(function(mutations) {
                 var text = quilleditor.root.innerHTML; 
                 console.log('#################testing the mutation observers!!!')
                 if(text != tempText){
                      tempText = text;
                      console.log(`\${text}`);
                     if($kIsWeb) {                  
                      OnTextChanged(text);
                      } else {
                      OnTextChanged.postMessage(text);
                    }                     
                     onRangeChanged(); 
                     quilleditor.focus();
                 } 

            });

            // configuration of the observer:
            var config = { attributes: true, childList: true, characterData: true, subtree: true };

            // pass in the target node, as well as the observer options
            observer.observe(target, config);
    
           // stops the listener
           //// observer.disconnect();
          
        
           //// to accept all link formats 
           var Link = Quill.import('formats/link');
              Link.sanitize = function(url) {
                // modify url if desired
                return url;
              }
             Quill.register(Link, true);
           
            /// quill custom font import
            var FontStyle = Quill.import('attributors/class/font');
            Quill.register(FontStyle, true);

            
            const Inline = Quill.import('blots/inline');
            class RequirementBlot extends Inline {}
            RequirementBlot.blotName = 'requirement';
            RequirementBlot.tagName = 'requirement';
            Quill.register(RequirementBlot);
            
            class ResponsibilityBlot extends Inline {}
            ResponsibilityBlot.blotName = 'responsibility';
            ResponsibilityBlot.tagName = 'responsibility';
            Quill.register(ResponsibilityBlot);
            
             ///// quill shift enter key binding      
              var bindings = {
                  linebreak: {
                      key: 13,
                      shiftKey: true,
                      handler: function(range) {
                          this.quill.insertEmbed(range.index, 'breaker', true, Quill.sources.USER);
                          this.quill.setSelection(range.index + 1, Quill.sources.SILENT);
                          return false;
                      }
                  },
                  enter: {
                      key: 'Enter',
                      handler: () => {
                         if($kIsWeb) {
                          OnEditingCompleted(quilleditor.root.innerHTML);
                          } else {
                          OnEditingCompleted.postMessage(quilleditor.root.innerHTML);
                          }
                      }
                  }
              };

              //  let Block = Quill.import('blots/block');

              // class Division extends Block {
              //  static tagName = 'div';
              //  static blotName = 'division';
              // }
              // Quill.register(Division); 


              let Embed = Quill.import('blots/embed');
              
              class Breaker extends Embed {
                  static tagName = 'br';
                  static blotName = 'breaker';
              }
              Quill.register(Breaker);

            var quilleditor = new Quill('#editor', {
              modules: {
                toolbar: '#toolbar-container',
                table: true,
                 keyboard:  ${inputAction == InputAction.send ? '{bindings: bindings}' : '{}'},
                history: {
                  delay: 2000,
                  maxStack: 500,
                  userOnly: false
                }
              },
              theme: 'snow',
             scrollingContainer: '#scrolling-container', 
              placeholder: '${hintText ?? "Description"}',
              clipboard: {
                matchVisual: true
              }
            });
            
            window.quilleditor = quilleditor;
            
            const table = quilleditor.getModule('table');
            quilleditor.enable($isEnabled);
        
           applyGoogleKeyboardWorkaround(quilleditor);
            
            let editorLoaded = false;
            quilleditor.on('editor-change', function(eventName, ...args) {   
              console.log("3############################################test change");   
             if (!editorLoaded) {
                if($kIsWeb) {
                    EditorLoaded(true);
                } else {
                    EditorLoaded.postMessage(true);
                }
                 // editorLoaded = true;
                }             
            });
            
            quilleditor.on('selection-change', function(range, oldRange, source)  {
             /// console.log('selection changed');
              onRangeChanged();
              if($kIsWeb){
              OnSelectionChanged(getSelectionRange());
              }else{
              OnSelectionChanged.postMessage(getSelectionRange());
              }                
            });   

      //       function setScrollPosition(savedScrollPosition){
      //       console.log('#################################ScrollPosition being set');
      //      if(savedScrollPosition != null) {
      //       window.scrollTo(0, parseInt(savedScrollPosition, 10));
      //   }
      //  } 

            function getSelectionHtml() {
           var selection = quilleditor.getSelection(true);
           if (selection) {
          var selectedContent = window.quilleditor.getContents(selection.index, selection.length);
          var tempContainer = document.createElement('div');
          var tempQuill = new Quill(tempContainer);
           tempQuill.setContents(selectedContent);
          return tempContainer.querySelector('.ql-editor').innerHTML;
        }
         return '';
        }      

             const Parchment = Quill.import('parchment');

            //const  = new Parchment.StyleAttributor('playButtonSize','font-size', {scope: Parchment.Scope.INLINE});
            
           
             const PositionAttributor = new Parchment.StyleAttributor('position','position');
             const DisplayAttributor = new Parchment.StyleAttributor('display','display');
             const ColorAttributor = new Parchment.StyleAttributor('color','color');
             const BackgroundColorAttributor = new Parchment.StyleAttributor('background-color','background-color');
             const CursorAttributor = new Parchment.StyleAttributor('cursor','cursor');
             const TopAttributor = new Parchment.StyleAttributor('top','top');
             const HeightAttributor = new Parchment.StyleAttributor('height','height');
             const WidthAttributor = new Parchment.StyleAttributor('width','width');
             const RightAttributor = new Parchment.StyleAttributor('right','right');
             const bottomAttribute = new Parchment.StyleAttributor('bottom','bottom');
             const gapAttribute = new Parchment.StyleAttributor('gap','gap');
             const LeftAttributor = new Parchment.StyleAttributor('left','left');
             const textAlignAttr = new Parchment.StyleAttributor('textAlign','textAlign');
             const marginTopAttr = new Parchment.StyleAttributor('margin-top', 'margin-top');
             const paddingAttr = new Parchment.StyleAttributor('padding', 'padding');
             const borderAttr = new Parchment.StyleAttributor('border', 'border');
             const borderRadiusAttr =  new Parchment.StyleAttributor('borderRadius', 'borderRadius');
             const alignItemsAttr = new Parchment.StyleAttributor('align-items', 'align-items');
             const marginbotAttr = new Parchment.StyleAttributor('margin-bottom', 'margin-bottom');
             const flexDirctionAttr = new Parchment.StyleAttributor('flex-direction', 'flex-direction');
             const justifyContentAttr = new Parchment.StyleAttributor('justify-content', 'justify-content');
             const fontAttribute = new Parchment.StyleAttributor('font-size', 'font-size');
             const transformAttr = new Parchment.StyleAttributor('transform', 'transform');
             const verticalAlignsAttr = new Parchment.StyleAttributor('vertical-align', 'vertical-align');
             const borderLeftAttr = new Parchment.StyleAttributor('border-left','border-left');
             const borderRightAttr = new Parchment.StyleAttributor('border-right','border-right');
             const borderBottomAttr = new Parchment.StyleAttributor('border-bottom','border-bottom');
             const borderTopAttr = new Parchment.StyleAttributor('border-top','border-top');
             const marginLeftAttr = new Parchment.StyleAttributor('margin-left','margin-left');
             const marginRightAttr = new Parchment.StyleAttributor('margin-right','margin-right');
             const overflowAttr = new Parchment.StyleAttributor('overflow','overflow');
             const objectFitAttr = new Parchment.StyleAttributor('object-fit','object-fit');

             Quill.register(PositionAttributor, true);
             Quill.register(DisplayAttributor, true);
             Quill.register(ColorAttributor, true);
             Quill.register(BackgroundColorAttributor, true);
             Quill.register(CursorAttributor, true);
             Quill.register(TopAttributor, true);
             Quill.register(HeightAttributor, true);
             Quill.register(WidthAttributor, true);
             Quill.register(RightAttributor, true);
             Quill.register(LeftAttributor, true);
             Quill.register(textAlignAttr, true);  
             Quill.register(marginTopAttr, true);            
             Quill.register(paddingAttr, true);
             Quill.register(borderAttr, true);
             Quill.register(borderRadiusAttr, true);
             Quill.register(alignItemsAttr, true);
             Quill.register(marginbotAttr, true);
             Quill.register(flexDirctionAttr, true);
             Quill.register(justifyContentAttr, true);
             Quill.register(gapAttribute, true);
             Quill.register(fontAttribute,true);
             Quill.register(transformAttr, true);
             Quill.register(borderLeftAttr, true);
             Quill.register(borderRightAttr, true);
             Quill.register(borderBottomAttr, true);
             Quill.register(borderTopAttr, true);
             Quill.register(overflowAttr, true);
             Quill.register(objectFitAttr, true);
        </script>
        </body>
        </html>
       ''';  
     """;
  }
}
