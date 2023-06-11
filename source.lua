local RobloxEye = {}
local Blacklist = {}

local ScanTable, ScanFunction, ScanInternal

local function Merge(list1 : {any}, list2 : {any}) : {any}
	for i, v in pairs(list2) do
		table.insert(list1, v)
	end
end

local function EQ(value1 : any, value2 : any) : boolean
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

local function ScanTable(list : {any}, value : any) : boolean
	for _, v in pairs(list) do
		if EQ(v, value) then
			return true
		end
	end
	return false
end

local function ScanFunction(func : () -> (), value : any) : boolean
	if table.find(Blacklist, func) or iscclosure(func) then 
		return false 
	end
	return 
		ScanTable(debug.getconstants(func), value) or 
		ScanTable(debug.getupvalues(func), value) or
		debug.getinfo(func).name == value
end

local function ScanInternal(list : {any}, value : any, lookInTables : boolean) : {() -> ()}
	local results = {}
	
	for _, v in pairs(list) do
		if typeof(v) == "function" then
			if not table.find(results, v) and ScanFunction(v, value) then
				table.insert(results, v)
			end
		elseif typeof(v) == "table" and lookInTables then
			if not table.find(results, v) then
				for i, val in pairs(v) do
					if EQ(i, value) or EQ(val, value) then
						table.insert(results, v)
						break
					end
				end
			end
		end
	end
	
	return results
end

function RobloxEye:ScanXrefs(value : any, lookInTables : boolean?) : {() -> ()}
	lookInTables = not not lookInTables
	RobloxEye:AddFunctionToBlackList(debug.getinfo(2).func)
	local results = ScanInternal(getgc(lookInTables), value, lookInTables)
	Merge(results, ScanInternal(getreg(), value, lookInTables))
	return results
end

function RobloxEye:GetBlacklist() : {() -> ()}
	return Blacklist
end

function RobloxEye:ClearBlacklist()
	Blacklist = {}
end

function RobloxEye:AddFunctionToBlackList(func : () -> ())
	table.insert(Blacklist, func)
end

return RobloxEye
