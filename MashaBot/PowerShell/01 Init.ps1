<#	
	.NOTES
	===========================================================================
	 Created on:   	27/2/2018
	 Created by:   	Cesar Ruge https://www.linkedin.com/in/cesar-ruge
	===========================================================================
	.DESCRIPTION
		Script to initialize  and execute  all scripts 
#>

try
{
    &'.\02 Create Elements.ps1' `
}
catch [System.Exception]
{
    $ErrorMessage = $_.Exception.Message
	Write-Host($ErrorMessage)
}

