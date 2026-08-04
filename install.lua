--------------------------------------------------
-- SGC Operating System
-- Installer
-- Version : 0.2.4
--------------------------------------------------


--------------------------------------------------
-- Configuration
--------------------------------------------------

local VERSION = "0.2.4"

local REPOSITORY =
"https://raw.githubusercontent.com/toine7214/SGC-Operating-System/main/"



--------------------------------------------------
-- Affichage
--------------------------------------------------

local function writeStatus(status,text)

    if status == "OK" then

        term.setTextColor(colors.lime)

    elseif status == "ERROR" then

        term.setTextColor(colors.red)

    elseif status == "INFO" then

        term.setTextColor(colors.cyan)

    else

        term.setTextColor(colors.white)

    end


    write("["..status.."] ")

    term.setTextColor(colors.white)

    print(text)

end



--------------------------------------------------
-- Interface
--------------------------------------------------

local function clearLine(y)

    term.setCursorPos(1,y)

    term.write(
        string.rep(" ",50)
    )

end



local function writeValue(x,y,width,text)

    term.setCursorPos(x,y)

    term.write(
        string.rep(" ",width)
    )

    term.setCursorPos(x,y)

    term.write(text)

end



local function header()

    term.clear()

    term.setCursorPos(1,1)

    print("==========================================")
    print("        SGC Operating System")
    print("              Installer")
    print("               v"..VERSION)
    print("==========================================")
    print()

    print("Repository")
    print(REPOSITORY)

end



local function drawLayout()

    header()


    print()

    print("Status :")

    print()

    print("Progress :")

    print()

    print("Current file :")

    print()

    print("Result :")

end



local function updateStatus(text)

    writeValue(
        10,
        8,
        40,
        text
    )

end



local function updateProgress(current,total)


    local width = 25


    local percent =
        math.floor(
            current / total * 100
        )


    local filled =
        math.floor(
            width * percent / 100
        )


    local bar =
        string.rep(
            "█",
            filled
        )
        ..
        string.rep(
            "░",
            width-filled
        )


    writeValue(
        1,
        10,
        45,
        "["..
        bar..
        "] "
        ..
        percent
        ..
        "%"
    )


    writeValue(
        1,
        11,
        40,
        current..
        "/"
        ..
        total
        ..
        " files"
    )

end



local function updateFile(file)

    writeValue(
        1,
        13,
        55,
        file
    )

end



local function updateResult(text)

    writeValue(
        1,
        16,
        50,
        text
    )

end



--------------------------------------------------
-- Structure système
--------------------------------------------------

local directories = {

    "sgc",
    "sgc/apps",
    "sgc/data",
    "sgc/lib"

}



--------------------------------------------------
-- Fichiers à télécharger
--------------------------------------------------

local files = {

    "startup.lua",

    "sgc/bootstrap.lua",
    "sgc/sgc.lua",


    "sgc/apps/addressbook.lua",
    "sgc/apps/diagnostic.lua",
    "sgc/apps/dialer.lua",
    "sgc/apps/iris.lua",
    "sgc/apps/menu.lua",
    "sgc/apps/settings.lua",


    "sgc/data/addresses.db",


    "sgc/lib/config.lua",
    "sgc/lib/database.lua",
    "sgc/lib/event.lua",
    "sgc/lib/gate.lua",
    "sgc/lib/logger.lua",
    "sgc/lib/ui.lua"

}



--------------------------------------------------
-- Vérification installation
--------------------------------------------------

local function checkInstallation()


    if fs.exists("sgc/sgc.lua") then

        writeStatus(
            "INFO",
            "Existing SGC installation detected"
        )

    else

        writeStatus(
            "INFO",
            "New installation"
        )

    end

end



--------------------------------------------------
-- Création dossiers
--------------------------------------------------

local function createDirectories()


    updateStatus(
        "Creating directories..."
    )


    for _,dir in ipairs(directories) do


        if fs.exists(dir) then

            writeStatus(
                "OK",
                dir
            )


        else

            fs.makeDir(dir)


            if fs.exists(dir) then

                writeStatus(
                    "OK",
                    dir
                )

            else

                error(
                    "Cannot create "
                    ..
                    dir
                )

            end

        end

    end

end



--------------------------------------------------
-- Téléchargement
--------------------------------------------------

local function download(file,index,total)


    updateProgress(
        index,
        total
    )


    updateFile(file)


    local url =
        REPOSITORY
        ..
        file



    local success =
        shell.run(
            "wget",
            url,
            file
        )



    if success then

        updateResult(
            "OK"
        )


    else

        updateResult(
            "FAILED"
        )


        error(
            "Download failed : "
            ..
            file
        )

    end

end



--------------------------------------------------
-- Création fichiers système
--------------------------------------------------

local function createSystemFiles()


    updateStatus(
        "Creating system data..."
    )


    if not fs.exists(
        "sgc/data/version.db"
    ) then


        local file =
            fs.open(
                "sgc/data/version.db",
                "w"
            )


        file.write(
            VERSION
        )

        file.close()


    end



    if not fs.exists(
        "sgc/data/install.db"
    ) then


        local file =
            fs.open(
                "sgc/data/install.db",
                "w"
            )


        file.write(
            "INSTALLED\n"
        )


        file.write(
            "VERSION="
            ..
            VERSION
            ..
            "\n"
        )


        file.close()

    end



    writeStatus(
        "OK",
        "System data created"
    )


end



--------------------------------------------------
-- Installation
--------------------------------------------------

local function install()


    updateStatus(
        "Downloading files..."
    )


    for i,file in ipairs(files) do


        download(
            file,
            i,
            #files
        )

    end



    createSystemFiles()



    updateStatus(
        "Installation complete"
    )


    updateResult(
        "SUCCESS"
    )


end



--------------------------------------------------
-- Programme principal
--------------------------------------------------

drawLayout()


checkInstallation()


createDirectories()


install()



print()

writeStatus(
    "OK",
    "SGC OS v"..VERSION.." installed"
)


print()

print(
    "Restart computer to launch SGC."
)
