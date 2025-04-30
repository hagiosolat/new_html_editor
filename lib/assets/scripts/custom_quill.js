let isPlatform;
let isEnabled;

let fullWindowHeight = window.innerHeight;
let keyboardIsProbablyOpen = false;
window.addEventListener("resize", function () {
    if (window.innerHeight == fullWindowHeight) {
        keyboardIsProbablyOpen = false;
    } else if (window.innerHeight < fullWindowHeight * 0.9) {
        keyboardIsProbablyOpen = true;
    }
});

window.addEventListener('load', () => {
    if (window.ScrollReady) {
        ScrollReady("Loaded");
    } else {
        //  console.log("ScrollReady not ready yet");
    }
});

window.addEventListener('scroll', () => {
    const scrollTop = window.scrollY || document.documentElement.scrollTop;
    const maxScroll = document.documentElement.scrollHeight - window.innerHeight;
    const currentScrollPosition = maxScroll === 0 ? 0 : scrollTop / maxScroll;

    const positionMap = {
        scrollTop,
        currentScrollPosition,
        maxScroll
    };

    if (typeof GetScrollPosition !== 'undefined') {
        try {
            // Flutter WebView
            if (typeof GetScrollPosition.postMessage === 'function') {
                GetScrollPosition.postMessage(JSON.stringify(positionMap));
            } else if (typeof GetScrollPosition === 'function') {
                GetScrollPosition(JSON.stringify(positionMap));
            } else {
                console.warn('GetScrollPosition exists but is not callable');
            }
        } catch (err) {
            console.error('Error calling GetScrollPosition:', err);
        }
    } else {
        // Fallback for testing
        console.log('Scroll Data:', positionMap);
    }
});


window.addEventListener('scroll', () => {
    var scrollTop = window.scrollY || document.documentElement.scrollTop;
    var maxScrollExtent = document.documentElement.scrollHeight - window.innerHeight
    var currentScrollPosition = maxScrollExtent === 0 ? 0 : scrollTop / maxScrollExtent;

    var positionMap = {};
    positionMap['scrollTop'] = scrollTop;
    positionMap['currentScrollPosition'] = currentScrollPosition;
    positionMap['maxScroll'] = maxScrollExtent;
    //   console.log('%%%%%%%%%%%%%%%%%%%FIRING UP A SCROLLING EFFECT BOTH MOBILE AND WEB-VERSION');

    if (isPlatform) {
        //    console.log(`Testing the scrolling event in the web version from Javascript ${currentScrollPosition}`);
        GetScrollPosition(JSON.stringify(positionMap))
    }
    else {
        //   console.log(`This is the scrollPosition of the Mobile Version of the codebase`);
        GetScrollPosition.postMessage(JSON.stringify(positionMap));
    }
});


function resizeElementHeight(element, ratio) {
    var height = 0;
    var body = window.document.body;
    if (window.innerHeight) {
        height = window.innerHeight;
    } else if (body.parentElement.clientHeight) {
        height = body.parentElement.clientHeight;
    } else if (body && body.clientHeight) {
        height = body.clientHeight;
    }
    let isIOS = /iPad|iPhone|iPod/.test(navigator.platform) || (navigator.platform === 'MacIntel' && navigator.maxTouchPoints > 1)
    if (isIOS) {
        element.style.height = ((height / ratio - element.offsetTop) + "px");
    } else {
        element.style.height = ((height - element.offsetTop) + "px");
    }
}

function disableQuillEditor() {
    document.querySelector('.ql-editor').setAttribute('contenteditable', 'false');
}

function enableQuillEditor() {
    document.querySelector('.ql-editor').setAttribute('contenteditable', 'true');
}

function forceKeyboardDismiss() {
    let hiddenInput = document.createElement("input");
    hiddenInput.style.position = "absolute";
    hiddenInput.style.opacity = "0";
    document.body.appendChild(hiddenInput);
    hiddenInput.focus();
    setTimeout(() => {
        hiddenInput.blur();
        document.body.removeChild(hiddenInput);
    }, 50);
}

function dismissKeyboard() {
    if (document.activeElement) {
        document.activeElement.blur();
    }
    window.getSelection()?.removeAllRanges();
}

function replaceSelection(replaceText) {
    try {
        var range = window.quilleditor.getSelection(true);
        if (range) {
            if (range.length == 0) {
                // console.log('User cursor is at index', range.index);
            } else {
                window.quilleditor.deleteText(range.index, range.length);
                window.quilleditor.insertText(range.index, replaceText);

                /// replace text with format will be coming in future release
                /// quilleditor.insertText(range.index, replaceText, JSON.parse(format));
            }
        } else {
            // console.log('User cursor is not in editor');
        }
    }
    catch (e) {
        console.log('replaceSelection', e);
    }
}


