<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');

echo 'come';

$nameFile = $_POST['nameFile'];
$descriptionFile =$_POST['descriptionFile'];
$datetime_upload = $_POST['datetimeUpload'];
$user_upload = $_POST['user_upload'];
$number_cate = $_POST['number_cate'];
$path_video = $_POST['path_video'];
$IDcategory_first = $_POST['IDcategory_first'];
$IDcategory_second= $_POST['IDcategory_second'];
$IDcategory_third= $_POST['IDcategory_third'];
$IDcategory_fourth= $_POST['IDcategory_fourth'];
// $IDcategory_fifth= $_GET['IDcategory_fifth'];
$type_file= $_POST['type_file'];
// $user_deleted= $_GET['user_deleted'];
// $datetime_deleted= $_GET['datetime_deleted'];

echo 'Sent';




$sql = "INSERT INTO filemanage_deleted_files (`name_file`, `description_file`, `datetime_upload`, `user_upload`, `number_cate`, `path_video`, `IDcategory_first`, `IDcategory_second`, `IDcategory_third`, `IDcategory_fourth`, `type_file`, `datetime_deleted`, `IDcategory_fifth`, `user_deleted`)
VALUES ('$nameFile', '$descriptionFile', '$datetime_upload', '$user_upload', '$number_cate', '$path_video', '$IDcategory_first', '$IDcategory_second', '$IDcategory_third', '$IDcategory_fourth', '$type_file', NOW(), '', '')
";



$result = mysqli_query($conn, $sql);
if ($result) {
    echo 'Data inserted successfully';
} else {
    echo 'Error: ' . mysqli_error($conn);
}
?>
