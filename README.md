# PixeLAW App template
This is a heavily WIP attempt to allow creation of PixeLAW apps without managing the main "game" repo.

# Prerequisites
## Dojo
PixeLAW is built on top of Dojo. Refer to this [page](https://book.dojoengine.org/getting-started/quick-start.html) to
get it installed.

# Getting started
## Clone this repository
### Via Sozo
Run sozo init. This will initialize the project by cloning the repo.
````console
sozo init <replace-with-project-file-path> pixelaw/app-template
````

### Via GitHub
Use this template to create a new repository or clone this repository locally.

## Run this code
### Run the tests made for this app
````console
sozo test
````

### Local Development
#### Run [Pixelaw/core](https://github.com/pixelaw/core)
There is a docker-compose file in this repository specifically for running a local image
of PixeLAW core. Running the following command will run core in a container.
````console
docker compose up -d
````
It takes a while for all the contracts to get deployed and initialized once it does start running.
Once it has finished initializing and deploying all the core contracts, you can now deploy your app onto your local PixeLAW. 
This can be done via:

##### Building your contracts
````console
sozo build
````

##### Deploying your contracts
This will deploy your app to the local PixeLAW using sozo migrate.
````console
sozo migrate --name pixelaw
````

##### Initializing your contracts
This will grant writer permission to your app for any custom models made.
````console
scarb run initialize
````

##### Uploading your manifest
````console
scarb run upload_manifest
````

### Deploying to Demo
Deploying to demo is almost the same as local development. The only difference is needing
the RPC_URL of the Demo environment as well as the DEMO_URL (NOTE: this must end in a slash i.e. '/')
of the Demo App to upload your manifest to. Both URLs can be provided by us. Please reach out through discord.

#### Build your contracts
````console
sozo build
````

#### Deploy your contracts
This will deploy your app to the local PixeLAW using sozo migrate.
````console
sozo migrate --name pixelaw --rpc-url <replace-this-with-provided-rpc-url>
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

# Current issues
The following is a current unresolved issue in Dojo.
- `test myapp::tests::tests::test_myapp_actions ... fail (gas usage est.: 1044740)
  failures:
  myapp::tests::tests::test_myapp_actions - panicked with [6445855526543742234424738320591137923774065490617582916 ('CLASS_HASH_NOT_DECLARED'), 23583600924385842957889778338389964899652 ('ENTRYPOINT_FAILED'), 23583600924385842957889778338389964899652 ('ENTRYPOINT_FAILED'), ]`