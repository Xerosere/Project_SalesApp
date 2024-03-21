<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php'); 
$name = $_GET['name_third'];
$id_first_cate = $_GET ['IDcategory_first'];
$id_second_cate = $_GET ['IDcategory_second'];



$sql = "INSERT INTO filemanage_thirdcategory (`name_third`,`IDcategory_first`,`IDcategory_second`)
        VALUES ('$name','$id_first_cate','$id_second_cate')";

$result = mysqli_query($conn, $sql);

if ($result) {
    echo 'Data inserted successfully';
} else {
    echo 'Error: ' . mysqli_error($conn);
}
?>
