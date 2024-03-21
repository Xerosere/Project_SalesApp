<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');
$numberMain  = $_GET['sentcurrentOption'];

$query = "SELECT * FROM filemanage_secondcategory";
$result = mysqli_query($conn, $query);
while ($row = mysqli_fetch_assoc($result)) {
    $output[] = $row;
}
echo json_encode($output);

