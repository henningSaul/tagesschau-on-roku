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
	' parsing everything crashes Roku, try to extract "fullvideo" JSON, again this is somewhat fragile
	regex = CreateObject("roRegex", "^" + Chr(34) + "fullvideo" + Chr(34) + "\:\ \[(.*?),\n^" + Chr(34) +"endOfContent" + Chr(34) + "\: null", "ms" )
	match = regex.Match(json)
	if(match[1] = invalid) 
		print "Failed to extract fullvideo JSON from " + url
		return invalid	
	end if
	json = match[1] + "}"
	fullvideo = parseJSON(json)
	if(fullvideo = invalid)
		print "Failed to parse JSON from " + url
		return invalid
	else
		return m.SuperGetStreams(fullvideo)
	end if
End Function


