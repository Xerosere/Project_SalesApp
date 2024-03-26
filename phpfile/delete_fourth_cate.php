<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php'); 

// รับค่าที่ส่งมาจาก HTTP GET request
$name_first_cate = $_GET['Namecategory_first'];
$name_second_cate = $_GET['Namecategory_second'];
$name_third_cate = $_GET['Namecategory_third'];
$name_fourth_cate = $_GET['Namecategory_fourth'];

$sql1 = "DELETE FROM filemanage_fourthcategory
         WHERE IDcategory_first = '$name_first_cate' 
         AND IDcategory_second = '$name_second_cate' 
         AND IDcategory_third = '$name_third_cate' 
         AND name_fourth = '$name_fourth_cate'";

$sql2 = "DELETE FROM filemanage_filedetail
         WHERE IDcategory_first = '$name_first_cate'
         AND IDcategory_second = '$name_second_cate'
         AND IDcategory_third = '$name_third_cate'
         AND IDcategory_fourth = '$name_fourth_cate'";


$result1 = mysqli_query($conn, $sql1);
$result2 = mysqli_query($conn, $sql2);


if ($result1) {
    echo 'Data Delete successfully category 4 '.$nameedit;
}

else if($result2) {
    echo 'Data Delete File successfully category 4 '.$nameedit;
}

else {
    echo 'Error: ' . mysqli_error($conn);
}

echo json_encode($output);
?>
