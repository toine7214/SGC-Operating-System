--------------------------------------------------
-- SGC Operating System
-- Dialer
-- Version : 0.2.1
--------------------------------------------------

local ui = SGC.load("lib.ui")
local db = SGC.load("lib.database")
local gate = SGC.load("lib.gate")


local dialer = {}

local planets = {}

local listWindow
local list


--------------------------------------------------
-- Création interface
--------------------------------------------------

local function createUI()

    local w,h = term.getSize()

    listWindow = ui.window(
        3,
        3,
        w-6,
        h-5
    )

    list = ui.ListView(listWindow)

end


--------------------------------------------------
-- Chargement adresses
--------------------------------------------------

local function loadAddresses()

    planets = db.list()

    list:setItems(planets)


    if #planets > 0 then

        list:setSelected(1)

    end

end


--------------------------------------------------
-- Rafraîchissement
--------------------------------------------------

local function refresh()

    list:draw()

end

--------------------------------------------------
-- Affichage progression composition
--------------------------------------------------

local function drawDialProgress(
    planet,
    current,
    total
)

    ui.begin("COMPOSITION")


    term.setCursorPos(3,4)

    print(
        "Destination : "..planet
    )


    term.setCursorPos(3,6)

    print(
        "Chevron : "
        ..current..
        " / "
        ..total
    )


    local percent =
        math.floor(
            current / total * 100
        )


    ui.progress(
        3,
        8,
        25,
        percent
    )



    local status =
        gate.status()



    if status then


        term.setCursorPos(3,10)

        print(
            "Symbole : "
            ..tostring(
                status.symbol
            )
        )


        term.setCursorPos(3,11)

        print(
            "Chevrons actifs : "
            ..tostring(
                status.chevrons
            )
        )


    end


end
--------------------------------------------------
-- Rafraîchissement composition
--------------------------------------------------

local function updateComposition(
    planet,
    current,
    total
)

    ui.dialerScreen(planet)

    ui.drawGateRing(current)

    ui.updateChevron(current,total)

    



local energy =
    gate.energy()


local percent = 0


if energy
and energy.capacity
and energy.capacity > 0 then

    percent =
        math.floor(
            energy.current /
            energy.capacity *
            100
        )

end



    ui.updateEnergy(percent)


    local status =
        gate.status()



    if status and status.connected then

    ui.updateDialState("CONNECTE")



else

    ui.updateDialState("COMPOSITION")

end


end

--------------------------------------------------
-- Composition
--------------------------------------------------

local function compose()


    local planet =
        list:getItem()


    if not planet then

        return

    end



    local address =
        db.get(planet)



    local finished = false

    local result = false

    local errorMessage



    parallel.waitForAny(


        function()

            local ok,err =
                gate.connect(

                    address,

                    function(current,total)

                        updateComposition(
                            planet,
                            current,
                            total
                        )

                    end

                )


            result = ok

            errorMessage = err

            finished = true


        end,



        function()


            while not finished do


                local event,key =
                    os.pullEvent()


                if event=="key"
                and key==keys.q then


                    gate.abort()


                    errorMessage =
                        "Composition annulee."


                    break


                end


            end


        end


    )



    if result then
	ui.dialerScreen(planet)
	ui.drawGateRing(#address)
    local energy = gate.energy()

local percent = 0

if energy and energy.capacity > 0 then

    percent =
        math.floor(
            energy.current /
            energy.capacity *
            100
        )

end

ui.updateEnergy(percent)

ui.updateChevron(#address,#address)

ui.updateDialState("CONNECTE")

ui.updateFooter("Q : Deconnecter")

    while true do

        local _,key = os.pullEvent("key")

        if key == keys.q then

            gate.disconnect()
            break

        end

    end

else

    ui.begin("ERREUR")

    term.setCursorPos(4,6)

    print(
        tostring(errorMessage)
    )

    os.pullEvent("key")

end
end

--------------------------------------------------
-- Programme principal
--------------------------------------------------

function dialer.run()


    createUI()

    loadAddresses()


    ui.begin("COMPOSEUR")

    refresh()



    while true do


        local _,key =
            os.pullEvent("key")



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


            compose()


            ui.begin("COMPOSEUR")

            refresh()


        end


    end


end


return dialer