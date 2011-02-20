Function newBroadcast(source as Object) As Object
    broadcast = newVideo(source)
	broadcast.GetDescriptionLine1 = broadcastGetDescriptionLine1
	' lazy loading of details/streams
	broadcast.GetDetails = broadcastGetDetails	
	return broadcast
End Function

Function broadcastGetDescriptionLine1(content As Object) As String
	broadcast = m.source
	return broadcast.broadcastTitle
End Function

' support for lazy loading...
Function broadcastGetDetails(content As Object)
	content.hasFetchedDetails = false
	content.detailsUrl = m.source.details
	content.FetchDetails = broadcastContentFetchDetails	
End Function

' Invoked on content
Function broadcastContentFetchDetails()
	m.Streams = broadcastGetStreams(m.detailsUrl)
	if(m.Streams <> invalid)
		m.hasFetchedDetails = true
	end if
End Function


Function broadcastGetStreams(url As String) As Object
	' get JSON
    urlTransfer = CreateObject("roUrlTransfer")
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
		return getStreams(fullvideo)
	end if
End Function


