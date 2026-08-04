--------------------------------------------------
-- SGC Operating System
-- Stargate Driver
-- Version : 0.2.1
--------------------------------------------------

local gate = {}

local VERSION = "0.2.1"

local config = SGC.load("lib.config")


--------------------------------------------------
-- Initialisation
--------------------------------------------------

local sg = nil

local rotationDirection = true
local dialing = false
local aborted = false

---------------------------------------------------------------
------ FONCTIONS INTERNES -------------------------------------
---------------------------------------------------------------
--------------------------------------------------
-- Recherche interface Stargate
--------------------------------------------------

local function initInterface()

    sg = peripheral.wrap(
        config.devices.interface
    )
    return sg ~= nil

end
--------------------------------------------------
-- Vérification interface
--------------------------------------------------

local function checkInterface()

    if not sg then

        initInterface()

    end


    if not sg then

        return false,
        "Interface Stargate introuvable"

    end


    return true

end
--------------------------------------------------
-- Appel sécurisé
--------------------------------------------------

local function safeCall(func,...)

    if type(func) ~= "function" then

        return false,
        "Fonction inexistante"

    end


    local ok,value =
        pcall(func,...)


    if not ok then

        return false,
        tostring(value)

    end


    return true,value

end



--------------------------------------------------
-- Vérification composition
--------------------------------------------------

local function canDial()

    local success,connected =
        safeCall(
            sg.isStargateConnected
        )


    if not success then

        return false,connected

    end


    if connected then

        return false,
        "La porte est deja connectee."

    end



    success,composing =
        safeCall(
            sg.isStargateDialingOut
        )


    if not success then

        return false,composing

    end


    if composing then

        return false,
        "Une composition est deja en cours."

    end


    return true

end

---------------------------------------------------------------
------ ETAT INTERNE -------------------------------------------
---------------------------------------------------------------
--------------------------------------------------
-- Reset état rotation
--------------------------------------------------

function gate.resetRotation()

    rotationDirection = true

end
--------------------------------------------------
-- Annulation composition
--------------------------------------------------

function gate.abort()

    aborted = true

    if sg then

        safeCall(
            sg.disconnectStargate
        )

    end

    dialing = false

    return true

end

--------------------------------------------------
-- Etat composition
--------------------------------------------------

function gate.isBusy()

    return dialing

end
---------------------------------------------------------------
------ ROTATION -----------------------------------------------
---------------------------------------------------------------

--------------------------------------------------
-- Rotation alternée
--------------------------------------------------

function gate.rotate(symbol)


    local ok,err =
        checkInterface()


    if not ok then

        return false,err

    end



    local success,message



    if rotationDirection then


        success,message =
            safeCall(
                sg.rotateClockwise,
                symbol
            )


    else


        success,message =
            safeCall(
                sg.rotateAntiClockwise,
                symbol
            )


    end



    if not success then

        return false,message

    end



    local timeout =
        config.timing.rotationTimeout
        or 10


    local timer = 0



    while true do

		local success,reached =
			safeCall(
				sg.isCurrentSymbol,
				symbol
			)


		if not success then

			return false,
			reached

		end


		if reached then

			break

		end



        sleep(
            config.timing.rotationWait
        )


        timer =
            timer +
            config.timing.rotationWait



        if timer >= timeout then

            return false,
            "Timeout rotation symbole "..symbol

        end


    end



    rotationDirection =
        not rotationDirection



    return true

end
--------------------------------------------------
-- Chevron
--------------------------------------------------

function gate.lockChevron(last)

    if aborted then

        return false,
        "Composition annulée."

    end


    local ok,err



    ok,err =
        safeCall(
            sg.openChevron
        )


    if not ok then

        return false,err

    end



    sleep(
        config.timing.chevronDelay
    )



    if not last then


        ok,err =
            safeCall(
                sg.encodeChevron
            )


        if not ok then

            return false,err

        end



        sleep(
            config.timing.chevronDelay
        )

    end



    ok,err =
        safeCall(
            sg.closeChevron
        )


    if not ok then

        return false,err

    end



    sleep(
        config.timing.chevronDelay
    )



    return true

end
---------------------------------------------------------------
------ COMPOSITION --------------------------------------------
---------------------------------------------------------------

--------------------------------------------------
-- Composition
--------------------------------------------------

