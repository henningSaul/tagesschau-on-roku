Sub Main()
    initTheme()
    showPosterScreen()
End Sub

Function showPosterScreen() As Integer
    port = CreateObject("roMessagePort")
    screen = CreateObject("roPosterScreen")
    screen.SetMessagePort(port)
	'screen.SetListStyle("arced-16x9")
    screen.SetListStyle("arced-landscape")	
    screen.Show()
	categories = getCategories()	
    categoryNames = getCategoryNames(categories)
    screen.SetListNames(categoryNames)
	contentList = getCategoryItems(categories[0])
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
					screen.SetContentList(getCategoryItems(categories[msg.GetIndex()]))
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

Function displayVideo(content As Object)
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

