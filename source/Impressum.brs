Function showImpressumScreen()
    port=CreateObject("roMessagePort")
    screen = CreateObject("roParagraphScreen")
    screen.SetMessagePort(port)	
	screen.SetTitle("Impressum")
	screen.AddHeaderText("Inhalt")
	screen.AddParagraph("tagesschau.de")
	screen.AddParagraph("Norddeutscher Rundfunk" + CHR(10) + "Anstalt des öffentlichen Rechts" + CHR(10) + "Hugh-Greene-Weg 1" + CHR(10) + "22529 Hamburg"  + CHR(10) + "Ust-Ident-Nummer: DE 1185 09 776")
	screen.AddParagraph("Telefon: +49 (0)40 / 4156-0" + CHR(10) + "Fax: +49 (0)40 / 4156-7419" + CHR(10) + "Email: redaktion@tagesschau.de")
	screen.AddButton(1, "Weiter")
	screen.Show()

    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roParagraphScreenEvent"
            if msg.isScreenClosed()
				exit while
            else if msg.isButtonPressed()
				if (msg.getIndex() = 1)
					if (showImpressumScreen2() = 0)
						exit while
					end if
				else				
					exit while                
				end if
            end if
        end if
    end while
	
	screen.Close()

End Function

Function showImpressumScreen2() as Integer
    port = CreateObject("roMessagePort")
    screen = CreateObject("roParagraphScreen")
    screen.SetMessagePort(port)	
	screen.SetTitle("Impressum")
	screen.AddHeaderText("Entwicklung")
	screen.AddParagraph("Roku Channel" + CHR(10) + "Henning Saul (henning.saul@gmx.net)")
	screen.AddParagraph("Backend" + CHR(10) + "Sven Bruns (sbruns@tagesschau.de)")
	screen.AddButton(1, "Zum Channel")
	screen.Show()

    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roParagraphScreenEvent"
            if msg.isScreenClosed()
				back = 1
				exit while
            else if msg.isButtonPressed()				
				back = 0
                exit while                
            end if
        end if
    end while

	screen.Close()
	return back
End Function
