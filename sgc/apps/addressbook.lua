--------------------------------------------------
-- SGC Operating System
-- Carnet d'adresses
-- Version : 0.2.1
--------------------------------------------------

local ui = SGC.load("lib.ui")
local db = SGC.load("lib.database")
local gate = SGC.load("lib.gate")

local addressbook = {}

--------------------------------------------------
-- Données
--------------------------------------------------

local planets = {}

--------------------------------------------------
-- Fenêtres
--------------------------------------------------

local listWindow
local detailWindow
local list

--------------------------------------------------
-- Chargement
--------------------------------------------------

local function loadPlanets()

    planets = db.list()

    list:setItems(planets)

    if #planets > 0 then
        list:setSelected(1)
    else
        list.selected = 0
    end

end

--------------------------------------------------
-- Création des fenêtres
--------------------------------------------------

local function createWindows()

    local w,h = term.getSize()

    listWindow = ui.window(
        2,
        3,
        17,
        h-4
    )

    detailWindow = ui.window(
        22,
        3,
        w-22,
        h-4
    )

    list = ui.ListView(listWindow)

end

--------------------------------------------------
-- Cadre
--------------------------------------------------

local function drawFrame()

    ui.begin("CARNET D'ADRESSES")

    local w,h = term.getSize()

    for y=2,h-1 do

        term.setCursorPos(20,y)

        term.write("|")

    end

    term.setCursorPos(1,h-1)

    term.write(string.rep("-",w))

    ui.footer(
        "up/down Nav Enter Dial A Back Q Add Suppr Del"
    )

end

--------------------------------------------------
-- Détails
--------------------------------------------------

local function drawDetails()

    ui.clearWindow(detailWindow)

    local planet = list:getItem()

    if not planet then

        ui.label(detailWindow,1,1,"Aucune planete.")

        return

    end

    local address = db.get(planet)

    ui.label(detailWindow,1,1,"Nom")

    ui.value(detailWindow,1,2,planet)

    ui.separator(detailWindow,4)

    ui.label(detailWindow,1,5,"Adresse")
	if not address then

    ui.label(
        detailWindow,
        1,
        5,
        "Adresse inexistante"
    )

    return

end
    local y = 7

    for i,symbol in ipairs(address) do

        ui.value(
            detailWindow,
            3,
            y,
            string.format(
                "Chevron %d : %02d",
                i,
                symbol
            )
        )

        y = y + 1

    end

end

--------------------------------------------------
-- Rafraîchissement
--------------------------------------------------

local function refresh()

    list:draw()

    drawDetails()

end

--------------------------------------------------
-- Composition
--------------------------------------------------

local function dialSelected()

    local planet = list:getItem()

    if not planet then
        return
    end

    local address = db.get(planet)

    ui.begin("COMPOSITION")

    print()

    print("Destination : "..planet)

    print()

    local ok,err =
    gate.connect(
        address,

        function(current,total)

            term.setCursorPos(1,8)

            term.clearLine()

            print(
                "Chevron "
                ..
                current
                ..
                "/"
                ..
                total
            )

        end
    )

if ok then

    term.setCursorPos(1,10)
    term.clearLine()

    print("Connexion etablie.")

else

    term.setCursorPos(1,10)
    term.clearLine()

    print(
    tostring(err)
)

end

    print()

    print("Appuie sur une touche...")

    os.pullEvent("key")

    drawFrame()

    refresh()

end
--------------------------------------------------
-- Ajout destination
--------------------------------------------------

local function addDestination()

    ui.begin("AJOUT DESTINATION")


    term.setCursorPos(3,5)
    write("Nom : ")

    local name =
        read()


    term.setCursorPos(3,7)
    write("Adresse : ")

    local raw =
        read()


    local address = {}


    for value in string.gmatch(raw,"[^,]+") do

        table.insert(
            address,
            tonumber(value)
        )

    end


    local ok,err =
        db.add(
            name,
            address
        )


    if ok then

        ui.message(
            "AJOUT",
            "Destination ajoutee."
        )

    else

        ui.message(
            "ERREUR",
            tostring(err)
        )

    end


end
--------------------------------------------------
-- Suppression destination
--------------------------------------------------

local function deleteDestination()

    local planet =
        list:getItem()


    if not planet then

        ui.message(
            "SUPPRESSION",
            "Aucune destination selectionnee."
        )

        return

    end


    ui.begin(
        "SUPPRESSION"
    )


    term.setCursorPos(3,5)

    print(
        "Supprimer : "
        ..planet
        .." ?"
    )


    term.setCursorPos(3,7)

    print(
        "[Y] Oui     [N] Non"
    )


    while true do


        local _,key =
            os.pullEvent("key")


        if key == keys.y then


            local ok =
                db.remove(
                    planet
                )


            if ok then

                ui.message(
                    "SUPPRESSION",
                    "Destination supprimee."
                )

            else

                ui.message(
                    "ERREUR",
                    "Suppression impossible."
                )

            end


            return


        elseif key == keys.n then

            return

        end

    end

end
--------------------------------------------------
-- Programme principal
--------------------------------------------------

function addressbook.run()

    createWindows()

    drawFrame()

    loadPlanets()

    refresh()

    while true do

        local _,key = os.pullEvent("key")

        if key == keys.q then

            return

        elseif key == keys.up then

            if list:moveUp() then
                refresh()
            end

        elseif key == keys.down then

            if list:moveDown() then
                refresh()
            end

        elseif key == keys.enter then

            dialSelected()

        elseif key == keys.a then

			addDestination()

			loadPlanets()

			drawFrame()

			refresh()

        elseif key == keys.e then

            ui.message(
                "MODIFICATION",
                "Fonction à venir."
            )

            drawFrame()

            refresh()

        elseif key == keys.delete then

			deleteDestination()

			loadPlanets()

			drawFrame()

			refresh()

		end

    end

end

return addressbook