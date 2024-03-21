feet+sale<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');


$query = "SELECT * FROM filemanage_firstcategory
";
$result = mysqli_query($conn, $query);
while ($row = mysqli_fetch_assoc($result)) {
    $output[] = $row;
}
echo json_encode($output);