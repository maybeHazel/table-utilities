local Utils = {}

export type Array = {[number]: any}
export type Dictionary = {
	[string]: any
} 
--[[i thought this would show up like {[string]: value} when you hover over something that has this type but, apparently
	it only shows "Dictionary" so, i guess there wont be any use for this. I'll leave this here just in case though.
	You can do MyDict: Utils.Dictionary or, since this isnt used anywhere in the codde you can just delete this if you want to.
	Same thing goes for the Array type.
]]

function GetLength(tbl)
	local counter = 0

	for i, _ in tbl do
		counter += 1
	end

	return counter
end

function Utils.IsDictionary(tbl: {}): boolean
	local foundKey = false
	local length = GetLength(tbl)

	for index, _ in tbl do
		if typeof(index) ~= "number" or index > length  or index < 1 then
			foundKey = true
		end
	end	

	return foundKey
end

--========================================//Stuff for both Arrays and Dictionaries\\======================================================================================


--returns the highest number inside the table. Works with dictionaries, arrays and arrays with keys
function Utils.GetHighest(tbl: {}): number
	local newT = {}
	for i, v in tbl do
		table.insert(newT, v)
	end

	return math.max(table.unpack(newT or {0}))
end

--returns the lowest number inside the table. Works with dictionaries, arrays and arrays with keys
function Utils.GetLowest(tbl: {}):number
	local newT = {}
	for i, v in tbl do
		table.insert(newT, v)
	end

	return math.min(table.unpack(newT or {0})) 
end


--Combines two tables into one new table that gets returned.
function Utils.MergeTables(tableA, tableB, ignore: {number | string}): {}
	local newTable = {}
	if not ignore then ignore = {} end

	for i, v in tableA do
		if table.find(ignore, i) then continue end

		if typeof(i) == "string" then
			newTable[i] = v
		else
			table.insert(newTable, v)
		end
	end

	for i, v in tableB do
		if table.find(ignore, i) then continue end

		if typeof(i) == "string" then
			newTable[i] = v
		else
			table.insert(newTable, v)
		end
	end

	return newTable
end

--copies everything inside a new table, randomizes the position of every value and then returns the new table
function Utils.RandomizeTable(tbl: {}, seed: number): {}
	local rng  = Random.new()
	local newTable = {}
	local keys, values = {}, {}

	if seed then
		rng = Random.new(seed)
	end

	for index, val in tbl do
		newTable[index] = val

		if Utils.IsDictionary(tbl) then
			table.insert(keys, index)
			table.insert(values, val)
		end
	end

	rng:Shuffle(newTable)
	rng:Shuffle(values)

	for index, key in keys do
		newTable[key] = values[index]
	end

	return newTable
end

--========================================//Array stuff\\======================================================================================

	--[[Searches for indexes with duplicated values inside the specified array and puts them in two tables which are respectively returned,
	the first table being a dictionary having the *duplicated values* as *Keys* and the amount of times that the duplicated value 
	was found as a value, and, an array containing every single duplicated value]]
function Utils.FindDuplicatedValuesInArray(array: {any}): ({[string]: number}, {any})
	if not array then return warn("missing array") end
	if typeof(array) ~= "table" then return warn(`expected table but got {typeof(array)} instead`) end

	local FilteredArray = {}
	local numberOfOccurencies = {}
	local sameItems = {}

	for index, item in array do
		if Utils.IsDictionary(array) then continue end
		if table.find(FilteredArray, item) then
			table.insert(sameItems, item)
			numberOfOccurencies[item] += 1
		else
			table.insert(FilteredArray, item)
			numberOfOccurencies[item] = 1
		end
	end

	return numberOfOccurencies, sameItems
end


	--[[This is literally the same thing as doing "if table.find(arr1, value) and table.find(arr2, value)" but simplified i think.
	Returns both the index A and B if the item is found in both arrays;
	Returns false and 0 if the item is not found in both arrays;
	Returns nil and 0 if an error occured (missing arguments or array length is lesser than 1)]]
function Utils.FindValueInArrays(arrayA: {any}, ArrayB: {any}, value: any): (number | boolean, number)
	if not arrayA or not ArrayB then 
		warn("missing arrays") 
		return false, 0
	end

	if typeof(arrayA) ~= "table" or typeof(ArrayB) ~= "table" then
		warn(`expected table for arrayA and arrayB but got {typeof(arrayA)} for arrayA and {typeof(ArrayB)} for arrayB`)  
		return false, 0
	end

	if #arrayA < 1 or #ArrayB < 1 then
		warn(`Cannot search value in arrays if they dont have atleast 1 item: A/B {#arrayA}, {#ArrayB}`)
		return false, 0
	end

	local itemInArrA = table.find(arrayA, value)
	local itemInArrB = table.find(ArrayB, value)

	if itemInArrA  and itemInArrB then
		return itemInArrA, itemInArrB
	end

	return false, 0
end


