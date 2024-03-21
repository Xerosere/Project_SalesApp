<?php


header("Access-Control-Allow-Origin: *");
// header('Content-Type: image/jpeg');
// $imgurl = $_GET['url'];
$imgurl = 'https://img.youtube.com/vi/OvyPr1UAzJs/maxresdefault.jpg';
// header('location: requestPicture/request3293675_1662428595426040_1.jpg');x
// readfile($imgurl);

$imgData = base64_encode(file_get_contents($imgurl));

echo '<img src="data:image/x-icon;base64,<?='.$imgData.'?>">';

// echo 'sdsfsf';

// echo file_get_contents();

?>