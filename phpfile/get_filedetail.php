
<?php
header("Access-Control-Allow-Origin:*");
include('connectphp.php');

$id_main_cate = $_GET['sent_id_first'];


$query = "SELECT * FROM filemanage_filedetail
WHERE IDcategory_first = '$id_main_cate'";

$result = mysqli_query($conn, $query);
while ($row = mysqli_fetch_assoc($result)) {
    $output[] = $row;
}
echo json_encode($output);