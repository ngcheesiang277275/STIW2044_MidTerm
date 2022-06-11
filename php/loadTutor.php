<?php
if (!isset($_POST)) {
    $response = array('status' => 'failed', 'data' => null);
    sendJsonResponse($response);
    die();
}

include_once("dbconnect.php");
$results_per_page = 5;
$pageno = (int)$_POST['pageno'];
$page_first_result = ($pageno-1) * $results_per_page;

$sqlload = "SELECT * FROM tbl_tutors";
$result = $conn->query($sqlload);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlload = $sqlload . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlload);

if($result->num_rows >0){
    $tutors["tutor"] = array();     
    while($row = $result->fetch_assoc()) {
        $tutorlist = array();
        $tutorlist['tutorId'] = $row['tutor_id'];
        $tutorlist['tutorEmail'] = $row['tutor_email'];
        $tutorlist['tutorPhone'] = $row['tutor_phone'];
        $tutorlist['tutorName'] = $row['tutor_name'];
        $tutorlist['tutorPassword'] = $row['tutor_password'];
        $tutorlist['tutorDescription'] = $row['tutor_description'];
        $tutorlist['tutorDatereg'] = $row['tutor_datereg'];
        array_push($tutors["tutor"],$tutorlist);
    }
    $response = array('status' => 'success', 'pageno' => "$pageno", 'numofpage' => "$number_of_page" , 'data' => $tutors);
    sendJsonResponse($response);
}else{
    $response = array('status' => 'failed', 'pageno' => "$pageno", 'numofpage' => "$number_of_page", 'data' => null);
    sendJsonResponse($response);
}

function sendJsonResponse($sentArray){
    header('Content-Type: application/json');
    echo json_encode($sentArray);
}
?>

