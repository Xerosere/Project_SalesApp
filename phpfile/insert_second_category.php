<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php'); 
$name = $_GET['name'];
$id_cate = $_GET ['id_cate'];


$sql = "INSERT INTO filemanage_secondcategory (`name_second`,`id_category`)
        VALUES ('$name','$id_cate')";

$result = mysqli_query($conn, $sql);

if ($result) {
    echo 'Data inserted successfully';
} else {
    echo 'Error: ' . mysqli_error($conn);
}
?>
