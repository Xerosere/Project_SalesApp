<?php
header("Access-Control-Allow-Origin: *");
include('connectphp.php'); 

// รับค่าที่ส่งมาจาก HTTP GET request
$nameedit = $_GET['edit_name_third'];
$name_first_cate = $_GET['Namecategory_first'];
$name_second_cate = $_GET['Namecategory_second'];
$name_third_cate = $_GET['Namecategory_third'];


$sql = "UPDATE filemanage_thirdcategory
        SET name_third = ?
        WHERE IDcategory_first = ? AND IDcategory_second = ? AND name_third = ?";

// เตรียม statement สำหรับการ execute คำสั่ง SQL
$stmt = $conn->prepare($sql);

// ผูกค่า parameter กับ statement
$stmt->bind_param("ssss", $nameedit, $name_first_cate, $name_second_cate, $name_third_cate);

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
