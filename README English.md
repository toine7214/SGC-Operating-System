   _____  _____   _____    ___   _____
  / ____|/ ____| / ____|  / _ \ / ____|
 | (___ | |  __ | |      | | | | (___
  \___ \| | |_ || |      | | | |\___ \
  ____) | |__| || |____  | |_| |____) |
 |_____/ \_____(_)_____|  \___/|_____/

         Stargate Operating System
		v0.2.1

> A modular Stargate operating system for ComputerCraft.

SGC Operating System (SGC OS) is a modular operating system designed for **ComputerCraft: Tweaked** and **SGJourney**.

It provides a complete graphical interface to control a Stargate directly from a ComputerCraft computer.

Current version: **v0.2.1 Stable**

---

## Features

### Dialer

- Stargate dialing
- Dialing animation
- Live dialing progress
- Dial cancellation
- Stargate disconnection

### Address Book

- Browse saved destinations
- Add new addresses
- Remove addresses
- Dial directly from the address book

### Iris Control

- Open iris
- Close iris
- Stop iris movement
- Real-time iris status

### Diagnostics

Complete Stargate information:

- Generation
- Variant
- Point of Origin
- Available energy
- Connection status
- Iris status

### Settings

System information:

- SGC OS version
- Stargate interface
- Hardware information

---

## Project Structure

```
startup.lua

sgc/
├── bootstrap.lua
├── sgc.lua
├── apps/
├── lib/
└── data/
```

The system is fully modular.

Applications load libraries using:

```lua
SGC.load("lib.gate")
```

---

## Compatibility

Designed for:

- ComputerCraft: Tweaked
- SGJourney

Tested on:

- Minecraft 1.20.1

---

## Installation

Copy:

```
startup.lua
```

and the entire:

```
sgc/
```

directory to the root of your ComputerCraft computer.

Restart the computer.

SGC OS will start automatically.

---

## Roadmap

### Version 0.3

Planned features:

- Address editing
- Connection history
- Persistent configuration
- Automatic peripheral detection
- External monitor support
- Improved user interface

---

## Development

Created by:

**toine7214**

Developed with the assistance of **ChatGPT (OpenAI)**.

---

## License

Released under the MIT License.

See **LICENSE** for details.