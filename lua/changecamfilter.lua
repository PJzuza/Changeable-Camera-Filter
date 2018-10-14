	_G.CCF = _G.CCF or {}
	CCF._path = ModPath
	CCF.settings_path = SavePath .. "CCF.txt"
	CCF.settings = {}
	CCF.Choose_Camera_Filter = 	
		{
			"color_sin",
			"color_main",
			"color_payday",
			"color_heat",
			"color_nice",
			"color_bhd",
			"color_xgen",
			"color_xxxgen",
			"color_matrix",
			"color_matrix_classic",
			"color_sin_classic",
			"color_sepia",
			"color_sunsetstrip",
			"color_colorful",
			"color_madplanet"
		}
-- Store Color Gradient before using it as a string value in PostHook
function CCF:GetFilter()
	return self.Choose_Camera_Filter[self.settings.color_camera_filters_value]
end

function CCF:Reset()
	self.settings = {
		color_camera_filters_value = 1
	}
end

function CCF:Save()
	local file = io.open(CCF.settings_path, "w+")
	if file then
		file:write(json.encode(CCF.settings))
		file:close()
	end
end

function CCF:Load()
	self:Reset()
	local file = io.open(self.settings_path, "r")
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
				self.settings[k] = v
		end
		file:close()
	end
end

--PostHook to overide a function IngameAccessCamera:at_enter
if RequiredScript == "lib/states/ingameaccesscamera" then
	Hooks:PostHook( IngameAccessCamera, "at_enter" , "ApplyCCF" , function(self)
		managers.environment_controller:set_default_color_grading(CCF:GetFilter(), true)
		managers.environment_controller:refresh_render_settings()
	end)
end

--PostHook to remove noise from camera
--thx to Cpone for his help with this
if RequiredScript == "lib/managers/hud/hudaccesscamera" then
	Hooks:PostHook( HUDAccessCamera, "init", "HideHUDNoiseCCF", 
	function(self)
		--if config.removeNoise == true then
		self._full_hud_panel:child("noise"):set_visible(false)
		self._full_hud_panel:child("noise2"):set_visible(false)
		--end
	end)
end

--Localization thingy things :P
Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_CCF", function( loc )
	if file.DirectoryExists(CCF._path .. "loc/") then
		local custom_language
		for _, mod in pairs(BLT and BLT.Mods:Mods() or {}) do
			if mod:GetName() == "ChnMod (Patch)" and mod:IsEnabled() then
				custom_language = "chinese"
				break
			elseif mod:GetName() == "PAYDAY 2 THAI LANGUAGE Mod" and mod:IsEnabled() then
				custom_language = "thai"
				break
			end			
		end
		if custom_language then
			loc:load_localization_file(CCF._path .. "loc/" .. custom_language ..".txt")
		else
			for _, filename in pairs(file.GetFiles(CCF._path .. "loc/")) do
				local str = filename:match('^(.*).txt$')
				if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
					loc:load_localization_file(CCF._path .. "loc/" .. filename)
					break
				end
			end
		end
	end
	loc:load_localization_file(CCF._path .. "loc/english.txt", false)
end)

-- Menu stuffs
Hooks:Add( "MenuManagerInitialize", "MenuManagerInitialize_CCF", function( menu_manager )
	MenuCallbackHandler.callback_color_camera_filters = function (self, item)
		CCF.settings.color_camera_filters_value = item:value()
	end

	MenuCallbackHandler.ccf_save = function(this, item)
		CCF:Save()
	end
	
	MenuCallbackHandler.callback_ccf_reset = function(self, item)
		MenuHelper:ResetItemsToDefaultValue(item, {["color_camera_filters"] = true}, 1)
	end
	
	CCF:Load()	
	MenuHelper:LoadFromJsonFile(CCF._path .. "menu/options.txt", CCF, CCF.settings)
end )