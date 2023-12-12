$DceURI = "https://dce-weu-prd-datacollection-xxxx.westeurope-1.ingest.monitor.azure.com"
$DcrImmutableId = "dcr-xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"
$streamName = "Custom-WeatherRawData" #name of the stream in the DCR that represents the destination table

#information needed to authenticate to AAD and obtain a bearer for app-am-alertcc-ingestion
$tenantId = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"; #Tenant ID the data collection endpoint resides in
$appId = "xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"; #Application ID created and granted permissions
$appSecret = "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx"; #Secret created for the application

#Obtain a bearer token used to authenticate against the data collection endpoint
$scope= [System.Web.HttpUtility]::UrlEncode("https://monitor.azure.com//.default")   
$body = "client_id=$appId&scope=$scope&client_secret=$appSecret&grant_type=client_credentials";
$headers = @{"Content-Type"="application/x-www-form-urlencoded"};
$uri = "https://login.microsoftonline.com/$tenantId/oauth2/v2.0/token"
$token = $null
$token = (Invoke-RestMethod -Uri $uri -Method "Post" -Body $body -Headers $headers).access_token

# payload
$data = Get-Content ".\meta\weather\weatherData.json"
$data = "[" + $data + "]"

# Sending the data to Log Analytics via the DCR!
$headers = @{"Authorization" = "Bearer $token"; "Content-Type" = "application/json" };
$uri = "$DceURI/dataCollectionRules/$DcrImmutableId/streams/$streamName" + "?api-version=2021-11-01-preview";
Invoke-RestMethod -Uri $uri -Method Post -Body $data -Headers $headers;
