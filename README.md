# PixeLAW App template
## Documents
For additional step-by-step explanations on how to build and deploy your own PixeLAW app follow along [PixeLAW book](https://pixelaw.github.io/book/getting-started/quick-start.html)!


## Prerequisites
### Dojo
PixeLAW is built on top of Dojo. Refer to this [page](https://book.dojoengine.org/getting-started/quick-start) to get it installed.

## Getting started
### Clone this repository
#### Via GitHub
Use this template to create a new repository or clone this repository locally.

## Run this code
### Run the tests made for this app
````console
sozo test
````

### Local Development
#### Run [Pixelaw/core](https://github.com/pixelaw/core)
We are using [devcontainer](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-containers) environments. Please open this code with vscode and launch the container with devcontainer.

This is the easiest way to get PixeLAW core up and running in http://localhost:3000. We recommend you to use incognito mode to browse.


---
### Check the status
If you succesfully start up PixeLAW core, it will take a while for all the core contracts to get deployed
and start running. Wait until http://localhost:3000/manifests/core stops returning NOT FOUND. To check if you can
start deploying your app, use the following script (this will print out "Ready for app deployment" when the core
contracts have finished initialization):

````console
scarb run ready_for_deployment
````

After which you can start deploying your app onto your local PixeLAW via:

---
### Build and Deploy your contracts locally
#### Building
````console
sozo build
````

#### Deploying your contracts
This will deploy your app to the local PixeLAW using sozo migrate.
````console
sozo migrate apply --name pixelaw
````

#### Initializing your contracts
This will grant writer permission to your app for any custom models made.
````console
scarb run initialize
````

#### Uploading your manifest
````console
scarb run upload_manifest
````

---
### Deploying to Demo
Deploying to demo is almost the same as local development. The only difference is needing
the RPC_URL of the Demo environment, the DEMO_URL (NOTE: this must end in a slash i.e. '/')
of the Demo App to upload your manifest to, and the world name. Both URLs and world name can be provided by us. 
Please reach out through discord. Currently, sozo checks first if an environment variable was set in Scarb.toml for 
rpc-url. So, comment that out before beginning with the following steps.

#### Build your contracts
````console
sozo build
````

#### Deploy your contracts
This will deploy your app to the local PixeLAW using sozo migrate.
````console
sozo migrate apply --name <replace-this-with-provided-world-name> --rpc-url <replace-this-with-provided-rpc-url>
````

#### Initializing your contracts
This will grant writer permission to your app for any custom models made.
````console
scarb run initialize <replace-this-with-provided-rpc-url>
````

#### Uploading your manifest
````console
scarb run upload_manifest <replace-this-with-provided-demo-url>
````


### FAQs
#### error when deploying to rpc-url

Please check the `[[tool.dojo.env]]` in your `Sarb.toml`. You have to modify it correctly.

Also, please verify `account_address` and `private_key`.

For dojo problems, please check the version is correct.
