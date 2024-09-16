<picture>
<source media="(prefers-color-scheme: dark)" srcset="https://avatars.githubusercontent.com/u/140254228?s=200&v=4">  
<img alt="Dojo logo" align="right" width="100" src="https://avatars.githubusercontent.com/u/140254228?s=200&v=4">
</picture>

<a href="https://twitter.com/0xpixelaw">
<img src="https://img.shields.io/twitter/follow/0xpixelaw?style=social"/>
</a>
<a href="https://github.com/pixelaw/core">
<img src="https://img.shields.io/github/stars/pixelaw/core?style=social"/>
</a>

[![discord](https://img.shields.io/badge/join-pixelaw-green?logo=discord&logoColor=white)](https://discord.gg/PwDa2mKhR4)

# PixeLAW App Template

Contracts written in Cairo using Dojo to showcase a Pixel World with app interoperability. Its interoperability is made possible with core actions. Apps are any other contracts that are deployed to the Pixel World.

## Prerequisites

- [asdf](https://asdf-vm.com/)
- [scarb](https://docs.swmansion.com/scarb/)
- [dojo](https://github.com/dojoengine/dojo)

## Install asdf

Follow the asdf installation instructions.

## Install dojo

```
asdf plugin add dojo https://github.com/dojoengine/asdf-dojo
asdf install dojo 1.0.0-alpha.11
```

## Install scarb

```
asdf plugin add scarb
asdf install scarb 2.7.0
```

And after moving into contracts directory, the versions for these libs are set in the .tool-versions file.

## Running Locally

#### Terminal one (Make sure this is running)

```bash
# Run Katana
katana --disable-fee --allowed-origins "*"
```

#### Terminal two

```bash
# Build the example
sozo build

# Migrate the example
sozo migrate apply

# Initialize the pixelaw app
scarb run init_auth

# Start Torii
torii --world 0x263ae44e5414519a5c5a135cccaf3d9d7ee196d37e8de47a178da91f3de9b34 --allowed-origins "*"
```
