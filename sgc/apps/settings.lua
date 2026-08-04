--------------------------------------------------
-- SGC Operating System
-- Settings
-- Version : 0.2.1
--------------------------------------------------

local ui = SGC.load("lib.ui")
local gate = SGC.load("lib.gate")
local config = SGC.load("lib.config")

local settings = {}


--------------------------------------------------
-- Affichage
--------------------------------------------------

local function draw()

    ui.begin("PARAMETRES SGC")


    local info,err =
        gate.info()


    print()

    print("SGC Operating System")
    print("--------------------")

    print()

    print("Version : 0.2.1")


    print()

print(
    "Interface : "
    ..
    tostring(
        config.devices.interface
    )
)


if info then


    print(
        "Generation : "
        ..
        tostring(
            info.generation
        )
    )


    print(
        "Variant : "
        ..
        tostring(
            info.variant
        )
    )


    print(
        "Origine : "
        ..
        tostring(
            info.origin
        )
    )


    print(
        "Energie : "
        ..
        tostring(info.energy)
        ..
        "/"
        ..
        tostring(info.capacity)
    )


    local state =
        "Inactive"


    if info.connected then

        state =
            "Connectee"


    elseif info.dialing then

        state =
            "Composition"

    end


    print(
        "Etat : "
        ..
        state
    )


else


    print()

    print(
        "Erreur : "
        ..
        tostring(err)
    )


end


    print()

    print()

    print("[Q] Retour")


end



--------------------------------------------------
-- Application
--------------------------------------------------

function settings.run()


    while true do


        draw()


        local _,key =
            os.pullEvent("key")


        if key == keys.q then

            return

        end


    end


end


return settings
