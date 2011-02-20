Function newVideo(source as Object) As Object
    video = CreateObject("roAssociativeArray")
	video.source = source
	video.AsContent = videoAsContent
	video.GetReleaseDate = videoGetReleaseDate
	video.GetReleaseTime = videoGetReleaseTime
	video.GetDescriptionLine1 = videoGetDescriptionLine1
	video.GetDescriptionLine2 = videoGetDescriptionLine2
	video.GetStreams = videoGetStreams
	video.GetStream = videoGetStream
	return video
End Function

Function videoAsContent() 
	content = CreateObject("roAssociativeArray")
	content.ContentType = "movie"
	video = m.source
	if(video.outMilli <> invalid)
		length% = ((video.outMilli - video.inMilli) / 1000)
		content.Length = length%
	end if
    content.ReleaseDate = m.GetReleaseDate(video)
	content.ShortDescriptionLine1 = m.GetDescriptionLine1(content, video)
	content.ShortDescriptionLine2 = m.GetDescriptionLine2(content, video)
    content.StreamFormat = "mp4"
	content.Streams = m.GetStreams(video)
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
	return content
End Function

Function videoGetReleaseDate(video As Object) As Object
	if (video.broadcastDate = invalid)
		return invalid
	end if
	date = left(video.broadcastDate, 10)
	year = left(date, 4)
	month = mid(date, 6, 2)	
	day = right(date, 2)	
	return day + "." + month + "." + year
End Function

Function videoGetReleaseTime(video As Object) As Object
	if (video.broadcastDate = invalid)
		return invalid
	end if
	date = mid(video.broadcastDate, 12, 5)
	return date
End Function

Function videoGetDescriptionLine1(content As Object, video As Object) As String
	return video.headline
End Function

Function videoGetDescriptionLine2(content As Object, video As Object) As String
	result = ""
	if(content.ReleaseDate <> invalid) 
		result = content.ReleaseDate
	end if
	releaseTime = m.GetReleaseTime(video)
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
	
Function videoGetStreams(video As Object) as Object
    streams = CreateObject("roList")
	mediadata = mergeAArrays(video.mediadata)	
	' TODO: get bitrate info from tagesschau
	stream = m.GetStream(video, mediadata, "h264s", 100)
	if(stream <> invalid)
		streams.AddTail(stream)
	end if
	stream = m.GetStream(video, mediadata, "h264m", 1000)
	if(stream <> invalid)
		streams.AddTail(stream)
	end if
	stream = m.GetStream(video, mediadata, "h264l", 2000)
	if(stream <> invalid)
		streams.AddTail(stream)
	end if
	return streams
End Function

Function videoGetStream(video As Object, mediadata As Object, format as String, bitrate As Integer) As Object
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