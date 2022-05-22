local labels = {
  ['en'] = {
    ['Entry']       = "Entry",
    ['Exit']        = "Exit",
    ['Garage']      = "Garage",
    ['Wardrobe']    = "Wardrobe",
    ['Inventory']   = "Inventory",
    ['InventoryLocation']   = "Inventory",

    ['LeavingHouse']      = "Leaving house",

    ['AccessHouseMenu']   = "Access the house menu",

    ['InteractDrawText']  = "["..Config.TextColors[Config.MarkerSelection].."E~s~] ",
    ['InteractHelpText']  = "~INPUT_PICKUP~ ",

    ['AcceptDrawText']    = "["..Config.TextColors[Config.MarkerSelection].."G~s~] ",
    ['AcceptHelpText']    = "~INPUT_DETONATE~ ",

    ['FurniDrawText']     = "["..Config.TextColors[Config.MarkerSelection].."F~s~] ",
    ['CancelDrawText']    = "["..Config.TextColors[Config.MarkerSelection].."F~s~] ",

    ['VehicleStored']     = "Vehicle stored",
    ['CantStoreVehicle']  = "You can't store this vehicle",

    ['HouseNotOwned']     = "You don't own this house",
    ['InvitedInside']     = "Accept house invitation",
    ['MovedTooFar']       = "You moved too far from the door",
    ['KnockAtDoor']       = "Someone is knocking at your door",

    ['TrackMessage']      = "Track message",

    ['Unlocked']          = "House unlocked",
    ['Locked']            = "House locked",

    ['WardrobeSet']       = "Wardrobe set",
    ['InventorySet']      = "Inventory set",

    ['ToggleFurni']       = "Toggle furniture UI",

    ['GivingKeys']        = "Giving keys to player",
    ['TakingKeys']        = "Taking keys from player",

    ['GarageSet']         = "Garage location set",
    ['GarageTooFar']      = "Garage is too far away",

    ['PurchasedHouse']    = "You brought the house for $%d",
    ['CantAffordHouse']   = "You can't afford this house",

    ['MortgagedHouse']    = "You mortgaged the house for $%d",

    ['NoLockpick']        = "You don't have a lockpick",
    ['LockpickFailed']    = "You failed to crack the lock",
    ['LockpickSuccess']   = "You successfully cracked the lock",

    ['NotifyRobbery']     = "Someone is attempting to rob a house at %s",

    ['ProgressLockpicking'] = "Lockpicking Door",

    ['InvalidShell']        = "Invalid house shell: %s, please report to your server owner.",
    ['ShellNotLoaded']      = "Shell would not load: %s, please report to your server owner.",
    ['BrokenOffset']        = "Offset is messed up for house with ID %s, please report to your server owner.",

    ['UpgradeHouse']        = "Upgrade house to: %s",
    ['CantAffordUpgrade']   = "You can't afford this upgrade",

    ['SetSalePrice']        = "Set sale price",
    ['InvalidAmount']       = "Invalid amount entered",
    ['InvalidSale']         = "You can't sell a house that you still owe money on",
    ['InvalidMoney']        = "You don't have enough money",

    ['EvictingTenants']     = "Evicting tenants",

    ['NoOutfits']           = "You don't have any outfits stored",

    ['EnterHouse']          = "Enter House",
    ['KnockHouse']          = "Knock On Door",
    ['RaidHouse']           = "Raid House",
    ['BreakIn']             = "Break In",
    ['InviteInside']        = "Invite Inside",
    ['HouseKeys']           = "House Keys",
    ['UpgradeHouse2']       = "Upgrade House",
    ['UpgradeShell']        = "Upgrade Shell",
    ['SellHouse']           = "Sell House",
    ['FurniUI']             = "Furni UI",
    ['SetWardrobe']         = "Set Wardrobe",
    ['SetInventory']        = "Set Inventory",
    ['SetGarage']           = "Set Garage",
    ['LockDoor']            = "Lock House",
    ['UnlockDoor']          = "Unlock House",
    ['LeaveHouse']          = "Leave House",
    ['Mortgage']            = "Mortgage",
    ['Buy']                 = "Buy",
    ['View']                = "View",
    ['Upgrades']            = "Upgrades",
    ['MoveGarage']          = "Move Garage",

    ['GiveKeys']            = "Give Keys",
    ['TakeKeys']            = "Take Keys",

    ['MyHouse']             = "My House",
    ['PlayerHouse']         = "Player House",
    ['EmptyHouse']          = "Empty House",

    ['NoUpgrades']          = "No upgrades available",
    ['NoVehicles']          = "No vehicles",
    ['NothingToDisplay']    = "Nothing to display",

    ['ConfirmSale']         = "Yes, sell my house",
    ['CancelSale']          = "No, don't sell my house",
    ['SellingHouse']        = "Sell House ($%d)",

    ['MoneyOwed']           = "Money Owed: $%s",
    ['LastRepayment']       = "Last Repayment: %s",
    ['PayMortgage']         = "Pay Mortgage",
    ['MortgageInfo']        = "Mortgage Info",

    ['SetEntry']            = "Set Entry",
    ['CancelGarage']        = "Cancel Garage",
    ['UseInterior']         = "Use Interior",
    ['UseShell']            = "Use Shell",
    ['InteriorType']        = "Set Interior Type",
    ['SetInterior']         = "Select Current Interior",
    ['SelectDefaultShell']  = "Select default house shell",
    ['ToggleShells']        = "Toggle shells available for this property",
    ['AvailableShells']     = "Available Shells",
    ['Enabled']             = "~g~ENABLED~s~",
    ['Disabled']            = "~r~DISABLED~s~",
    ['NewDoor']             = "Add New Door",
    ['Done']                = "Done",
    ['Doors']               = "Doors",
    ['Interior']            = "Interior",

    ['CreationComplete']    = "House creation complete.",

    ['HousePurchased'] = "Your house was purchased for $%d",
    ['HouseEarning']   = ", you earnt $%d from the sale."
  }
}

Labels = labels[Config.Locale]

