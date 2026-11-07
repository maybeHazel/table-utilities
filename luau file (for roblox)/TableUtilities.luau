local Utils = {}

--========================================//Array stuff\\======================================================================================

	--[[Searches for indexes with duplicated values inside the specified array and puts them in two tables which are respectively returned,
	the first table being a dictionary having the *duplicated values* as *Keys* and the amount of times that the duplicated value 
	was found as a value, and, an array containing every single duplicated value]]
function Utils.FindDuplicatedValuesInArray(array: {any}): ({key: number}, {any})
	if not array then return warn("missing array") end
	if typeof(array) ~= "table" then return warn(`expected table but got {typeof(array)} instead`) end

	local FilteredArray = {}
	local numberOfOccurencies = {}
	local sameItems = {}

	for index, item in array do
		if typeof(index) ~= "number" then continue end

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
function Utils.FindValueInArrays(arrayA: {any}, ArrayB: {any}, value: any): (number | boolean | nil, number)
	if not arrayA and not ArrayB and not value then 
		warn("missing arrays or value") 
		return nil, 0
	end

	if typeof(arrayA) ~= "table" or typeof(ArrayB) ~= "table" then
		warn(`expected table for arrayA and arrayB but got {typeof(arrayA)} for arrayA and {typeof(ArrayB)} for arrayB`)  
		return nil, 0
	end

	if #arrayA < 1 or #ArrayB < 1 then
		warn(`Cannot search value in arrays if they dont have atleast 1 item: A/B {#arrayA}, {#ArrayB}`)
		return nil, 0
	end

	local itemInArrA = table.find(arrayA, value)
	local itemInArrB = table.find(ArrayB, value)

	if itemInArrA  and itemInArrB then
		return itemInArrA, itemInArrB
	end

	return false, 0
end


--[[looks for indexes with the same value as the specified value inside the array and places them inside of another array which gets returned]]
function Utils.FindDuplicatedValueInArray(value: any, array: {any}): {any}
	if not array and not value then return end
	if typeof(array) ~= "table" then return warn(`expected table but got {typeof(array)} instead`) end

	local dupesArray = {}
	local filter = {}

	for index, item in array do
		if typeof(index) ~= "number" then continue end


		if table.find(filter, item) then
			table.insert(dupesArray, item)

		else
			table.insert(filter, item)
		end

	end

	return dupesArray
end

--======================================//Dictionary stuff\\======================================================================================


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
function Utils.FindDuplicatedValuesInDictionary(dictionary: {key:any}): ({key: number}, {key: {key: number}})
	if not dictionary then return warn("missing dictonary") end
	if typeof(dictionary) ~= "table" then return warn(`expected table but got {typeof(dictionary)} instead`) end

	local TotalOccurencies = {}
	local filteredValues = {}
	local sameOccurencies = {}

	for key, value in dictionary do
		if typeof(key) ~= "string" then continue end

		if table.find(filteredValues, value) then
			TotalOccurencies[value] += 1

			local hasOccurency: {} = sameOccurencies[value] 
			if hasOccurency then

				local numberOfOccurencies = hasOccurency[key]
				if numberOfOccurencies then
					hasOccurency[key] += 1
				else
					hasOccurency[key] = 1
				end

			else
				sameOccurencies[value] = {}
				sameOccurencies[value][key] = 1
			end

		else
			table.insert(filteredValues, value)
			TotalOccurencies[value] = 1
		end

	end


	return TotalOccurencies, sameOccurencies
end


return Utils
