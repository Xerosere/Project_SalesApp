<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');
$numberMain  = $_GET['currentOption'];
// $numberMain = '2';
// echo 'select'.$numberMain;

$query = "SELECT * FROM sale_material_sub_category 
Where  id_category  = $numberMain
";
$result = mysqli_query($conn, $query);
while ($row = mysqli_fetch_assoc($result)) {
    $output[] = $row;
}
echo json_encode($output);

