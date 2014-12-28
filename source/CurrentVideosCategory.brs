Function newCurrentVideosCategory(name As String, url As String) As Object
    category = newCategory(name, url)
    category.GetCacheInSeconds = currentGetCacheInSeconds
    category.GetVideosFromParsedJSON = currentGetVideosFromParsedJSON
    return category
End Function

Function currentGetCacheInSeconds() As Integer
    return 1 * 60
End Function

Function currentGetVideosFromParsedJSON(parsedJSON As Object) As Object 
    result = CreateObject("roList")
    ' add livestream(s)
    for each multimedia in parsedJSON.multimedia
        if(multimedia.livestreams <> invalid)
            for each livestream in multimedia.livestreams
                l = newLiveStream(livestream)
                content = l.asContent()
                result.addTail(content)
            end for
        end if      
    end for
    ' add current videos
    for each video in parsedJSON.videos
        v = newVideo(video)
        content = v.asContent()
        result.addTail(content)
    end for
    return result
End Function




