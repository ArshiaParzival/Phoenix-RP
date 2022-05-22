Config = {}

Config.RangeCheck = 25.0 

Config.Garages = {


    ["B"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(273.67422485352, -344.15573120117, 44.919834136963)
            },
            ["vehicle"] = {
                ["position"] = vector3(272.50082397461, -337.40579223633, 44.919834136963), 
                ["heading"] = 160.0
            }
        },
        ["camera"] = { 
            ["x"] = 283.28225708008, 
            ["y"] = -333.24017333984, 
            ["z"] = 50.004745483398, 
            ["rotationX"] = -21.637795701623, 
            ["rotationY"] = 0.0, 
            ["rotationZ"] = 125.73228356242 
        }
    },
    ["E"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(1893.77, 3712.21, 32.78)
            },
            ["vehicle"] = {
                ["position"] = vector3(1886.67, 3716.10, 32.82), 
                ["heading"] = 118.94
            }
        }
    },
    ["F"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(77.53, 6361.71, 31.49)
            },
            ["vehicle"] = {
                ["position"] = vector3(-76.74, 6346.73, 31.07), 
                ["heading"] = 45.58
            }
        }
    },
    ["L"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-72.69, 908.39, 235.63)
            },
            ["vehicle"] = {
                ["position"] = vector3(-71.00, 900.06, 235.59), 
                ["heading"] = 110.55
            }
        }

    },
    ["M"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-3155.68, 1125.22, 20.86)
            },
            ["vehicle"] = {
                ["position"] = vector3(-3163.21, 1130.80, 20.99), 
                ["heading"] = 332.06
            }
        }
    },
    ["A"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(213.8, -809.00, 31.00)
            },
            ["vehicle"] = {
                ["position"] = vector3(231.48, -797.75, 30.56), 
                ["heading"] = 159.29
            }
        },
        ["camera"] = {
            ["x"] = 231.94,
            ["y"] = -803.61,
            ["z"] = 32.51,
            ["rotationX"] = -30.401574149728,
            ["rotationY"] = 00.0,
            ["rotationZ"] = 0.75157422423
        }
    },
    ["P"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(951.42, -122.64, 74.35)
            },
            ["vehicle"] = {
                ["position"] = vector3(966.3, -130.11, 74.37), 
                ["heading"] = 164.31
            }
        }

    },
    ["Q"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(-1414.61, -653.81, 28.67)
            },
            ["vehicle"] = {
                ["position"] = vector3(-1422.6, -645.43, 28.67), 
                ["heading"] = 214.54
            }
        }
    },
    ["S"] = {
        ["positions"] = {
            ["menu"] = {
                ["position"] = vector3(541.1, -1791.09, 29.14)
            },
            ["vehicle"] = {
                ["position"] = vector3(545.74, -1794.52, 29.2), 
                ["heading"] = 335.87
            }
        }
    },
}


Config.Trim = function(value)
	if value then
		return (string.gsub(value, "^%s*(.-)%s*$", "%1"))
	else
		return nil
	end
end

Config.AlignMenu = "right"