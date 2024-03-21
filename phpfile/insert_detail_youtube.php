<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php'); 

$pathYoutube = $_GET['pathYoutube'];
$descriptionVideo = $_GET['descriptionVideo'];
$datetimeUpload = $_GET['datetimeUpload'];
$pathVideoInput = $_GET['pathVideoInput'];

$sql = "INSERT INTO filemanage_youtubedetail (`name_video`, `description_video`, `time_upload`, `path_video`)
        VALUES ('$pathYoutube', '$descriptionVideo', '$datetimeUpload', '$pathVideoInput')";

$result = mysqli_query($conn, $sql);

if ($result) {
    echo 'Data inserted successfully';
} else {
    echo 'Error: ' . mysqli_error($conn);
}
?>
