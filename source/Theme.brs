Sub initTheme()
    app = CreateObject("roAppManager")
    theme = getTheme()	
    app.SetTheme(theme)
End Sub

Function getTheme() As Object 
	theme = CreateObject("roAssociativeArray")
	' General Colors
	theme.BackgroundColor = "#1977C0"
	theme.ParagraphTitleText = "#FFFFFF"
	theme.ParagraphHeaderText = "#FFFFFF"
	theme.ParagraphBodyText = "#FFFFFF"
	theme.BreadcrumbTextLeft = "#FFFFFF"
	theme.BreadcrumbDelimiter = "#FFFFFF"
	theme.BreadcrumbTextRight = "#FFFFFF"
	' PosterScreen colors
	theme.PosterScreenLine1Text = "#FFFFFF"
	theme.PosterScreenLine2Text = "#DDDD00"
	' FilterBanner colors and images
	theme.FilterBannerActiveColor = "#FFFFFF"
	'theme.FilterBannerInactiveColor = "#666600"
	'theme.FilterBannerSideColor = "#DDDDDD"
	'theme.FilterBannerSliceSD = "pkg:/images/Overhang_Slice_SD43.png"
	'theme.FilterBannerActiveSD = "pkg:/images/Overhang_Slice_SD43.png"
	'theme.FilterBannerInactiveSD = "pkg:/images/Overhang_Slice_SD43.png"
	'theme.FilterBannerSliceHD = "pkg:/images/Overhang_Slice_SD43.png"
	'theme.FilterBannerActiveHD = "pkg:/images/Overhang_Slice_SD43.png"
	'theme.FilterBannerInactiveHD = "pkg:/images/Overhang_Slice_SD43.png"	
	' TODO: check if images can be loaded via HTTP
	' SD Overhang
    theme.OverhangOffsetSD_X = "72"
    theme.OverhangOffsetSD_Y = "25"
    'theme.OverhangLogoSD  = "pkg:/images/tagesschau.jpg"
    'theme.OverhangSliceSD = "pkg:/images/Overhang_Slice_SD43.png"
	' HD Overhang
    theme.OverhangOffsetHD_X = "123"
    theme.OverhangOffsetHD_Y = "48"
    theme.OverhangSliceHD = "pkg:/images/TODO.png"
    theme.OverhangLogoHD  = "pkg:/images/TODO.png"
	Return theme
End Function