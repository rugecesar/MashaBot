<#	
	.NOTES
	===========================================================================
	 Created on:   	27/2/2018
	 Created by:   	Cesar Ruge https://www.linkedin.com/in/cesar-ruge
	===========================================================================
	.DESCRIPTION
		This script create a   webApp sites for Masha Bot
#>


#declare variables 

    $location = "eastus"
	$resoursegroup = "rggmashabot$(Get-Random)"
    $SubscriptionId = "[your suscription id here]"
    $WebAppMashaBot = "WebAppMashaBot$(Get-Random)"
    $WebPublicAppMashaBot = "WebPublicAppMashaBot$(Get-Random)"
    $AppServicePlan = "AzureRmAppServicePlan$(Get-Random)"
    $WebAppSlot = "WebAppSlot$(Get-Random)"

#Set user and subcription
function Select-SubscriptionAzure{
    
	$login = Login-AzureRmAccount
	Write-Host("Login Account:")
	Write-Host($login.Context.Account)
	$subcription = Select-AzureRmSubscription -SubscriptionId $SubscriptionId  -ErrorAction Stop

	Write-Host("Select Subscription:")
	Write-Host($subcription.Subscription)
}


#Create resource Group
function New-RGmva{
	Write-Host("Create Resource Group:" + $resoursegroup )
	New-AzureRmResourceGroup -Name $resoursegroup  -Location $location -ErrorAction Stop
}


#Create a BOT Web Site 
function New-BotWebsitemva{
	param(
		[parameter(Mandatory=$true)]
		$WebAppName
	)

    # Create an App Service plan in Free tier.
    New-AzureRmAppServicePlan -Name $AppServicePlan -Location $location `
    -ResourceGroupName $resoursegroup -Tier Free

    # Create a web app.
    New-AzureRmWebApp -Name $WebAppName -Location $location `
    -AppServicePlan $AppServicePlan -ResourceGroupName $resoursegroup


    #Create a deployment slot with the name "staging".
    New-AzureRmWebAppSlot -Name $WebAppSlot -ResourceGroupName $resoursegroup `
    -Slot staging

    # Upgrade App Service plan to Standard tier (minimum required by deployment slots)
    Set-AzureRmAppServicePlan -Name $AppServicePlan -ResourceGroupName $resoursegroup `
    -Tier Standard

}


#Create Header Message
function Start-ASCIIART{
	cls
	Write-Host("*****************************************")
	Write-Host("          __ _ _____   _ _ __ ___        ")
	Write-Host("         / _` |_  / | | | '__/ _ \       ")
	Write-Host("        | (_| |/ /| |_| | | |  __/       ")
	Write-Host("         \__,_/___|\__,_|_|  \___|       ")
	Write-Host("*		        Cesar Ruge              *")
	Write-Host("*           MashaBot Azure WebApp       *")
	Write-Host("*****************************************")
}

#Main Funtion
function Start-Main(){
try{
	Start-ASCIIART
	Select-SubscriptionAzure
	New-RGmva
    New-BotWebsitemva -WebAppName $WebAppMashaBot
    New-BotWebsitemva -WebAppName $WebPublicAppMashaBot
 
    Write-Host("Finished The Process...");
}
catch [System.Exception]
{
	$ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
    Write-Error("The Script does not work :" + $ErrorMessage )
	
}
}

#Start Run Functions
try
{	
	Start-Main
}
catch [System.Exception]
{
	$ErrorMessage = $_.Exception.Message
    $FailedItem = $_.Exception.ItemName
	
	Write-Error("The Script does not work :" + $ErrorMessage + "Objet:" +$FailedItem)
	exit
}