function isQuillFocused() {
    // Retrieve the Quill editor container element by its ID
    var quillContainer = document.getElementById('scrolling-container');

    // Check if the Quill editor container or any of its descendants have focus
    return quillContainer.contains(document.activeElement);
}

function getSelectedText() {
    let text = '';
    try {
        var range = window.quilleditor.getSelection(true);
        if (range) {
            if (range.length == 0) {
                // console.log('User cursor is at index', range.index);
            } else {
                text = quilleditor.getText(range.index, range.length);
            }
        } else {
            //  console.log('User cursor is not in editor');
        }
    }
    catch (e) {
        console.log('getSelectedText', e);
    }
    return text;
}


function onRangeChanged() {
    try {
        var range = window.quilleditor.getSelection(true);
        if (range != null) {
            if (range.length == 0) {
                var format = window.quilleditor.getFormat();
                formatParser(format);
            } else {
                var format = window.quilleditor.getFormat(range.index, range.length);
                formatParser(format);
            }
        } else {
            // console.log('Cursor not in the editor');
        }
    } catch (e) {
        ///  console.log(e);
    }
}


function redo() {
    window.quilleditor.history.redo();
    return '';
}

function undo() {
    window.quilleditor.history.undo();
    return '';
}
function clearHistory() {
    window.quilleditor.history.clear();
    return '';
}


function formatParser(format) {
    var formatMap = {};
    formatMap['bold'] = format['bold'];
    formatMap['italic'] = format['italic'];
    formatMap['underline'] = format['underline'];
    formatMap['strike'] = format['strike'];
    formatMap['blockqoute'] = format['blockqoute'];
    formatMap['background'] = format['background'];
    formatMap['code-block'] = format['code-block'];
    formatMap['indent'] = format['indent'];
    formatMap['direction'] = format['direction'];
    formatMap['size'] = format['size'];
    formatMap['header'] = format['header'];
    formatMap['color'] = format['color'];
    formatMap['font'] = format['font'];
    formatMap['align'] = format['align'];
    formatMap['list'] = format['list'];
    formatMap['image'] = format['image'];
    formatMap['video'] = format['video'];
    formatMap['clean'] = format['clean'];
    formatMap['link'] = format['link'];
    if (isPlatform) {
        UpdateFormat(JSON.stringify(formatMap));
    } else {
        UpdateFormat.postMessage(JSON.stringify(formatMap));
    }
}


function getHtmlText() {
    return quilleditor.root.innerHTML;
}

function getPlainText() {
    var text = "";
    try {
        text = toPlaintext(quilleditor.getContents());
    } catch (e) {
        text = "";
    }
    return text;
}

function toPlaintext(delta) {
    return delta.reduce(function (text, op) {
        if (!op.insert) throw new TypeError('only `insert` operations can be transformed!');
        if (typeof op.insert !== 'string') return text + ' ';
        return text + op.insert;
    }, '');
};

function getSelection() {
    try {
        var range = quilleditor.getSelection(true);
        if (range) {
            return range.length;
        }
    } catch (e) {
        console.log('getSelection', e);
    }
    return -1;
}


function getSelectionRange() {
    var range = window.quilleditor.getSelection(true);
    if (range) {
        var rangeMap = {};
        rangeMap['length'] = range.length;
        rangeMap['index'] = range.index;
        return JSON.stringify(rangeMap);
    }
    return {};
}

function setSelection(index, length) {
    try {
        setTimeout(() => window.quilleditor.setSelection(index, length), 1);
    } catch (e) {
        console.log('setSelection', e);
    }
    return '';
}




async function setHtmlText(htmlString, isWeb, isEnable) {
    //  console.log('*****&&&****&&&*****&&&*****&&&&&******&&&******&&&&&*****&&&&****&&&&****');
    try {
        isPlatform = isWeb;
        isEnabled = isEnable;
        // videoMap = {};
        if (isWeb) {
            //  console.log('**********TESTING THE TIMING TIMING OF THE WEB VERSION *********');
            window.quilleditor.enable(false);
            //    console.log('Testing the web rendering of this code');
            const moddifiedHtml = await wrapMediaWithDiv(htmlString);
            // console.log(`${moddifiedHtml}`);
            window.quilleditor.clipboard.dangerouslyPasteHTML(moddifiedHtml);
        } else {
            //  console.log('######TESTING THE TIMING TIMING OF THE MOBILE VERSION##########');
            const modifiedHtml = await replaceVideoWithThumbnail(htmlString);
            //console.log(`\${modifiedHtml}`);
            //  console.log('*****&&&****&&&*****&&&*****&&&&&******&&&******&&&&&*****&&&&****&&&&****');
            window.quilleditor.enable(false);
            window.quilleditor.clipboard.dangerouslyPasteHTML(modifiedHtml);
        }
    } catch (e) {
        console.log('Error in setHtmlText', e);
    }
    setTimeout(() => window.quilleditor.enable(isEnable), 10);
    return '';
}


