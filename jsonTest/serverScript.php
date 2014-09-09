<?php

$url = "http://www.hwchronicle.com/front/center/?json=get_recent_posts&count=1";
$filename = '/ids.txt';
$file;
if(file_exists($filename)){
	$file = file_get_contents($filename, true);
	$file = intval($file);
}else{
	$file = fopen($_SERVER['DOCUMENT_ROOT'] . "/ids.txt","wb");
	fclose($file);
}
$content = file_get_contents($url);
$json = json_decode($content, true);

if(intval($json['posts']['id']) != $file){
	file_put_contents($filename,$json['posts']['id']);
	$cmd = 'curl -X POST -u "UtDQUj2kQ2yhezsk0Sd80A:RjephhAoRHW6HyypkSSkcw" -H "Content-Type: application/json" --data \'{"device_tokens": ["4732CD1F2153F6509C8E4404BFE00B5E2630321B3C634847E1F081B861170033"], "aps": {"alert": "Update"}}\' https://go.urbanairship.com/api/push/';
	exec($cmd, $result);
}


?>