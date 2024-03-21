<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');

$query = "SELECT * FROM sale_material_Brochure_BT_category_list 
";
$result = mysqli_query($conn, $query);
while ($row = mysqli_fetch_assoc($result)) {
    $output[] = $row;
}
echo json_encode($output);