function setDeltaContent(deltaMap) {
    try {
        window.quilleditor.enable(false);
        const obj = JSON.parse(deltaMap);
        window.quilleditor.setContents(obj);
    } catch (e) {
        console.log('setDeltaContent', e);
    }
    setTimeout(() => quilleditor.enable($isEnabled), 10);
    return '';
}

function getDelta() {
    return JSON.stringify(quilleditor.getContents());
}

function requestFocus() {
    try {
        var htmlString = quilleditor.root.innerHTML;
        document.querySelector('.ql-editor').setAttribute('contenteditable', 'true');
        setTimeout(() => {
            window.quilleditor.setSelection(htmlString.length + 1, htmlString.length + 1);
            window.quilleditor.focus();
            //  document.querySelector('.ql-editor').setAttribute('contenteditable', 'true');

        }, 600);
    } catch (e) {
        console.log('requestFocus', e);
    }

    return '';
}


function unFocus() {
    // console.log('Trying to unfocus the quill');
    document.activeElement.blur();
    window.quilleditor.root.blur()
    return '';
}

function insertTable(row, column) {
    table.insertTable(row, column);
    return '';
}

function modifyTable(type) {
    if (type == "insertRowAbove") {
        table.insertRowAbove();
    } else if (type == "insertRowBelow") {
        table.insertRowBelow();
    } else if (type == "insertColumnLeft") {
        table.insertColumnLeft();
    } else if (type == "insertColumnRight") {
        table.insertColumnRight();
    } else if (type == "deleteRow") {
        table.deleteRow();
    } else if (type == "deleteColumn") {
        table.deleteColumn();
    } else if (type == "deleteTable") {
        table.deleteTable();
    }
    return '';
}

function insertHtmlText(htmlString, index) {
    if (index == null) {
        var range = quilleditor.getSelection(true);
        if (range) {
            window.quilleditor.clipboard.dangerouslyPasteHTML(range.index, htmlString);
        }
    } else {
        window.quilleditor.clipboard.dangerouslyPasteHTML(index, htmlString);
    }
    return '';
}


function embedVideo(videoUrl) {
    var range = quilleditor.getSelection(true);
    var formattedVideoUrl = videoUrl

    if (formattedVideoUrl.startsWith('http://')) {
        formattedVideoUrl = formattedVideoUrl.replace('http://', 'https://');
    }

    if (range) {
        if (isPlatform) {
            window.quilleditor.insertEmbed(range.index, 'div', {
                url: videoUrl,
            }, Quill.sources.USER);

        } else {
            unFocus();
            window.quilleditor.insertEmbed(range.index, 'videoThumbnail', {
                url: formattedVideoUrl,
                thumbnail: "https://hips.hearstapps.com/hmg-prod/images/bright-forget-me-nots-royalty-free-image-1677788394.jpg",
            }, Quill.sources.USER);
        }
    }
    return '';
}


function embedImage(img) {
    var range = quilleditor.getSelection(true);
    if (range) {
        window.quilleditor.insertEmbed(range.index, 'image', img);
    }
    return '';
}


function wrapMediaWithDiv(htmlContent) {
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = htmlContent;
    const mediaElements = tempDiv.querySelectorAll('video, iframe');

    mediaElements.forEach((media) => {
        // Create a div element
        const wrapperDiv = document.createElement('div');


        // Insert the div before the media element
        media.parentNode.insertBefore(wrapperDiv, media);

        // Move the media element inside the div
        wrapperDiv.appendChild(media);
    });
    return tempDiv.innerHTML; //return the modifies HTML
}


///Generate the video List and convert it to a container with the thumbnail
async function replaceVideoWithThumbnail(htmlContent) {
    //Create a temporary element to hold the HTML content
    const tempDiv = document.createElement('div');
    tempDiv.innerHTML = htmlContent;

    const videos = tempDiv.querySelectorAll('video');

    const iframes = tempDiv.querySelectorAll('iframe');

    for (let iframe of iframes) {
        const videoSrc = iframe.getAttribute('src');

        if (videoSrc) {
            try {
                //  console.log(`${videoSrc}`);
                const thumbnailUrl = await getYouTubeThumbnail(videoSrc);
                //  console.log(`This is the generated thumbnail ${thumbnailUrl}`);
                const thumbnailWithButton = insertThumbnailWithPlayButton(thumbnailUrl, videoSrc);

                iframe.parentNode.replaceChild(thumbnailWithButton, iframe);

            } catch (e) {
                console.log('Error generating videoThumbnail:', e);
            }
        }
    }
    for (let video of videos) {
        const width = video.getAttribute('width');
        const height = video.getAttribute('height');
        let videoSrc = video.getAttribute('src') || video.querySelector('source').getAttribute('src');
        if (videoSrc.startsWith('http://')) {
            videoSrc = videoSrc.replace('http://', 'https://');
        }


        if (videoSrc) {
            try {
                //Create an <img> tag with the thumbnail URL
                // console.log(`This is the width of the video ${width}`);
                // console.log(`This is the height of the video ${height}`);


                //  const thumbnailUrl = await generateThumbnail(videoSrc);
                const thumbnailUrl = "https://hips.hearstapps.com/hmg-prod/images/bright-forget-me-nots-royalty-free-image-1677788394.jpg" + ".mp4"

                const thumbnailWithButton = insertThumbnailWithPlayButton(thumbnailUrl, videoSrc, width, height);


                video.parentNode.replaceChild(thumbnailWithButton, video);


            } catch (error) {
                console.log('Error generating thumbnail:', error);
            }
        }
    }
    return tempDiv.innerHTML; //Return the modified HTML             
}



