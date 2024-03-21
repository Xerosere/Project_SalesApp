
<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');
$numberfirst = 2;
// $numberMain = '2';
// echo 'select'.$numberMain;

$query = "SELECT * FROM filemanage_fourthcategory 
Where  IDcategory_first  = $numberfirst 
";
$result = mysqli_query($conn, $query);
while ($row = mysqli_fetch_assoc($result)) {
    $output[] = $row;
}
echo json_encode($output);

