<?php	
	echo "Here 1";
	include("databaseConnect.php");
	echo "Here 2";
	$conn = new databaseConnect();
	echo "Here 3";	
	$db = $conn->connect();
	echo "Here 4";

	
	

	$sql = "Select email, password from users u
		where u.email = '" . $_REQUEST['email'] .
		"' and u.password = '" . $_REQUEST['password'] . "'";

	$result = $db->query($sql);

	if($result->num_rows == 1){
		return json_encode(true);
	}else{
		return json_encode(false);
	}
	

	$db->close();

?>