function insertThumbnailWithPlayButton(thumbnailUrl, videoSrc, width, height) {
    //Create an <img> tag with the thumbnail URL
    const img = document.createElement('img');
    img.setAttribute('src', thumbnailUrl);
    img.setAttribute('alt', videoSrc);
    img.setAttribute('width', width);
    img.setAttribute('height', height);
    return img;
}

function convertToHttps(url) {
    try {
        const parsedUrl = new URL(url);
        if (parsedUrl.protocol === 'http:') {
            parsedUrl.protocol = 'https:';
        }
        return parsedUrl.toString();
    } catch (error) {
        console.error("Invalid URL:", error.message);
        return null;
    }
}

///This is the container to set the thumbnail as the background of the container
///*****************************************************************************
async function generateThumbnail(videoUrl) {
    // Code to extract a thumbnail from a custom video source (like canvas)
    // console.log('trying to generate the video thumbnail');

    return new Promise((resolve, reject) => {
        const video = document.createElement('video');
        video.src = videoUrl;
        video.crossOrigin = '';
        video.addEventListener('loadeddata', () => {
            const canvas = document.createElement('canvas');
            canvas.width = video.videoWidth;
            canvas.height = video.videoHeight;
            const context = canvas.getContext('2d');
            context.drawImage(video, 0, 0, canvas.width, canvas.height);
            const thumbnailUrl = canvas.toDataURL();
            resolve(thumbnailUrl);
        });

        video.addEventListener('error', (err) => {
            reject('Error loading video for thumbnail generation');
        });

        video.currentTime = 2;
    });
}


function getYouTubeThumbnail(url) {

    // Regular expression to extract the video ID from a YouTube URL
    //const regex = /(?:https?:\\/\\/)?(?:www\\.)?(?:youtube\\.com\\/(?: [^\\/\\n\\s]+\\/\\S +\\/|(?:v|embed|e)\\/ |\\S *? [?&]v =) | youtu\\.be\\/)([a-zA-Z0-9_-]{11})/;

    const regex = /(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|embed|e)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/;

    const match = url.match(regex);
    if (match && match[1]) {
        const videoId = match[1];
        // Construct different thumbnail URLs
        const thumbnails =
            `https://img.youtube.com/vi/${videoId}/hqdefault.jpg`;
        return thumbnails;
    } else {
        console.error('Invalid YouTube URL');
        return null;
    }
}


///This is the function to set the scrollPosition of the last position.
///********************************************************************
let savedForFuture;
function setScrollPosition(savedScrollPosition) {
 //   console.log(`############################################################ ${savedScrollPosition}`);
    if (savedScrollPosition !== null) {
        savedForFuture = savedScrollPosition;
        const maxScroll = document.documentElement.scrollHeight - window.innerHeight;
        const currentPosition = maxScroll === 0 ? 0 : maxScroll * savedScrollPosition
        window.scrollTo(0, parseInt(currentPosition, 10));
    }
}


let videoMap;
function setVideoPosition(videoPosition) {
    try {
        videoMap = JSON.parse(videoPosition);
        console.log('Testing for the available videos in the javascript side');
        console.log(JSON.stringify(videoMap));
    } catch (error) {
        console.error('Error parsing JSON:', error);
    }
}




function enableEditor(isEnabled) {
    window.quilleditor.enable(isEnabled);
    return '';
}



function setFormat(format, value, index, length) {
    index = index || -1;
    length = length || 0;
    try {
        if (format == 'clean') {
            var range = quilleditor.getSelection(true);
            if (range) {
                if (range.length == 0) {
                    window.quilleditor.removeFormat(range.index, quilleditor.root.innerHTML.length);
                } else {
                    window.quilleditor.removeFormat(range.index, range.length);
                }
            } else {
                quilleditor.format('clean');
            }
        } else {
            if (index >= 0 && length > 0) {
                quilleditor.setSelection(index, length);
            }
            window.quilleditor.format(format, value);
        }
    } catch (e) {
        console.log('setFormat', e);
    }
    return '';
}





