Function mergeAArrays(enum As Object) As Object
    result = CreateObject("roAssociativeArray")	
	for each aarray in enum 
		for each key in aarray
			value = aarray.Lookup(key)
			result.AddReplace(key, value)
		end for
	end for
	return result
End Function

Function parseJSON(json As String) As Object
	null = invalid
	jsonObject = invalid
	' get rid of quotes around keys
	regex = CreateObject("roRegex", Chr(34) + "([a-zA-Z0-9_\-\s]*)" + Chr(34) + "\s*\:", "i" )
	json = regex.replaceAll(json, "\1\:")
	' correct leading comma
	regex = CreateObject("roRegex", "\n,\n", "m" )
	json = regex.replaceAll(json, "," + CHR(10))
	regex = CreateObject("roRegex", "\n,\{\n", "m" )
	json = regex.replaceAll(json, "," + CHR(10) + "{")
	' correct escaped quotes
	regex = CreateObject("roRegex","\\" + Chr(34), "i" )
	json = regex.ReplaceAll(json, Chr(34) + " + Chr(34) + " + Chr(34))
	' eval json
	eval("jsonObject = " + json)
	return jsonObject
End Function
