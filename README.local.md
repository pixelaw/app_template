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
asdf install dojo 1.0.1
```

### Install scarb

```
asdf plugin add scarb
asdf install scarb 2.7.0
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
torii --world 0x6f130c8e150882e39cbe878c650c8f35c86579180dbc77d0c1cbe169449b5f6 --http.cors_origins "*"
```

### How to deploy

you can deploy your app to our katana testnet by running the following commands:

```bash
# Deploy the pixelaw app
sozo build -P release
sozo migrate apply -P release
```
