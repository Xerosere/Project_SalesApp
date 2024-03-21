<?php
    header("Access-Control-Allow-Origin:*");
    include('connectphp.php'); 

    // รับค่าที่ส่งมาจาก HTTP GET request
    $name_first_cate = $_GET['IDcategory_first'];
    $name_second_cate = $_GET['IDcategory_second'];

    

    $sql = "DELETE FROM filemanage_filedetail
            WHERE IDcategory_first = '$name_first_cate'
            AND IDcategory_second = '$name_second_cate'
          ";

    $result = mysqli_query($conn, $sql);

    if ($result) {
        echo 'Data Delete successfully item category 2 '.$name_fourth_cate;
    } else {
        echo 'Error: ' . mysqli_error($conn);
    }
    ?>
