<?php

	include("databaseConnect.php");

	$conn = new databaseConnect();

	$db = $conn->connect();



	$prepare = $db->prepare("UPDATE rides (LATITUDE, LONGITUDE, DRIVER_ID) VALUES (?, ?, ?)");
	$prepare->bind_param("ddi",$_REQUEST['latitude'], $_REQUEST['longitude'], $_REQUEST['driver_id']);

	$prepare->execute();
	$prepare->close();
	$db->close();


	


?>
