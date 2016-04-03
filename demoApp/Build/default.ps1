properties {
	$testMessage = 'Executed Test!'
	$compileMessage = 'Executed Compile!'
	$cleanMessage = 'Executed Clean!'
}

task default -depends Test

task Clean -description "Remove temporary files" {
	Write-Host $cleanMessage
}

task Compile -depends Clean -description "Compile the code" {
	Write-Host $compileMessage
}

task Test -depends Compile, Clean -description "Run unit tests" {
	Write-Host $testMessage
}