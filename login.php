<?php	

	include("databaseConnect.php");

	$conn = new databaseConnect();

	$db = $conn->connect();


	
	

	$sql = "Select email, password from users u
		where u.email = '" . $_REQUEST['email'] .
		"' and u.password = '" . $_REQUEST['password'] . "'";

	$result = $db->query($sql);
	
	if($result->num_rows == 1){
		
		$sql = "Select ID, Name, isDriver, email from users u where u.email = '" . $_REQUEST['email'] ."'";
		$result = $db->query($sql);
		$row = $result->fetch_assoc();

		echo json_encode(array( "ID" => intval($row['ID']), "ISDRIVER" => $row["isDriver"], "NAME" => $row['Name'], "EMAIL" => $row["email"]));
	}else{
		echo json_encode(array( "ID" => -1));
	}
	

	$db->close();

?>
