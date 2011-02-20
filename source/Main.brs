Sub Main()
    initTheme()
    showPosterScreen()
End Sub

Function showPosterScreen() As Integer
    port = CreateObject("roMessagePort")
    screen = CreateObject("roPosterScreen")
    screen.SetMessagePort(port)
	' pick list style depending on aspect ratio
	deviceInfo = CreateObject("roDeviceInfo")
	displayType = deviceInfo.GetDisplayType()
	if (displayType = "16:9 anamorphic")
		screen.SetListStyle("arced-landscape")	
	else
		screen.SetListStyle("arced-16x9")
	end if
    screen.Show()
	categories = getCategories()	
    categoryNames = getCategoryNames(categories)
    screen.SetListNames(categoryNames)
	contentList = categories[0].getVideos()
    screen.SetContentList(contentList)

    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roPosterScreenEvent" then            
            if msg.isListFocused() then
				if((msg.getIndex() + 1) = categoryNames.Count())
					showImpressumScreen()
					screen.setFocusedList(0)
				else
					screen.setContentList(invalid)
					category = categories[msg.GetIndex()]
					screen.SetContentList(category.GetVideos())
					screen.SetFocusedListItem(0)
				end if
			else if msg.isListItemSelected() then                
				content = screen.getContentList()[msg.GetIndex()]
				displayVideo(content)
            else if msg.isScreenClosed() then
                return -1
            end if
		end if
    end while

End Function

Function getCategories() As Object
    categories = CreateObject("roList")
	' Aktuelle Videos
	category = newCurrentVideosCategory("Aktuelle Videos", "http://www.tagesschau.de/api/multimedia/video/ondemand100_type-video.json")
	categories.AddTail(category)
	' Alle (aktuellen) Sendungen
	category = newBroadcastsCategory("Alle Sendungen", "http://www.tagesschau.de/api/multimedia/sendung/letztesendungen100.json")
	categories.AddTail(category)
	' (Sendungs) Archiv
	category = newBroadcastsCategory("Archiv", "http://www.tagesschau.de/api/multimedia/sendung/letztesendungen100_week-true.json")
	categories.AddTail(category)
	' Dossier Videos
	category = newCategory("Dossier", "http://www.tagesschau.de/api/multimedia/video/ondemanddossier100.json")
	categories.AddTail(category)
	return categories	
End Function

Function displayVideo(content As Object)
	' lazy loading for Broadcasts
	if(not content.hasFetchedDetails)
		content.FetchDetails()
	end if
	' playback video
    p = CreateObject("roMessagePort")
    video = CreateObject("roVideoScreen")
    video.setMessagePort(p)
    video.SetContent(content)
    video.show()
    while true
        msg = wait(0, video.GetMessagePort())
        if type(msg) = "roVideoScreenEvent"
            if msg.isScreenClosed() then
                exit while
            endif
        end if
    end while
End Function


Function getCategoryNames(categories As Object) As Object 
	categoryNames = CreateObject("roList")
    for each category in categories
		categoryNames.addTail(category.name)
	end for
	' add special category Impressum
	categoryNames.addTail("Impressum")
	return categoryNames
End Function