--[[looks for indexes with the same value as the specified value inside the array and places them inside of another array which gets returned]]
function Utils.FindDuplicatedValueInArray(array: {any}, value: any): {any}
	if not array then return end
	if typeof(array) ~= "table" then return warn(`expected table but got {typeof(array)} instead`) end

	local dupesArray = {}
	local originalItem = {}

	for index, item in array do
		if item == value then
			if not table.find(originalItem, item) then
				table.insert(originalItem, item)
			else
				table.insert(dupesArray, value)
			end
		end
	end

	return dupesArray
end


function Utils.ReplaceIndexesInArray(array: {any}, indexes: {[string]: any}, insertNonExistingIndexes: boolean)
	if not array or not indexes then return end

	for newIndex, item in indexes do
		local KeyToNumber = tonumber(newIndex)

		if insertNonExistingIndexes and not array[KeyToNumber] then
			table.insert(array, item)

		elseif not array[KeyToNumber] and not insertNonExistingIndexes then
			continue
		end

		array[KeyToNumber] = item
	end
end


--[[Sets every value of the array to be the specified value, if no value is passed, it sets it to 0.
startPoint is the index to start from (4 will start counting from index 4 and ignore everything before it) 
and endPoint is where to end (endPoint 6 will ignore everything past index 6). This is literally C# array.Clear but you can choose a default
value]]
function Utils.ResetArray(array: {}, value: any, startPoint: number, endPoint: number): number
	local changedValues = 0
	if not array then return changedValues end
	if value == nil then value = 0 end

	if Utils.IsDictionary(array) then
		warn("expected array but got dictionary")
		return changedValues
	end

	if (startPoint > #array) or (startPoint < #array) then
		warn(`not enough indexes to start from because startPoint is smaller or greater than the elements inside of the array: Sp = {startPoint} \n lenght of the array = {#array}`)
		return changedValues
	end

	if (endPoint > #array) or (endPoint < #array)  or (endPoint < startPoint) then
		warn(`endPoint is greater or smaller than the elements inside of the array, or, endPoint is smaller than the startPoint: ep = {endPoint} \n sp = {startPoint} \n lenght of the array = {#array}`)

		return changedValues
	end

	for index, item in array do
		if (index < startPoint) or (index > endPoint) then continue end
		item = value
		changedValues += 1
	end

	return changedValues
end

--======================================//Dictionary stuff\\======================================================================================

--returns the length (the amount of items inside) of an dictionary. In other words, #Array but for dictionaries.
function Utils.DictionaryLenght(dictionary: {[string]:any}): number
	if not dictionary then return 0 end
	local count = 0

	for key, _ in dictionary do
		count +=1
	end

	return count
end


	--[[Looks for keys with duplicated values inside the specified dictionary and place them inside of two dictionaries, one having
	the amount of occurencies of the duplicated value and the second one is too complicated to explain so heres the structure:

	    sameOccurencies = {
	        ["value1"] = {
	            ["key1"] = number,
	            ["key2"] = number,
	            ...continue
	        },

	        ["value2"] = {
	            ["key1"] = number
	            ...continue
	        }
	    }
	]]
function Utils.FindDuplicatedValuesInDictionary(dictionary: {[string]: any}): ({[any]: number}, {[any]: {[string]: number}})
    if typeof(dictionary) ~= "table" then
        warn(`expected table but got {typeof(dictionary)}`)
        return
    end

    local totalOccurencies = {}
	local sameOccurencies = {}
    local keysByValue = {}
    local duplicatedTotals = {}

    for key, value in dictionary do
        totalOccurencies[value] = (totalOccurencies[value] or 0) + 1

        if not keysByValue[value] then
            keysByValue[value] = {}
        end
        keysByValue[value][key] = 1
    end

    for value, count in totalOccurencies do
        if count > 1 then
            duplicatedTotals[value] = count
            sameOccurencies[value] = keysByValue[value]
        end
    end

    return duplicatedTotals, sameOccurencies
end


--Looks for keys with the same value as the specified value and returns them inside of another dictonary.
function Utils.FindInDictionary(dictionary: {[string]: any}, value: any): {[string]: any} | false
	if not dictionary then return false end
	if not Utils.IsDictionary(dictionary) then 
		warn("expected dictionary")
		return false 
	end

	local foundKVs = {}
	local keyCount = 0

	for key, item in dictionary do
		if item == value then
			foundKVs[key] = value
			keyCount += 1
		end
	end

	if keyCount > 0 then
		return foundKVs
	end

	return false
end


--[[table.find but for dictionaries. Looks for the first key that has the same value as the specified value and returns it if found.]]
function Utils.FirstKeyOf(dictionary: {[string]: any}, value: any): string | false
	if not dictionary then return false end
	if not Utils.IsDictionary(dictionary) then 
		warn("expected dictionary")
		return false 
	end

	for key, item in dictionary do
		if item == value then
			return key
		end
	end

	return false
end


--Looks for an key that's the same as the specified key and returns it.
function Utils.FindKeyInDictionary(dictionary: {[string]: any}, key: string): string | false
	if not dictionary or not key then return false end
	if not Utils.IsDictionary(dictionary) then 
		warn("expected dictionary")
		return false 
	end

	for _key, _ in dictionary do
		if _key == key then 
			return key
		end
	end

	return false
end

return Utils
