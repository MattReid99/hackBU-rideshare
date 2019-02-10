<?php

	include("databaseConnect.php");

	$conn = new databaseConnect();


	$db = $conn->connect();
	$sql = "SELECT userID, location, destination, name from rider_queue LIMIT 30";
	
	$result = $db->query($sql);
	
	while($row = $result->fetch_assoc()){
		$outArr[] = ['userID' => intval($row['userID']), 'location' => $row['location'], 'destination' => $row['destination'], 'name' => $row['name']];
	    
	}

	echo json_encode($outArr);
	$db->close();
?>
