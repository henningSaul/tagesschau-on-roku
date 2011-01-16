Sub Main()
    initTheme()
    showPosterScreen()
End Sub

Function showPosterScreen() As Integer
    port = CreateObject("roMessagePort")
    screen = CreateObject("roPosterScreen")
    screen.SetMessagePort(port)
	screen.SetListStyle("arced-16x9")
    'screen.SetListStyle("arced-landscape")	
    screen.Show()
	' TODO: show an overlay while retrieving content?
	categories = getCategories()	
    categoryNames = getCategoryNames(categories)
    screen.SetListNames(categoryNames)
    screen.SetContentList(categories[0].items)

    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roPosterScreenEvent" then
            print "showPosterScreen | msg = "; msg.GetMessage() " | index = "; msg.GetIndex()			
            if msg.isListFocused() then
				if((msg.getIndex())  = categories.Count())
					showImpressumScreen()
					screen.setFocusedList(0)
				else
					screen.SetContentList(categories[msg.GetIndex()].items)				
				end if
			else if msg.isListItemSelected() then
                print "list item selected | current show = "; msg.GetIndex() 
            else if msg.isScreenClosed() then
                return -1
            end if
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

