<?php
$file = "/root/Logs/anchor_dropbox_log_overall.txt";
if (file_exists($file)) {
$file = file_get_contents($file);
	// Bytes
	$pattern = '/(\d.*)(?=.Bytes)/';
	preg_match_all($pattern, $file, $matches); 
	$total_bytes = array_sum($matches[0]);
	$total_gb = round($total_bytes / 1024 / 1024 / 1024, 2);

	// Errors
	$pattern = '/(\d.*)(?=\sChecks)/';
	preg_match_all($pattern, $file, $matches); 
	$total_errors = array_sum($matches[0]);

	// Checks
	$pattern = '/(\d.*)(?=\sTransferred)/';
	preg_match_all($pattern, $file, $matches); 
	$total_checks = array_sum($matches[0]);

	// Transferred
	$pattern = '/(\d.*)(?=\sElapsed time)/';
	preg_match_all($pattern, $file, $matches); 
	$total_transferred = array_sum($matches[0]);

	// return GBs transferred 
	echo "Total data transferred: " . $total_gb ." GB\n";
	echo "Total file errors: " . $total_errors . "\n";
	echo "Total file checkes: " . $total_checks . "\n";
	echo "Total files transferred: ". $total_transferred . "\n";
}

?>