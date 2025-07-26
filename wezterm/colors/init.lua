local wezterm = require("wezterm")
local dark = require("colors.dark")
local light = require("colors.dark")

-- wezterm.gui is not available to the mux server, so take care to
-- do something reasonable when this config is evaluated by the mux
local function get_appearance()
	if wezterm.gui then
		return wezterm.gui.get_appearance()
	end
	return "Dark"
end

local function scheme_for_appearance(appearance)
	if appearance:find("Dark") then
		return dark
	else
		return light
	end
end

return scheme_for_appearance(get_appearance())
