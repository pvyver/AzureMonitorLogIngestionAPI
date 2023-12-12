$headers=@{}
$headers.Add("X-RapidAPI-Key", "xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
$headers.Add("X-RapidAPI-Host", "weatherapi-com.p.rapidapi.com")
$response = Invoke-WebRequest -Uri 'https://weatherapi-com.p.rapidapi.com/current.json?q=51.21%2C4.40' -Method GET -Headers $headers
$response.Content | Out-File ".\meta\weather\weatherData.json"