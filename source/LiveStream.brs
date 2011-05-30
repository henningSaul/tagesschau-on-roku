Function newLiveStream(title As String, url As String, image As String ) As Object
    stream = CreateObject("roAssociativeArray")
    stream.title = title
    stream.url = url
    stream.format = "hls"
    stream.bitrate = 0
    stream.image = image
    stream.AsContent = streamAsContent
    return stream
End Function

Function streamAsContent() 
    content = CreateObject("roAssociativeArray")
    content.ContentType = "episode"
    content.Title = m.title
    content.ShortDescriptionLine1 = m.title
    content.ShortDescriptionLine2 = "Live Stream"
    content.Rating = "NR"
    content.SDPosterUrl = m.image
    content.HDPosterUrl = m.image
    content.hasFetchedDetails = true
    content.StreamFormat = m.format
    streams = CreateObject("roList")
    stream = CreateObject("roAssociativeArray")
    stream.url = m.url
    stream.bitrate = m.bitrate
    stream.quality = false
    streams.addTail(stream)
    content.Streams = streams
    return content
End Function