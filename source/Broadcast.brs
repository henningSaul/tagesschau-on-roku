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

' Invoked on content, fetches streams, length
Sub broadcastContentFetchDetails()
    ' get JSON
    url = m.detailsUrl
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl(url)
    print "broadcastGetStreams() retrieving JSON from " + url
    json = urlTransfer.GetToString()
    ' parsing everything crashes Roku, try to extract "fullvideo" JSON, again this is somewhat fragile
    regex = CreateObject("roRegex", "^" + Chr(34) + "fullvideo" + Chr(34) + "\:\ \[(.*?),\n^" + Chr(34) +"endOfContent" + Chr(34) + "\: null", "ms" )
    match = regex.Match(json)
    if(match[1] = invalid) 
        print "Failed to extract fullvideo JSON from " + url
    else
        json = match[1] + "}"
        fullvideo = parseJSON(json)
        if(fullvideo = invalid)
            print "Failed to parse JSON from " + url
        else
            m.Streams = getStreams(fullvideo)
            m.hasFetchedDetails = true
        end if      
    end if
    ' set length
    if(fullvideo.outMilli <> invalid)
        length% = ((fullvideo.outMilli - fullvideo.inMilli) / 1000)
        m.Length = length%
    end if
End Sub


