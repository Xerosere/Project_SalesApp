<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');
// $nameFile = $_GET['nameFile'];
$descriptionEditor = $_GET['descriptionFileEdit'];
// $filePath = $_GET['filePath'];
// $datetimeUpload = $_GET['datetimeUpload'];
// $category = $_GET['category'];
$idFileget = $_GET['idFile'];

$sql = "UPDATE  filemanage_filedetail 
        SET     description_file='$descriptionEditor'
        Where number_cate  = $idFileget";


$result = mysqli_query($conn, $sql);

if ($result) {
    echo 'Data Update successfully '.$descriptionEditor;
} else {
    echo 'Error: ' . mysqli_error($conn);
}
// echo json_encode($output);