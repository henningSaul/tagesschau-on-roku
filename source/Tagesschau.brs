Function getCategories() As Object
    categories = CreateObject("roList")
	'category = getCategory("Dossier", "http://www.tagesschau.de/api/multimedia/video/ondemanddossier100.json")
	category = getCategory("Dossier", "http://10.0.1.5/test.json")
	categories.AddTail(category)
	return categories	
End Function

Function getCategory(name As String, url As String) As Object
    category = CreateObject("roAssociativeArray")
	category.name = name
	' get JSON from tagesschau
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl(url)
	print "getCategory() retrieving JSON from " + url
    json = urlTransfer.GetToString()
	parsedJSON = parseJSON(json)
	category.items = getCategoryItems(element, json) 
	return category
End Function

Function getCategoryItems(element As String, json As String) As Object 
    items = CreateObject("roList")
	return items
End Function

Function parseJSON(json As String) As Object
	null = invalid
	jsonObject = invalid
	' get rid of quotes around keys
	regex = CreateObject("roRegex", Chr(34) + "([a-zA-Z0-9_\-\s]*)" + Chr(34) + "\s*\:", "i" )
	json = regex.replaceAll(json, "\1\:")
	' correct leading comma
	regex = CreateObject("roRegex", "\n,\n", "m" )
	json = regex.replaceAll(json, "," + CHR(10))
	regex = CreateObject("roRegex", "\n,\{\n", "m" )
	json = regex.replaceAll(json, "," + CHR(10) + "{")
	' eval json
	eval("jsonObject = " + json)
	stop
	return jsonObject
End Function
