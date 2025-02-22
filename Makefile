.PHONY: help login deploy-prod deploy-dev lint clean validate changeset version release setup-changesets

# Variables
RG ?= your-resource-group
LOCATION ?= eastus2
ENV ?= dev

help: ## Show this help
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

login: ## Login to Azure
	az login

validate: ## Validate Bicep templates
	az bicep build --file bicep/main.bicep
	az deployment group validate \
		--resource-group $(RG) \
		--template-file bicep/main.bicep \
		--parameters bicep/parameters/$(ENV).bicepparam

deploy-prod: ## Deploy to production
	az deployment group create \
		--resource-group $(RG) \
		--template-file bicep/main.bicep \
		--parameters bicep/parameters/prod.bicepparam

deploy-dev: ## Deploy to development
	az deployment group create \
		--resource-group $(RG) \
		--template-file bicep/main.bicep \
		--parameters bicep/parameters/dev.bicepparam

lint: ## Lint Bicep files
	az bicep lint bicep/main.bicep
	az bicep lint bicep/modules/*.bicep

purview-roles: ## Assign Purview roles to the current user
	az role assignment create \
		--role "Purview Data Curator" \
		--assignee-principal-type User \
		--assignee-object-id $$(az ad signed-in-user show --query id -o tsv) \
		--scope "/subscriptions/$$(az account show --query id -o tsv)/resourceGroups/$(RG)"

clean: ## Clean up Bicep artifacts
	find . -name "*.json" -type f -delete
	find . -name "*.lock" -type f -delete

list-adx: ## List ADX clusters
	az kusto cluster list \
		--resource-group $(RG) \
		--output table

list-purview: ## List Purview accounts
	az purview account list \
		--resource-group $(RG) \
		--output table

changeset: ## Create a new changeset
	npx changeset

version: ## Apply changesets to update versions
	npx changeset version

release: ## Create a release
	npx changeset tag

setup-changesets: ## Initialize changesets
	npm install
	npx changeset init
