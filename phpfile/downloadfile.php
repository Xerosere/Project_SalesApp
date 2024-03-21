<?php
header("Access-Control-Allow-Origin: *");
include('connectphp.php');
error_reporting(E_ERROR | E_PARSE);

// กำหนด path ของไฟล์ที่ต้องการดาวน์โหลด
$file_path = 'file/' . $_GET['url']; // เช่น file/sample_file.txt

// ตรวจสอบว่าไฟล์มีอยู่หรือไม่
if (file_exists($file_path)) {
    // กำหนด header สำหรับการดาวน์โหลดไฟล์
    header('Content-Description: File Transfer');
    header('Content-Type: application/octet-stream');
    header('Content-Disposition: attachment; filename="' . basename($file_path) . '"');
    header('Expires: 0');
    header('Cache-Control: must-revalidate');
    header('Pragma: public');
    header('Content-Length: ' . filesize($file_path));
    // อ่านและส่งข้อมูลในไฟล์ไปยังผู้ใช้
    readfile($file_path);
    exit;
} else {
    // ถ้าไม่พบไฟล์ ส่งคำตอบว่าไม่พบไฟล์
    http_response_code(404);
    echo json_encode(array("message" => "File not found."));
}
?>
