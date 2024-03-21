    <?php
    header("Access-Control-Allow-Origin: *");
    include('connectphp.php'); 

    if(isset($_GET['currentOption']) && isset($_GET['currentOption2']) && isset($_GET['currentOption3']) && isset($_GET['currentOption4']) && isset($_GET['url'])) {

        $currentOption = $_GET['currentOption'];
        $currentOption2 = $_GET['currentOption2'];
        $currentOption3 = $_GET['currentOption3'];
        $currentOption4 = $_GET['currentOption4'];
        $file_url = $_GET['url'];

        // 1. ลบข้อมูลไฟล์ในฐานข้อมูล MySQL
        $sql_delete = "DELETE FROM filemanage_filedetail WHERE IDcategory_first = '$currentOption' AND IDcategory_second = '$currentOption2' AND IDcategory_third = '$currentOption3' AND IDcategory_fourth = '$currentOption4'";
        $result_delete = mysqli_query($conn, $sql_delete);

        if ($result_delete) {
            // 2. ตรวจสอบว่าไฟล์อยู่ในเซิร์ฟเวอร์หรือไม่ และลบไฟล์ในเซิร์ฟเวอร์
            if(file_exists($file_url)) {
                if(unlink($file_url)) {
                    echo 'Data and files deleted successfully';
                } else {
                    echo 'Unable to delete file';
                }
            } else {
                echo 'File not found';
            }
        } else {
            echo 'Error deleting data: ' . mysqli_error($conn);
        }
    } else {
        echo 'Missing parameters';
        exit();
    }
    ?>
