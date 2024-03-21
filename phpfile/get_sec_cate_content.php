<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');
$getidcate = $_GET['Getidcate'];

$query = "SELECT * FROM filemanage_secondcategory
Where id_category='$getidcate'";

$result = mysqli_query($conn, $query);
while ($row = mysqli_fetch_assoc($result)) {    
    $output[] = $row;
}
echo json_encode($output);  