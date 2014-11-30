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


