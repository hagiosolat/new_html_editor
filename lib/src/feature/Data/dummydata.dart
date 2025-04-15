import 'package:new_html_editor/src/feature/Domain/html_data_model.dart';

List<HtmlData> content = [
  HtmlData(
    articleID: '010',
    videosTotalDuration: 5649394,
    title: 'THE FIRST ARTICLE',
    totalProgress: 1057.727295101181,
    scrollProgress: 0.56,
    videos: [
      Video(
        videoUrl: "https://www.youtube.com/embed/dQw4w9WgXcQ",

        savedDuration: 9008,
      ),
      Video(
        videoUrl:
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4",

        savedDuration: 7508,
      ),
      Video(
        videoUrl:
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4",

        savedDuration: 9308,
      ),
      Video(
        videoUrl:
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",

        savedDuration: 5308,
      ),
      Video(
        videoUrl:
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",

        savedDuration: 5308,
      ),
      Video(
        videoUrl:
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
        savedDuration: 9308,
      ),
      Video(
        videoUrl:
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
        savedDuration: 18308,
      ),
    ],
    articleData: '''
   <html>
<body>
  <article>
    <h1>First Page</h1>
    <p>This is the initial paragraph with some sample content of the first page.<br>The Next Line</p>
    <h2>List Example</h2>
    <ul>
      <li>List item 1</li>
      <li>List item 2</li>
      <li>List item 3</li>
    </ul>
    <h2>FIRST Table Example </h2>
    <table border="1">
      <tr>
        <td>Header 1</td>
        <td>Header 2</td>
        <td>Header 1</td>
        <td>Header 2</td>
      </tr>
      <tr>
        <td>Data 1</td>
        <td>Data 2</td>
        <td>Data 1</td>
        <td>Data 2</td>
      </tr>
    </table>
    <h2>Image Example</h2>
    <p><img src="https://hips.hearstapps.com/hmg-prod/images/bright-forget-me-nots-royalty-free-image-1677788394.jpg" alt="Flowers image"></p>
    <h2>IFrame Example</h2>
    <iframe width="520" height="300" src="https://www.youtube.com/embed/dQw4w9WgXcQ"></iframe>
    
    <h2>Video Example</h2>
   <video width="320" height="240" controls>
  <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerFun.mp4" type="video/mp4">
  Your browser does not support the video tag.
  <figcaption> Hello World</figcaption>
  </video>
  <h2>Another Video Example</h2>
   <video width="320" height="240" controls>
  <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4" type="video/mp4">
  Your browser does not support the video tag.
  <figcaption> Hello World</figcaption>
  </video> 
<h2>Another Random Image</h2>
<p><img
 src="https://www.shutterstock.com/shutterstock/photos/2056485080/display_1500/stock-vector-address-and-navigation-bar-icon-business-concept-search-www-http-pictogram-d-concept-2056485080.jpg" alt="Flower Image"></p>
  <h1>Sample Article second page</h1>
    <p>This is the second paragraph with some sample content.<br>The Next Line</p>
    <h2>List Example</h2>
    <ul>
      <li>List item 1</li>
      <li>List item 2</li>
      <li>List item 3</li>
    </ul>
    <h2>Table Example</h2>
    <table border="1">
      <tr>
        <td>Header 1</td>
        <td>Header 2</td>
        <td>Header 1</td>
        <td>Header 2</td>
      </tr>
      <tr>
        <td>Data 1</td>
        <td>Data 2</td>
        <td>Data 1</td>
        <td>Data 2</td>
      </tr>
    </table>
    <h2>Image Example</h2>
    <p><img src="https://hips.hearstapps.com/hmg-prod/images/bright-forget-me-nots-royalty-free-image-1677788394.jpg" alt="Flowers image"></p>
    <h2>Video Example</h2>
   <video width="320" height="240" controls>
  <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4" type="video/mp4">
  Your browser does not support the video tag.
  <figcaption> Hello World</figcaption>
  </video>
  <h2>Another Video Example</h2>
   <video width="320" height="240" controls>
  <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4" type="video/mp4">
  Your browser does not support the video tag.
  <figcaption> Hello World</figcaption>
  </video> 
<h2>Another Random Image</h2>
<p><img
 src="https://www.shutterstock.com/shutterstock/photos/2056485080/display_1500/stock-vector-address-and-navigation-bar-icon-business-concept-search-www-http-pictogram-d-concept-2056485080.jpg" alt="Flower Image"></p>
  <h1>Sample Article second page</h1>
    <p>This is the second paragraph with some sample content.<br>The Next Line</p>
    <h2>List Example</h2>
    <ul>
      <li>List item 1</li>
      <li>List item 2</li>
      <li>List item 3</li>
    </ul>
    <h2>Table Example</h2>
    <table border="1">
      <tr>
        <td>Header 1</td>
        <td>Header 2</td>
        <td>Header 1</td>
        <td>Header 2</td>
      </tr>
      <tr>
        <td>Data 1</td>
        <td>Data 2</td>
        <td>Data 1</td>
        <td>Data 2</td>
      </tr>
    </table>
    <h2>Image Example</h2>
    <p><img src="https://hips.hearstapps.com/hmg-prod/images/bright-forget-me-nots-royalty-free-image-1677788394.jpg" alt="Flowers image"></p>
    <h2>Video Example</h2>
   <video width="320" height="240" controls>
  <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4" type="video/mp4">
  Your browser does not support the video tag.
  <figcaption> Hello World</figcaption>
  </video>
  <h2>Another Video Example</h2>
   <video width="320" height="240" controls>
  <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4" type="video/mp4">
  Your browser does not support the video tag.
  <figcaption> Hello World</figcaption>
  </video> 
<h2>Another Random Image</h2>
<p><img
 src="https://www.shutterstock.com/shutterstock/photos/2056485080/display_1500/stock-vector-address-and-navigation-bar-icon-business-concept-search-www-http-pictogram-d-concept-2056485080.jpg" alt="Flower Image"></p>
  </article>
</body>
</html>
  ''',
  ),
  HtmlData(
    articleID: '011',
    title: 'THE SECOND ARTICLE',
    scrollProgress: 0.8,
    videosTotalDuration: 60070 + 653803 + 213000 + 100000,
    videos: [
      Video(
        videoUrl: "https://www.youtube.com/embed/tgbNymZ7vqY",
        savedDuration: 4608,
      ),
      Video(
        videoUrl:
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4",
        savedDuration: 6308,
      ),
      Video(
        videoUrl:
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4",
        savedDuration: 10308,
      ),
    ],
    articleData: '''
 <html>
<body>
  <article>
    <h1>Second Article</h1>
    <p>This is the second paragraph with some sample content.<br>The Next Line</p>
    <h2>List Example</h2>
    <ul>
      <li>List item 1</li>
      <li>List item 2</li>
      <li>List item 3</li>
    </ul>
    <h2>Table Example</h2>
    <table border="1">
      <tr>
        <td>Header 1</td>
        <td>Header 2</td>
        <td>Header 1</td>
        <td>Header 2</td>
      </tr>
      <tr>
        <td>Data 1</td>
        <td>Data 2</td>
        <td>Data 1</td>
        <td>Data 2</td>
      </tr>
    </table>
    <h2>Image Example</h2>
    <p><img src="https://hips.hearstapps.com/hmg-prod/images/bright-forget-me-nots-royalty-free-image-1677788394.jpg" alt="Flowers image"></p>
    <h2>IFrame Example</h2>
    <iframe width="520" height="300" src="https://www.youtube.com/embed/tgbNymZ7vqY"></iframe>
    
    <h2>Video Example</h2>
   <video width="320" height="240" controls>
  <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerJoyrides.mp4" type="video/mp4">
  Your browser does not support the video tag.
  <figcaption> Hello World</figcaption>
  </video>
  <h2>Another Video Example</h2>
   <video width="320" height="240" controls>
  <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerMeltdowns.mp4" type="video/mp4">
  Your browser does not support the video tag.
  <figcaption> Hello World</figcaption>
  </video> 
<h2>Another Random Image</h2>
<p><img
 src="https://www.shutterstock.com/shutterstock/photos/2056485080/display_1500/stock-vector-address-and-navigation-bar-icon-business-concept-search-www-http-pictogram-d-concept-2056485080.jpg" alt="Flower Image"></p>
  </article>
</body>
</html>
 ''',
  ),
  HtmlData(
    articleID: '012',
    title: 'THE THIRD ARTICLE',
    scrollProgress: 0.7,
    videosTotalDuration: 60070 + 653803 + 213000,
    videos: [
      Video(
        videoUrl: "https://www.youtube.com/embed/dQw4w9WgXcQ",
        savedDuration: 8908,
      ),
      Video(
        videoUrl:
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4",
        savedDuration: 5808,
      ),
      Video(
        videoUrl:
            "http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4",
        savedDuration: 8308,
      ),
    ],
    articleData: '''
  <html>
<body>
  <article>
    <h1>Third Article</h1>
    <p>This is a paragraph with some sample content.<br>The Next Line</p>
    <h2>List Example</h2>
    <ul>
      <li>List item 1</li>
      <li>List item 2</li>
      <li>List item 3</li>
    </ul>
    <h2>Table Example</h2>
    <table border="1">
      <tr>
        <td>Header 1</td>
        <td>Header 2</td>
        <td>Header 1</td>
        <td>Header 2</td>
      </tr>
      <tr>
        <td>Data 1</td>
        <td>Data 2</td>
        <td>Data 1</td>
        <td>Data 2</td>
      </tr>
    </table>
    <h2>Image Example</h2>
    <p><img src="https://hips.hearstapps.com/hmg-prod/images/bright-forget-me-nots-royalty-free-image-1677788394.jpg" alt="Flowers image"></p>
    <h2>IFrame Example</h2>
    <iframe width="520" height="300" src="https://www.youtube.com/embed/dQw4w9WgXcQ"></iframe>    
    <h2>Video Example</h2>
   <video width="320" height="240" controls>
  <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/WhatCarCanYouGetForAGrand.mp4" type="video/mp4">
  Your browser does not support the video tag.
  <figcaption> Hello World</figcaption>
  </video>
  <h2>Another Video Example</h2>
   <video width="320" height="240" controls>
  <source src="http://commondatastorage.googleapis.com/gtv-videos-bucket/sample/TearsOfSteel.mp4" type="video/mp4">
  Your browser does not support the video tag.
  <figcaption> Hello World</figcaption>
  </video> 
<h2>Another Random Image</h2>
<p><img
 src="https://www.shutterstock.com/shutterstock/photos/2056485080/display_1500/stock-vector-address-and-navigation-bar-icon-business-concept-search-www-http-pictogram-d-concept-2056485080.jpg" alt="Flower Image"></p>
  </article>
</body>
</html>
 ''',
  ),
];
