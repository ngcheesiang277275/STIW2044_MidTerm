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

$sqlloadsubject = "SELECT * FROM tbl_subjects";
$result = $conn->query($sqlloadsubject);
$number_of_result = $result->num_rows;
$number_of_page = ceil($number_of_result / $results_per_page);
$sqlloadsubject = $sqlloadsubject . " LIMIT $page_first_result , $results_per_page";
$result = $conn->query($sqlloadsubject);

if($result->num_rows >0){
    $subjects["subject"] = array();     
    while($row = $result->fetch_assoc()) {
        $sublist = array();
        $sublist['subjectId'] = $row['subject_id'];
        $sublist['subjectName'] = $row['subject_name'];
        $sublist['subjectDescription'] = $row['subject_description'];
        $sublist['subjectPrice'] = $row['subject_price'];
        $sublist['tutorId'] = $row['tutor_id'];
        $sublist['subjectSessions'] = $row['subject_sessions'];
        $sublist['subjectRating'] = $row['subject_rating'];
        array_push($subjects["subject"],$sublist);
    }
    $response = array('status' => 'success', 'pageno' => "$pageno", 'numofpage' => "$number_of_page" , 'data' => $subjects);
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

