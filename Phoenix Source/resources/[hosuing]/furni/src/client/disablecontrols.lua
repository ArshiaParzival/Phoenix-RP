furni.handleControls = function(e)
  if not e and     IsControlEnabled(0,  23) then d = true;
  elseif e and not IsControlEnabled(0,  23) then d = true;
  end

  if d then
    -- All controls related to [F] key
    DisableControlAction(0,  23, e)
    DisableControlAction(0,  75, e)
    DisableControlAction(0, 144, e)
    DisableControlAction(0, 145, e)
    DisableControlAction(0, 185, e)
    DisableControlAction(0, 251, e)

    -- Left click
    --DisableControlAction(0,  18, e)
    DisableControlAction(0,  24, e)
    DisableControlAction(0,  69, e)
    DisableControlAction(0,  92, e)
    DisableControlAction(0, 106, e)
    DisableControlAction(0, 122, e)
    DisableControlAction(0, 135, e)
    DisableControlAction(0, 142, e)
    DisableControlAction(0, 144, e)
    --DisableControlAction(0, 176, e)
    DisableControlAction(0, 223, e)
    DisableControlAction(0, 229, e)
    DisableControlAction(0, 237, e)
    DisableControlAction(0, 257, e)
    DisableControlAction(0, 329, e)
    DisableControlAction(0, 346, e)

    -- Right Click
    DisableControlAction(0,  25, e)
    DisableControlAction(0,  68, e)
    DisableControlAction(0,  70, e)
    DisableControlAction(0,  91, e)
    DisableControlAction(0, 114, e)
   -- DisableControlAction(0, 177, e)
    DisableControlAction(0, 222, e)
    DisableControlAction(0, 225, e)
    DisableControlAction(0, 238, e)
    DisableControlAction(0, 330, e)
    DisableControlAction(0, 331, e)
    DisableControlAction(0, 347, e)

    -- Numpad -
    DisableControlAction(0,  96, e)
    DisableControlAction(0,  97, e)
    DisableControlAction(0, 107, e)
    DisableControlAction(0, 108, e)
    DisableControlAction(0, 109, e)
    DisableControlAction(0, 110, e)
    DisableControlAction(0, 111, e)
    DisableControlAction(0, 112, e)
    DisableControlAction(0, 117, e)
    DisableControlAction(0, 118, e)
    DisableControlAction(0, 123, e)
    DisableControlAction(0, 124, e)
    DisableControlAction(0, 125, e)
    DisableControlAction(0, 126, e)
    DisableControlAction(0, 127, e)
    DisableControlAction(0, 128, e)
    DisableControlAction(0, 314, e)
    DisableControlAction(0, 315, e)

    -- Scroll
    DisableControlAction(0, 261, e)
    DisableControlAction(0, 262, e)
    DisableControlAction(0, 14, e)
    DisableControlAction(0, 15, e)
    DisableControlAction(0, 16, e)
    DisableControlAction(0, 17, e)
  end
end