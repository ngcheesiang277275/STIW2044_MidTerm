<?php
if (!isset($_POST)) {
    echo "failed";
}

include_once("dbconnect.php");

$email = $_POST['email'];
$password = sha1($_POST['password']);
$sqllogin = "SELECT * FROM `tbl_users` WHERE email = '$email' AND password = '$password'";
$result = $conn->query($sqllogin);
$numrow = $result->num_rows;

if ($numrow > 0) {
    while ($row = $result->fetch_assoc()) {
        $user = array();
        $user['email'] = $row['email'];
        $user['password'] = $row['password'];
        $user['name'] = $row['name'];
        $user['phoneNumber'] = $row['phoneNumber'];
        $user['homeAddress'] = $row['homeAddress'];
        echo json_encode($user);
        return;
    }
} else {
    echo "failed";
}

?>


