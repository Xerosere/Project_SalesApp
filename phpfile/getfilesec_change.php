<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');
$idfirstcate = mysqli_real_escape_string($conn, $_GET['file_first_cate']);
$idsecondcate = mysqli_real_escape_string($conn, $_GET['file_second_cate']);

// อย่าลืมใส่เครื่องหมาย backtick (`) หรือเครื่องหมายคำพูด (') รอบชื่อคอลัมน์ในคำสั่ง SQL
$query = "SELECT * FROM filemanage_filedetail 
          WHERE IDcategory_first = '$idfirstcate' AND IDcategory_second = '$idsecondcate'";

$result = mysqli_query($conn, $query);
$output = array();
while ($row = mysqli_fetch_assoc($result)) {
    $output[] = $row;
}
echo json_encode($output);
?>