///IMAGE BLOT TO RENDER IMAGE TAGS IN THE EDITOR
const ImageEmbed = Quill.import('formats/image');
class ImageBlot extends ImageEmbed {
    static create(value) {
        let node = super.create(value);
        PositionAttributor.add(node, 'relative');
        overflowAttr.add(node, 'hidden');

        // Regular expression to remove `.mp4` at the end
        const updatedValue = value.replace(/\.mp4/g, '');
        let img = document.createElement('img');
        img.setAttribute('src', updatedValue);
        img.setAttribute('contenteditable', false);
        img.setAttribute('display', 'block');
        objectFitAttr.add(img, 'cover');
        node.appendChild(img);

        //if(value.includes('data:image') || value.includes('youtube')){

        if (value.includes('.mp4') || value.includes('youtube')) {
            //  console.log(`This is the url: ${value}`);

            let container = document.createElement('div');
            PositionAttributor.add(container, 'absolute');
            TopAttributor.add(container, '50%');
            LeftAttributor.add(container, '50%');
            transformAttr.add(container, 'translate(-50%, -50%)');
            DisplayAttributor.add(container, 'flex');
            flexDirctionAttr.add(container, 'column');
            alignItemsAttr.add(container, 'center');
            gapAttribute.add(container, '30px');
            container.classList.add('button-wrapper');
            justifyContentAttr.add(container, 'space-between');

            let url = node.getAttribute('alt');
            let playButton = document.createElement('button');
            playButton.setAttribute('contenteditable', false);
            DisplayAttributor.add(playButton, 'block');

            BackgroundColorAttributor.add(playButton, 'red');

            WidthAttributor.add(playButton, '100px');
            HeightAttributor.add(playButton, '100px');

            borderRadiusAttr.add(playButton, '50%');

            justifyContentAttr.add(playButton, 'center');
            alignItemsAttr.add(playButton, 'center');
            //ColorAttributor.add(playButton,'white'); 
            borderAttr.add(playButton, 'none');
            verticalAlignsAttr.add(playButton, 'middle');
            playButton.classList.add('playButton');
            //  playButton.innerText = '▶';
            fontAttribute.add(playButton, '100px');
            textAlignAttr.add(playButton, 'center');
            paddingAttr.add(playButton, '10px 20px');


            let triangle = document.createElement('div');
            HeightAttributor.add(triangle, '0px');
            WidthAttributor.add(triangle, '0px');
            borderBottomAttr.add(triangle, '25px  solid transparent');
            borderLeftAttr.add(triangle, '50px solid white');
            borderTopAttr.add(triangle, '25px  solid transparent');
            marginLeftAttr.add(triangle, '9px');
            //BackgroundColorAttributor.add(triangle,'white');

            const markAsReadButton = document.createElement('button');
            markAsReadButton.setAttribute('contenteditable', false);
            PositionAttributor.add(markAsReadButton, 'absolute');
            bottomAttribute.add(markAsReadButton, '20px');
            LeftAttributor.add(markAsReadButton, '50%');
            transformAttr.add(markAsReadButton, 'translateX(-50%)');
            BackgroundColorAttributor.add(markAsReadButton, 'green')
            paddingAttr.add(markAsReadButton, '8px 10px');
            ColorAttributor.add(markAsReadButton, 'white');
            borderAttr.add(markAsReadButton, 'none');
            borderRadiusAttr.add(markAsReadButton, '5px');
            fontAttribute.add(markAsReadButton, '14px');
            markAsReadButton.innerText = '✅ Mark as Read';

            CursorAttributor.add(markAsReadButton, 'pointer');

            playButton.addEventListener('click', () => {
                let link = node.getAttribute('alt');
                if (isPlatform) {
                } else {
                    setTimeout(() => {
                        unFocus();
                    }, 200);

                    GetVideoUrl.postMessage(link);
                }
            });

            markAsReadButton.addEventListener('click', () => {
                //  console.log('Mark As read button pressed');
                let link = node.getAttribute('alt');
                if (isPlatform) {
                    //  WatchVideo(link);
                } else {
                    WatchVideo.postMessage(link);
                    setTimeout(() => {
                        unFocus();
                    }, 200);
                }
            });

            playButton.appendChild(triangle);
            container.appendChild(playButton);
            node.appendChild(markAsReadButton);
            node.appendChild(container);
        }
        return node;
    }
    static value(node) {
        let img2 = node.querySelector('img')
        return {
            alt: node.getAttribute('alt'),
            src: node.getAttribute('src'),
        };
    }
}
ImageBlot.blotName = 'image';
ImageBlot.tagName = 'div';
Quill.register('formats/image', ImageBlot)
// Quill.register(ImageBlot);






