<?php
header("Access-Control-Allow-Origin: *");
include('connectphp.php');
error_reporting(E_ERROR | E_PARSE);




$response = new stdClass;
$response->status = null;
$response->message = null;


$destination_dir = "pdf_preview/";
$base_filename = basename($_FILES["file"]["name"]);
$target_file = $destination_dir . $base_filename;


if (!$_FILES["file"]["error"]) {
    if (move_uploaded_file($_FILES["file"]["tmp_name"], $target_file)) {
        $response->status = true;
        $response->message = "File uploaded successfullyasjdkjqgwiludglqgdw";
    } else {


        $response->status = false;
        $response->message = "File uploading failed";
    }
} else {
    $response->status = false;
    $response->message = "File uploading failed";
}


header('Content-Type: application/json');
echo json_encode($response);
