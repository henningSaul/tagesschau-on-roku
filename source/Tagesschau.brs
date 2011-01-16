Function getCategories() As Object
    categories = CreateObject("roList")
	category = getCategory("Dossier", "http://www.tagesschau.de/api/multimedia/video/ondemanddossier100.json")
	'category = getCategory("Dossier", "http://10.0.1.5/test.json")
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
	if(parsedJSON = invalid)
		print "Failed to parse JSON from " + url
	else
		category.items = getCategoryItems(parsedJSON) 
	end if
	return category
End Function

Function getCategoryItems(parsedJSON As Object) As Object 
    items = CreateObject("roList")
	for each video in parsedJSON.videos
		content = getVideo(video)
		items.addTail(content)
	end for
	return items
End Function

Function getVideo(video As Object) As Object
    content = CreateObject("roAssociativeArray")
	content.ContentType = "movie"
	length = ((video.outMilli - video.inMilli) / 1000)
	print length
	content.Length = length
    content.ReleaseDate = left(video.broadcastDate, 10)
	content.ShortDescriptionLine1 = video.headline
	content.ShortDescriptionLine2 = content.ReleaseDate
    content.StreamFormat= "mp4"
	' get images
	' Roku arced-landscape sizes: SD=214x144; HD=290x218
	' Roku arced-16x9 sizes: SD=166x112; HD=224x168
	images = mergeAArrays(video.images[0].variants)
	' seems to be the best fit
    content.SDPosterUrl= images.mittel16x9
	return content
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
	' correct escaped quotes
	regex = CreateObject("roRegex","\\" + Chr(34), "i" )
	json = regex.ReplaceAll(json, Chr(34) + " + Chr(34) + " + Chr(34))
	' eval json
	eval("jsonObject = " + json)
	return jsonObject
End Function

