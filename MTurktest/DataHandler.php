<?php

	function random_str($length, $keyspace = '0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ')
	{
		$str = '';
		$max = mb_strlen($keyspace, '8bit') - 1;
		for ($i = 0; $i < $length; ++$i) {
			$str .= $keyspace[rand(0, $max)];
		}
		return $str;
	}

	echo "<h2>Uploading data... </h2>";
	
	$cCode = random_str(8);
	$returnMsg = "Data successfully uploaded. This is your confirmation code: ".$cCode;
	
	//var_dump($_GET);
	
	$expName = $_REQUEST['ExpName'];
	//echo "ExpName:".$expName;
	$dirName = "../AMTData/".$expName;//Expname from Mnenu
	//$dirName = $expName;
	//$dirName = .$expName;
	if (false == is_dir($dirName)) {
		mkdir($dirName);
	}
		
	$fileName = $_REQUEST['assignmentId'];
		
	$fid1 = fopen($dirName."/".$fileName.".txt", 'w');
	fwrite($fid1, 'confirmation number: '.$cCode."\r\n");
	
	// Loop over each item in the form.
	foreach($_REQUEST as $name => $value) {
	    switch ($name){
	    case "Ratings":
			//create a specific file for data
			$fid2 = fopen($dirName."/Ratings".$fileName.".txt", 'w');
			fwrite($fid2, $value);
			fclose($fid2);
			break;
		case "SameDifferent":
			//create a specific file for data
			$fid2 = fopen($dirName."/SameDifferent".$fileName.".txt", 'w');
			fwrite($fid2, $value);
			fclose($fid2);
			break;
			}
			
		fwrite($fid1, $name.':'.$value."\r\n");		
		}

	fclose($fid1);
	echo "<h2>".$returnMsg."</h2>";
?>