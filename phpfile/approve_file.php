<?php
header("Access-Control-Allow-Origin: *");
include('connectphp.php');
$ID = $_GET['id_file'];

$query = "UPDATE filemanage_filedetail 
          SET status_file = 'approve'
          WHERE number_cate = $ID";

$result = mysqli_query($conn, $query);
if ($result) {
    // หากปรับปรุงข้อมูลสำเร็จ
    echo json_encode(['message' => 'File status updated successfully']);
} else {
    // หากเกิดข้อผิดพลาดในการปรับปรุงข้อมูล
    echo json_encode(['message' => 'Error updating file status']);
}
