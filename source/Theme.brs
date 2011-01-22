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
	theme.FilterBannerSliceSD = "pkg:/images/FilterBanner_Slice.png"
	theme.FilterBannerActiveSD = "pkg:/images/FilterBanner_Active.png"
	'theme.FilterBannerInactiveSD = "pkg:/images/FilterBanner_Inactive.png"
	'theme.FilterBannerSliceHD = "pkg:/images/FilterBanner_Slice.png"
	'theme.FilterBannerActiveHD = "pkg:/images/FilterBanner_Active.png"
	'theme.FilterBannerInactiveHD = "pkg:/images/FilterBanner_Slice.png"
	' SD Overhang
    theme.OverhangOffsetSD_X = "10"
    theme.OverhangOffsetSD_Y = "14"
    theme.OverhangLogoSD  = "pkg:/images/Logo_Overhang.png"
    'theme.OverhangSliceSD = "pkg:/images/Overhang_Slice.png"
	' HD Overhang
    theme.OverhangOffsetHD_X = "123"
    theme.OverhangOffsetHD_Y = "48"
    theme.OverhangLogoHD  = "pkg:/images/Logo_Overhang.png"
    'theme.OverhangSliceHD = "pkg:/images/Overhang_Slice.png"
	Return theme
End Function