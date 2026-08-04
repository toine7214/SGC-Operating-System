# Installation Guide

This guide explains how to install **SGC Operating System** on a ComputerCraft computer.

---

# Requirements

Before installing SGC OS, make sure you have:

- Minecraft **1.20.1**
- ComputerCraft: Tweaked
- SGJourney
- A Stargate Interface connected to the computer

---

# Installation

Copy the following files to the root of your ComputerCraft computer:

```
startup.lua
```

and the complete directory:

```
sgc/
```

Your computer should look like this:

```
/
├── startup.lua
└── sgc/
    ├── bootstrap.lua
    ├── sgc.lua
    ├── apps/
    ├── lib/
    └── data/
```

---

# Stargate Interface

Open:

```
sgc/lib/config.lua
```

and configure the Stargate Interface name if necessary.

Example:

```lua
config.devices = {
    interface = "basic_interface_0"
}
```

Use the ComputerCraft command:

```lua
peripheral.getNames()
```

to list all connected peripherals.

---

# First Boot

Restart the computer:

```lua
reboot
```

or press:

```
Ctrl + R
```

SGC OS should start automatically.

---

# Updating
Before updating, always back up the entire sgc/data directory.
When updating to a newer version:

1. Back up your `addresses.db` file.
2. Replace the SGC OS files with the new version.
3. Restore your `addresses.db` if necessary.

---

# Troubleshooting

## "Interface Stargate not found"

Verify the interface name in:

```
sgc/lib/config.lua
```

---

## Black screen

Check that:

- `startup.lua` is present.
- The `sgc` directory is complete.

---

## Missing addresses

Restore your backup of:

```
sgc/data/addresses.db
```

---

For more information, see the project README.