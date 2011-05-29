Function newBroadcastsCategory(name As String, url As String) As Object
    category = newCategory(name, url)
    category.GetVideosFromParsedJSON = catGetBroadcastsFromParsedJSON
    category.MassageJSON = broadcastsMassageJSON
    return category
End Function

Function catGetBroadcastsFromParsedJSON(parsedJSON As Object) As Object 
    videos = CreateObject("roList")
    for each broadcast in parsedJSON.latestBroadcastsPerType
        b = newBroadcast(broadcast)
        content = b.asContent()     
        videos.addTail(content)
    end for
    return videos
End Function

Function broadcastsMassageJSON(json As String) As String
    ' remove leading commas for topics
    regex = CreateObject("roRegex", "\n," + Chr(34), "m" )
    json = regex.replaceAll(json, "," + CHR(10) + Chr(34))
    return json
End Function

