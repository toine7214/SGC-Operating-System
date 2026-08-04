--------------------------------------------------
-- SGC Operating System
-- Diagnostic
-- Version : 0.2.1
--------------------------------------------------

local ui = SGC.load("lib.ui")
local gate = SGC.load("lib.gate")
local db = SGC.load("lib.database")

local diagnostic = {}


--------------------------------------------------
-- Couleurs
--------------------------------------------------

local function status(text, ok)

    if ok then

        term.setTextColor(colors.lime)
        term.write("OK")

    else

        term.setTextColor(colors.red)
        term.write("ERREUR")

    end

    term.setTextColor(colors.white)

    term.write(" - "..text)

end


--------------------------------------------------
-- Affichage système
--------------------------------------------------

local function drawSystem()


    ui.begin(
        "DIAGNOSTIC SGC"
    )


    term.setCursorPos(3,2)

    print(
        "SYSTEME"
    )


    ui.line(4)



    term.setCursorPos(3,4)

    status(
        "Kernel charge",
        true
    )


    term.setCursorPos(3,5)

    status(
        "Bootstrap",
        true
    )


    term.setCursorPos(3,6)

    local modules =
        SGC.listLoaded()


    print(
        "Modules charges : "
        ..
        #modules
    )


end



--------------------------------------------------
-- Stargate
--------------------------------------------------

local function drawGate()


    term.setCursorPos(3,8)

    print(
        "STARGATE"
    )


    local info,err =
        gate.info()



    if not info then

        term.setCursorPos(3,9)

        status(
            err,
            false
        )

        return

    end



    term.setCursorPos(3,9)

    status(
        "Interface",
        true
    )



    term.setCursorPos(3,10)

    print(
        "Gen : "
        ..
        tostring(info.generation)
    )



    term.setCursorPos(3,11)

    print(
        "Var : "
        ..
        tostring(info.variant)
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



    term.setCursorPos(3,12)

    print(
        "Etat : "
        ..
        state
    )



    term.setCursorPos(3,13)

    print(
        "Vortex : "
        ..
        tostring(info.wormhole)
    )



    term.setCursorPos(3,14)

    print(
		"Iris : "
		..
		tostring(info.irisType)
	)


	term.setCursorPos(3,15)

	print(
		"Etat Iris : "
		..
		tostring(info.irisState)
	)


end



--------------------------------------------------
-- Energie
--------------------------------------------------
local function drawEnergy()


    local energy,err =
        gate.energy()



    term.setCursorPos(3,16)


    if not energy then

        print(
            "Energie : ERREUR"
        )

        return

    end



    print(
        "Energie : "
        ..
        energy.current
        ..
        "/"
        ..
        energy.capacity
    )


end



--------------------------------------------------
-- Base de données
--------------------------------------------------

local function drawDatabase()


    term.setCursorPos(3,23)

    print(
        "BASE DE DONNEES"
    )


    ui.line(24)



    local planets =
        db.list()



    term.setCursorPos(3,25)


    print(
        "Planetes : "
        ..
        #planets
    )


end



--------------------------------------------------
-- Rafraîchissement
--------------------------------------------------

local function refresh()


    term.setBackgroundColor(
        colors.black
    )

    term.clear()



    drawSystem()

    drawGate()

    drawEnergy()

   



    term.setCursorPos(
        3,
        18
    )


    term.setTextColor(
        colors.lightGray
    )


    print(
        "Q : Retour"
    )


    term.setTextColor(
        colors.white
    )

end



--------------------------------------------------
-- Application
--------------------------------------------------

function diagnostic.run()


    while true do


        refresh()



        local event,key =
            os.pullEvent("key")



        if key == keys.q then

            return

        end


    end


end



return diagnostic