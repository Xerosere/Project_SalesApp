<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');
$getfirstcate = $_GET['Getidcate'];
// $getseccate = $_GET['Getidsec'];



$query = "SELECT * FROM filemanage_thirdcategory
Where IDcategory_first='$getfirstcate' 
-- AND IDcategory_second ='$getseccate'
";

$result = mysqli_query($conn, $query);
while ($row = mysqli_fetch_assoc($result)) {    
    $output[] = $row;
}
echo json_encode($output);