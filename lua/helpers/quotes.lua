--[[
This file is a list of quotes to randomly load on start
]]
--
Inspire = true
Comedy = true
Quotes = {}
--[[
Vaugly inspiring
--]]
local inspire = {
	"Strive for progress.",
	"Nothing about us without us.",
}
if Inspire then
	for i, v in ipairs(inspire) do
		Quotes[#Quotes + 1] = v
	end
end
--[[
Comedy
--]]
local funny = {
	"I use Arch btw",
}
if Comedy then
	for i, v in ipairs(funny) do
		Quotes[#Quotes + 1] = v
	end
end
