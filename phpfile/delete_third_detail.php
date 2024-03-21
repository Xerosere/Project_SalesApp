<?php
    header("Access-Control-Allow-Origin:*");
    include('connectphp.php'); 

    // รับค่าที่ส่งมาจาก HTTP GET request
    $name_first_cate = $_GET['IDcategory_first'];
    $name_second_cate = $_GET['IDcategory_second'];
    $name_third_cate = $_GET['IDcategory_third'];
    

    $sql = "DELETE FROM filemanage_filedetail
            WHERE IDcategory_first = '$name_first_cate'
            AND IDcategory_second = '$name_second_cate'
            AND IDcategory_third = '$name_third_cate'";

    $result = mysqli_query($conn, $sql);

    if ($result) {
        echo 'Data Delete successfully item category 4 '.$name_fourth_cate;
    } else {
        echo 'Error: ' . mysqli_error($conn);
    }
    ?>
