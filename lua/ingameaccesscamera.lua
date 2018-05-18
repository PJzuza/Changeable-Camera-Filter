Hooks:PostHook( IngameAccessCamera , "at_enter" , "CCF" , function( self , old_state, ...)
    --self._saved_default_color_grading = managers.environment_controller:default_color_grading()
managers.environment_controller:set_default_color_grading(CCF.settings.color_camera_filters_value)
end)

--[[local color_old = IngameAccessCamera.at_enter
function IngameAccessCamera:at_enter(old_state, ...)
	color_old(self, old_state, ...)
    local player = managers.player:player_unit()
    if player then
        player:base():set_enabled(false)
        player:base():set_visible(false)
        player:character_damage():add_listener("IngameAccessCamera", {"hurt", "death"}, callback(self, self, "_player_damage"))
        SoundDevice:set_rtpc("stamina", 100)
    end
    self._sound_source = self._sound_source or SoundDevice:create_source("IngameAccessCamera")
    self._sound_source:post_event("camera_monitor_engage")
    managers.enemy:set_gfx_lod_enabled(false)
    self._old_state = old_state:name()
    if not managers.hud:exists(self.GUI_SAFERECT) then
        managers.hud:load_hud(self.GUI_FULLSCREEN, false, true, false, {})
        managers.hud:load_hud(self.GUI_SAFERECT, false, true, true, {})
    end
    managers.hud:show(self.GUI_SAFERECT)
    managers.hud:show(self.GUI_FULLSCREEN)
    managers.hud:start_access_camera()
    self._saved_default_color_grading = managers.environment_controller:default_color_grading()
    managers.environment_controller:set_default_color_grading(CCF.settings.color_camera_filters_value)
    self._cam_unit = CoreUnit.safe_spawn_unit("units/gui/background_camera_01/access_camera", Vector3(), Rotation())
    self:_get_cameras()
    self._camera_data = {}
    self._camera_data.index = 0
    self._no_feeds = not self:_any_enabled_cameras()
    if self._no_feeds then
        managers.hud:set_access_camera_destroyed(true, true)
    else
        self:_next_camera()
    end
    self:_setup_controller()
end]]--
	--[[Lists of all color_filters]
	color_main
	color_payday
	color_heat
	color_nice
	color_sin
	color_bhd
	color_xgen
	color_xxxgen
	color_matrix
	color_matrix_classic
	color_sin_classic
	color_sepia
	color_sunsetstrip
	color_colorful
	color_madplanet
	]]--