function gate.connect(address,callback)


    local ok,err


    ok,err =
        checkInterface()


    if not ok then

        return false,err

    end



    ok,err =
        canDial()


    if not ok then

        return false,err

    end



    if type(address) ~= "table" then

    return false,
    "Adresse invalide."

	end


if #address == 0 then

    return false,
    "Adresse vide."

	end


	gate.resetRotation()
    dialing = true
	aborted = false


    for i,symbol in ipairs(address) do
	if aborted then

    dialing=false

	gate.resetRotation()

	return false,err
    "Composition annulée."

	end

    ok,err =
        gate.rotate(symbol)


    if not ok then

        dialing=false

		gate.resetRotation()

		return false,err

    end



    -- Mise à jour écran AVANT verrouillage

    if callback then

        callback(
            i,
            #address
        )

    end



    ok,err =
        gate.lockChevron(
            i == #address
        )


    if not ok then

        dialing=false

		gate.resetRotation()

		return false,err

    end


end



        
        


    



    dialing=false

gate.resetRotation()

return true


end









---------------------------------------------------------------
------ CONNEXION ----------------------------------------------
---------------------------------------------------------------

--------------------------------------------------
-- Déconnexion
--------------------------------------------------

function gate.disconnect()

    local ok,err =
        checkInterface()


    if not ok then

        return false,err

    end


    local success,message =
        safeCall(
            sg.disconnectStargate
        )


    if not success then

        return false,message

    end


    return true

end

--------------------------------------------------
-- Etat connexion
--------------------------------------------------
function gate.isConnected()

    local ok,err =
        checkInterface()


    if not ok then

        return false

    end



    local success,result =
        safeCall(
            sg.isStargateConnected
        )


    if not success then

        return false

    end



    return result

end

---------------------------------------------------------------
------ IRIS ---------------------------------------------------
---------------------------------------------------------------

--------------------------------------------------
-- Iris
--------------------------------------------------

function gate.openIris()

    local ok,err =
        checkInterface()

    if not ok then
        return false,err
    end


    return safeCall(
        sg.openIris
    )

end



function gate.closeIris()

    local ok,err =
        checkInterface()

    if not ok then
        return false,err
    end


    return safeCall(
        sg.closeIris
    )

end



function gate.stopIris()

    local ok,err =
        checkInterface()

    if not ok then
        return false,err
    end


    return safeCall(
        sg.stopIris
    )

end



function gate.getIris()

    local ok,err =
        checkInterface()

    if not ok then
        return nil,err
    end


    local success,result =
        safeCall(
            sg.getIris
        )


    if not success then
        return nil,result
    end


    return result

end
--------------------------------------------------
-- Progression Iris
--------------------------------------------------

function gate.getIrisProgress()


    local ok,err =
        checkInterface()


    if not ok then

        return nil,err

    end



    local success,value =
        safeCall(
            sg.getIrisProgressPercentage
        )


    if not success then

        return nil,value

    end


    return value


end
--------------------------------------------------
-- Etat Iris
--------------------------------------------------

function gate.irisStatus()

    local ok,err =
        checkInterface()

    if not ok then
        return nil,err
    end


    local success,progress =
        safeCall(
            sg.getIrisProgressPercentage
        )
--------------------------------------------------
-- Progression Iris (%)
-- Retourne un nombre entre 0 et 100
--------------------------------------------------	

    if not success then
        return nil,progress
    end


    return progress

end

---------------------------------------------------------------
------ INFORMATIONS -------------------------------------------
---------------------------------------------------------------

--------------------------------------------------
-- Informations
--------------------------------------------------

function gate.status()

    local ok,err =
        checkInterface()


    if not ok then

        return nil,err

    end


    local status = {}


    local success,result


    success,result =
        safeCall(
            sg.isStargateConnected
        )

    status.connected =
        success and result or false



    success,result =
        safeCall(
            sg.isStargateDialingOut
        )

    status.dialing =
        success and result or false



    success,result =
        safeCall(
            sg.isWormholeOpen
        )

    status.wormhole =
        success and result or false



    success,result =
        safeCall(
            sg.getChevronsEngaged
        )

    status.chevrons =
        success and result or 0



    success,result =
        safeCall(
            sg.getCurrentSymbol
        )

    status.symbol =
        success and result or nil



    return status

end

function gate.feedback()

    local ok,err =
        checkInterface()


    if not ok then

        return nil,err

    end


    local success,result =
        safeCall(
            sg.getRecentFeedback
        )


    if not success then

        return nil,result

    end


    return result

end

