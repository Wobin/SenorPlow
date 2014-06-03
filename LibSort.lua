
local MAJOR,MINOR = "Wob:LibSort-1.0", 1
-- Get a reference to the package information if any
local APkg = Apollo.GetPackage(MAJOR)
-- If there was an older version loaded we need to see if this is newer
if APkg and (APkg.nVersion or 0) >= MINOR then
	return -- no upgrade needed
end
-- Set a reference to the actual package or create an empty table
local LibSort = APkg and APkg.tPackage or {}

local glog

function LibSort:OnLoad()
local GeminiLogging = Apollo.GetPackage("Gemini:Logging-1.2").tPackage
glog = GeminiLogging:GetLogger({
        level = GeminiLogging.DEBUG,
        pattern = "%d %n %c %l - %m",
        appender = "GeminiConsole"
  	})
end

local function removeSpaces(name)
	return name:gsub(" ","")
end

local function makePrefix(name)
	return removeSpaces(name) .. "_"
end

LibSort.FirstInChain = nil

LibSort.RegisteredCallbacks = {}
LibSort.AddonOrder = {}
LibSort.DefaultOrdersLow = {}
LibSort.DefaultOrdersHigh = {}
LibSort.TiebreakerChain = {}

function LibSort:Comparer(itemA, itemB)
	return self:ProcessOrderFunction(self.FirstInChain, self.TiebreakerChain[self.FirstInChain.key], itemA, itemB)
end

function LibSort:ReOrderKeys()
	local first 
	local previous
	for i, addonName in ipairs(self.AddonOrder) do		
		if self.DefaultOrdersLow[addonName] then
			for _, name in ipairs(self.DefaultOrdersLow[addonName]) do
				local data = self.RegisteredCallbacks[addonName][name] 
				if data then -- we skip the ones we haven't registered yet
					first, previous = self:SetKeyOrder(first, previous, data)
				end
			end
		end
	end
	for i, addonName in ipairs(self.AddonOrder) do		
		if self.DefaultOrdersHigh[addonName] then
			for _, name in ipairs(self.DefaultOrdersHigh[addonName]) do
				local data = self.RegisteredCallbacks[addonName][name] 
				if data then -- we skip the ones we haven't registered yet
					first, previous = self:SetKeyOrder(first, previous, data)
				end
			end
		end					
	end
end

function LibSort:SetKeyOrder(first, previous, data)
	if not first then 
		first = true 
		self.FirstInChain = data
	else
		if previous then
			self.TiebreakerChain[previous] = data
		end
	end	
	return first, data.key
end


function LibSort:ProcessOrderFunction(data, tiebreaker, itemA, itemB)
	if itemA == itemB then
		return 0
	end
	if itemA and itemB == nil then
		return -1
	end
	if itemA == nil and itemB then
		return 1
	end
	

	local response = data.func(itemA, itemB)
	if response == 0 and self.TiebreakerChain[data.key] then		
		return self:ProcessOrderFunction(tiebreaker, self.TiebreakerChain[tiebreaker.key], itemA, itemB)
	else
		glog:debug(data.name .. " checking ".. data.name .. " for " .. itemA:GetName() .. " vs " .. itemB:GetName())
		glog:debug("Returning " .. response )
		return response
	end
end

--------- API ---------

function LibSort:Unregister(addonName, name)
	if not name then 
		self.RegisteredCallbacks[addonName] = nil
		self.DefaultOrdersHigh[addonName] = nil
		self.DefaultOrdersLow[addonName] = nil
		return
	end

	if self.RegisteredCallbacks[addonName] then
		self.RegisteredCallbacks[addonName][name] = nil
	end
end

function LibSort:Register(addonName, name, desc, key, func)
	if not self.RegisteredCallbacks[addonName] then self.RegisteredCallbacks[addonName] = {} table.insert(self.AddonOrder, addonName) end
	self.RegisteredCallbacks[addonName][name] = {key = makePrefix(addonName)..key, func = func, desc = desc, name = name}
	if not self.DefaultOrdersHigh[addonName] then self.DefaultOrdersHigh[addonName] = {} end
	table.insert(self.DefaultOrdersHigh[addonName], name)
	self:ReOrderKeys()
end

function LibSort:RegisterDefaultOrder(addonName, keyTableLow, keyTableHigh)
	self.DefaultOrdersHigh[addonName] = keyTableHigh
	self.DefaultOrdersLow[addonName] = keyTableLow
	self:ReOrderKeys()
end

Apollo.RegisterPackage(LibSort, MAJOR, MINOR, {})