Function newLiveStream() As Object
    stream = CreateObject("roAssociativeArray")
    stream.title = "EinsExtra Aktuell Live Stream"
    stream.url = "http://ia-streaming.tagesschau.de/master.m3u8"
    stream.format = "hls"
    stream.bitrate = 0
    stream.image = "http://miss.tagesschau.de/image/sendung/ard_portal_vorspann_eea.jpg"
    stream.AsContent = streamAsContent
    return stream
End Function

Function streamAsContent() 
    content = CreateObject("roAssociativeArray")
    content.ContentType = "episode"
    content.Title = m.title
    content.ShortDescriptionLine1 = m.title
    content.Rating = "NR"
    content.StreamFormat = m.format
    content.SDPosterUrl = m.image
    content.HDPosterUrl = m.image
    streams = CreateObject("roList")
    stream = CreateObject("roAssociativeArray")
    stream.url = m.url
    stream.bitrate = m.bitrate
    stream.quality = false
    streams.addTail(stream)
    content.hasFetchedDetails = true
    return content
End Function