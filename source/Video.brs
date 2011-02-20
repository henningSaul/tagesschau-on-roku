Function newVideo(source as Object) As Object
    video = CreateObject("roAssociativeArray")
	video.source = source
	video.AsContent = videoAsContent
	video.GetReleaseDate = videoGetReleaseDate
	video.GetReleaseTime = videoGetReleaseTime
	video.GetDescriptionLine1 = videoGetDescriptionLine1
	video.GetDescriptionLine2 = videoGetDescriptionLine2
	video.GetImages = videoGetImages
	' support for lazy loading in Broadcast.brs
	video.GetDetails = videoGetDetails
	return video
End Function

Function videoAsContent() 
	content = CreateObject("roAssociativeArray")
	content.ContentType = "episode"
	video = m.source
	' Length
	if(video.outMilli <> invalid)
		length% = ((video.outMilli - video.inMilli) / 1000)
		content.Length = length%
	end if
	' Description from topics	
	if(m.source.topics <> invalid) 
		description = ""
		for each topic in m.source.topics
			if(len(description) > 0)
				description = description + ", "
			end if
			description = description + topic
		end for
		content.Description = description
	end if	
	'
    content.ReleaseDate = m.GetReleaseDate()
	content.ShortDescriptionLine1 = m.GetDescriptionLine1(content)
	content.ShortDescriptionLine2 = m.GetDescriptionLine2(content)
	content.Title = content.ShortDescriptionLine1 + " " + content.ReleaseDate
	content.Rating = "NR"
	m.GetImages(content)
    content.StreamFormat = "mp4"
	m.GetDetails(content)
	return content
End Function

Function videoGetImages(content as Object)
	video = m.source
	' get image, Roku arced-landscape sizes: SD=214x144; HD=290x218, Roku arced-16x9 sizes: SD=166x112; HD=224x168
	if(video.images.Count() = 0)
		content.SDPosterUrl = "pkg:/images/Logo_Main.png"
		content.HDPosterUrl = "pkg:/images/Logo_Main.png"
	else
		images = mergeAArrays(video.images[0].variants)
		' mittel16x9 seems to be the best fit
		if(images.mittel16x9 <> invalid)
			content.SDPosterUrl = images.mittel16x9
			content.HDPosterUrl = images.mittel16x9
		else
			' fallback for Aktuell/Wetter
			content.SDPosterUrl = images.grossgalerie16x9
			content.HDPosterUrl = images.grossgalerie16x9
		end if
	end if	
End Function

Function videoGetDetails(content as Object)
	video = m.source
	content.Streams = getStreams(video)
	content.hasFetchedDetails = true
End Function

Function videoGetReleaseDate() As Object
	video = m.source
	if (video.broadcastDate = invalid)
		return invalid
	end if
	date = left(video.broadcastDate, 10)
	year = left(date, 4)
	month = mid(date, 6, 2)	
	day = right(date, 2)	
	return day + "." + month + "." + year
End Function

Function videoGetReleaseTime() As Object
	video = m.source
	if (video.broadcastDate = invalid)
		return invalid
	end if
	date = mid(video.broadcastDate, 12, 5)
	return date
End Function

Function videoGetDescriptionLine1(content As Object) As String
	video = m.source
	return video.headline
End Function

Function videoGetDescriptionLine2(content As Object) As String
	video = m.source
	result = ""
	if(content.ReleaseDate <> invalid) 
		result = content.ReleaseDate
	end if
	releaseTime = m.GetReleaseTime()
	if(releaseTime <> invalid) 
		result = result + " | " + releaseTime + " Uhr"
	end if
	if(content.Length <> invalid)
		' get duration in min
		durationMin% = content.Length / 60
		durationSec% = content.Length - (durationMin% * 60)
		if (durationSec% < 10)
			durationSecString = "0" + durationSec%.tostr()
		else 
			durationSecString = durationSec%.tostr()
		end if
		durationString = "" + durationMin%.tostr() + ":" + durationSecString
		result = result + " | " + durationString + " min"	
	end if
	return result
End Function
	
' "static" helper method	
Function getStreams(video As Object) as Object
    streams = CreateObject("roList")
	mediadata = mergeAArrays(video.mediadata)	
	' TODO: get bitrate info from tagesschau
	stream = getStream(video, mediadata, "h264s", 100)
	if(stream <> invalid)
		streams.AddTail(stream)
	end if
	stream = getStream(video, mediadata, "h264m", 1000)
	if(stream <> invalid)
		streams.AddTail(stream)
	end if
	stream = getStream(video, mediadata, "h264l", 2000)
	if(stream <> invalid)
		streams.AddTail(stream)
	end if
	return streams
End Function

' "static" helper method	
Function getStream(video As Object, mediadata As Object, format as String, bitrate As Integer) As Object
    stream = CreateObject("roAssociativeArray")
	stream.url = mediadata.Lookup(format)
	if(stream.url = invalid)
		return invalid
	end if
	stream.bitrate = bitrate
	stream.quality = false
	stream.contentid = video.sophoraId + "-" + format
	return stream
End Function