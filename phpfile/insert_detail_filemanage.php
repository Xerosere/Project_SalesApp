<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php'); 
$nameFile = $_GET['nameFile'];
$descriptionFile =$_GET['descriptionFile'];
// $filePath = $_GET['filePath'];
$datetimeUpload = $_GET['datetimeUpload'];
$firstcategory = $_GET['IDcategory_first'];
$secondcategory = $_GET['IDcategory_second'];
$thirdcategory = $_GET['IDcategory_third'];
$fourthcategory = $_GET['IDcategory_fourth'];
$pathyoutube = $_GET['IDpath_youtube'];
$typeFile = $_GET['type_of_file'];
$tag_file = $_GET['tag_file'];

$sql = "INSERT INTO filemanage_filedetail (`name_file`, `description_file`,  `datetime_upload`,`path_video`, `IDcategory_first`,`IDcategory_second`,`IDcategory_third`,`IDcategory_fourth`,`type_file`,`Tag`)
        VALUES ('$nameFile', '$descriptionFile', '$datetimeUpload','$pathyoutube', '$firstcategory', '$secondcategory','$thirdcategory','$fourthcategory','$typeFile','$tag_file')";


$result = mysqli_query($conn, $sql);
echo $tag_file;
if ($result) {
    echo 'Data inserted successfully'. $tag_file;
} else {
    echo 'Error: ' . mysqli_error($conn);
}
?>
