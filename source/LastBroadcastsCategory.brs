Function newLastBroadcastsCategory(name As String, url As String) As Object
    category = newCategory(name, url)
	category.GetVideosFromParsedJSON = catGetLastBroadcastsFromParsedJSON
	return category
End Function

Function catGetLastBroadcastsFromParsedJSON(parsedJSON As Object) As Object 
    videos = CreateObject("roList")
	for each broadcast in parsedJSON.latestBroadcastsPerType
		b = newBroadcast(broadcast)
		content = b.asContent()		
		videos.addTail(content)
	end for
	return videos
End Function
