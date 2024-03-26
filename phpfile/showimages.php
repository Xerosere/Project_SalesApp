<?php


header("Access-Control-Allow-Origin: *");
header('Content-Type: image/jpeg');

$imgurl = $_GET['url'];
$sourceImg = imagecreatefromjpeg($imgurl);
$watermarkImg = imagecreatefrompng('watermark.png'); // เปลี่ยน 'watermark.png' เป็นชื่อไฟล์ watermark ของคุณ

// เพิ่ม watermark บนรูป
$watermarkWidth = imagesx($watermarkImg);
$watermarkHeight = imagesy($watermarkImg);
$sourceWidth = imagesx($sourceImg);
$sourceHeight = imagesy($sourceImg);
$offsetX = ($sourceWidth - $watermarkWidth) / 2;
$offsetY = ($sourceHeight - $watermarkHeight) / 2;
imagecopy($sourceImg, $watermarkImg, $offsetX, $offsetY, 0, 0, $watermarkWidth, $watermarkHeight);

// ปรับขนาดภาพให้มีขนาดเท่ากับ maxresdefault
$resizedImg = imagescale($sourceImg, 1280, 720); // ปรับขนาดเป็น 1280x720 (maxresdefault)

// ส่งรูปภาพกลับไปยังผู้รับ
imagejpeg($resizedImg);

// ล้างหน่วยความจำหลังจากการใช้งาน
imagedestroy($sourceImg);
imagedestroy($watermarkImg);
imagedestroy($resizedImg);
