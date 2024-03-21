<?php

header("content-type:text/javascript;charset=utf-8");
$servername = "localhost";
$username = "intern_dev";
$password = "n3ioTFoLD5e4nLaN";
$dbname = "btmexpe1_warehouseconnect";

$conn = mysqli_connect($servername, $username, $password, $dbname);


if (!$conn) {
    die("connection failed" . mysqli_connect_error());
    echo 'Error fail!!!';
} else {  


}