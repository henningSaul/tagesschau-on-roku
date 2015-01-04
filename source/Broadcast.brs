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
    parsedJSON = ParseJson(json)
    fullvideo = parsedJSON.fullvideo[0]
    if(fullvideo = invalid)
        print "Failed to parse JSON from " + url
    else
        m.Streams = getStreams(fullvideo)
        m.hasFetchedDetails = true
    end if      
    ' set length
    if(fullvideo.outMilli <> invalid)
        length% = ((fullvideo.outMilli - fullvideo.inMilli) / 1000)
        m.Length = length%
    end if
    ' set subtitle URL
    ' e.g. http://www.tagesschau.de/multimedia/video/video-50605~subtitle.html
    subtitleUrl = "http://www.tagesschau.de/multimedia/video/" + fullvideo.sophoraId + "~subtitle.html"
    ' check if subtitles available
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl(subtitleUrl)
    subtitleText = urlTransfer.GetToString()
    if((subtitleText <> invalid) and (Len(subtitleText) > 0))
        print "broadcastGetStreams() setting subtitles url to " + subtitleUrl
        m.SubtitleTracks = [{
            Language: "ger",
            Description: "German",
            ' TrackName: "http://vimeosrtplayer.googlecode.com/svn-history/r5/VimeoSrtPlayer/bin/srt/example.srt"
            TrackName: subtitleUrl
        }]
    endif    
End Sub


