properties {
	$testMessage = 'Executed Test!'
	$compileMessage = 'Executed Compile!'
	$cleanMessage = 'Executed Clean!'

	$solutionDirectory = (Get-Item $solutionFile).DirectoryName
	$outputDirectory = "$solutionDirectory\.build"
	$temporaryDirectory = "$outputDirectory\temp"

	$buildConfiguration = "Release"
	$buildPlatform = "Any CPU"
}

FormatTaskName "`r`n`r`n--- Executing {0} Task ---"

task default -depends Test

task Init `
	-description "Initializes the build by removing previous artifacts and creating output directories" `
	-requiredVariables outputDirectory, temporaryDirectory {
	
	Assert ("Debug", "Release" -contains $buildConfiguration) `
			"Invalid build configuration '$buildConfiguration'. Valid values are 'Debug' or 'Release'"

	Assert ("x86", "x64", "Any CPU" -contains $buildPlatform) `
			"Invalid build configuration '$buildPlatform'. Valid values are 'x86', 'x64' or 'Any CPU'"
			
	if(Test-Path $outputDirectory) {
		Write-Host "Removing output directory located at $outputDirectory"
		Remove-Item $outputDirectory -Recurse -Force
	}
	Write-Host "Creating output directory located at $outputDirectory"
	New-Item $outputDirectory -ItemType Directory | Out-Null

	Write-Host "Creating temporary directory located at $temporaryDirectory"
	New-Item $temporaryDirectory -ItemType Directory | Out-Null
}

task Clean -description "Remove temporary files" {
	Write-Host $cleanMessage
}

task Compile -depends Init `
	-description "Compile the code" `
	-requiredVariables solutionFile, buildConfiguration, buildPlatform, temporaryDirectory {
	Write-Host "Building solution $solutionFile"
	Exec {
		msbuild $solutionFile "/p:Configuration=$buildConfiguration;Platform=$buildPlatform;OutDir=$temporaryDirectory"
	}
}

task Test -depends Compile, Clean -description "Run unit tests" {
	Write-Host $testMessage
}