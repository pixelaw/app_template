# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a **PixeLAW App Template** - a blockchain-based game development template built on the Starknet blockchain using the Dojo Framework. It creates interoperable pixel-based applications within the PixeLAW ecosystem.

**Core Technologies:**
- **Cairo** (v2.9.4) - Smart contract programming language for Starknet
- **Dojo Framework** (v1.5.1) - ECS (Entity Component System) framework for blockchain games
- **Starknet** - Layer 2 blockchain platform
- **Scarb** (v2.9.4) - Package manager and build tool for Cairo

## Common Development Commands

### Building and Testing
```bash
# Build the project
sozo build

# Run tests
sozo test

# Build for Sepolia testnet
./scripts/build_sepolia.sh

# Deploy to local development environment
sozo migrate

# Deploy to Sepolia testnet
./scripts/deploy_sepolia.sh
```

### Development Environment
```bash
# Start local blockchain (Katana)
katana --dev

# Start indexing service (Torii)
torii --world <world_address>

# View logs in DevContainer
klog    # Katana logs
tlog    # Torii logs
slog    # Server logs
```

### Account Management
```bash
# Create keystore from private key (for testnet deployment)
./scripts/account_from_key.sh
```

## Architecture Overview

### ECS Architecture
The project uses Dojo's Entity Component System (ECS) pattern:
- **Entities**: Represent game objects (pixels, players)
- **Components**: Data structures (ClickGame model, Pixel model)
- **Systems**: Logic that operates on components (myapp_actions)

### Core Integration
- **PixeLAW Core**: Provides shared functionality via `pixelaw::core::actions`
- **Interoperability**: Apps can interact with pixels managed by other apps
- **Namespace Separation**: `pixelaw` namespace for core, `myapp` namespace for app-specific logic

### Smart Contract Structure
- **src/app.cairo**: Main application logic with ClickGame model and actions
- **src/lib.cairo**: Library entry point
- **src/constants.cairo**: App configuration (APP_KEY, APP_ICON)
- **src/tests.cairo**: Integration tests

### Key Models and Systems
- **ClickGame Model**: Tracks last player interaction per pixel position
- **myapp_actions System**: Handles pixel interaction logic
- **Core Actions Integration**: Uses PixeLAW core for pixel updates

## Development Workflow

### Local Development
1. Use VSCode DevContainer (recommended) - all tools pre-installed
2. Environment automatically starts Katana, Torii, and PixeLAW server
3. Use built-in Katana accounts for testing

### Testing
- Integration tests use mock world storage
- Tests deploy both core and app contracts
- Use `pixelaw_testing` helpers for setup
- Example test in `src/tests.cairo` demonstrates full interaction flow

### Deployment Environments
- **Development**: Local Katana instance (`dojo_dev.toml`)
- **Release**: Production configuration (`dojo_release.toml`)
- **Sepolia**: Testnet deployment (`dojo_sepolia.toml`)

## Code Conventions

### Cairo Development
- Use snake_case for variables and functions
- Use PascalCase for types and structs
- Follow Dojo's ECS patterns for components and systems
- Implement proper error handling with assertions
- Use Starknet-specific types (felt252, ContractAddress)

### Contract Naming
- Actions contracts: `{APP_KEY}_actions` (e.g., `myapp_actions`)
- Models: Follow Dojo naming conventions
- Namespaces: Use app-specific namespace for custom logic

### Testing Guidelines
- Write integration tests for full user workflows
- Use `setup_core()` helper for test environment
- Test both successful and failure scenarios
- Verify pixel state changes after interactions

## Dependency Management

### Core Dependencies
- **pixelaw**: PixeLAW core contracts (currently using local path)
- **dojo**: Dojo framework for ECS functionality
- **dojo_cairo_test**: Testing utilities
- **pixelaw_testing**: PixeLAW-specific test helpers

### Version Upgrades
1. Update version numbers in `Scarb.toml`
2. Delete `/target/` folder and `Scarb.lock`
3. Run `sozo build` to rebuild
4. Fix any compilation issues
5. Run `sozo test` to verify tests pass
6. Deploy updates using `sozo migrate --profile sepolia`

## Configuration Files

- **Scarb.toml**: Main package configuration and dependencies
- **dojo_dev.toml**: Local development environment settings
- **dojo_sepolia.toml**: Sepolia testnet deployment configuration
- **.devcontainer/devcontainer.json**: VSCode DevContainer setup

## Important Notes

- The app integrates with PixeLAW core for pixel manipulation
- Multiple apps can interact with the same pixel world
- Use proper namespace management to avoid conflicts
- Always test locally before deploying to testnet
- Follow ECS patterns for clean separation of concerns