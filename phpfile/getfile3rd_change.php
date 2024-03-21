<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');
$idfirstcate = $_GET['file_first_cate'];
$idsecondcate = $_GET['file_second_cate'];
$idthirdcate = $_GET['file_third_cate'];
// $idfourthcate = $_GET['file_fo_cate'];


$query = "SELECT * FROM filemanage_filedetail 
          WHERE IDcategory_first = '$idfirstcate' 
          AND IDcategory_second = '$idsecondcate'
          AND IDcategory_third = '$idthirdcate'";

$result = mysqli_query($conn, $query);
$output = array();
while ($row = mysqli_fetch_assoc($result)) {
    $output[] = $row;
}
echo json_encode($output);
?>
