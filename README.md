# RobloxEye
Open source roblox values scanner
## Documentation
```lua
-- // Load the libraly
local RobloxEye = loadstring(game:HttpGet("https://raw.githubusercontent.com/GrblxHOfficial/RobloxEye/main/source.lua"))()

-- // Get blacklist
local Blacklist = RobloxEye:GetBlacklist()

-- // Clear the Blacklist
RobloxEye:ClearBlacklist()

-- // Create a function for test
local function testfunction()
    print("Hello World!")  
end

-- // Scan for value "Hello World!" only in functions (lookInTables is false)
for i, v in pairs(RobloxEye:ScanXrefs("Hello World!", false)) do
    print("\"Hello World!\" found in", v)
end

-- // Remove 'testfunction' from scanner
RobloxEye:AddFunctionToBlackList(testfunction)

-- // Create a table for test
local testtable = {
    [1] = "Hello World!"
}

-- // Scan for value "Hello World!" in functions and tables
for i, v in pairs(RobloxEye:ScanXrefs("Hello World!", true)) do
    print("\"Hello World!\" found in", v)
end
```
