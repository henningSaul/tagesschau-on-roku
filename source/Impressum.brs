Function showImpressumScreen()
    port=CreateObject("roMessagePort")
    screen = CreateObject("roParagraphScreen")
    screen.SetMessagePort(port)	
	screen.SetTitle("Impressum")
	screen.AddHeaderText("Inhalt")
	screen.AddParagraph("ARD-aktuell")
	screen.AddParagraph("Norddeutscher Rundfunk" + CHR(10) + "Anstalt des öffentlichen Rechts" + CHR(10) + "Hugh-Greene-Weg 1" + CHR(10) + "D-22529 Hamburg")
	screen.AddParagraph("Ust-Ident-Nummer: DE 1185 09 776")
	screen.AddParagraph("ARD-aktuell ist eine ARD-Gemeinschaftseinrichtung mit Sitz beim Norddeutschen Rundfunk in Hamburg." + CHR(10) +"Verantwortlich gemäß § 5 TMG und § 55 (2) Rundfunkstaatsvertrag ist der Intendant des NDR, Lutz Marmor.")
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

Function showImpressumScreen2()
    port=CreateObject("roMessagePort")
    screen = CreateObject("roParagraphScreen")
    screen.SetMessagePort(port)	
	screen.SetTitle("Impressum")
	screen.AddHeaderText("Inhalt")
	screen.AddParagraph("Chefredaktion" + CHR(10) + "Dr. Kai Gniffke" + CHR(10) + "Thomas Hinrichs" + CHR(10) + "Jörg Sadrozinski")	
	screen.AddParagraph("Telefon: +49 (0)40 / 4156-0" + CHR(10) + "Fax: +49 (0)40 / 4156-7419" + CHR(10) + "Email: redaktion@tagesschau.de")
	screen.AddParagraph("Verwendete Agenturen: AFP, AP (DAPD), ddp, dpa, Reuters.")
	screen.AddButton(1, "Weiter")
	screen.Show()

    while true
        msg = wait(0, screen.GetMessagePort())
        if type(msg) = "roParagraphScreenEvent"
            if msg.isScreenClosed()
				back = 1
			exit while
            else if msg.isButtonPressed()
				if (msg.getIndex() = 1)
					if (showImpressumScreen3() = 0)
						back = 0
						exit while
					end if
				else				
					exit while                
				end if
            end if
        end if
    end while
	
	screen.Close()
	return back
End Function

Function showImpressumScreen3() as Integer
    port = CreateObject("roMessagePort")
    screen = CreateObject("roParagraphScreen")
    screen.SetMessagePort(port)	
	screen.SetTitle("Impressum")
	screen.AddHeaderText("Technik")
	screen.AddParagraph("Roku Channel Entwicklung" + CHR(10) + "Henning Saul (henning.saul@gmx.net)")
	screen.AddParagraph("Tagesschau Tech. Leiter" + CHR(10) + "Sven Bruns (webmaster@tagesschau.de)")
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
