<picture>
<source media="(prefers-color-scheme: dark)" srcset="https://avatars.githubusercontent.com/u/140254228?s=200&v=4">  
<img alt="Dojo logo" align="right" width="100" src="https://avatars.githubusercontent.com/u/140254228?s=200&v=4">
</picture>

<a href="https://x.com/0xpixelaw">
<img src="https://img.shields.io/twitter/follow/0xpixelaw?style=social"/>
</a>
<a href="https://github.com/pixelaw/core">
<img src="https://img.shields.io/github/stars/pixelaw/core?style=social"/>
</a>

[![discord](https://img.shields.io/badge/join-PixeLAW-green?logo=discord&logoColor=white)](https://t.co/jKDjNbFdZ5)

# PixeLAW App Template

Contracts written in Cairo using Dojo to showcase a Pixel World with app interoperability. Its interoperability is made possible with core actions. Apps are any other contracts that are deployed to the Pixel World.

## Getting started
The easiest way is to use the VSCode DevContainer, all tools will be installed already. Keep reading for this approach. You can also install all tools in your local environment, see [Local Environment](README.local.md).
This README is all about using the Devcontainer (recommended)

## 1. Devcontainer
Open this folder in VSCode, and build/run the devcontainer.
You will see a series of commands executed in the terminal, which you can close when done. After that you have a fully configured environment with Katana, Torii and the Pixelaw server running. Use `klog`, `tlog` and `slog` to see the logs for each. 


## 2. Accounts
When doing local development, you'll use the build-in Katana accounts which have been preconfigured.

When ready to deploy to Sepolia testnet, you'll have to create and fund an account, and install the keystore file in your project.
You can use the `scripts/account_from_key.sh` for this.

## 3. Build/Deployment
All normal Dojo tooling is available, see the    [Dojo Documentation](https://book.dojoengine.org/toolchain/sozo)

### 3.1 Build
This will compile the Cairo contracts in `/src` 
```
sozo build
```

### 3.2 Deployment
Deploy (migrate) the contracts  
```
sozo migrate
```

## 4. Maintenance
The idea is that you'll copy this template and create your own PixeLAW app with it. So eventually the versions of Core, Dojo may get outdated.

### 4.1 Upgrade Dojo
To upgrade Dojo, you have to upgrade Pixelaw Core (see below)

### 4.2 Upgrade Core
The easiest is to do a full-text search/replace on the Core version number (for example `0.5.17`) and replace it with the new version. Then it's easiest to 
1. Delete the `/target/` folder
1. Delete the `Scarb.lock` file
1. Full Rebuild using `sozo build`
1. Fix any compile issues
1. Run (integration) tests with `sozo test`
1. Fix any test issues
1. If applicable: Upgrade your live code using `sozo migrate --profile sepolia` 