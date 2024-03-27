<?php
$path = $_GET['url'];

header('Content-Type: application/pdf');
header('Content-Disposition: inline; filename=' . $path);
header('Content-Transfer-Encoding: binary');
header('Accept-Ranges: bytes');

readfile($path);
