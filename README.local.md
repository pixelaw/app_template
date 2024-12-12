# Install Local Environment


## Prerequisites

- [asdf](https://asdf-vm.com/)
- [scarb](https://docs.swmansion.com/scarb/)
- [dojo](https://github.com/dojoengine/dojo)

## Install asdf

Follow the asdf installation instructions.

### Install dojo

```
asdf plugin add dojo https://github.com/dojoengine/asdf-dojo
asdf install dojo 1.0.6
```

### Install scarb

```
asdf plugin add scarb
asdf install scarb 2.8.4
```


### Running Locally

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
torii --world 0x2bf4d3aa0dced89d37d8c3b4ff6a05895c0af32ff3baf9b02abf8504e53eaad --http.cors_origins "*"
```

### How to deploy

you can deploy your app to our katana testnet by running the following commands:

```bash
# Deploy the pixelaw app
sozo build -P release
sozo migrate apply -P release
```
