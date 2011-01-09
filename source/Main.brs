' TODOs
' - Graphics from Tagesschau
' - Colors for Buttons and Buttontext
' - Colors for (Impressum) Title
' - JSON Parsing for Aktuell, Dossier and Archiv


Sub Main()
    initTheme()
    showPosterScreen()
End Sub

Function showPosterScreen() As Integer
    port=CreateObject("roMessagePort")
    screen = CreateObject("roPosterScreen")
    screen.SetMessagePort(port)
    screen.SetListStyle("arced-landscape")
	
    categories = ["Aktuell", "Dossier", "Archiv", "Impressum"]
    screen.SetListNames(categories)
    'screen.SetContentList(getShowsForCategoryItem(categories[0]))
    screen.Show()

    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roPosterScreenEvent" then
            print "showPosterScreen | msg = "; msg.GetMessage() " | index = "; msg.GetIndex()			
            if msg.isListFocused() then
				if((msg.getIndex() + 1)  = categories.Count())
					showImpressumScreen()
					screen.setFocusedList(0)
				else
					'screen.SetContentList(getShowsForCategoryItem(categories[msg.GetIndex()]))				
				end if
			else if msg.isListItemSelected() then
                print "list item selected | current show = "; msg.GetIndex() 
            else if msg.isScreenClosed() then
                return -1
            end if
		end if
    end while

End Function
