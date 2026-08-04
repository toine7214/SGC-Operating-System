--------------------------------------------------
-- SGC Operating System
-- Kernel
-- Version 0.2.1
--------------------------------------------------

local kernel = {}

--------------------------------------------------
-- Initialisation
--------------------------------------------------

function kernel.run()


    --------------------------------------------------
    -- Chargement des modules systeme
    --------------------------------------------------

    local SGC = _G.SGC


    local config =
        SGC.load("lib.config")


    local ui =
        SGC.load("lib.ui")


    local logger =
        SGC.load("lib.logger")


    local menu =
        SGC.load("apps.menu")


    local gate =
        SGC.load("lib.gate")



    --------------------------------------------------
    -- Demarrage
    --------------------------------------------------

    logger.init()

    logger.info(
        "SGC OS demarre"
    )


    local info,err =
    gate.info()


if info then

    logger.info(
        "Driver Stargate charge"
    )

else

    logger.info(
        "Driver Stargate indisponible : "
        ..
        tostring(err)
    )

end



    --------------------------------------------------
    -- Applications
    --------------------------------------------------

    local apps = {


        [1] =
        "apps.dialer",


        [2] =
        "apps.addressbook",


        [3] =
        "apps.diagnostic",


        [4] =
        "apps.iris",


        [5] =
        "apps.settings"


    }



    --------------------------------------------------
    -- Boucle principale
    --------------------------------------------------

    while true do


        local choix =
            menu.run()



        --------------------------------------------------
        -- Quitter
        --------------------------------------------------

        if choix == 0 then


            logger.info(
                "Arret du systeme"
            )


            ui.clear()


            term.setCursorPos(
                1,
                1
            )


            print(
                "Fermeture du SGC OS..."
            )


            sleep(1)


            break


        end



        --------------------------------------------------
        -- Chargement application
        --------------------------------------------------

        local module =
            apps[choix]



        if module then



            local ok, app =
                pcall(
                    function()

                        return SGC.load(module)

                    end
                )



            if not ok then


                logger.error(app)


                ui.begin(
                    "ERREUR"
                )


                print()

               print(
    tostring(app)
)


                sleep(3)



            else



                if type(app.run)
                    ~= "function"
                then


                    logger.error(
                        module
                        ..
                      " -- ne possede pas run()"
                    )


                    ui.begin(
                        "ERREUR"
                    )


                    print()

                    print(
                        module
                        ..
                        " invalide"
                    )


                    sleep(3)



                else



                    local success, err =
                        pcall(
                            app.run
                        )



                    if not success then


                        logger.error(err)


                        ui.begin(
                            "ERREUR"
                        )


                        print()

                        print(
    tostring(err)
)


                        sleep(3)


                    end


                end


            end


        end


    end


end



--------------------------------------------------
-- Retour module
--------------------------------------------------

return kernel