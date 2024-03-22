<?php


header("Access-Control-Allow-Origin: *");
header('Content-Type: image/jpeg');
$imgurl = $_GET['url'];
readfile($imgurl);
