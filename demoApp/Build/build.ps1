Clear-Host

# '[p]'sake is the same as psake but $Error is not polluted
Remove-Module [p]sake

# find psake's path
$psakeModule = (Get-ChildItem "..\packages\psake.*\tools\psake.psm1").FullName | Sort-Object $_ | select -Last 1

Import-Module $psakeModule

Invoke-psake -buildFile .\default.ps1 -taskList Test -properties @{
	 "testMessage" = "What am I doing?"
}

# Get Task list
# Invoke-psake -docs