function gate.energy()

    local ok,err =
        checkInterface()


    if not ok then

        return nil,err

    end



    local success,current =
        safeCall(
            sg.getStargateEnergy
        )


    if not success then

        return nil,current

    end



    success,capacity =
        safeCall(
            sg.getEnergyCapacity
        )


    if not success then

        return nil,capacity

    end



    return {

        current =
            current,

        capacity =
            capacity

    }

end

--------------------------------------------------
-- Déconnexion
--------------------------------------------------

function gate.disconnect()

    local ok,err =
        checkInterface()

    if not ok then
        return false,err
    end

    return safeCall(
        sg.disconnectStargate
    )

end
--------------------------------------------------
-- Pourcentage énergie
--------------------------------------------------

function gate.energyPercent()

    local energy =
        gate.energy()


    if not energy then

        return 0

    end


    if not energy.capacity
    or energy.capacity <= 0 then

        return 0

    end


    local percent =
        energy.current /
        energy.capacity *
        100


    return math.floor(
        math.max(
            0,
            math.min(
                100,
                percent
            )
        )
    )

end

function gate.getGeneration()

    local ok,err =
        checkInterface()


    if not ok then

        return nil,err

    end



    local success,value =
        safeCall(
            sg.getStargateGeneration
        )


    if not success then

        return nil,value

    end


    return value

end

function gate.getVariant()

    local ok,err =
        checkInterface()


    if not ok then

        return nil,err

    end



    local success,value =
        safeCall(
            sg.getStargateVariant
        )


    if not success then

        return nil,value

    end


    return value

end



function gate.getPointOfOrigin()

    local ok,err =
        checkInterface()


    if not ok then

        return nil,err

    end



    local success,value =
        safeCall(
            sg.getPointOfOrigin
        )


    if not success then

        return nil,value

    end


    return value

end

--------------------------------------------------
-- Informations complètes
--------------------------------------------------

function gate.info()


    local energy,energyError =
        gate.energy()


    local status,statusError =
        gate.status()



    local generation,generationError =
        gate.getGeneration()


    local variant,variantError =
        gate.getVariant()


    local origin,originError =
        gate.getPointOfOrigin()


    local iris,irisError =
        gate.getIris()

	local irisProgress =
    gate.getIrisProgress()


	local irisState =
    "INCONNU"


		if irisProgress then

		if irisProgress >= 100 then

        irisState =
            "FERME"

		elseif irisProgress <= 0 then

        irisState =
            "OUVERT"

		else

        irisState =
            "MOUVEMENT"

		end

	end

    return {


        generation =
            generation,


        variant =
            variant,


        origin =
            origin,



        energy =
            energy and energy.current or 0,


        capacity =
            energy and energy.capacity or 0,



        connected =
            status and status.connected or false,


        dialing =
            status and status.dialing or false,


        wormhole =
            status and status.wormhole or false,

		irisType =
			iris,
		
		irisProgress = 
			irisProgress,
			
		irisState =
			irisState,
		
		chevrons =
            status and status.chevrons or 0,


        symbol =
            status and status.symbol or nil,



        irisProgress =
    gate.getIrisProgress(),



        errors = {


            energy =
                energyError,


            status =
                statusError,


            generation =
                generationError,


            variant =
                variantError,


            origin =
                originError,


            iris =
                irisError

        }


    }


end


---------------------------------------------------------------
------ UTILITAIRES --------------------------------------------
---------------------------------------------------------------

--------------------------------------------------
-- Symboles
--------------------------------------------------

function gate.symbols()

    local ok,err =
        checkInterface()


    if not ok then

        return nil,err

    end



    local success,result =
        safeCall(
            sg.getSymbols
        )


    if not success then

        return nil,result

    end


    return result

end



function gate.rotation()

    local ok,err =
        checkInterface()


    if not ok then

        return nil,err

    end



    local success,symbol =
        safeCall(
            sg.getCurrentSymbol
        )


    if not success then

        symbol = nil

    end



    success,degrees =
        safeCall(
            sg.getRotationDegrees
        )


    if not success then

        degrees = 0

    end



    return {

        symbol = symbol,

        degrees = degrees

    }

end

--------------------------------------------------
-- Etat général
--------------------------------------------------

function gate.state()

    return {

        busy =
            dialing,

        aborted =
            aborted,

        connected =
            gate.isConnected()

    }

end
--------------------------------------------------
-- Version Driver
--------------------------------------------------

function gate.version()

    return VERSION

end
return gate




















