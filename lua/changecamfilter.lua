--if not _G.CCF then
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
--end
function CCF:GetFilter()
	log("[CCF]Check color_camera_filters_value", tostring(CCF.settings.color_camera_filters_value))
	return CCF.Choose_Camera_Filter[CCF.settings.color_camera_filters_value]
end

function CCF:Reset()
	CCF.settings = {
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
	CCF:Reset()
	local file = io.open(CCF.settings_path, "r")
	if file then
		for k, v in pairs(json.decode(file:read('*all')) or {}) do
				CCF.settings[k] = v
		end
		CCF:GetFilter()
		file:close()
	end
end

--PostHook to overide a function IngameAccessCamera:at_enter
Hooks:PostHook( IngameAccessCamera , "at_enter" , "ApplyCCF" , function(self)
		--local filter = CCF:GetFilter()
		-- add logs to check the value if it has contained the value and turned out it did but for some reasons it won't call in-game I think?) 
		log("[CCF ingameaccesscamera]Check CCF:GetFilter() Function value", tostring(CCF:GetFilter()))
		--log("[CCF ingameaccesscamera]Check filter value", tostring(filter))
		--self._saved_default_color_grading = managers.environment_controller:default_color_grading()
		managers.environment_controller:set_default_color_grading(CCF:GetFilter(), true)
		managers.environment_controller:refresh_render_settings()
end)

Hooks:Add("LocalizationManagerPostInit", "LocalizationManagerPostInit_CCF", function( loc )
	if file.DirectoryExists(CCF._path .. "loc/") then
			for _, filename in pairs(file.GetFiles(CCF._path .. "loc/")) do
				local str = filename:match('^(.*).txt$')
				if str and Idstring(str) and Idstring(str):key() == SystemInfo:language():key() then
					loc:load_localization_file(CCF._path .. "loc/" .. filename)
					break
				end
			end
	end
	loc:load_localization_file(CCF._path .. "loc/english.txt", false)
end)

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