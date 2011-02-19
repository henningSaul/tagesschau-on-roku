Function newCategory(name As String, url As String) As Object
    category = CreateObject("roAssociativeArray")
	category.name = name
	category.url = url
	category.currentVideos = false
	category.lastFetched = invalid
	category.videos = invalid
	category.GetVideos = catGetVideos
	category.HasUpdate = catHasUpdate
	category.FetchVideos = catFetchVideos
	return category
End Function

Function newCurrentVideosCategory(name As String, url As String) As Object
    category = newCategory(name, url)
	category.currentVideos = true
	return category
End Function

Function catHasUpdate() As Boolean
	if (m.lastFetched = invalid)
		return true
	end if
	now = CreateObject("roDateTime")
	' cache for 5 minutes
	if(now.asSeconds() > m.lastFetched.asSeconds() + (5 * 60))
		return true
	end if
	return false
End Function

Function catGetVideos() As Object
	if(m.HasUpdate())
		m.videos = m.FetchVideos()
	end if
	return m.videos
End Function

Function catFetchVideos() As Object
	' get JSON
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl(m.url)
	print "getVideos() retrieving JSON for category " + m.name + " from " + m.url
    json = urlTransfer.GetToString()
	' special handling for current videos...
	if(m.currentVideos)
		' TODO: this is a little fragile.... maybe tagesschau has a dedicated URL for the Aktuell JSON  
		' we need to remove some json elements, otherwise the Aktuell JSON parsing crashes the Roku, too big?
		regex = CreateObject("roRegex", "^" + Chr(34) + "multimedia" + Chr(34) + "\:\ \[.*^" + Chr(34) +"broadcastArchive" + Chr(34) + "\:", "ms" )
		json = regex.replaceAll(json, CHR(34) + "broadcastArchive" + CHR(34) + ":")	
	end if
	parsedJSON = parseJSON(json)
	if(parsedJSON = invalid)
		print "Failed to parse JSON from " + m.url
		return invalid
	else
		items = getCategoryItemsFromParsedJSON(parsedJSON) 
		m.lastFetched = CreateObject("roDateTime")
		return items
	end if
End Function

' Helper methods for translating JSON to content
Function getCategoryItemsFromParsedJSON(parsedJSON As Object) As Object 
    items = CreateObject("roList")
	for each video in parsedJSON.videos
		content = getVideo(video)
		items.addTail(content)
	end for
	return items
End Function

Function getVideo(video As Object) As Object
    content = CreateObject("roAssociativeArray")
	content.ContentType = "movie"
	length% = ((video.outMilli - video.inMilli) / 1000)
	content.Length = length%
    content.ReleaseDate = getReleaseDate(video)
	content.ShortDescriptionLine1 = video.headline
	content.ShortDescriptionLine2 = getDescriptionLine2(content, video)
    content.StreamFormat = "mp4"
	content.Streams = getStreams(video)
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

Function getReleaseDate(video As Object) As Object
	if (video.broadcastDate = invalid)
		return invalid
	end if
	date = left(video.broadcastDate, 10)
	year = left(date, 4)
	month = mid(date, 6, 2)	
	day = right(date, 2)	
	return day + "." + month + "." + year
End Function

Function getReleaseTime(video As Object) As Object
	if (video.broadcastDate = invalid)
		return invalid
	end if
	date = mid(video.broadcastDate, 12, 5)
	return date
End Function

Function getDescriptionLine2(content As Object, video As Object) As String
	result = ""
	if(content.ReleaseDate <> invalid) 
		result = content.ReleaseDate
	end if
	releaseTime = getReleaseTime(video)
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