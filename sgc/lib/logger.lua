

--------------------------------------------------
-- SGC Operating System
-- Logger
-- Version : 0.2.1
--------------------------------------------------

local logger = {}

local config = SGC.load("lib.config")
local event = SGC.load("lib.event")

--------------------------------------------------
-- Initialisation
--------------------------------------------------

function logger.init()

    event.subscribe("log", function(data)

        logger.event(
            data.level,
            data.type,
            data.values
        )

    end)

end

--------------------------------------------------
-- Horodatage
--------------------------------------------------

local function timestamp()

    if os.date then
        return os.date("%Y-%m-%d %H:%M:%S")
    end

    return tostring(os.epoch("utc"))

end

--------------------------------------------------
-- Ecriture
--------------------------------------------------

local function write(level, message)

    local line = string.format(
        "[%s] [%s] %s",
        timestamp(),
        level,
        message
    )

    local dir = fs.getDir(config.paths.history)

	if dir ~= "" and not fs.exists(dir) then
		fs.makeDir(dir)
	end

    local file =
    fs.open(
        config.paths.history,
        "a"
    )


	if file then

		file.writeLine(line)

		file.close()

	end

    if config.options.debug then
        print(line)
    end

end

--------------------------------------------------
-- Fonctions publiques
--------------------------------------------------

function logger.info(message)
    write("INFO", message)
end

function logger.warning(message)
    write("WARNING", message)
end

function logger.error(message)
    write("ERROR", message)
end

function logger.debug(message)
    if config.options.debug then
        write("DEBUG", message)
    end
end

--------------------------------------------------
-- Lecture complète du journal
--------------------------------------------------

function logger.read()

    local lines = {}

    if not fs.exists(config.paths.history) then
        return lines
    end

    local file = fs.open(config.paths.history,"r")

		if not file then return lines
		end
    while true do

        local line = file.readLine()

        if not line then
            break
        end

        table.insert(lines, line)

    end

    file.close()

    return lines

end

--------------------------------------------------
-- Effacement du journal
--------------------------------------------------

function logger.clear()

   local file = fs.open(config.paths.history,"w")

		if file then file.close()
	end

end

--------------------------------------------------
-- Evènement structuré
--------------------------------------------------

function logger.event(level, eventType, data)

    local parts = {}

    if data then

        for key, value in pairs(data) do

            table.insert(
                parts,
                tostring(key) .. "=" .. tostring(value)
            )

        end

        table.sort(parts)

    end

    local message =
        "[" .. eventType .. "] "

    if #parts > 0 then
        message = message .. table.concat(parts, " ")
    end

    write(level, message)

end

return logger
