<?php
header("Access-Control-Allow-Origin: *");
include('connectphp.php');

// Sanitize input values
$nameFile = mysqli_real_escape_string($conn, $_GET['nameFile']);
$descriptionFile = mysqli_real_escape_string($conn, $_GET['descriptionFile']);
$datetimeUpload = mysqli_real_escape_string($conn, $_GET['datetimeUpload']);
$firstcategory = mysqli_real_escape_string($conn, $_GET['IDcategory_first']);
$secondcategory = mysqli_real_escape_string($conn, $_GET['IDcategory_second']);
$thirdcategory = mysqli_real_escape_string($conn, $_GET['IDcategory_third']);
$fourthcategory = mysqli_real_escape_string($conn, $_GET['IDcategory_fourth']);
$pathyoutube = mysqli_real_escape_string($conn, $_GET['IDpath_youtube']);
$typeFile = mysqli_real_escape_string($conn, $_GET['type_of_file']);
$tag_file = mysqli_real_escape_string($conn, $_GET['tag_file']);
$status_file = mysqli_real_escape_string($conn, $_GET['status_file']);

$sql = "INSERT INTO filemanage_filedetail (`name_file`, `description_file`,  `datetime_upload`, `path_video`, `IDcategory_first`, `IDcategory_second`, `IDcategory_third`, `IDcategory_fourth`, `type_file`, `Tag`, `status_file`)
        VALUES ('$nameFile', '$descriptionFile', '$datetimeUpload', '$pathyoutube', '$firstcategory', '$secondcategory', '$thirdcategory', '$fourthcategory', '$typeFile', '$tag_file', '$status_file')";

$result = mysqli_query($conn, $sql);

if ($result) {
    echo 'Data inserted successfully';
} else {
    echo 'Error: Unable to insert data into the database';
}
