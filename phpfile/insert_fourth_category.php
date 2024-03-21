<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php'); 
$name = $_GET['name_fourth'];
$id_first_cate = $_GET ['IDcategory_first'];
$id_second_cate = $_GET ['IDcategory_second'];
$id_third_cate = $_GET['IDcategory_third'];



$sql = "INSERT INTO filemanage_fourthcategory (`name_fourth`,`IDcategory_first`,`IDcategory_second`,`IDcategory_third`)
        VALUES ('$name','$id_first_cate','$id_second_cate','$id_third_cate')";

$result = mysqli_query($conn, $sql);

if ($result) {
    echo 'Data inserted successfully';
} else {
    echo 'Error: ' . mysqli_error($conn);
}
?>
