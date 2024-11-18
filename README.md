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

## Prerequisites

- [asdf](https://asdf-vm.com/)
- [scarb](https://docs.swmansion.com/scarb/)
- [dojo](https://github.com/dojoengine/dojo)

## Install asdf

Follow the asdf installation instructions.

## Install dojo

```
asdf plugin add dojo https://github.com/dojoengine/asdf-dojo
asdf install dojo 1.0.1
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
katana --dev --dev.no-fee --http.cors_origins "*"
```

#### Terminal two

```bash
# Build the example
sozo build

# Migrate the example
sozo migrate

# Initialize the pixelaw app
scarb run init_auth

# Start Torii
torii --world 0x6f130c8e150882e39cbe878c650c8f35c86579180dbc77d0c1cbe169449b5f6 --http.cors_origins "*"
```

### How to deploy

you can deploy your app to our katana testnet by running the following commands:

```bash
# Deploy the pixelaw app
sozo build -P release
sozo migrate apply -P release
```


## Troubleshooting

If you want to use latest dojo version, you need to clone core by yourself and modify the path in `Scarb.toml` file.

1. Clone core repo
```bash
git clone https://github.com/pixelaw/core
```

2. Modify the path in `Scarb.toml` file
```Scarb.toml
pixelaw = { path = "../pixelaw/core/contracts" }
```

3. Modify version in `Scarb.toml` file in core repo
```Scarb.toml
dojo = { git = "https://github.com/dojoengine/dojo", tag = "v1.0.1-alpha.11" }
```

4. Build and run core
```bash
cd contracts
sozo build
sozo migrate apply
```