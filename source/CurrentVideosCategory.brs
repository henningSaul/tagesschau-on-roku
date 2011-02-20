Function newCurrentVideosCategory(name As String, url As String) As Object
    category = newCategory(name, url)
	category.MassageJSON = currentVideosMassageJSON
	return category
End Function

Function currentVideosMassageJSON(json As String) As String
	' TODO: this is a little fragile.... maybe tagesschau has a dedicated URL for the Aktuell JSON  
	' we need to remove some json elements, otherwise the Aktuell JSON parsing crashes the Roku...
	regex = CreateObject("roRegex", "^" + Chr(34) + "multimedia" + Chr(34) + "\:\ \[.*^" + Chr(34) +"broadcastArchive" + Chr(34) + "\:", "ms" )
	json = regex.replaceAll(json, CHR(34) + "broadcastArchive" + CHR(34) + ":")	
	return json
End Function
