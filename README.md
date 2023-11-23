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
sozo init <replace-with-project-file-path> pixelaw/app_template
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
There are multiple ways to have a local copy of PixeLAW core for development:

##### Using Docker Compose (Recommended)
This is the easiest way to get PixeLAW core up and running in http://localhost:3000. There is a docker-compose file in this repository specifically for running a local image
of PixeLAW core. 

###### Prerequisites
1. [Docker](https://docs.docker.com/engine/install/)
2. [Docker Compose plugin](https://docs.docker.com/compose/install/)

Running the following command will run core in a container.
````console
docker compose up -d
````

##### Using Docker
Another way to go about it is by using the Docker engine by itself. 

######
1. [Docker](https://docs.docker.com/engine/install/)

The following script will create the docker network for the container to run in:
````console
docker network create --driver bridge pixelaw
````
And this will run the actual container in http://localhost:3000:
````console
docker run -d --name pixelaw-core -p 5050:5050 -p 3000:3000 -p 8080:8080 -p 50051 --restart unless-stopped --network pixelaw oostvoort/pixelaw-core:v0.0.6
````

##### Manually
This will take the most time. This entails cloning the PixeLAW core repos and running each individual component
manually. Refer to the [GitHub repository](https://github.com/pixelaw/core) for how to run it.

---
Whichever way you've chosen to start up PixeLAW core, it will take a while for all the core contracts to get deployed
and start running. Wait until http://localhost:3000/manifests/core stops returning NOT FOUND. To check if you can
start deploying your app, use the following script (this will print out "Ready for app deployment" when the core
contracts have finished initialization):

````console
scarb run ready_for_deployment
````

After which you can start deploying your app onto your local PixeLAW via:

#### Building your contracts
````console
sozo build
````

#### Deploying your contracts
This will deploy your app to the local PixeLAW using sozo migrate.
````console
sozo migrate --name pixelaw
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