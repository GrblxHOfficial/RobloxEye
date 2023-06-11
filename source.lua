local RobloxEye = {}
local Blacklist = {}

local ScanTable, ScanFunction, ScanInternal

local function Merge(list1 : {any}, list2 : {any})
	local tbl = {}
	
	for i, v in pairs(list1) do
		table.insert(tbl, v)
	end
	
	for i, v in pairs(list2) do
		table.insert(tbl, v)
	end
	
	return tbl
end

local function EQ(value1 : any, value2 : any)
	local type1 = typeof(value1)
	local type2 = typeof(value2)
	if type1 ~= type2 then
		return false
	elseif type1 == "table" then
		local indexes = {}
		for i, v in pairs(value1) do
			indexes[i] = true
		end
		for i, v in pairs(value2) do
			if not value1[i] then
				return false
			end
		end
		return true
	elseif type1 == "function" then
		if islclosure(value1) and islclosure(value2) then
			return EQ(debug.getconstants(value1), debug.getconstants(value2))
		end
	end
	return rawequal(value1, value2)
end

local function ScanTable(list : {any}, value : any)
	for _, v in pairs(list) do
		if EQ(v, value) then
			return true
		end
	end
	return false
end

local function ScanFunction(func : () -> (), value : any)
	if table.find(Blacklist, func) or iscclosure(func) then 
		return false 
	end
	return 
		ScanTable(debug.getconstants(func), value) or 
		ScanTable(debug.getupvalues(func), value) or
		debug.info(func, "n") == value
end

local function ScanInternal(list : {any}, value : any) : {}
	local results = {}
	
	for _, v in pairs(list) do
		if typeof(v) == "function" then
			if not table.find(results, v) and ScanFunction(v, value) then
				table.insert(results, v)
			end
		end
	end
	
	return results
end

function RobloxEye:ScanXrefs(value : any) : {() -> ()}
	RobloxEye:AddFunctionToBlackList(debug.info(2, "f"))
	return Merge(ScanInternal(getgc(), value), ScanInternal(getreg(), value))
end

function RobloxEye:AddFunctionToBlackList(func : () -> ())
	table.insert(Blacklist, func)
end

return RobloxEye
