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

local function ScanTable(list : {any}, value : any)
	for _, v in pairs(list) do
		if v == value then
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
		ScanTable(debug.getupvalues(func), value)
end

local function ScanInternal(list : {any}, value : any, lookInTables : boolean) : {}
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

function RobloxEye:Scan(value : any) : {() -> ()}
	return Merge(ScanInternal(getgc(), value, not not lookInTables), ScanInternal(getreg(), value))
end

function RobloxEye:AddFunctionToBlackList(func : () -> ())
	table.insert(Blacklist, func)
end

return RobloxEye