//IMAGE BLOT TO RENDER VIDEO TAGS IN THE EDITOR
let BlockEmbed = Quill.import('blots/block/embed');
class VideoBlot extends BlockEmbed {
    static create(value) {
        let node = super.create(value);
        DisplayAttributor.add(node, 'flex');
        alignItemsAttr.add(node, 'start');
        flexDirctionAttr.add(node, 'column');

        if (value.url.includes('.mp4')) {
            let video = document.createElement('video');
            video.setAttribute('id', 'videoElement');
            video.setAttribute('width', value.width || 520);
            video.setAttribute('height', value.height || 300);
            video.setAttribute('controls', true);
            //PositionAttributor.add(node, 'relative');


            let source = document.createElement('source');
            source.setAttribute('src', `${value.url}#t=0.3`);
            source.setAttribute('type', 'video/mp4');

            video.addEventListener('loadedmetadata', () => {
                let key = value.url;
                if (videoMap.hasOwnProperty(key)) {
                    // console.log('This is something that happen');
                    // console.log(videoMap[key]);
                    video.currentTime = videoMap[key] * 0.001;
                }
                setScrollPosition(savedForFuture);
            });

            video.addEventListener('timeupdate', () => {
                const currentTime = video.currentTime * 1000;
                const duration = video.duration * 1000;
                // const progress = (currentTime / duration) * 100;
                var postMap = {};
                postMap['totalDuration'] = duration;
                postMap['currentPosition'] = currentTime;
                postMap['videoUrl'] = value.url;
                if (isPlatform) {
                    GetVideoTracking(JSON.stringify(postMap))
                } else {
                    GetVideoTracking.postMessage(JSON.stringify(postMap))
                }
            });

            const buttonContainer = document.createElement('div');
            buttonContainer.setAttribute('contenteditable', false);
            textAlignAttr.add(buttonContainer, 'center');
            marginTopAttr.add(buttonContainer, '8px');

            const markAsReadButton = document.createElement('button');
            markAsReadButton.innerText = '✅ Mark as Read';
            paddingAttr.add(markAsReadButton, '8px 12px');
            borderAttr.add(markAsReadButton, 'none');
            BackgroundColorAttributor.add(markAsReadButton, 'green')
            ColorAttributor.add(markAsReadButton, 'white');
            borderRadiusAttr.add(markAsReadButton, '4px');
            CursorAttributor.add(markAsReadButton, 'pointer');


            markAsReadButton.addEventListener('click', () => {

                video.currentTime = video.duration;
                const currentTime = video.duration * 1000;
                const duration = video.duration * 1000;
                // const progress = (currentTime / duration) * 100;
                var postMap = {};
                postMap['totalDuration'] = duration;
                postMap['currentPosition'] = currentTime;
                postMap['videoUrl'] = value.url;
                if (isPlatform) {
                    GetVideoTracking(JSON.stringify(postMap))
                } else {
                    GetVideoTracking.postMessage(JSON.stringify(postMap))
                }

            });

            buttonContainer.appendChild(markAsReadButton);
            video.appendChild(source);
            node.appendChild(video);
            node.appendChild(buttonContainer);

        }
        else if (value.url.includes('youtube')) {
            let youtubePlayer;
            // console.log(`This is the youtube videoBlot to be rendered actually ${value.url}`);
            const iframe = document.createElement('iframe');
            iframe.setAttribute('id', 'youtubeIframe');
            iframe.setAttribute('src', `${value.url}?enablejsapi=1`);
            iframe.setAttribute('width', value.width || '560');
            iframe.setAttribute('height', value.height || '315');
            iframe.setAttribute('frameborder', '0');
            iframe.setAttribute(
                'allow',
                'accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture'
            );
            iframe.setAttribute('allowfullscreen', true);

            // Create the button
            const button = document.createElement('button');
            button.setAttribute('contenteditable', false);
            button.innerText = '✅ Mark as Read';
            button.style.marginTop = '10px';
            button.style.padding = '5px 10px';
            button.style.backgroundColor = 'green';
            button.style.color = '#fff';
            button.style.border = 'none';
            button.style.cursor = 'pointer';
            button.style.borderRadius = '5px';

            const extractYoutubeId = (url) => {
                const regex = /(?:https?:\/\/)?(?:www\.)?(?:youtube\.com\/(?:[^\/\n\s]+\/\S+\/|(?:v|embed|e)\/|\S*?[?&]v=)|youtu\.be\/)([a-zA-Z0-9_-]{11})/;
                const match = url.match(regex);
                return match ? match[1] : null;
            };


            const trackProgress = (player, iframe) => {
                let lastTime = -1;
                const duration = player.getDuration();
                const videoUrl = iframe.getAttribute('src');
                const trackInterval = setInterval(() => {
                    if (player.getPlayerState() === YT.PlayerState.PLAYING) {
                        const currentTime = player.getCurrentTime();
                        var postMap = {};
                        postMap['totalDuration'] = duration * 1000;
                        postMap['currentPosition'] = currentTime * 1000;
                        postMap['videoUrl'] = videoUrl;
                        //  const progress = (currentTime / duration) * 100;
                        if (isPlatform) {
                            GetVideoTracking(JSON.stringify(postMap));
                            //   GetVideoTracking(progress.toFixed(2));
                        } else {
                            GetVideoTracking.postMessage(JSON.stringify(postMap))
                            // GetVideoTracking.postMessage(progress.toFixed(2));
                        }
                    } else {
                        const currentTime = player.getCurrentTime();
                        if (Math.abs(currentTime - lastTime) >= 0.1) {
                            lastTime = currentTime;
                            const postMap = {
                                totalDuration: duration * 1000,
                                currentPosition: currentTime * 1000,
                                videoUrl: videoUrl,
                            };
                            if (isPlatform) {
                                GetVideoTracking(JSON.stringify(postMap));
                                //   GetVideoTracking(progress.toFixed(2));
                            } else {
                                GetVideoTracking.postMessage(JSON.stringify(postMap))
                                // GetVideoTracking.postMessage(progress.toFixed(2));
                            }

                        }
                        //  clearInterval(trackInterval);
                    }
                }, 1000);
            };


            const addYoutubeTracking = (iframe1, linkUrl) => {
                //  const linkUrl = value.url
                const videoId = extractYoutubeId(linkUrl);
                //   console.log(`This is the youtube Video Link ${linkUrl}`);
                youtubePlayer = new YT.Player(iframe1.getAttribute('id'), {
                    events: {
                        'onReady': (event) => onPlayerReady(event, iframe1),
                        'onStateChange': (event) => onPlayerStateChange(event, iframe1)
                    }
                });
            };

            const onPlayerReady = (event, iframe2) => {
                const key = iframe2.getAttribute('src');
                if (videoMap.hasOwnProperty(key)) {
                    // console.log('This is something that happen when youtube player is ready');
                    // console.log(`This is the youtube videoMap ${videoMap[key]}`);
                    const currentTime = event.target.getDuration();
                    var postMap = {
                        totalDuration: currentTime * 1000,
                        currentPosition: videoMap[key],
                        videoUrl: key,
                    };
                    const savedPosition = videoMap[key] * 0.001;
                    event.target.seekTo(parseFloat(savedPosition), true); //Resume playback
                    if (isPlatform) {
                        GetVideoTracking(JSON.stringify(postMap));
                    }
                    setTimeout(() => {
                        event.target.pauseVideo(); //Prevent AutoPlay
                    }, 400
                    );
                }
                setScrollPosition(savedForFuture);
            };

            const onPlayerStateChange = (event, iframe) => {
                if (event.data == YT.PlayerState.PLAYING) {
                    //   console.log('video is playing');
                    trackProgress(event.target, iframe);
                } else if (event.data == YT.PlayerState.ENDED) {
                    //  console.log('Video has ended.');
                }
            };

            // Button click handler with iframe passed as an argument
            button.addEventListener('click', () => handleButtonClick(iframe));
            function handleButtonClick(iframe) {
                if (youtubePlayer) {
                    youtubePlayer.seekTo(youtubePlayer.getDuration(), true);
                    const currentTime = youtubePlayer.getDuration();
                    var postMap = {};
                    postMap['totalDuration'] = currentTime * 1000;
                    postMap['currentPosition'] = currentTime * 1000;
                    postMap['videoUrl'] = iframe.getAttribute('src');
                    if (isPlatform) {
                        GetVideoTracking(JSON.stringify(postMap));
                    } else {
                        GetVideoTracking.postMessage(JSON.stringify(postMap));
                    }
                }
            }
            iframe.addEventListener('load', () => {
                addYoutubeTracking(iframe, value.url);
            });
            node.appendChild(iframe);
            node.appendChild(button);
        }
        return node;
    }

