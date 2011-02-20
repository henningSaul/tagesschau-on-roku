Function newBroadcast(source as Object) As Object
    broadcast = newVideo(source)
	broadcast.GetDescriptionLine1 = broadcastGetDescriptionLine1
	broadcast.SuperGetStreams = broadcast.GetStreams
	broadcast.GetStreams = broadcastGetStreams
	return broadcast
End Function

Function broadcastGetDescriptionLine1(content As Object, broadcast As Object) As String
	return broadcast.broadcastTitle
End Function

Function broadcastGetStreams(broadcast As Object) as Object
	' get JSON
    urlTransfer = CreateObject("roUrlTransfer")
	url = m.source.details
    urlTransfer.SetUrl(url)
	print "broadcastGetStreams() retrieving JSON from " + url
    json = urlTransfer.GetToString()
	' WIP/TODO.... parsing everything crashes Roku, extract "fullvideo"
	regex = CreateObject("roRegex", "^" + Chr(34) + "fullvideo" + Chr(34) + "\:\ \[(.*?)^" + Chr(34) +"endOfContent" + Chr(34) + "\: null", "ms" )
	match = regex.Match(json)
	json = match[1]
	parsedJSON = parseJSON(json)
	if(parsedJSON = invalid)
		print "Failed to parse JSON from " + url
		return invalid
	else
		' TODO
	end if
End Function


