local Utils = {}


--========================================//Array stuff\\======================================================================================

function Utils.find(tbl, value)
	for i, v in ipairs(tbl) do
    if v == value then return i end
  end
  return nil
end

	--[[Searches for indexes with duplicated values inside the specified array and puts them in two tables which are respectively returned,
	the first table being a dictionary having the *duplicated values* as *Keys* and the amount of times that the duplicated value 
	was found as a value, and, an array containing every single duplicated value]]
function Utils.FindDuplicatedValuesInArray(array)
	if not array then return print("missing array") end

	local FilteredArray = {}
	local numberOfOccurencies = {}
	local sameItems = {}

	for index, item in ipairs(array) do

		if Utils.find(FilteredArray, item) then
			table.insert(sameItems, item)
			numberOfOccurencies[item] = numberOfOccurencies[item] + 1
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
function Utils.FindValueInArrays(arrayA, ArrayB, value)
	if not arrayA or not ArrayB then 
		print("missing arrays or value") 
		return nil, 0
	end

	if #arrayA < 1 or #ArrayB < 1 then
		print("Cannot search value in arrays if they dont have atleast 1 item: A/B ", #arrayA, #ArrayB)
		return nil, 0
	end

	local itemInArrA = Utils.find(arrayA, value)
	local itemInArrB = Utils.find(ArrayB, value)

	if itemInArrA  and itemInArrB then
		return itemInArrA, itemInArrB
	end

	return false, 0
end


--[[looks for indexes with the same value as the specified value inside the array and places them inside of another array which gets returned]]
function Utils.FindDuplicatedValueInArray(value, array)
	if not array then return end

	local dupesArray = {}
	local originalItem = {}

	for index, item in ipairs(array) do
		
		if item == value then
			if not Utils.find(originalItem, item) then
				table.insert(originalItem, item)
			else
				table.insert(dupesArray, value)
			end
			
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
function Utils.FindDuplicatedValuesInDictionary(dictionary)
	if not dictionary then return print("missing dictonary") end

	local TotalOccurencies = {}
	local filteredValues = {}
	local sameOccurencies = {}

	for key, value in pairs(dictionary) do

		if Utils.find(filteredValues, value) then
			TotalOccurencies[value] = TotalOccurencies[value] + 1

			local hasOccurency = sameOccurencies[value] 
			if hasOccurency then

				local numberOfOccurencies = hasOccurency[key]
				if numberOfOccurencies then
					hasOccurency[key] = hasOccurency[key] + 1
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
