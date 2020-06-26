-- try to Stop LUAJIT Out-Of-Memory (OOM) crashes [stop_lj_oom]

-- inspirated by: blert2112's original

-- fork by Thomas march 2019
-- https://github.com/Minetest-One/stop_lj_oom
-- edited for report count memory before and after
-- will reduce lag, with change globalstep to minetest.after

-----------------------------------------------------------------------------------------------
local title	= "stop_lj_oom"
local date	= "29.03.2019"
local version	= "1.10"
local mname	= "stop_lj_oom"
-----------------------------------------------------------------------------------------------

local oldluamem = nil
local newluamem = nil


-- following settings can be changed by admin as wanted, needed - useful
local loaded = 1 -- to get terminal output when mod is loaded
local looptime = 60 -- set repeat time of check here
local maxluamem = 2500 -- set to value 10% ? less then lowest known OOM
-- END of settings to change mostly


local function cleanup()
	oldluamem = math.floor(collectgarbage("count"))
--	print(oldluamem.." KB used before check if to clean (stop_lj_oom)")
	if oldluamem > maxluamem then
		collectgarbage()
		newluamem = math.floor(collectgarbage("count"))
		core.log("action", "[MOD] [stop_lj_oom]: Collected Garbage from "..oldluamem.." to "..newluamem.." KB" )
	end
	oldluamem = nil
	newluamem = nil
	minetest.after(looptime, cleanup)
end

minetest.after(looptime, cleanup) -- here now to set time to repeat


if loaded then
	print ("[Mod] "..title.." settings: "..looptime.." sec / warn: "..maxluamem.." KB")
  print ("[Mod] "..title.." ("..version.." "..date..") - loaded - end mem : "..math.floor(collectgarbage("count")).." KB")
end