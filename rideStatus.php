<?php

	include("databaseConnect.php");

	$conn = new databaseConnect();

//echo "test 1";
	$db = $conn->connect();
	$sql = "SELECT DRIVER_ID, destination, rating, driverName from rides where PASSENGER_ID = " . "'". $_REQUEST['userID'] . "'";
    $result = $db->query($sql);
	if($row = $result->fetch_assoc()){
	    echo json_encode(array('driverID' => intval($row['DRIVER_ID']), 'destination' => $row['destination'], 'rating' => doubleval($row['rating']), 'name' => $row['driverName']));
	    
	}else{
	    echo "NULL";
	}
	$db->close();
?>
