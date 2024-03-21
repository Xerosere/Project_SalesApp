<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php'); 
$name = $_GET['bro_bt_cate_name'];



$sql = "INSERT INTO sale_material_Brochure_BT_category_list (`bro_bt_cate_name`)
        VALUES ('$name')";

$result = mysqli_query($conn, $sql);

if ($result) {
    echo 'Data inserted successfully';
} else {
    echo 'Error: ' . mysqli_error($conn);
}
?>