    static value(node) {
        let source = node.querySelector('source');
        let video = node.querySelector('video')
        let iframe = node.querySelector('iframe');
        if (source != null) {
            return {
                width: video.getAttribute('width'),
                height: video.getAttribute('height'),
                url: source ? source.getAttribute('src') : '',
            };
        } else {
            return {
                url: iframe ? iframe.getAttribute('src') : '',
                width: iframe ? iframe.getAttribute('width') : '560',
                height: iframe ? iframe.getAttribute('height') : '315',
            };
        }
    }
}
VideoBlot.blotName = 'div';
VideoBlot.tagName = 'div';
Quill.register(VideoBlot);






/// VIDEO THUMBNAIL: THIS WILL RENDER THE VIDEOS WITH THE CUSTOMIZED UI JUST WHEN VIDEO IS 
/// MANUALLY ADDED BY THE USER
class VideoThumbnailBlot extends BlockEmbed {
    static create(value) {
        // Ensure value is an object and contains 'url'
        if (!value || !value.url) {
            throw new Error("Invalid value: 'src' property is required");
        }
        let node = super.create(value); // Call the parent class's create method
        //  console.log(`${value.url}`);
        PositionAttributor.add(node, 'relative');
        overflowAttr.add(node, 'hidden');

        let img = document.createElement('img');
        img.setAttribute('src', value.thumbnail);
        img.setAttribute('contenteditable', false);
        img.setAttribute('display', 'block');
        objectFitAttr.add(img, 'cover');
        node.appendChild(img);

        let container = document.createElement('div');
        PositionAttributor.add(container, 'absolute');
        TopAttributor.add(container, '50%');
        LeftAttributor.add(container, '50%');
        transformAttr.add(container, 'translate(-50%, -50%)');
        DisplayAttributor.add(container, 'flex');
        flexDirctionAttr.add(container, 'column');
        alignItemsAttr.add(container, 'center');
        gapAttribute.add(container, '30px');
        container.classList.add('button-wrapper');
        justifyContentAttr.add(container, 'space-between');


        let url = node.getAttribute('alt');
        let playButton = document.createElement('button');
        playButton.setAttribute('contenteditable', false);
        DisplayAttributor.add(playButton, 'block');
        BackgroundColorAttributor.add(playButton, 'red');

        WidthAttributor.add(playButton, '100px');
        HeightAttributor.add(playButton, '100px');
        borderRadiusAttr.add(playButton, '50%');

        justifyContentAttr.add(playButton, 'center');
        alignItemsAttr.add(playButton, 'center');
        borderAttr.add(playButton, 'none');
        verticalAlignsAttr.add(playButton, 'middle');
        playButton.classList.add('playButton');
        fontAttribute.add(playButton, '100px');
        textAlignAttr.add(playButton, 'center');
        paddingAttr.add(playButton, '10px 20px');

        let triangle = document.createElement('div');
        HeightAttributor.add(triangle, '0px');
        WidthAttributor.add(triangle, '0px');
        borderBottomAttr.add(triangle, '25px  solid transparent');
        borderLeftAttr.add(triangle, '50px solid white');
        borderTopAttr.add(triangle, '25px  solid transparent');
        marginLeftAttr.add(triangle, '9px');

        const markAsReadButton = document.createElement('button');
        markAsReadButton.setAttribute('contenteditable', false);
        PositionAttributor.add(markAsReadButton, 'absolute');
        bottomAttribute.add(markAsReadButton, '20px');
        LeftAttributor.add(markAsReadButton, '50%');
        transformAttr.add(markAsReadButton, 'translateX(-50%)');
        BackgroundColorAttributor.add(markAsReadButton, 'green')
        paddingAttr.add(markAsReadButton, '8px 10px');
        ColorAttributor.add(markAsReadButton, 'white');
        borderAttr.add(markAsReadButton, 'none');
        borderRadiusAttr.add(markAsReadButton, '5px');
        fontAttribute.add(markAsReadButton, '14px');
        markAsReadButton.innerText = '✅ Mark as Read';
        CursorAttributor.add(markAsReadButton, 'pointer');

        playButton.addEventListener('click', () => {
            let link = node.getAttribute('alt');
            if (isPlatform) {
                //  GetVideoUrl(link);
            } else {

                setTimeout(() => {
                    unFocus();
                }, 200);

                GetVideoUrl.postMessage(link);
            }
            //  alert(`\${link}`);
        });

        markAsReadButton.addEventListener('click', () => {
            //   console.log('Mark As read button pressed');
            let link = node.getAttribute('alt');
            if (isPlatform) {
                //  WatchVideo(link);
            } else {
                WatchVideo.postMessage(link);
            }
        });
        playButton.appendChild(triangle);
        container.appendChild(playButton);
        node.appendChild(markAsReadButton);
        node.appendChild(container);
        node.setAttribute('alt', value.url); // Store the URL
        return node;
    }
    // static value(node) {
    //   return {
    //     alt: value.url,
    //     thumbnail: value.src,
    //     // thumbnail: node.querySelector('img')?.src || '',
    //   };
    // }
}
VideoThumbnailBlot.blotName = 'videoThumbnail';
VideoThumbnailBlot.tagName = 'div';
VideoThumbnailBlot.className = 'videoThumbnail';
Quill.register(VideoThumbnailBlot);


