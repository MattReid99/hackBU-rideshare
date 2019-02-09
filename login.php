<?php	

	include("databaseConnect.php");

	$conn = new databaseConnect();

	$db = $conn->connect();


	
	

	$sql = "Select email, password from users u
		where u.email = '" . $_REQUEST['email'] .
		"' and u.password = '" . $_REQUEST['password'] . "'";

	$result = $db->query($sql);

	if($result->num_rows == 1){
		echo "true";
	}else{
		echo "false";
	}
	

	$db->close();

?>
