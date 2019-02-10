<?php

	include("databaseConnect.php");

	$conn = new databaseConnect();


	$db = $conn->connect();
	$sql = $db->prepare("DELETE FROM rider_queue WHERE (userID) = (?)");
	$sql->bind_param("s", $_REQUEST['userID']);
	$sql->execute();

	$db->close();
?>
