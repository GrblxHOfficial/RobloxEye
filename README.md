# RobloxEye
Open source roblox values scanner
## Documentation
```lua
-- // Load the libraly
local RobloxEye = loadstring(game:HttpGet("https://raw.githubusercontent.com/GrblxHOfficial/RobloxEye/main/source.lua"))()

-- // Create a function for test
local function testfunction()
    print("Hello World!")  
end

-- // Scan for value "Hello World!"
for i, v in pairs(RobloxEye:ScanXrefs("Hello World!")) do
    print("\"Hello World!\" found in", v)
end

-- // Remove 'testfunction' from scanner
RobloxEye:AddFunctionToBlackList(testfunction)
```
