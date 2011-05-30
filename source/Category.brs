Function newCategory(name As String, url As String) As Object
    category = CreateObject("roAssociativeArray")
    category.name = name
    category.url = url
    category.lastFetched = invalid
    category.videos = invalid
    category.GetVideos = catGetVideos
    category.HasUpdate = catHasUpdate
    category.FetchVideos = catFetchVideos
    category.MassageJSON = catMassageJSON
    category.GetVideosFromParsedJSON = catGetVideosFromParsedJSON
    category.GetCacheInSeconds = catGetCacheInSeconds
    return category
End Function


Function catGetVideos() As Object
    if(m.HasUpdate())
        m.videos = m.FetchVideos()
    end if
    return m.videos
End Function


Function catHasUpdate() As Boolean
    if (m.lastFetched = invalid)
        return true
    end if
    now = CreateObject("roDateTime")
    ' cache for 5 minutes
    if(now.asSeconds() > m.lastFetched.asSeconds() + m.GetCacheInSeconds())
        return true
    end if
    return false
End Function

Function catGetCacheInSeconds() As Integer
    return 5 * 60
End Function

Function catMassageJSON(json As String) As String
    ' no massaging necessary
    return json
End Function

Function catFetchVideos() As Object
    ' get JSON
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl(m.url)
    print "getVideos() retrieving JSON for category " + m.name + " from " + m.url
    json = urlTransfer.GetToString()
    json = m.massageJSON(json)
    parsedJSON = parseJSON(json)
    if(parsedJSON = invalid)
        print "Failed to parse JSON from " + m.url
        return invalid
    else
        videos = m.GetVideosFromParsedJSON(parsedJSON) 
        m.lastFetched = CreateObject("roDateTime")
        return videos
    end if
End Function

Function catGetVideosFromParsedJSON(parsedJSON As Object) As Object 
    result = CreateObject("roList")
    for each video in parsedJSON.videos
        v = newVideo(video)
        content = v.asContent()
        result.addTail(content)
    end for
    return result
End Function
