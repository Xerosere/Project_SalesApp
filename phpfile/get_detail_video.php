<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');
$pathvideo = $_GET ['pathvideo'];
error_log("Received path_video: $pathvideo");

$query = "SELECT * FROM filemanage_filedetail
Where (path_video = '$pathvideo')
";

$result = mysqli_query($conn, $query);
while ($row = mysqli_fetch_assoc($result)) {
$output[] = $row;
}
echo json_encode($output);
error_log("Output: " . json_encode($output));
?>