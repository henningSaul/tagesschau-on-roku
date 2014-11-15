Function newCurrentVideosCategory(name As String, url As String) As Object
    category = newCategory(name, url)
    category.MassageJSON = currentVideosMassageJSON
'    category.GetVideos = currentVideosGetVideos
    category.GetCacheInSeconds = currentGetCacheInSeconds
    category.SuperFetchVideos = category.FetchVideos
    category.FetchVideos = currentFetchVideos
    category.FetchLiveStreams = currentFetchLiveStreams
    return category
End Function

Function currentGetCacheInSeconds() As Integer
    return 1 * 60
End Function

Function currentVideosMassageJSON(json As String) As String
    ' TODO: this is a little fragile.... maybe tagesschau has a dedicated URL for the Aktuell JSON  
    ' we need to remove some json elements, otherwise the Aktuell JSON parsing crashes the Roku...
    ' TODO: use ParseJson from SDK
    regex = CreateObject("roRegex", "^" + Chr(34) + "multimedia" + Chr(34) + "\:\ \[.*^" + Chr(34) +"broadcastArchive" + Chr(34) + "\:", "ms" )
    json = regex.replaceAll(json, CHR(34) + "broadcastArchive" + CHR(34) + ":")
    return json
End Function

Function currentFetchVideos() As Object
    result = m.SuperFetchVideos()
    ' fetch live stream(s)
    currentLiveStreams = m.FetchLiveStreams()
    if currentLiveStreams <> invalid
        for each liveStream in currentLiveStreams
            result.addHead(liveStream.AsContent())
        end for
    end if
    return result           
End Function

Function currentFetchLiveStreams() As Object
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl(m.url)
    json = urlTransfer.GetToString()
    regex = CreateObject("roRegex", "^" + Chr(34) + "livestreams" + Chr(34) + "\:(.*)" + "},\n{" + Chr(34) +"tsInHundredSeconds" + Chr(34) + "\:", "ms" )
    matched = regex.Match(json)
    if(matched = invalid)
        return invalid
    end if
    json = matched[1]    
    parsedJSON = parseJSON(json)
    if(parsedJSON = invalid)
        print "Failed to parse LiveStreams JSON from " + m.url
        return invalid
    else
        liveStreams = CreateObject("roList")
        for each parsedStream in parsedJSON
            liveStream = newLiveStream(parsedStream)
            liveStreams.addHead(liveStream)            
        end for
        return liveStreams
    end if
End Function



