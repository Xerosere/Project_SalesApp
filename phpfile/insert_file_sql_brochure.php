<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php'); 
$nameFile = $_GET['nameFile'];
$descriptionFile =$_GET['descriptionFile'];
$filePath = $_GET['filePath'];
$datetimeUpload = $_GET['datetimeUpload'];
$category = $_GET['category'];


$sql = "INSERT INTO sale_material_brochure (`name_file`, `description_file`,  `datetime_upload`, `category`)
        VALUES ('$nameFile', '$descriptionFile', '$datetimeUpload', '$category')";

$result = mysqli_query($conn, $sql);

if ($result) {
    echo 'Data inserted successfully';
} else {
    echo 'Error: ' . mysqli_error($conn);
}
?>
