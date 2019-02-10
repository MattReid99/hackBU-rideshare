<?php 
include("databaseConnect.php");
	if(strpos($_REQUEST['email'], '@binghamton.edu') != 0){
		


		$conn = new databaseConnect();

		$db = $conn->connect();



		$prepare = $db->prepare("INSERT INTO users (name, email, password) VALUES (?, ?, ?)");
		$prepare->bind_param($_REQUEST['name'], $_REQUEST['email'], $_REQUEST['password']);

		$prepare->execute();
		$prepare->close();
		$db->close();
	}else{

		echo "false";
	}



?>
