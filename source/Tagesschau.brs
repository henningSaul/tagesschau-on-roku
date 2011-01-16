Function getCategories() As Object
    categories = CreateObject("roList")
	' get JSON from tagesschau
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl("http://www.tagesschau.de/api/multimedia/video/ondemand100.json")
    json = urlTransfer.GetToString()
	category = getCategory("Aktuell", "bla", json)
	categories.AddTail(category)
	category = getCategory("Dossier", "bla", json)
	categories.AddTail(category)
	category = getCategory("Archive", "bla", json)
	categories.AddTail(category)
	return categories	
End Function


Function getCategory(name As String, element As String, json As String) As Object
    category = CreateObject("roAssociativeArray")
	category.name = name
	category.items = getCategoryItems(element, json) 
	return category
End Function

Function getCategoryItems(element As String, json As String) As Object 
    items = CreateObject("roList")
	return items
End Function