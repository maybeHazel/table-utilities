# table-utilities
Mainly some simple functions for searching things inside of arrays and dictionaries. Everything here can be easily done, im just making this cause im lazy.

## How to use:

```luau
local ServerStorage = game:GetService("ServerStorage")

local TableUtils = require(Server Storage.TableUtils)

-- Functions to get duplicated items inside of tables: --


local CharactersArray = {"Isaac", "Magdalene", "Samson", "Isaac", "Tainted Samson", "Tainted Samson", "Jacob and hitbox", "Tainted Samson"}

local Stuff = {
["keyA"] = "ItemA",
["KeyB"] = "ItemB",
["KeyC"] = "ItemB",
}

--[[FindDuplicatedValuesInArray(array) returns:
{["item"] = number}, {duplicated items}]]

local Occurencies, DuplicatedCharacters = TableUtils.FindDuplicatedValuesInArray(CharactersArray)

--[[FindDuplicatedValueInArray(array, value) returns: {array}]]
local DuplicatedCharacters2 = TableUtils.FindDuplicatedValueInArray(CharactersArray, "Tainted Samson")

--[[FindDuplicatedValuesInDictionary(dictionary) returns: {["item"] = number}]]
local DuplicatedStuff = TableUtils.FindDuplicatedValuesInDictionary(Stuff)

print(Occurencies, DuplicatedCharacters)
print(DuplicatedCharacters2)
print(DuplicatedStuff)

--[[
Output:

]]

-->

-- Functions to get/find items in tables: --
local TableA = {"Tidal Wave", "Lost in Time 2"}
local TableA = {"Bloodlust", "Tidal Wave"}
local numbers = {1,2,3,4,5,6,7,8}

local dictionaryA = {
["KeyA"] = "BeatFromUNBEATABLE",
["keyB"] = "Quaber",
["keyC"] = "clef",
["KeyD"] = "Quaber",
}


--[[FindValueInArrays(arrayA, arrayB, value)
 return: number or false, number of false]]
local indexOfA, indexOfB = TableUtils.FindValueInArrays(TableA, Table, "TidalWave")

--FirstKeyOf(Dictionary) returns: string
local KeyOfQuaber = TableUtils.FirstKeyOf(dictionaryA, "Quaber")

--[[FindKeyInDictionary(Dictionary, string)
returns: string or false]]
local HasKey = TableUtils.FindKeyInDictionary(dictionary, "KeyB")

print(indexOfA, indexOfB)
print(KeyOfQuaber)
print(HasKey)

--[[
Output:
1, 2
"KeyB"
"KeyB"
]]

-->

-- Merging tables: --
local TabA = {"hi", "hello", 9,10,21}
local TabB = {
["KeyA"] = "BeatFromUNBEATABLE",
["keyB"] = "Quaber",
["keyC"] = "clef",
["KeyD"] = "Quaber",
33, 37, 22
}

--[[MergeTables(TableA, tableB, tableC) 
returns Table A and B combined. tableC is an optional ignore table and every index or key inside will be ignored]]

local MergedTable = TableUtils.MergeTables(TabA, TabB)

print(MergedTable)
--[[
Output:
{"hi", "hello", 9,10,21
["KeyA"] = "BeatFromUNBEATABLE",
["keyB"] = "Quaber",
["keyC"] = "clef",
["KeyD"] = "Quaber",
33, 37, 22,
}
]]

-->

```