Sub initTheme()
    app = CreateObject("roAppManager")
    theme = getTheme()	
    app.SetTheme(theme)
End Sub

Function getTheme() As Object 
	theme = CreateObject("roAssociativeArray")
	' General Colors
	theme.BackgroundColor = "#194780"
	theme.ParagraphTitleText = "#FFFFFF"
	theme.ParagraphHeaderText = "#A5ADC1"
	theme.ParagraphBodyText = "#FFFFFF"
	theme.ButtonHighlightColor = "#FFFFFF"
	' PosterScreen colors
	theme.PosterScreenLine1Text = "#FFFFFF"
	theme.PosterScreenLine2Text = "#A5ADC1"
	' FilterBanner colors and images
	theme.FilterBannerActiveColor = "#001841"
	theme.FilterBannerInactiveColor = "#A5ADC1"
	theme.FilterBannerSideColor = "#A5ADC1"
	theme.FilterBannerSliceSD = "pkg:/images/FilterBanner_Slice_SD.png"
	theme.FilterBannerActiveSD = "pkg:/images/FilterBanner_Active_SD.png"
	theme.FilterBannerSliceHD = "pkg:/images/FilterBanner_Slice_HD.png"
	theme.FilterBannerActiveHD = "pkg:/images/FilterBanner_Active_HD.png"
	' SD Overhang
    theme.OverhangOffsetSD_X = "10"
    theme.OverhangOffsetSD_Y = "14"
    theme.OverhangLogoSD  = "pkg:/images/Logo_Overhang_SD.png"
	' HD Overhang
    theme.OverhangOffsetHD_X = "10"
    theme.OverhangOffsetHD_Y = "11"
    theme.OverhangLogoHD  = "pkg:/images/Logo_Overhang_HD.png"
	Return theme
End Function