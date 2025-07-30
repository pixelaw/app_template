# PixeLAW App Deployment Optimization Recommendations

Based on analysis of the current PixeLAW deployment flow, this document outlines key optimizations to enable more permissionless app deployment to the PixeLAW world.

## Current Deployment Bottlenecks

### 1. Manual Configuration Dependencies
- Apps must manually configure `world_address` in `dojo_sepolia.toml`
- Requires knowing specific core deployment addresses
- Manual keystore management and account setup

### 2. Permission Management Complexity  
- Apps need explicit write permissions in core's `dojo_sepolia.toml` 
- Core contracts control which apps can write to which models
- Requires coordination with core maintainers for permission updates

### 3. Initialization Dependencies
- Apps must call `core_actions.new_app()` during `dojo_init()`
- Registration happens post-deployment, creating deployment-registration gap
- Manual namespace registration required

## Optimization Recommendations

### 1. Auto-Discovery Deployment
```bash
# Create a registry-aware deployment script
./scripts/deploy_to_world.sh --world-address <auto-detect> --app-key <unique-key>
```
**Benefits:**
- Auto-detect existing world address from chain
- Eliminate manual `dojo_sepolia.toml` world_address configuration
- Use chain queries to discover core contract addresses

### 2. Permissionless Permission System
```cairo
// In core actions - implement permission-by-registration
fn register_app_with_permissions(app_key: felt252, required_models: Array<felt252>) {
    // Automatically grant write permissions for registered apps
    // to standard models (Pixel, QueueItem, etc.)
}
```
**Benefits:**
- Apps self-declare required model permissions during registration
- Core automatically grants standard permissions (Pixel updates, Queue operations)
- Remove need for core maintainers to manually update writer permissions

### 3. Deployment-Time Registration
```bash
# Enhanced deployment script
sozo migrate --profile sepolia --post-deploy-hook register_app
```
**Benefits:**
- Combine deployment and registration into single atomic operation
- Auto-call `new_app()` immediately after contract deployment
- Reduce deployment-to-registration gap

### 4. App Registry Smart Contract
```cairo
#[starknet::contract]
mod AppRegistry {
    // Permissionless app registration
    fn register_app(app_key: felt252, contract_address: ContractAddress) {
        // Validate app_key uniqueness
        // Auto-grant standard permissions
        // Emit registration event
    }
}
```
**Benefits:**
- Centralized app discovery mechanism
- Apps register themselves without core team intervention
- Event-driven frontend updates for new apps

### 5. Template Standardization
```bash
# One-command deployment
pixelaw create-app --name myapp --deploy-to sepolia
```
**Benefits:**
- Standardized CLI tool for app creation and deployment
- Pre-configured templates with optimal settings
- Automated APP_KEY uniqueness checking

### 6. Gas-Optimized Deployment
**Optimizations:**
- Batch app registration with initial pixel operations
- Use CREATE2-style deterministic addresses for apps
- Implement app proxy pattern for upgradeable deployments

### 7. Developer Experience Improvements
```json
// pixelaw.config.json
{
  "app_key": "maze",
  "target_world": "sepolia-main",
  "auto_permissions": ["Pixel", "QueueItem"],
  "init_pixels": [{"x": 0, "y": 0, "color": "blue"}]
}
```
**Benefits:**
- Configuration-driven deployment
- Auto-populate deployment parameters
- Built-in testing against live worlds

## Implementation Priority

### Phase 1 (High Impact, Low Effort)
- **Auto-discovery deployment scripts**
  - Create enhanced deployment scripts that auto-detect world addresses
  - Update template with configuration-free deployment options
- **Standardized deployment templates**  
  - Improve existing scripts with better error handling and automation
  - Add validation for APP_KEY uniqueness
- **Documentation improvements**
  - Create step-by-step deployment guides
  - Add troubleshooting sections for common deployment issues

### Phase 2 (Medium Effort)
- **Permissionless permission system in core**
  - Modify core contracts to support self-service permission granting
  - Implement standard permission sets for common app patterns
- **App registry smart contract**
  - Deploy centralized registry for app discovery
  - Add event emission for frontend integration
- **CLI tooling improvements**
  - Create `pixelaw` CLI tool for streamlined app development
  - Add commands for deployment, testing, and management

### Phase 3 (High Effort)
- **Gas optimization patterns**
  - Research and implement gas-efficient deployment strategies
  - Add batching capabilities for multiple operations
- **Proxy-based upgradeable apps**
  - Design upgradeable app architecture
  - Implement migration patterns for app updates
- **Advanced developer tooling**
  - Build IDE extensions and development environments
  - Create testing frameworks specific to PixeLAW apps

## Expected Impact

These optimizations would transform the PixeLAW app deployment process from:

**Current State:**
1. Manual world address configuration
2. Coordinate with core team for permissions
3. Deploy contracts separately
4. Manually register app post-deployment
5. Hope everything works together

**Optimized State:**
1. Run single deployment command
2. Automatic world discovery and registration
3. Self-service permission granting
4. Atomic deployment and registration
5. Built-in validation and error handling

This would significantly reduce friction for developers wanting to deploy new apps to the PixeLAW world, moving from a manually-coordinated process to a truly permissionless system where apps can self-register and deploy with minimal configuration.

## Next Steps

1. **Immediate (Week 1-2):**
   - Enhance existing deployment scripts with auto-discovery
   - Add better error handling and validation
   - Create deployment troubleshooting guide

2. **Short-term (Month 1):**
   - Design permissionless permission system
   - Prototype app registry contract
   - Begin CLI tool development

3. **Medium-term (Quarter 1):**
   - Implement and test new permission system
   - Deploy app registry to testnet
   - Release initial CLI tooling

4. **Long-term (Quarter 2+):**
   - Implement gas optimizations
   - Design upgradeable app patterns
   - Build advanced developer tooling

This roadmap provides a clear path toward making PixeLAW app deployment truly permissionless while maintaining security and reliability.


justfile that installs all the boilerplate configs from a seperate repo.
base repo - includes all configs / boilerplaye (This should probably be in the devcontaienr)
app template - inlcudes all app/game specific code + justfile + dev specific (i.e. private keys)
ideally this works for any machine (i.e. using devcointainer/docker)