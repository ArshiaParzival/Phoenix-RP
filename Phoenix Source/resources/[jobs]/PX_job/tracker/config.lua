TrackerConfig = {}

TrackerConfig.selfBlip = true -- use classic arrow or job specified blip?
TrackerConfig.useRflxMulti = false -- server specific init
TrackerConfig.useBaseEvents = false -- F for optimisation
TrackerConfig.prints = false -- server side prints (on/off duty)

-- looks
TrackerConfig.font = {
    useCustom = false, -- use custom font? Has to be specified below, also can be buggy with player tags
    name = 'Russo One', -- > this being inserted into <font face='nameComesHere'> eg. (<font face='Russo One'>) --> Your font has to be streamed and initialized on ur server
}
TrackerConfig.notifications = {
    enable = true,
    useMythic = true,
    onDutyText = 'Přišel/a jste do služby', -- pretty straight foward
    offDutyText = 'Odešel/a jste ze služby', -- pretty straight foward
}
TrackerConfig.blipGroup = {
    renameGroup = false,
    groupName = '~b~Other units'
}

-- blips
TrackerConfig.bigmapTags = false -- Playername tags when bigmap enabled?
TrackerConfig.blipCone = true -- use that wierd FOV indicators thing?

TrackerConfig.useCharacterName = true -- use IC name or OOC name, chose your warrior
TrackerConfig.usePrefix = true
TrackerConfig.namePrefix = { -- global name prefixes by grade_name 
    -- recruit = 'CAD.',
    -- officer = 'P/O-1.',
    -- officer2 = 'P/O-2.',
    -- officer3 = 'P/O-3.',
    -- sergeant = 'SGT-1.',
    -- sergeant2 = 'SGT-2.',
    -- lieutenant = 'LTN.',
    -- captain = 'CAPT.',
    -- commander = 'COM.',
    -- deputy = 'DPT.',
    -- aschief = 'AS-CHF.',
    -- boss = 'CHF.',

    -- deputy1 = 'DPT-1.',
    -- deputy2 = 'DPT-2.',
    -- assheriff = 'AS-SHRF.',
    -- undersheriff = 'UNSHRF.',
    -- boss_shrf = 'SHRF-COP.',
}

--[[
  Full TrackerConfig template:

    ['police'] = { --> job name in database
        ignoreDuty = true, -- if ignore, you don't need to call onDuty or offDuty by exports or event, player is on map while he has that job
        blip = {
            sprite = 60, -- on foot blip sprite (required)
            color = 29, -- on foot blip color (required)
            scale = 0.8, -- global blip scale 1.0 by default (not required)
            flashColors = { -- blip flash when siren ON! You can define as many colors as you want! //// If you don't want to use flash, then just delete it (not required)
                59,
                29,
            }
        },
        vehBlip = { -- in vehicle blip TrackerConfig, if you don't want to use it, just delete it (not required)
            ['default'] = { -- global in vehicle blip (required if you have "vehBlip" defined)
                sprite = 56,
                color = 29,
            },
            [`ambluance`] = { -- this overrides 'default' blip by vehicle hash, hash has to be between ` eg. `spawnnamehere`
                sprite = 56,
                color = 29,
            },
            [`police2`] = {
                sprite = 56,
                color = 29,
            }
        },
        gradePrefix = { -- global TrackerConfig.namePrefix override (not required)
            [0] = 'CAD.', -- 0 = grade number in database | 'CAD. ' is label obv..
        },
        canSee = { -- What job can see this job, when not defined they'll see only self job --> police will see only police blips (not required)
            ['police'] = true,
            ['sheriff'] = true,
            ['shreck'] = true, --> this cfg has to be in specified format "['jobname'] = true"
        }
    },
--]]

TrackerConfig.emergencyJobs = {
    ['police'] = {
        ignoreDuty = true,
        blip = {
            sprite = 60,
            color = 29,
            flashColors = {
                59,
                29,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 56,
                color = 29,
            },
        },

        canSee = {
            ['police'] = true,
            ['ambulance'] = true,
            ['dadgostari'] = true,
        },
    },
    ['ambulance'] = {
        ignoreDuty = true,
        blip = {
            sprite = 1,
            color = 0,
            flashColors = {
                0,
                59,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 225,
                color = 0,
            },
        },
        canSee = {
            ['police'] = true,
            ['ambulance'] = true,
            ['dadgostari'] = true,
        }
    },
    ['weazel'] = {
        ignoreDuty = true,
        blip = {
            sprite = 402,
            color = 31,
            flashColors = {
                31,
                31,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 225,
                color = 31,
            },
        },
        canSee = {
            ['weazel'] = true,
        }
    },
    ['dadgostari'] = {
        ignoreDuty = true,
        blip = {
            sprite = 468,
            color = 40,
            flashColors = {
                40,
                40,
            }
        },
        vehBlip = {
            ['default'] = {
                sprite = 225,
                color = 40,
            },
        },
        canSee = {
            ['dadgostari'] = true,
        }
    },
}