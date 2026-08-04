--------------------------------------------------
-- SGC Operating System
-- Iris Control
-- Version : 0.2.1
--------------------------------------------------

local ui = SGC.load("lib.ui")
local gate = SGC.load("lib.gate")

local iris = {}


--------------------------------------------------
-- Affichage
--------------------------------------------------

local function drawScreen()

    ui.begin("CONTROLE IRIS")


    term.setCursorPos(1,3)
    term.write("Etat Iris :")


    term.setCursorPos(1,7)
    term.write("[O] Ouvrir")


    term.setCursorPos(1,8)
    term.write("[F] Fermer")


    term.setCursorPos(1,9)
    term.write("[S] Stop")


    term.setCursorPos(1,10)
    term.write("[Q] Retour")

end
local function refreshStatus()

    local progress =
    gate.getIrisProgress()


    term.setCursorPos(1,5)

    term.clearLine()


    if progress == 100 then

        print("FERME")


    elseif progress == 0 then

        print("OUVERT")


    else

        print(
            "MOUVEMENT : "
            ..
            progress
            ..
            "%"
        )

    end

end

--------------------------------------------------
-- Application
--------------------------------------------------

function iris.run()


    while true do

		drawScreen()
		refreshStatus()


        local timer =
            os.startTimer(1)


        local event,key =
            os.pullEvent()


        if event == "timer" then

    refreshStatus()


        elseif event == "key" then


            if key == keys.q then

                return


            elseif key == keys.o then


                local ok,err =
                    gate.openIris()


                if not ok then

                    ui.message(
                        "ERREUR IRIS",
                        tostring(err)
                    )

                end


            elseif key == keys.f then


                local ok,err =
                    gate.closeIris()


                if not ok then

                    ui.message(
                        "ERREUR IRIS",
                        tostring(err)
                    )

                end


            elseif key == keys.s then

                gate.stopIris()

            end


        end


    end

end


return iris
