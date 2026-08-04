--------------------------------------------------
-- SGC Operating System
-- Configuration centrale
-- Version : 0.2.1
--------------------------------------------------

local config = {}

--------------------------------------------------
-- Informations système
--------------------------------------------------

config.system = {
    name = "SGC Operating System",
    version = "0.2.1",
    author = "toine7214 & ChatGPT"
}

--------------------------------------------------
-- Périphériques
--------------------------------------------------

config.devices = {

    -- Interface Stargate
    interface = "basic_interface_0",

    -- Moniteur Externe (nil = recherche automatique plus tard)
    monitor = nil, --Moniteur Principal

    -- Modem (nil = recherche automatique plus tard)
    modem = nil

}

--------------------------------------------------
-- Couleurs
--------------------------------------------------

config.colors = {

    background = colors.black,
    foreground = colors.white,

    titleBackground = colors.blue,
    titleForeground = colors.white,

    menuSelectedBackground = colors.gray,
    menuSelectedForeground = colors.black,

    success = colors.lime,
    warning = colors.orange,
    error = colors.red,

    border = colors.lightGray

}

--------------------------------------------------
-- Chemins des fichiers
--------------------------------------------------

config.paths = {

    addresses = "sgc/data/addresses.db",
    history = "sgc/data/history.log",
    settings = "sgc/data/settings.cfg"

}

--------------------------------------------------
-- Délais d'animation
--------------------------------------------------

config.timing = {

    rotationWait = 0.05,
    chevronDelay = 0.15,
    screenRefresh = 0.05,
	rotationTimeout = 10
}

--------------------------------------------------
-- Divers
--------------------------------------------------
function config.getVersion()

    return config.system.name ..
           " v" ..
           config.system.version

end
--------------------------------------------------
-- Options
--------------------------------------------------

config.options = {

    debug = true

}
--------------------------------------------------
-- Extensions futures
--------------------------------------------------

config.future = {

}
return config