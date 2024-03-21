<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');

// ตรวจสอบว่าตัวแปรถูกส่งมาหรือไม่
if(isset($_GET['file_first_cate'], $_GET['file_second_cate'], $_GET['file_third_cate'], $_GET['file_fourth_cate'])) {
    $idfirstcate = $_GET['file_first_cate'];
    $idsecondcate = $_GET['file_second_cate'];
    $idthirdcate = $_GET['file_third_cate'];
    $idfourthcate = $_GET['file_fourth_cate'];

    // ใส่เครื่องหมายเดิมพันรอบค่าข้อมูลที่เป็น string
    $query = "SELECT * FROM filemanage_filedetail 
              WHERE IDcategory_first = '$idfirstcate'
              AND IDcategory_second = '$idsecondcate'
              AND IDcategory_third = '$idthirdcate'
              AND IDcategory_fourth = '$idfourthcate'";

    $result = mysqli_query($conn, $query);
    $output = array();
    while ($row = mysqli_fetch_assoc($result)) {
        $output[] = $row;
    }
    echo json_encode($output);
} else {
    // ถ้าไม่มีพารามิเตอร์ที่ส่งมาก็คืนค่าว่าง
    echo json_encode([]);
}
?>
