Sub initTheme()
    app = CreateObject("roAppManager")
    theme = getTheme()	
    app.SetTheme(theme)
End Sub

Function getTheme() As Object 
	theme = CreateObject("roAssociativeArray")
	' General Colors
	theme.BackgroundColor = "#C3D1EB"
	theme.ParagraphTitleText = "#C3D1EB"
	theme.ParagraphHeaderText = "#6C85BB"
	theme.ParagraphBodyText = "#000044"
	theme.ButtonHighlightColor = "#C3D1EB"
	' PosterScreen colors
	theme.PosterScreenLine1Text = "#000044"
	theme.PosterScreenLine2Text = "#6C85BB"
	' FilterBanner colors and images
	theme.FilterBannerActiveColor = "#000044"
	theme.FilterBannerInactiveColor = "#000044"
	theme.FilterBannerSideColor = "#FFFFFF"
	theme.FilterBannerSliceSD = "pkg:/images/FilterBanner_Slice.png"
	theme.FilterBannerActiveSD = "pkg:/images/FilterBanner_Active.png"
	theme.FilterBannerInactiveSD = "pkg:/images/FilterBanner_Slice.png"
	theme.FilterBannerSliceHD = "pkg:/images/FilterBanner_Slice.png"
	theme.FilterBannerActiveHD = "pkg:/images/FilterBanner_Active.png"
	theme.FilterBannerInactiveHD = "pkg:/images/FilterBanner_Slice.png"
	' SD Overhang
    theme.OverhangOffsetSD_X = "40"
    theme.OverhangOffsetSD_Y = "20"
    theme.OverhangLogoSD  = "pkg:/images/Logo_Overhang.png"
    theme.OverhangSliceSD = "pkg:/images/Overhang_Slice.png"
	' HD Overhang
    theme.OverhangOffsetHD_X = "123"
    theme.OverhangOffsetHD_Y = "48"
    theme.OverhangLogoHD  = "pkg:/images/Logo_Overhang.png"
    theme.OverhangSliceHD = "pkg:/images/Overhang_Slice.png"
	Return theme
End Function