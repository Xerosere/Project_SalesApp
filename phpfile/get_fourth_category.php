<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');
$numberSub = $_GET['currentOption3'];
// $numberMain = '2';
// echo 'select'.$numberMain;

$query = "SELECT * FROM filemanage_fourthcategory 
Where  IDcategory_third  = $numberSub
";
$result = mysqli_query($conn, $query);
while ($row = mysqli_fetch_assoc($result)) {
    $output[] = $row;
}
echo json_encode($output);

