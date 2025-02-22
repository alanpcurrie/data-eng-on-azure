# Azure Data Engineering Infrastructure

Infrastructure as Code (IaC) repository for Azure Data Explorer (ADX) deployment using Bicep.

![Repository Structure](az-data-eng-repo.webp)

## Components

- Azure Data Explorer (ADX): Data exploration and analytics service

## Project Structure

- `common/`: Common tools and configurations
  - `config/`: Shared configurations
  - `tools/`: Shared development tools
- `packages/`: Infrastructure packages
  - `adx/`: Azure Data Explorer infrastructure
    - `bicep/`: Bicep templates
    - `parameters/`: Environment parameters
- `.gitignore`: Specifies files and directories to be ignored by Git.
- `.github/workflows/`: Contains GitHub Actions workflows.
  - `deploy-adx.yml`: Workflow for deploying the ADX cluster.
- `bicep/`: Contains Bicep templates and parameter files.
  - `main.bicep`: Main Bicep template for deploying the ADX cluster.
  - `modules/`: Contains Bicep modules.
    - `adx.bicep`: Bicep module for deploying the ADX cluster.
  - `parameters/`: Contains parameter files for different environments.
    - `prod.bicepparam`: Parameters for the production environment.

## Prerequisites

- Azure CLI installed and authenticated
- GitHub repository with the necessary secrets configured
- Azure subscription
- pnpm v10.4.1 or later (Install using `corepack enable && corepack prepare pnpm@10.4.1 --activate`)

## Development Setup

1. Install dependencies:
   ```bash
   pnpm install
   ```

2. Initialize git hooks:
   ```bash
   pnpm lefthook install
   ```

3. When committing changes, use:
   ```bash
   pnpm commit  # This will trigger both commitizen and changeset prompts
   ```

## Development Workflow

1. Make changes in a feature branch
2. Format and lint: `pnpm format && pnpm lint`
3. Commit changes: `pnpm commit`
4. If version change needed: `pnpm cs`
5. Create pull request

## Release Process

We use [changesets](https://github.com/changesets/changesets) to manage versions and changelogs. Here's how it works:

1. **Making Changes**
   When you make changes, create a changeset to document what changed:
   ```bash
   make prepare-release
   ```
   This will:
   - Run linting
   - Prompt you to describe your changes
   - Create a `.changeset/[name].md` file

2. **Changeset Format**
   Each changeset file looks like this:
   ```md
   ---
   "azure-data-eng": patch | minor | major
   ---

   Description of your changes here.
   - Added feature X
   - Fixed bug Y
   - Updated component Z
   ```

3. **Creating a Release**
   When you're ready to release:
   ```bash
   make create-release
   ```
   This will:
   - Convert changesets into CHANGELOG.md entries
   - Bump version numbers
   - Create a git tag
   - Create a GitHub release with notes

## Release Management

This project uses several tools to maintain a consistent and automated release process:

- **Commitizen**: Standardizes commit messages
- **Changesets**: Manages versioning
- **Lefthook**: Manages git hooks
- **Biome**: Maintains code quality and formatting
- **Azure Bicep CLI**: Validates Bicep templates

### Release Workflow

1. Make your changes in a feature branch
2. Use `pnpm commit` to:
   - Create a conventional commit with emoji
   - Add a changeset for version management
3. Create a pull request
4. After merge, maintainers run:
   ```bash
   pnpm version
   pnpm release
   ```

## Required Permissions

The service principal needs the following roles:
- Contributor on the target resource group

## Deployment Process

1. Ensure you have the necessary Azure credentials stored as GitHub secrets:
   - `AZURE_RESOURCE_GROUP`
   - `AZURE_SUBSCRIPTION_ID`
   - `AZURE_TENANT_ID`
   - `AZURE_CLIENT_ID`
2. Trigger the deployment workflow:
   - Push changes to the `main` branch.
   - Or manually trigger the workflow from the GitHub Actions tab, specifying the environment (`dev`, `test`, or `prod`).

## Troubleshooting

### Template Validation Failures

If template validation fails:
1. Verify your service principal has the required permissions
2. Check the tracking ID in the error message for Azure support
3. Review the inner errors for specific validation issues