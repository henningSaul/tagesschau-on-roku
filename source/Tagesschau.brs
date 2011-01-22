Function getCategories() As Object
    categories = CreateObject("roList")
	' TODO: Aktuell, crashes the Roku... too big? Extract relevant JSON or alternative JSON/URL available?
	'category = getCategory("Aktuelle Videos", "http://www.tagesschau.de/api/multimedia/video/ondemand100_type-video.json")
	category = getCategory("Aktuelle Videos", "http://www.tagesschau.de/api/multimedia/video/ondemanddossier100.json")
	categories.AddTail(category)
	' Archiv/Sendungen
	category = getCategory("Archiv", "http://www.tagesschau.de/api/multimedia/video/ondemandarchiv100.json")
	categories.AddTail(category)
	' Dossier
	category = getCategory("Dossier", "http://www.tagesschau.de/api/multimedia/video/ondemanddossier100.json")
	categories.AddTail(category)
	return categories	
End Function

Function getCategory(name As String, url As String) As Object
    category = CreateObject("roAssociativeArray")
	category.name = name
	category.url = url
	return category
End Function

Function getCategoryItems(category As Object) As Object
	' get JSON from tagesschau
    urlTransfer = CreateObject("roUrlTransfer")
    urlTransfer.SetUrl(category.url)
	print "getCategory() retrieving JSON for category " + category.name + " from " + category.url
    json = urlTransfer.GetToString()
	parsedJSON = parseJSON(json)
	if(parsedJSON = invalid)
		print "Failed to parse JSON from " + category.url
		return invalid
	else
		return getCategoryItemsFromParsedJSON(parsedJSON) 
	end if
End Function

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
	length = ((video.outMilli - video.inMilli) / 1000)
	content.Length = length
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
		content.SDPosterUrl = images.mittel16x9
		content.HDPosterUrl = images.mittel16x9
	end if
	return content
End Function

Function getReleaseDate(video As Object)
	date = left(video.broadcastDate, 10)
	year = left(date, 4)
	month = mid(date, 6, 2)	
	day = right(date, 2)	
	return day + "." + month + "." + year
End Function

Function getReleaseTime(video As Object)
	date = mid(video.broadcastDate, 12, 5)
	return date
End Function

Function getDescriptionLine2(content As Object, video As Object)
	result = content.ReleaseDate
	result = result + " | " + getReleaseTime(video) + " Uhr"
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
	return result
End Function
	
Function getStreams(video As Object)
    streams = CreateObject("roList")
	mediadata = mergeAArrays(video.mediadata)	
	' TODO: get bitrate info from tagesschau
	stream = getStream(mediadata, "h264s", 100)
	streams.AddTail(stream)
	stream = getStream(mediadata, "h264m", 1000)
	streams.AddTail(stream)
	stream = getStream(mediadata, "h264l", 2000)
	streams.AddTail(stream)
	return streams
End Function

Function getStream(mediadata As Object, format as String, bitrate As Integer) 
    stream = CreateObject("roAssociativeArray")
	stream.url = mediadata.Lookup(format)
	stream.bitrate = bitrate
	stream.quality = false
	return stream
End Function