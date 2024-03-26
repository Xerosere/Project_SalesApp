<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');

$id_file = $_GET['id_file'];


$sql1 = "DELETE FROM filemanage_filedetail
         WHERE number_cate  = '$id_file' 
";


$result1 = mysqli_query($conn, $sql1);


if ($result1) {
    echo 'Data Delete successfully category 4 ' . $id_file;
} else {
    echo 'Error: ' . mysqli_error($conn);
}

echo json_encode($output);
