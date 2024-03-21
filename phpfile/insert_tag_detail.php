<?php
header("Access-Control-Allow-Origin: *");
include('connectphp.php');

// รับค่า name_tag จาก GET parameter
$name_tag = $_GET['name_tag'];

// เชื่อมต่อฐานข้อมูลและทำการ INSERT ข้อมูล
$sql = "INSERT INTO filemanage_tagKeyword (`name_tag`)
        VALUES ('$name_tag')";

$result = mysqli_query($conn, $sql);

// ตรวจสอบผลลัพธ์การ INSERT และแสดงข้อความตามผลลัพธ์
if ($result) {
    echo 'Data inserted successfully ' . $name_tag;
} else {
    echo 'Error: ' . mysqli_error($conn);
}
?>
