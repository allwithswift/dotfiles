hs.alert.show("Hello, Hammerspoon")
hs.hotkey.bind({'option', 'cmd'}, 'r', hs.reload)

hs.hotkey.bind({'shift', 'cmd'}, 'T', function() hs.application.launchOrFocus('Terminal') end)
hs.hotkey.bind({'shift', 'cmd'}, 'X', function() hs.application.launchOrFocus('Xcode') end)
hs.hotkey.bind({'shift', 'cmd'}, 'V', function() hs.application.launchOrFocus('VimR') end)
hs.hotkey.bind({'shift', 'cmd'}, 'B', function() hs.application.launchOrFocus('Safari') end)

local caps_mode = hs.hotkey.modal.new()
local inputEnglish = "com.apple.keylayout.ABC"

local on_caps_mode = function()
	caps_mode:enter()
end

local on_delayed_escape = function()
	hs.eventtap.keyStroke({}, 'escape')
end

local off_caps_mode = function()

	caps_mode:exit()

	local input_source = hs.keycodes.currentSourceID()

	if not (input_source == inputEnglish) then
		hs.keycodes.currentSourceID(inputEnglish)
	end
	on_delayed_escape()
end


ctrl_table = {
	sends_escape = true,
	last_mods = {}

}

control_key_timer = hs.timer.delayed.new(0.15, function()
	ctrl_table["send_escape"] = false
end
)

last_mods = {}

control_handler = function(evt)
	local new_mods = evt:getFlags()
	if last_mods["ctrl"] == new_mods["ctrl"] then
		return false
	end
	if not last_mods["ctrl"] then
		last_mods = new_mods
		ctrl_table["send_escape"] = true
		control_key_timer:start()
	else
		if ctrl_table["send_escape"] then
			hs.eventtap.keyStroke({}, "ESCAPE")
			off_caps_mode()
		end
		last_mods = new_mods
		control_key_timer:stop()
	end
	return false
end

control_tap = hs.eventtap.new({12}, control_handler)

control_tap:start()


