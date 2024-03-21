<?php
header("Access-Control-Allow-Origin: *");
include('connectphp.php'); 

// รับค่าที่ส่งมาจาก HTTP GET request
$nameedit = $_GET['edit_name_second'];
$name_second_cate = $_GET['Namecategory_second'];
$name_first_cate = $_GET['Namecategory_first'];

$sql = "UPDATE filemanage_secondcategory
        SET name_second = ?
        WHERE name_second = ? AND id_category = ?";

// เตรียม statement สำหรับการ execute คำสั่ง SQL
$stmt = $conn->prepare($sql);

// ผูกค่า parameter กับ statement
$stmt->bind_param("sss", $nameedit, $name_second_cate, $name_first_cate);

// execute statement
if ($stmt->execute()) {
    echo 'Data updated successfully';
} else {
    echo 'Error: ' . $conn->error;
}

// ปิด statement และ connection
$stmt->close();
$conn->close();
?>
