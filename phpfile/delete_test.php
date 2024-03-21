<?php
header("Access-Control-Allow-Origin: *");

if(isset($_GET['url'])) {
    $file_url = $_GET['url'];
    
    if(unlink($file_url)) {
        echo 'File deleted successfully';
    } else {
        echo 'Unable to delete file';
    }
} else {
    echo 'No file URL specified';
}
?>
