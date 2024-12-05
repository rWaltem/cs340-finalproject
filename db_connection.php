<?php
$host = 'classmysql.engr.oregonstate.edu'; // Remote host
$username = 'cs340_waltemry'; // Your OSU database username
$password = '4358'; // Your OSU database password
$database = 'cs340_waltemry'; // Database name

$conn = new mysqli($host, $username, $password, $database);

// Check connection
if ($conn->connect_error) {
    die("Connection failed: " . $conn->connect_error);
}
?>
