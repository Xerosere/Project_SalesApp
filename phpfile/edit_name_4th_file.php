<?php
header("Access-Control-Allow-Origin: *");
include('connectphp.php'); 

// รับค่าที่ส่งมาจาก HTTP GET request
$nameedit = $_GET['edit_name_fourth'];
$name_first_cate = $_GET['Namecategory_first'];
$name_second_cate = $_GET['Namecategory_second'];
$name_third_cate = $_GET['Namecategory_third'];
$name_fourth_cate = $_GET['Namecategory_fourth'];



$sql = "UPDATE filemanage_filedetail
        SET IDcategory_fourth = '$nameedit'
        WHERE IDcategory_first = '$name_first_cate' 
        AND IDcategory_second = '$name_second_cate' 
        AND IDcategory_third = '$name_third_cate' 
        AND IDcategory_fourth = '$name_fourth_cate'";

$result = mysqli_query($conn, $sql);

if ($result) {
    echo 'Data Update successfully '.$nameedit;
} else {
    echo 'Error: ' . mysqli_error($conn);
}

echo json_encode($output);
?>
