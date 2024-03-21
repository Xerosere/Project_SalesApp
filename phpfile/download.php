<?php
header("Access-Control-Allow-Origin: *");
session_start();

 isset($_GET['filename']);

   $doc_reffer = $_GET['filename']; 
   $file_path = 'file/' . $doc_reffer; 
   
   file_exists($file_path);
       header('Content-Type: application/octet-stream');
       header('Content-Disposition: attachment; filename="' . basename($file_path) . '"');
       header('Content-Length: ' . filesize($file_path));
       
       readfile($file_path);


   exit;
?>
