<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');
$new_tag = $_GET['new_tag'];

$idFileget = $_GET['idFile'];

$sql = "UPDATE  filemanage_filedetail 
        SET     Tag='$new_tag'
        Where number_cate  = $idFileget";


$result = mysqli_query($conn, $sql);

if ($result) {
    echo 'Data Update successfully ' . $descriptionEditor;
} else {
    echo 'Error: ' . mysqli_error($conn);
}
// echo json_encode($output);