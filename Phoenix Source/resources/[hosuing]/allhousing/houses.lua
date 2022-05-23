-- NOTE: You can potentially pre-furnish house models using this.
-- If you don't know/cant figure it out, don't ask how.
ShellExtras = {
  HotelV1 = {
    [GetHashKey("v_49_motelmp_winframe")]       = {offset = vector3(1.44,-3.9, 1.419)},
    [GetHashKey("v_49_motelmp_glass")]          = {offset = vector3(1.44,-3.9, 1.419)},
    [GetHashKey("v_49_motelmp_curtains")]       = {offset = vector3(1.44,-3.8, 1.200)},
    [GetHashKey("hei_prop_heist_safedeposit")]  = {offset = vector3(1.0,-4.2, 1.00), rotation = vector3(0.0,0.0,180.0)},
  }
}

ShellPrices = {
  Medium2       = 20000,
  Medium3       = 20000,
  
  CokeShell1    = 35000,
  CokeShell2    = 35000,
  MethShell     = 35000,
  WeedShell1    = 35000,
  WeedShell2    = 35000,

  GarageShell1  = 35000,
  GarageShell2  = 35000,
  GarageShell3  = 35000,

  NewApt2       = 35000,
  NewApt3       = 35000,
  
  Warehouse1 = 35000, 
  Warehouse2 = 35000,
  Warehouse3 = 35000, 

  Office1   = 35000, 
  Office2   = 35000,
  OfficeBig = 55000,

  Store1    = 55000,
  Store2    = 55000,
  Store3    = 55000,
  Gunstore  = 55000, 
  Barbers   = 55000,

  Trailer       = 150000,  
  HotelV1       = 150000,  
  Lester        = 150000,
  Trevor        = 200000, 
  ApartmentV2   = 250000, 
  HighEndV1     = 500000, 
  HighEndV2     = 600000, 
  Ranch         = 700000,
  Michaels      = 700000

  --NOTE: KAMBI PAYED SHELLS

  --[[

  Office1   = 35000, 
  Office2   = 35000,
  OfficeBig = 45000,

  FrankAunt     = 20000,
  Medium2       = 20000,
  Medium3       = 20000,
  
  CokeShell1    = 35000,
  CokeShell2    = 35000,
  MethShell     = 35000,
  WeedShell1    = 35000,
  WeedShell2    = 35000,

  GarageShell1  = 35000,
  GarageShell2  = 35000,
  GarageShell3  = 35000,

  NewApt2       = 35000,
  NewApt3       = 35000,
  
  Warehouse1 = 35000, 
  Warehouse2 = 35000,
  Warehouse3 = 35000, 

  Office1   = 35000, 
  Office2   = 35000,
  OfficeBig = 55000,

  Store1    = 55000,
  Store2    = 55000,
  Store3    = 55000,
  Gunstore  = 55000, 
  Barbers   = 55000,

  Trailer       = 150000,  
  Lester        = 150000,
  Trevor        = 200000, 
  ApartmentV2   = 250000, 
  HighEndV1     = 500000, 
  HighEndV2     = 600000, 
  Ranch         = 700000,
  Michaels      = 700000,
  ]]
}

ShellModels = {  
  Office1   = 'shell_office1',  
  Office2   = 'shell_office2',
  OfficeBig = 'shell_officebig',

  Medium2       = "shell_medium2",
  Medium3       = "shell_medium3",
  
  CokeShell1    = 'shell_coke1',
  CokeShell2    = 'shell_coke2',
  MethShell     = 'shell_meth',
  WeedShell1    = 'shell_weed',
  WeedShell2    = 'shell_weed2',

  GarageShell1  = 'shell_garages',
  GarageShell2  = 'shell_garagem',
  GarageShell3  = 'shell_garagel',

  NewApt2       = 'shell_apartment2',
  NewApt3       = 'shell_apartment3',

  Warehouse1 = "shell_warehouse1",
  Warehouse2 = "shell_warehouse2",
  Warehouse3 = "shell_warehouse3",  

  Office1   = 'shell_office1',  
  Office2   = 'shell_office2',
  OfficeBig = 'shell_officebig',

  Store1    = 'traphouse_shell',   
  Store2    = 'shell_store2',   
  Store3    = 'shell_store3',  
  Gunstore  = 'gunshop_shell', 
  Barbers   = 'barbers_shell',  
  
  HotelV1       = "playerhouse_appartment_motel",
  Trailer       = "shell_trailer",
  Trevor        = "trevors_shell",
  ApartmentV1   = "playerhouse_tier1",
  ApartmentV2   = "playerhouse_tier3",
  Lester        = "shell_lester",
  Ranch         = "shell_ranch",
  HighEndV1     = "traphouse_shell",
  HighEndV2     = "traphouse_shell",
  Michaels      = "micheal_shell"

  -- NOTE: KAMBI PAYED SHELLS
  --[[

  Office1   = 'shell_office1',  
  Office2   = 'shell_office2',
  OfficeBig = 'shell_officebig',

  FrankAunt     = "shell_frankaunt",
  Medium2       = "shell_medium2",
  Medium3       = "shell_medium3",
  
  CokeShell1    = 'shell_coke1',
  CokeShell2    = 'shell_coke2',
  MethShell     = 'shell_meth',
  WeedShell1    = 'shell_weed',
  WeedShell2    = 'shell_weed2',

  GarageShell1  = 'shell_garages',
  GarageShell2  = 'shell_garagem',
  GarageShell3  = 'shell_garagel',

  NewApt2       = 'shell_apartment2',
  NewApt3       = 'shell_apartment3',

  Warehouse1 = "shell_warehouse1",
  Warehouse2 = "shell_warehouse2",
  Warehouse3 = "shell_warehouse3",  

  Office1   = 'shell_office1',  
  Office2   = 'shell_office2',
  OfficeBig = 'shell_officebig',

  Store1    = 'shell_store1',   
  Store2    = 'shell_store2',   
  Store3    = 'shell_store3',  
  Gunstore  = 'shell_gunstore', 
  Barbers   = 'shell_barber',  
  
  Trailer       = "shell_trailer",
  Trevor        = "shell_trevor",
  ApartmentV2   = "shell_v16mid",
  Lester        = "shell_lester",
  Ranch         = "shell_ranch",
  HighEndV1     = "shell_highend",
  HighEndV2     = "shell_highendv2",
  Michaels      = "shell_michael",
  ]]
}

ShellOffsets = {  
  -- FIXES -->>
  HotelV1       = {exit = vector4(1.7,3.5,28.6,1.5)},
  Trevor        = {exit = vector4(-0.2,3.5,22.5,0.0)},
  ApartmentV1   = {exit = vector4(-3.6,15.4,27.7,0.0)},
  Michaels      = {exit = vector4(9.3,-2.6,28.6,259.0)},
  -- FIXES -->
}
Houses = {
}

if IsDuplicityVersion() then
  Citizen.CreateThread(function()
    Wait(1500)

    local check_coords = {}  
    for _,house in ipairs(Houses) do
      if check_coords[house.Entry] then
        print("Duplicate entry location in houses.lua","Entry: "..tostring(house.Entry))
        return
      else
        check_coords[house.Entry] = true
      end
    end
    if not error_out then
      print("Completed house table check successfully.")
    end
  end)
end

