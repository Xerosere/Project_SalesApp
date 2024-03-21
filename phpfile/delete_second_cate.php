<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php'); 

// รับค่าที่ส่งมาจาก HTTP GET request
$name_first_cate = $_GET['Namecategory_first'];
$name_second_cate = $_GET['Namecategory_second'];


$sql = "DELETE FROM filemanage_secondcategory
         WHERE id_category = '$name_first_cate' 
         AND name_second = '$name_second_cate' 
         ";


$result= mysqli_query($conn, $sql);


if ($result) {
    echo 'Data Delete successfully category 3 '.$name_third_cate;
}

else {
    echo 'Error: ' . mysqli_error($conn);
}

echo json_encode($output);
?>
