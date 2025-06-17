<thinking>The user wants a highly detailed, step-by-step plan based on the provided technical specification, project rules, and core application intent.

I need to break down the entire project into granular tasks, ensuring no detail from the spec is missed. The output must follow the specified markdown format precisely.

Key constraints and guidelines:
-   High granularity.
-   Retain all details from the spec.
-   Multiple passes to ensure completeness.
-   Specific markdown format for each step.
-   Max 15 files per step (justify if more).
-   Mix backend/frontend if logical.
-   Start with setup/critical config.
-   Make steps contained/buildable where possible.
-   Mark dependencies.
-   Wrap thought process in `<thinking>` tags.
-   Adhere to Next.js rules for the frontend.
-   Emphasize PHIPA/Canadian data residency throughout.

Plan:
1.  **Initial Setup & Infrastructure:** Start with the foundational elements - monorepo, basic GCP setup in Canada, core services (DB, Storage, Messaging), CI/CD, IaC.
2.  **Core Identity & Access:** Implement Auth0/Okta integration and the User Management service/UI, as this underpins security.
3.  **Core Data & Services:** Implement the main data entities (Patient, Documentation) and their basic CRUD APIs and UIs.
4.  **Cross-cutting Concerns (Early):** Integrate Audit Logging and initial RBAC enforcement as soon as data is handled.
5.  **Feature Implementation (Iterative):** Build out features based on dependencies and logical flow:
    *   Voice-to-Text (builds on Documentation, needs GCS, Speech-to-Text, Pub/Sub).
    *   Templates (builds on Documentation, needs Template Service/UI).
    *   Messaging (separate service, needs WebSockets, FCM).
    *   Offline Mode (mobile-specific, needs local storage, sync logic, backend sync processor, conflict handling).
    *   Conflict Resolution Dashboard (builds on Offline Mode conflict handling, needs UI).
    *   Reporting (builds on Documentation data, needs Reporting Service/UI).
    *   Data Export (builds on data access, needs Export Service, Pub/Sub, GCS, UI).
    *   EHR Foundation (separate services MDM/Consent, needs FHIR API layer).
6.  **Refinement & Hardening:** Address remaining non-functional requirements - comprehensive error handling, monitoring, security hardening, data retention, performance tuning, accessibility review.

Throughout the process, I will ensure:
-   Each step is atomic enough to be reasonably implemented and tested.
-   File lists are concise and relevant.
-   Dependencies are clearly stated.
-   User instructions guide verification.
-   PHIPA/Canadian residency is mentioned in relevant infrastructure and data handling steps.
-   Next.js rules are applied to frontend steps (App Router, RSC preference, `'use client'` usage, `nuqs`).

Let's begin with the setup steps. I will create sections for logical groupings of steps.<thinking>Starting with the foundational setup steps. This includes the monorepo, basic GCP project setup focusing on Canadian regions, core infrastructure services like Cloud SQL (PostgreSQL), Redis, GCS, Pub/Sub, and Apigee. Also, setting up the CI/CD pipeline foundation and IaC. Finally, configuring Auth0/Okta as the identity provider is critical early on.

**Section 1: Foundational Setup & Infrastructure**

*   Step 1: Monorepo Setup
*   Step 2: Basic GCP Project & VPC Setup (Canadian Region)
*   Step 3: CI/CD Pipeline (Basic Build/Test)
*   Step 4: IaC Foundation (Terraform/Pulumi)
*   Step 5: Cloud SQL (PostgreSQL) Setup (Canadian Region, HA, CMEK)
*   Step 6: Redis (Memorystore) Setup (Canadian Region, HA)
*   Step 7: GCS Buckets Setup (Canadian Region, Encryption, Bucket Lock)
*   Step 8: Pub/Sub Topics Setup (Canadian Region)
*   Step 9: Apigee API Gateway Setup (Initial Proxy, Auth0 Integration Point)
*   Step 10: Auth0/Okta Setup (Tenant, Application, Users, Roles, MFA Policy)

This covers the initial infrastructure and identity provider setup as requested by the guidelines (start with setup and critical config). These steps are highly dependent on each other. I will detail each one now.## 1. Foundational Setup & Infrastructure

- [X] Step 1: Initialize Monorepo Structure
  - **Task**: Set up the monorepo using a tool like pnpm workspaces or Lerna. Create the root `package.json` and the initial directory structure as defined in the Project Structure section of the tech spec (`/packages/backend`, `/packages/frontend`, `/packages/mobile`, `/packages/infrastructure`). Add basic README files to each package directory. Configure the monorepo tool.
  - **Files**:
    - `package.json`: Configure monorepo workspaces.
    - `pnpm-workspace.yaml` (or `lerna.json`): Monorepo tool configuration.
    - `.gitignore`: Standard ignore file for Node.js, React, Flutter, GCP.
    - `README.md`: Root project README.
    - `packages/backend/README.md`: Backend README.
    - `packages/frontend/README.md`: Frontend README.
    - `packages/mobile/README.md`: Mobile README.
    - `packages/infrastructure/README.md`: Infrastructure README.
  - **Step Dependencies**: None
  - **User Instructions**: Run the monorepo tool's install command (e.g., `pnpm install`) to verify the setup. The basic directory structure should be created.

- [X] Step 2: Setup Basic GCP Project and VPC Network in Canada
  - **Task**: Create a new Google Cloud Platform project. Configure billing. Set up a Virtual Private Cloud (VPC) network with subnets exclusively within designated Canadian regions (e.g., `northamerica-east1`). Define initial firewall rules to allow necessary internal communication (e.g., within subnets) and restricted external access. This step lays the groundwork for data residency compliance.
  - **Files**:
    - `packages/infrastructure/gcp/main.tf` (or equivalent Pulumi file): Define GCP provider, project, VPC, subnets, and basic firewall rules using IaC.
    - `packages/infrastructure/gcp/variables.tf`: Define variables for project ID, region, network names, etc.
  - **Step Dependencies**: Step 1 (Monorepo setup to place IaC files).
  - **User Instructions**: Ensure you have the `gcloud` CLI and Terraform/Pulumi installed and authenticated. Apply the IaC configuration (`terraform apply` or `pulumi up`). Verify the VPC network and subnets are created in the specified Canadian region(s) via the GCP Console.

- [X] Step 3: Configure Foundational CI/CD Pipeline
  - **Task**: Set up a basic CI/CD pipeline using Cloud Build or GitHub Actions. Configure triggers for commits to the repository. The initial pipeline should perform basic checks: code checkout, dependency installation for all packages, running linters/formatters (placeholders for now), and running placeholder build scripts for each package (`npm build` or equivalent in each package's `package.json`). This establishes the automated build process.
  - **Files**:
    - `.github/workflows/build.yml` (or `cloudbuild.yaml`): Define the CI/CD pipeline steps.
    - `packages/backend/package.json`: Add a placeholder build script.
    - `packages/frontend/package.json`: Add a placeholder build script.
    - `packages/mobile/pubspec.yaml`: Ensure Flutter build command is standard.
  - **Step Dependencies**: Step 1 (Monorepo structure).
  - **User Instructions**: Push a test commit to the repository. Verify that the CI/CD pipeline triggers and completes successfully, running the defined steps for all packages.

- [ ] Step 4: Establish Infrastructure as Code (IaC) Foundation
  - **Task**: Formalize the IaC structure within the monorepo (`packages/infrastructure/gcp`). Define modules for reusable infrastructure components (e.g., network, databases, GKE cluster - placeholders for now). Set up environment-specific configurations (dev, staging, prod) using separate directories or variable files. Configure a remote backend for Terraform state (e.g., GCS bucket in Canada) or Pulumi state backend. This ensures infrastructure is versioned and managed programmatically, crucial for compliance and consistency.
  - **Files**:
    - `packages/infrastructure/gcp/main.tf`: Update to include backend configuration and module calls (placeholders).
    - `packages/infrastructure/gcp/environments/dev/terraform.tfvars`: Environment-specific variables.
    - `packages/infrastructure/gcp/modules/network/main.tf`: Placeholder network module.
    - `packages/infrastructure/gcp/modules/cloudsql/main.tf`: Placeholder Cloud SQL module.
    - `packages/infrastructure/gcp/modules/gke/main.tf`: Placeholder GKE module.
  - **Step Dependencies**: Step 2 (Basic GCP setup).
  - **User Instructions**: Initialize the IaC backend (`terraform init` or `pulumi login`). Apply the (still basic) configuration for the 'dev' environment (`terraform apply -var-file=environments/dev/terraform.tfvars` or `pulumi up --stack dev`). Verify state is stored remotely.

- [ ] Step 5: Set up Cloud SQL (PostgreSQL) Instance
  - **Task**: Provision a Google Cloud SQL for PostgreSQL instance in a Canadian region (`northamerica-east1`). Configure High Availability (HA) for resilience. Enable Customer-Managed Encryption Keys (CMEK) for encryption at rest, linking it to a key in Cloud Key Management Service (KMS) in the same region. Configure automated backups and Point-in-Time Recovery (PITR). Set up private IP for secure access within the VPC. This is the primary database for PHI.
  - **Files**:
    - `packages/infrastructure/gcp/modules/cloudsql/main.tf`: Define the Cloud SQL instance, HA, CMEK, backups, PITR, private IP.
    - `packages/infrastructure/gcp/environments/dev/terraform.tfvars`: Add Cloud SQL specific variables (machine type, storage).
    - `packages/infrastructure/gcp/main.tf`: Call the cloudsql module.
  - **Step Dependencies**: Step 4 (IaC foundation), Step 2 (VPC network).
  - **User Instructions**: Update and apply the IaC configuration (`terraform apply` or `pulumi up`). Verify the Cloud SQL instance is created in the correct region, has HA enabled, CMEK configured, and a private IP address via the GCP Console. Note the instance connection name and private IP.

- [ ] Step 6: Set up Redis (Memorystore) Instance
  - **Task**: Provision a Google Cloud Memorystore for Redis instance in the same Canadian region (`northamerica-east1`). Configure the Standard tier for High Availability. Connect it to the VPC network using private IP. This instance will be used for caching and rate limiting.
  - **Files**:
    - `packages/infrastructure/gcp/modules/redis/main.tf`: Define the Memorystore instance, Standard tier, private IP.
    - `packages/infrastructure/gcp/environments/dev/terraform.tfvars`: Add Redis specific variables (size).
    - `packages/infrastructure/gcp/main.tf`: Call the redis module.
  - **Step Dependencies**: Step 4 (IaC foundation), Step 2 (VPC network).
  - **User Instructions**: Update and apply the IaC configuration. Verify the Redis instance is created in the correct region, is Standard tier, and has a private IP via the GCP Console. Note the private IP address.

- [ ] Step 7: Set up Google Cloud Storage (GCS) Buckets
  - **Task**: Create three GCS buckets in the Canadian region (`northamerica-east1`): one for temporary audio uploads/processing, one for long-term archived audio/exports, and one for IaC state (if using Terraform backend). Configure default encryption (CMEK optional but recommended for consistency). Enable Bucket Lock on the archive/exports bucket for WORM compliance. Configure Lifecycle Management policies (placeholders for now) for tiered storage and retention on the archive bucket.
  - **Files**:
    - `packages/infrastructure/gcp/modules/gcs/main.tf`: Define GCS buckets, region, encryption, Bucket Lock, Lifecycle policies (placeholders).
    - `packages/infrastructure/gcp/environments/dev/terraform.tfvars`: Add GCS bucket names.
    - `packages/infrastructure/gcp/main.tf`: Call the gcs module.
  - **Step Dependencies**: Step 4 (IaC foundation).
  - **User Instructions**: Update and apply the IaC configuration. Verify the buckets are created in the correct region, have encryption enabled, and Bucket Lock is configured on the archive/exports bucket via the GCP Console.

- [ ] Step 8: Set up Google Cloud Pub/Sub Topics
  - **Task**: Create the necessary Pub/Sub topics in the Canadian region (`northamerica-east1`) for asynchronous communication: `audit.events`, `voice.recordings`, `offline.sync`, `data.exports`, `queue.speech-to-text`, `event.export.completed`, `event.export.failed`. These topics decouple services and enable asynchronous processing.
  - **Files**:
    - `packages/infrastructure/gcp/modules/pubsub/main.tf`: Define Pub/Sub topics and subscriptions (subscriptions will be added later with consumers).
    - `packages/infrastructure/gcp/environments/dev/terraform.tfvars`: Add topic names.
    - `packages/infrastructure/gcp/main.tf`: Call the pubsub module.
  - **Step Dependencies**: Step 4 (IaC foundation).
  - **User Instructions**: Update and apply the IaC configuration. Verify the Pub/Sub topics are created in the correct region via the GCP Console.

- [ ] Step 9: Set up Apigee API Gateway (Initial Configuration)
  - **Task**: Provision an Apigee API Management instance (e.g., Apigee X or Hybrid, ensuring Canadian region deployment/connectivity). Configure an initial API proxy that acts as the single entry point for client applications. Set up basic routing to a placeholder backend service URL (this will be updated later). Configure initial security policies, specifically integrating with Auth0/Okta for JWT validation (this requires Auth0 setup first).
  - **Files**:
    - `packages/infrastructure/gcp/modules/apigee/main.tf`: Define Apigee instance, environment, initial API proxy, target endpoint, security policies (JWT validation placeholder).
    - `packages/infrastructure/gcp/environments/dev/terraform.tfvars`: Add Apigee specific variables.
    - `packages/infrastructure/gcp/main.tf`: Call the apigee module.
  - **Step Dependencies**: Step 4 (IaC foundation), Step 2 (VPC network for connectivity), Step 10 (Auth0/Okta setup for JWT validation config).
  - **User Instructions**: Update and apply the IaC configuration. Verify the Apigee instance and initial proxy are deployed via the Apigee console. Note the external IP/hostname for the gateway.

- [ ] Step 10: Configure Auth0/Okta Tenant and Application
  - **Task**: Set up a new tenant in Auth0 or Okta. Create a new Application representing the Digital Healthcare Platform. Configure application settings (e.g., Allowed Callback URLs, Allowed Logout URLs, Allowed Web Origins, Allowed Origins (CORS)). Define initial User Roles (`agency_admin`, `care_manager`, `caregiver`). Configure the tenant to enforce Mandatory Multi-Factor Authentication (MFA) for all users upon login. Explore and note the available MFA factors and the process for administrative MFA reset. Obtain the Tenant Domain, Client ID, and Client Secret for the application.
  - **Files**: No code files modified in this step, but configuration is done in the Auth0/Okta console. Document the configuration details.
  - **Step Dependencies**: None (External service setup). Step 9 (Apigee setup needs Auth0 details).
  - **User Instructions**: Log in to the Auth0/Okta console. Create the tenant and application. Configure URLs. Define roles. Enable mandatory MFA. Document Tenant Domain, Client ID, Client Secret, and the process for MFA reset.

## 2. Core Backend Services & Data Models

<thinking>Now that the basic infrastructure and identity provider are set up, the next logical step is to define the core backend services and their database models. This involves creating the basic NestJS application structure for each microservice within the monorepo and defining the initial TypeORM/Sequelize entities that map to the PostgreSQL database tables. Setting up the database migration tool is also crucial at this stage.

**Section 2: Core Backend Services & Data Models**

*   Step 11: Backend Monorepo Structure & Shared Libraries
*   Step 12: User Service (Basic Structure, DB Model)
*   Step 13: Patient Service (Basic Structure, DB Model)
*   Step 14: Documentation Service (Basic Structure, DB Model)
*   Step 15: Messaging Service (Basic Structure, DB Model)
*   Step 16: Template Service (Basic Structure, DB Model)
*   Step 17: Export Service (Basic Structure, DB Model)
*   Step 18: Audit Service (Basic Structure, DB Model - Bigtable/PG)
*   Step 19: MDM Service (Basic Structure, DB Models)
*   Step 20: Consent Service (Basic Structure, DB Models)
*   Step 21: EHR Integration Service (Basic Structure)
*   Step 22: Database Migrations Setup (TypeORM/Sequelize Migrations)

This section focuses on setting up the backend architecture and data layer foundation before implementing specific feature logic.- [ ] Step 11: Initialize Backend Microservice Structure and Shared Libraries
  - **Task**: Within the `packages/backend` directory, set up the NestJS project structure. Create the `services` directory and initial directories for core services (`user-service`, `patient-service`, `documentation-service`, etc.). Create a `shared` directory for common code (DTOs, utilities, database entities that might be shared). Add a root `package.json` for the backend and individual `package.json` files for each service and the shared library. Install NestJS core dependencies.
  - **Files**:
    - `packages/backend/package.json`: Backend root dependencies.
    - `packages/backend/tsconfig.json`: Backend root TypeScript config.
    - `packages/backend/services/user-service/package.json`: User service dependencies.
    - `packages/backend/services/user-service/src/main.ts`: User service entry point.
    - `packages/backend/services/user-service/src/app.module.ts`: User service root module.
    - `packages/backend/services/patient-service/package.json`: Patient service dependencies.
    - `packages/backend/services/patient-service/src/main.ts`: Patient service entry point.
    - `packages/backend/services/documentation-service/package.json`: Documentation service dependencies.
    - `packages/backend/services/documentation-service/src/main.ts`: Documentation service entry point.
    - `packages/backend/shared/package.json`: Shared library dependencies.
    - `packages/backend/shared/src/index.ts`: Shared library entry point.
    - `packages/backend/services/.../tsconfig.json`: Service-specific TypeScript config.
    - `packages/backend/shared/tsconfig.json`: Shared library TypeScript config.
  - **Step Dependencies**: Step 1 (Monorepo setup).
  - **User Instructions**: Run `pnpm install` (or your monorepo tool's install command) from the monorepo root to install dependencies across packages. Verify that the basic NestJS application structure is in place for the initial services.

- [ ] Step 12: Define User Service Database Model
  - **Task**: Define the TypeORM/Sequelize Entity for the `User` and `Agency` tables in the `packages/backend/shared/src/entities` directory. Include fields identified in the Data Models section (`id`, `auth0_id`, `agency_id`, `internal_role`, `email`, `name`, `status`, timestamps). Define relationships. Configure the User Service to connect to the PostgreSQL database using TypeORM/Sequelize, loading these entities.
  - **Files**:
    - `packages/backend/shared/src/entities/user.entity.ts`: TypeORM/Sequelize Entity definition for `User`.
    - `packages/backend/shared/src/entities/agency.entity.ts`: TypeORM/Sequelize Entity definition for `Agency`.
    - `packages/backend/shared/src/database/database.module.ts`: Shared database connection module.
    - `packages/backend/services/user-service/src/app.module.ts`: Import shared database module.
    - `packages/backend/services/user-service/src/user.module.ts`: User service module (placeholder).
    - `packages/backend/services/user-service/src/user.repository.ts`: Placeholder repository.
  - **Step Dependencies**: Step 11 (Backend structure), Step 5 (Cloud SQL setup).
  - **User Instructions**: Ensure database connection details (from Step 5) are available (e.g., via environment variables or Secret Manager - Secret Manager integration comes later). Configure the database module with these details. The User Service should now be configured to connect to the database and recognize the User and Agency entities.

- [ ] Step 13: Define Patient Service Database Model
  - **Task**: Define the TypeORM/Sequelize Entities for the `Patient` and `PatientAssignment` tables in `packages/backend/shared/src/entities`. Include fields identified in the Data Models section (`id`, `agency_id`, `patient_identifier`, demographics, JSONB fields for `medical_history`, `care_plan`, `status`, timestamps for `Patient`; `patient_id`, `user_id`, `assignment_role`, dates for `PatientAssignment`). Define relationships. Configure the Patient Service to connect to the PostgreSQL database, loading these entities.
  - **Files**:
    - `packages/backend/shared/src/entities/patient.entity.ts`: TypeORM/Sequelize Entity definition for `Patient`.
    - `packages/backend/shared/src/entities/patient-assignment.entity.ts`: TypeORM/Sequelize Entity definition for `PatientAssignment`.
    - `packages/backend/services/patient-service/src/app.module.ts`: Import shared database module.
    - `packages/backend/services/patient-service/src/patient.module.ts`: Patient service module (placeholder).
    - `packages/backend/services/patient-service/src/patient.repository.ts`: Placeholder repository.
  - **Step Dependencies**: Step 11 (Backend structure), Step 12 (Shared database module), Step 5 (Cloud SQL setup).
  - **User Instructions**: Configure the Patient Service database connection. The service should be able to connect to the database and recognize the Patient and PatientAssignment entities.

- [ ] Step 14: Define Documentation Service Database Model
  - **Task**: Define the TypeORM/Sequelize Entity for the `DocumentationEntry` table in `packages/backend/shared/src/entities`. Include fields identified in the Data Models section (`id`, `patient_id`, `caregiver_user_id`, `agency_id`, `timestamp`, `text_content`, `structured_data` (JSONB), `audio_url`, `version`, `is_draft`, `status`, timestamps). Define relationships. Configure the Documentation Service to connect to the PostgreSQL database, loading this entity.
  - **Files**:
    - `packages/backend/shared/src/entities/documentation-entry.entity.ts`: TypeORM/Sequelize Entity definition for `DocumentationEntry`.
    - `packages/backend/services/documentation-service/src/app.module.ts`: Import shared database module.
    - `packages/backend/services/documentation-service/src/documentation.module.ts`: Documentation service module (placeholder).
    - `packages/backend/services/documentation-service/src/documentation.repository.ts`: Placeholder repository.
  - **Step Dependencies**: Step 11 (Backend structure), Step 12 (Shared database module), Step 5 (Cloud SQL setup).
  - **User Instructions**: Configure the Documentation Service database connection. The service should be able to connect to the database and recognize the DocumentationEntry entity.

- [ ] Step 15: Define Messaging Service Database Models
  - **Task**: Define the TypeORM/Sequelize Entities for the `Conversation` and `Message` tables in `packages/backend/shared/src/entities`. Include fields identified in the Data Models section (`id`, `patient_id`, `agency_id`, `type`, timestamps for `Conversation`; `id`, `conversation_id`, `sender_user_id`, `content`, `timestamp`, `status`, timestamp for `Message`). Define relationships, including the `ConversationParticipant` join table entity. Configure the Messaging Service to connect to the PostgreSQL database, loading these entities.
  - **Files**:
    - `packages/backend/shared/src/entities/conversation.entity.ts`: TypeORM/Sequelize Entity definition for `Conversation`.
    - `packages/backend/shared/src/entities/message.entity.ts`: TypeORM/Sequelize Entity definition for `Message`.
    - `packages/backend/shared/src/entities/conversation-participant.entity.ts`: TypeORM/Sequelize Entity definition for `ConversationParticipant`.
    - `packages/backend/services/messaging-service/src/app.module.ts`: Import shared database module.
    - `packages/backend/services/messaging-service/src/messaging.module.ts`: Messaging service module (placeholder).
    - `packages/backend/services/messaging-service/src/conversation.repository.ts`: Placeholder repository.
    - `packages/backend/services/messaging-service/src/message.repository.ts`: Placeholder repository.
  - **Step Dependencies**: Step 11 (Backend structure), Step 12 (Shared database module), Step 5 (Cloud SQL setup).
  - **User Instructions**: Configure the Messaging Service database connection. The service should be able to connect to the database and recognize the Conversation, Message, and ConversationParticipant entities.

- [ ] Step 16: Define Template Service Database Model
  - **Task**: Define the TypeORM/Sequelize Entity for the `Template` table in `packages/backend/shared/src/entities`. Include fields identified in the Data Models section (`id`, `agency_id`, `name`, `description`, `free_text_content`, `structured_data_template` (JSONB), timestamps). Define relationships. Configure the Template Service to connect to the PostgreSQL database, loading this entity.
  - **Files**:
    - `packages/backend/shared/src/entities/template.entity.ts`: TypeORM/Sequelize Entity definition for `Template`.
    - `packages/backend/services/template-service/src/app.module.ts`: Import shared database module.
    - `packages/backend/services/template-service/src/template.module.ts`: Template service module (placeholder).
    - `packages/backend/services/template-service/src/template.repository.ts`: Placeholder repository.
  - **Step Dependencies**: Step 11 (Backend structure), Step 12 (Shared database module), Step 5 (Cloud SQL setup).
  - **User Instructions**: Configure the Template Service database connection. The service should be able to connect to the database and recognize the Template entity.

- [ ] Step 17: Define Export Service Database Model
  - **Task**: Define the TypeORM/Sequelize Entity for the `ExportJob` table in `packages/backend/shared/src/entities`. Include fields identified in the Data Models section (`id`, `agency_id`, `requested_by_user_id`, `status`, `data_types` (array), `start_date`, `end_date`, `format`, `file_paths` (array), `error_details`, timestamps). Define relationships. Configure the Export Service to connect to the PostgreSQL database, loading this entity.
  - **Files**:
    - `packages/backend/shared/src/entities/export-job.entity.ts`: TypeORM/Sequelize Entity definition for `ExportJob`.
    - `packages/backend/services/export-service/src/app.module.ts`: Import shared database module.
    - `packages/backend/services/export-service/src/export.module.ts`: Export service module (placeholder).
    - `packages/backend/services/export-service/src/export-job.repository.ts`: Placeholder repository.
  - **Step Dependencies**: Step 11 (Backend structure), Step 12 (Shared database module), Step 5 (Cloud SQL setup).
  - **User Instructions**: Configure the Export Service database connection. The service should be able to connect to the database and recognize the ExportJob entity.

- [ ] Step 18: Define Audit Service Database Model (Bigtable or Optimized PG)
  - **Task**: Choose either Google Cloud Bigtable or a separate, optimized PostgreSQL instance for the Audit Database.
    *   **If Bigtable:** Define the schema design (Row Key structure, column families) for the `AuditLog` data based on the Data Models section (`entity_type#entity_id#timestamp` or `agency_id#entity_type#timestamp#entity_id`). Configure the Audit Service to connect to the Bigtable instance using the appropriate client library.
    *   **If Optimized PostgreSQL:** Define the TypeORM/Sequelize Entity for the `AuditLog` table in `packages/backend/shared/src/entities`. Include fields (`id`, `entity_type`, `entity_id`, `action`, `user_id`, `timestamp`, `change_details` (JSONB), `agency_id`). Configure the Audit Service to connect to this *separate* PostgreSQL instance (or schema), loading the entity.
  - **Files**:
    - `packages/infrastructure/gcp/modules/bigtable/main.tf` (if Bigtable): Define Bigtable instance.
    - `packages/infrastructure/gcp/modules/cloudsql-audit/main.tf` (if separate PG): Define separate Cloud SQL instance for audit.
    - `packages/backend/shared/src/entities/audit-log.entity.ts` (if PG): TypeORM/Sequelize Entity for `AuditLog`.
    - `packages/backend/services/audit-service/src/app.module.ts`: Configure database/Bigtable connection.
    - `packages/backend/services/audit-service/src/audit.module.ts`: Audit service module (placeholder).
    - `packages/backend/services/audit-service/src/audit.repository.ts`: Placeholder repository (adapts for Bigtable or PG).
  - **Step Dependencies**: Step 11 (Backend structure), Step 4 (IaC foundation), Step 5 (Cloud SQL setup - if using separate PG instance).
  - **User Instructions**: Update and apply IaC for the chosen Audit DB. Configure the Audit Service connection details. The service should be able to connect to the Audit DB.

- [ ] Step 19: Define MDM Service Database Models
  - **Task**: Define the TypeORM/Sequelize Entities for the `MdmPatientIdentity` and `MdmExternalIdentifier` tables. These can reside in the primary PostgreSQL database or a separate MDM-specific database. Include fields identified in the Data Models section (`mpi_id`, `internal_patient_id`, `agency_id`, timestamps for `MdmPatientIdentity`; `id`, `mpi_id`, `system`, `value`, timestamp for `MdmExternalIdentifier`). Define relationships. Configure the MDM Service to connect to the appropriate database, loading these entities.
  - **Files**:
    - `packages/backend/shared/src/entities/mdm-patient-identity.entity.ts`: TypeORM/Sequelize Entity for `MdmPatientIdentity`.
    - `packages/backend/shared/src/entities/mdm-external-identifier.entity.ts`: TypeORM/Sequelize Entity for `MdmExternalIdentifier`.
    - `packages/backend/services/mdm-service/src/app.module.ts`: Configure database connection.
    - `packages/backend/services/mdm-service/src/mdm.module.ts`: MDM service module (placeholder).
    - `packages/backend/services/mdm-service/src/mdm.repository.ts`: Placeholder repository.
  - **Step Dependencies**: Step 11 (Backend structure), Step 12 (Shared database module), Step 5 (Cloud SQL setup - or separate MDM DB setup via IaC).
  - **User Instructions**: Configure the MDM Service database connection. The service should be able to connect to the database and recognize the MDM entities.

- [ ] Step 20: Define Consent Service Database Models
  - **Task**: Define the TypeORM/Sequelize Entities for the `ConsentDirective` and `ConsentLog` tables. These can reside in the primary PostgreSQL database or a separate Consent-specific database. Include fields identified in the Data Models section (`id`, `patient_id`, `directive` (JSONB), dates, status for `ConsentDirective`; `id`, `timestamp`, `user_id`, `patient_id`, `access_context` (JSONB), `policy_evaluated`, `decision`, `reason` for `ConsentLog`). Define relationships. Configure the Consent Service to connect to the appropriate database, loading these entities.
  - **Files**:
    - `packages/backend/shared/src/entities/consent-directive.entity.ts`: TypeORM/Sequelize Entity for `ConsentDirective`.
    - `packages/backend/shared/src/entities/consent-log.entity.ts`: TypeORM/Sequelize Entity for `ConsentLog`.
    - `packages/backend/services/consent-service/src/app.module.ts`: Configure database connection.
    - `packages/backend/services/consent-service/src/consent.module.ts`: Consent service module (placeholder).
    - `packages/backend/services/consent-service/src/consent.repository.ts`: Placeholder repository.
  - **Step Dependencies**: Step 11 (Backend structure), Step 12 (Shared database module), Step 5 (Cloud SQL setup - or separate Consent DB setup via IaC).
  - **User Instructions**: Configure the Consent Service database connection. The service should be able to connect to the database and recognize the Consent entities.

- [ ] Step 21: Initialize EHR Integration Service Structure
  - **Task**: Create the basic NestJS application structure for the `ehr-service` within `packages/backend/services`. This service will house the FHIR API implementation. It won't have its own database models initially but will depend on other services (Patient, MDM, Consent).
  - **Files**:
    - `packages/backend/services/ehr-service/package.json`: EHR service dependencies.
    - `packages/backend/services/ehr-service/src/main.ts`: EHR service entry point.
    - `packages/backend/services/ehr-service/src/app.module.ts`: EHR service root module.
    - `packages/backend/services/ehr-service/src/ehr.module.ts`: EHR service module (placeholder).
  - **Step Dependencies**: Step 11 (Backend structure).
  - **User Instructions**: Run `pnpm install` from the monorepo root. The basic EHR service structure should be created.

- [ ] Step 22: Set up Database Migrations
  - **Task**: Configure a database migration tool (e.g., TypeORM migrations, Sequelize migrations, Flyway) for the primary PostgreSQL database. Set up the configuration to connect to the database (using details from Step 5). Create an initial migration script that defines the schema for all entities created in Steps 12-17, 19, and 20 (if using the primary DB for MDM/Consent). Run the initial migration against the 'dev' database instance.
  - **Files**:
    - `packages/backend/ormconfig.js` (or similar): Database connection configuration for migrations.
    - `packages/backend/migrations/1678886400000-InitialSchema.ts` (example): Initial migration script defining tables and columns.
    - `packages/backend/package.json`: Add migration scripts (e.g., `typeorm migration:run`).
  - **Step Dependencies**: Steps 12-17, 19, 20 (Database models defined), Step 5 (Cloud SQL setup).
  - **User Instructions**: Configure the migration tool. Run the command to generate an initial migration based on the defined entities. Review the generated SQL. Run the migration command (`pnpm run migration:run` or equivalent) against the 'dev' Cloud SQL instance. Verify that the tables are created in the database using a database client.

## 3. Authentication & User Management Implementation

<thinking>With the core backend structure and data models in place, the next critical area is implementing user authentication and management, leveraging Auth0/Okta. This involves integrating Auth0/Okta with the backend User Service and the frontend applications, implementing the user management APIs, and setting up the initial authentication flow. RBAC enforcement starts here.

**Section 3: Authentication & User Management Implementation**

*   Step 23: User Service - Auth0/Okta Integration (Management API Client)
*   Step 24: User Service - Invite User API
*   Step 25: User Service - Get/List Users API
*   Step 26: User Service - Update User Role/Status API
*   Step 27: User Service - Reset MFA API
*   Step 28: Backend Auth Middleware/Guards (JWT Validation, User Context)
*   Step 29: Web Frontend - Auth0/Okta SDK Integration & Login Flow
*   Step 30: Web Frontend - User Management UI (Invite, List, Edit Actions)
*   Step 31: Web Frontend - RBAC for UI Elements (User Management)

This section builds directly on the User Service structure and Auth0/Okta setup. It introduces the frontend implementation for user management and the core backend authentication/authorization logic that will be used by all services.- [ ] Step 23: Implement User Service Integration with Auth0/Okta Management API
  - **Task**: In the User Service, install the Auth0/Okta Node.js Management API SDK. Configure the SDK with credentials (Client ID, Client Secret, Tenant Domain) obtained from Step 10, retrieving them securely (placeholder for Secret Manager integration later). Implement a service class (`Auth0ManagementService` or similar) that wraps the SDK calls needed for user management (create user, update user metadata/roles, get user, reset MFA).
  - **Files**:
    - `packages/backend/services/user-service/package.json`: Add Auth0/Okta SDK dependency.
    - `packages/backend/services/user-service/src/auth0/auth0-management.service.ts`: Implement service class for Auth0/Okta API calls.
    - `packages/backend/services/user-service/src/auth0/auth0.module.ts`: NestJS module for Auth0 integration.
    - `packages/backend/services/user-service/src/user.module.ts`: Import Auth0 module.
    - `packages/backend/services/user-service/src/config/auth0.config.ts`: Configuration loading (placeholder for secrets).
  - **Step Dependencies**: Step 11 (Backend structure), Step 10 (Auth0/Okta setup).
  - **User Instructions**: Ensure Auth0/Okta credentials are set up as environment variables or in a config file for the User Service (will be replaced by Secret Manager later). The User Service should now be able to make calls to the Auth0/Okta Management API.

- [ ] Step 24: Implement User Service - Invite User API
  - **Task**: Implement the `POST /users/invite` API endpoint in the User Service. This endpoint should accept `email`, `name`, and `role` in the request body. Validate the input using a DTO (`CreateUserDto`). Call the `Auth0ManagementService` to create the user in Auth0/Okta, setting initial metadata like `agency_id` and `internal_role`. Store a corresponding entry in the local PostgreSQL `User` table, linking it via the Auth0 `user_id`. Ensure the inviting user has `user:invite` permission (placeholder check for now).
  - **Files**:
    - `packages/backend/services/user-service/src/user.controller.ts`: Add `POST /users/invite` route.
    - `packages/backend/services/user-service/src/user.service.ts`: Implement invite logic (call Auth0, save to local DB).
    - `packages/backend/services/user-service/src/dtos/create-user.dto.ts`: DTO for invite request body.
    - `packages/backend/services/user-service/src/user.repository.ts`: Add method to save local user.
  - **Step Dependencies**: Step 23 (Auth0/Okta integration), Step 12 (User DB model), Step 22 (DB migrations run).
  - **User Instructions**: Deploy the User Service locally or to a dev environment. Use an API client (like Postman) to send a POST request to `/users/invite` with valid data. Verify a user is created in Auth0/Okta and a corresponding entry appears in the local `users` table in the PostgreSQL database.

- [ ] Step 25: Implement User Service - Get/List Users API
  - **Task**: Implement the `GET /users` API endpoint in the User Service. This endpoint should retrieve a list of users belonging to the requesting user's agency (agency context will be added via auth later). Query the local `User` table, potentially joining with Auth0 data if needed (though local table should suffice for list view). Implement basic filtering/pagination if required by the spec (MVP might be simple list). Implement the `GET /users/:id` endpoint to get details for a single user. Ensure the requesting user has `user:list` permission (placeholder).
  - **Files**:
    - `packages/backend/services/user-service/src/user.controller.ts`: Add `GET /users` and `GET /users/:id` routes.
    - `packages/backend/services/user-service/src/user.service.ts`: Implement logic to fetch users from local DB.
    - `packages/backend/services/user-service/src/dtos/user.dto.ts`: DTO for user response data.
    - `packages/backend/services/user-service/src/user.repository.ts`: Add methods to find users.
  - **Step Dependencies**: Step 12 (User DB model), Step 22 (DB migrations run).
  - **User Instructions**: Deploy the User Service. Use an API client to send GET requests to `/users` and `/users/:id`. Verify that user data is returned correctly from the local database.

- [ ] Step 26: Implement User Service - Update User Role/Status API
  - **Task**: Implement the `PUT /users/:id/role` and `PUT /users/:id/status` API endpoints in the User Service. These endpoints should accept the target user's Auth0 `user_id` and the new role or status. Validate input using DTOs. Update the user's role/status in both Auth0/Okta (via `Auth0ManagementService`) and the local `User` table. Implement permission checks (`user:update_role`, `user:update_status`) and logic to prevent self-modification or unauthorized role changes (e.g., caregiver changing admin role).
  - **Files**:
    - `packages/backend/services/user-service/src/user.controller.ts`: Add `PUT /users/:id/role` and `PUT /users/:id/status` routes.
    - `packages/backend/services/user-service/src/user.service.ts`: Implement update logic (call Auth0, update local DB).
    - `packages/backend/services/user-service/src/dtos/update-user.dto.ts`: DTOs for update requests.
    - `packages/backend/services/user-service/src/user.repository.ts`: Add method to update local user.
  - **Step Dependencies**: Step 23 (Auth0/Okta integration), Step 12 (User DB model), Step 22 (DB migrations run).
  - **User Instructions**: Deploy the User Service. Use an API client to send PUT requests to update a user's role and status. Verify changes are reflected in both Auth0/Okta and the local database. Test permission denied cases (e.g., trying to change a role without sufficient permissions).

- [ ] Step 27: Implement User Service - Reset MFA API
  - **Task**: Implement the `POST /users/:id/mfa/reset` API endpoint in the User Service. This endpoint should accept the target user's Auth0 `user_id`. Call the appropriate method in the `Auth0ManagementService` to trigger the MFA reset process via Auth0/Okta. Implement permission checks (`user:reset_mfa`).
  - **Files**:
    - `packages/backend/services/user-service/src/user.controller.ts`: Add `POST /users/:id/mfa/reset` route.
    - `packages/backend/services/user-service/src/user.service.ts`: Implement MFA reset logic (call Auth0).
  - **Step Dependencies**: Step 23 (Auth0/Okta integration).
  - **User Instructions**: Deploy the User Service. Use an API client to send a POST request to reset MFA for a test user in Auth0/Okta. Verify the MFA reset is initiated in Auth0/Okta (e.g., user is prompted to set up MFA on next login).

- [ ] Step 28: Implement Backend Authentication Middleware/Guards
  - **Task**: Implement global authentication middleware or NestJS Guards that validate the JWT provided in the `Authorization` header of incoming requests (expected from Apigee). This middleware/guard should:
    1.  Extract the JWT.
    2.  Verify the JWT signature and claims using Auth0/Okta's public keys (JWKS endpoint).
    3.  Extract the Auth0 `user_id` (`sub` claim).
    4.  Look up the user in the local `User` table using the `auth0_id` to get internal user details (`id`, `agency_id`, `internal_role`, etc.).
    5.  Attach the internal `User` object or relevant details (like `userId`, `agencyId`, `role`) to the request context (e.g., `req.user`).
    6.  If validation fails, return 401 Unauthorized.
  - **Files**:
    - `packages/backend/shared/src/auth/jwt.strategy.ts`: NestJS Passport JWT strategy for validation.
    - `packages/backend/shared/src/auth/jwt-auth.guard.ts`: NestJS AuthGuard using the strategy.
    - `packages/backend/shared/src/auth/auth.module.ts`: Shared Auth module.
    - `packages/backend/shared/src/auth/user.decorator.ts`: Custom decorator to inject `req.user`.
    - `packages/backend/shared/src/user/user.service.ts`: Shared user lookup logic (fetches from local DB by auth0_id).
    - `packages/backend/shared/src/user/user.module.ts`: Shared user module.
    - `packages/backend/services/*/src/app.module.ts`: Import shared Auth and User modules. Apply global guard (`APP_GUARD`).
  - **Step Dependencies**: Step 10 (Auth0/Okta setup - need JWKS endpoint), Step 12 (User DB model), Step 22 (DB migrations run).
  - **User Instructions**: Configure the JWT strategy with Auth0/Okta JWKS URI. Deploy one of the backend services (e.g., User Service). Attempt to access a protected endpoint without a token (should get 401). Obtain a valid JWT from Auth0/Okta (e.g., via a test login flow). Use an API client to call a protected endpoint with the token. Verify the request reaches the controller and `req.user` contains the correct internal user details.

- [ ] Step 29: Implement Web Frontend - Auth0/Okta SDK Integration and Login Flow
  - **Task**: In the React frontend (`packages/frontend`), install the Auth0/Okta React SDK. Configure the SDK with the Auth0/Okta Client ID and Tenant Domain (from Step 10). Implement the login flow using the SDK's `loginWithRedirect` or `loginWithPopup` methods. Set up the callback page to handle the redirect response. Implement logout functionality. Create a basic protected route/page that requires authentication.
  - **Files**:
    - `packages/frontend/package.json`: Add Auth0/Okta React SDK dependency.
    - `packages/frontend/src/auth/auth-provider.tsx`: Context provider for Auth0/Okta SDK.
    - `packages/frontend/src/pages/_app.tsx`: Wrap app with AuthProvider.
    - `packages/frontend/src/pages/login.tsx`: Login page with login button.
    - `packages/frontend/src/pages/callback.tsx`: Callback page to handle redirect.
    - `packages/frontend/src/pages/dashboard/index.tsx`: Placeholder protected dashboard page.
    - `packages/frontend/src/auth/auth-guard.tsx`: Component to protect routes.
    - `packages/frontend/src/config/auth.config.ts`: Auth configuration (Client ID, Domain).
  - **Step Dependencies**: Step 10 (Auth0/Okta setup).
  - **User Instructions**: Configure the React app with Auth0/Okta details. Run the web application locally. Attempt to access the protected dashboard page (should redirect to login). Click the login button (should redirect to Auth0/Okta). Log in with a test user (MFA should be required if not set up). Verify successful redirect back to the app and access to the dashboard. Test logout.

- [ ] Step 30: Implement Web Frontend - User Management UI
  - **Task**: In the React frontend, implement the User Management UI for Agency Administrators. Create the `/dashboard/admin/users` page. Display a table listing users fetched from the `GET /users` API endpoint (from Step 25). Implement the "Invite User" modal/form that calls the `POST /users/invite` API (from Step 24). Implement the action menu (kebab icon) for each user row with placeholder actions for "Edit Role", "Deactivate/Activate", "Reset MFA". Use design system components (Table, Button, Modal, Form fields).
  - **Files**:
    - `packages/frontend/src/features/user-management/pages/user-list.tsx`: User list page.
    - `packages/frontend/src/features/user-management/components/user-table.tsx`: Table component.
    - `packages/frontend/src/features/user-management/components/invite-user-modal.tsx`: Invite user modal.
    - `packages/frontend/src/features/user-management/services/user.api.ts`: API client calls for user management endpoints.
    - `packages/frontend/src/features/user-management/types/user.ts`: TypeScript types for user data.
    - `packages/frontend/src/components/design-system/Table.tsx`: Placeholder Table component.
    - `packages/frontend/src/components/design-system/Modal.tsx`: Placeholder Modal component.
    - `packages/frontend/src/components/design-system/Form.tsx`: Placeholder Form components.
  - **Step Dependencies**: Step 25 (GET /users API), Step 24 (POST /users/invite API), Step 29 (Frontend Auth - need authenticated user context), Step 71 (Design System components - placeholder).
  - **User Instructions**: Log in as an Agency Admin user. Navigate to the User Management page. Verify the list of users is displayed. Test the "Invite User" modal and form submission. Verify new users appear in the list after inviting.

- [ ] Step 31: Implement Web Frontend - RBAC for User Management UI
  - **Task**: Implement frontend logic to conditionally render or disable UI elements on the User Management page based on the logged-in user's role and permissions. For example, only show the "Invite User" button and the action menu columns if the user has the necessary `user:manage` or specific `user:invite`, `user:update_role`, `user:update_status`, `user:reset_mfa` permissions (permissions should be available in the user context from the Auth0/Okta token or a separate user info endpoint).
  - **Files**:
    - `packages/frontend/src/features/user-management/pages/user-list.tsx`: Add conditional rendering logic.
    - `packages/frontend/src/features/user-management/components/user-table.tsx`: Add logic to hide/disable columns/actions.
    - `packages/frontend/src/auth/auth.hooks.ts`: Custom hook to access user context and permissions.
  - **Step Dependencies**: Step 30 (User Management UI), Step 28 (Backend Auth - ensures user context is available), Step 29 (Frontend Auth - provides user context).
  - **User Instructions**: Log in as different user roles (Admin, Care Manager, Caregiver). Navigate to the User Management page. Verify that only the Admin user sees the full UI with invite and action options, while other roles see restricted or empty views, or are redirected if they lack basic list permission.

## 4. Patient Profile Implementation

<thinking>Now that user management and core authentication are functional, the next step is to implement the Patient Profile feature. This involves implementing the Patient Service APIs for CRUD operations, enforcing RBAC based on agency and patient assignments, and building the corresponding Web (for Managers/Admins) and Mobile (for Caregivers) UI components.

**Section 4: Patient Profile Implementation**

*   Step 32: Patient Service - Create Patient API
*   Step 33: Patient Service - Get/List Patients API (Basic)
*   Step 34: Patient Service - Update Patient API
*   Step 35: Patient Service - RBAC Enforcement (Agency Scope)
*   Step 36: Patient Service - Patient Assignment Model & Basic Assignment Logic
*   Step 37: Patient Service - RBAC Enforcement (Patient Assignment Scope)
*   Step 38: Web Frontend - Patient Profile UI (Create, View, Edit Forms)
*   Step 39: Web Frontend - Patient List UI (List, Search, Filter)
*   Step 40: Web Frontend - RBAC for Patient UI (Edit/View Restrictions)
*   Step 41: Mobile Frontend - Patient List UI (Filtered by Assignment)
*   Step 42: Mobile Frontend - Restricted Patient Profile View UI

This section builds on the Patient Service structure and DB models defined earlier, and integrates the authentication/authorization logic from Section 3.- [ ] Step 32: Implement Patient Service - Create Patient API
  - **Task**: Implement the `POST /patients` API endpoint in the Patient Service. Accept patient data (demographics, history, care plan JSONB) via a DTO (`CreatePatientDto`). Validate the input. Use TypeORM/Sequelize to save the new patient record to the PostgreSQL `patients` table. Associate the patient with the agency of the requesting user (get agency ID from the authenticated user context).
  - **Files**:
    - `packages/backend/services/patient-service/src/patient.controller.ts`: Add `POST /patients` route.
    - `packages/backend/services/patient-service/src/patient.service.ts`: Implement create logic.
    - `packages/backend/services/patient-service/src/dtos/create-patient.dto.ts`: DTO for patient creation.
    - `packages/backend/services/patient-service/src/patient.repository.ts`: Add method to save patient.
  - **Step Dependencies**: Step 13 (Patient DB model), Step 22 (DB migrations run), Step 28 (Backend Auth - need user context with agencyId).
  - **User Instructions**: Deploy the Patient Service. Obtain a valid JWT for a Care Manager or Admin user. Use an API client to send a POST request to `/patients` with valid patient data and the JWT. Verify a new patient record is created in the `patients` table in the database, linked to the correct agency.

- [ ] Step 33: Implement Patient Service - Get/List Patients API (Basic)
  - **Task**: Implement the `GET /patients` API endpoint in the Patient Service. This endpoint should return a list of patients. Initially, filter the list to include only patients belonging to the requesting user's agency (get agency ID from user context). Implement basic pagination and sorting based on query parameters. Implement the `GET /patients/:id` endpoint to fetch a single patient's details by ID.
  - **Files**:
    - `packages/backend/services/patient-service/src/patient.controller.ts`: Add `GET /patients` and `GET /patients/:id` routes.
    - `packages/backend/services/patient-service/src/patient.service.ts`: Implement list and get logic, including agency filtering.
    - `packages/backend/services/patient-service/src/dtos/patient.dto.ts`: DTOs for patient list items and details.
    - `packages/backend/services/patient-service/src/patient.repository.ts`: Add methods to find patients.
  - **Step Dependencies**: Step 13 (Patient DB model), Step 22 (DB migrations run), Step 28 (Backend Auth - need user context with agencyId).
  - **User Instructions**: Deploy the Patient Service. Obtain a valid JWT for a user. Use an API client to send GET requests to `/patients` and `/patients/:id`. Verify that only patients from the user's agency are returned and that single patient details are correct.

- [ ] Step 34: Implement Patient Service - Update Patient API
  - **Task**: Implement the `PUT /patients/:id` API endpoint in the Patient Service. Accept the patient ID and updated patient data via a DTO (`UpdatePatientDto`). Validate the input. Use TypeORM/Sequelize to update the existing patient record in the `patients` table. Ensure the patient belongs to the requesting user's agency before allowing the update.
  - **Files**:
    - `packages/backend/services/patient-service/src/patient.controller.ts`: Add `PUT /patients/:id` route.
    - `packages/backend/services/patient-service/src/patient.service.ts`: Implement update logic.
    - `packages/backend/services/patient-service/src/dtos/update-patient.dto.ts`: DTO for patient update.
    - `packages/backend/services/patient-service/src/patient.repository.ts`: Add method to update patient.
  - **Step Dependencies**: Step 13 (Patient DB model), Step 22 (DB migrations run), Step 28 (Backend Auth - need user context with agencyId), Step 33 (GET /patients/:id to verify existence).
  - **User Instructions**: Deploy the Patient Service. Obtain a valid JWT for a Care Manager or Admin. Create a test patient (Step 32). Use an API client to send a PUT request to update the patient's data. Verify the record is updated in the database. Test updating a patient from a different agency (should be denied - handled in Step 35).

- [ ] Step 35: Implement Patient Service - RBAC Enforcement (Agency Scope)
  - **Task**: Enhance the Patient Service API endpoints (`POST /patients`, `GET /patients`, `GET /patients/:id`, `PUT /patients/:id`) to enforce Role-Based Access Control based on the user's role and agency.
    *   `POST /patients`: Only allow users with `patient:create` permission (e.g., Care Manager, Admin).
    *   `GET /patients`, `GET /patients/:id`: Allow users with `patient:read` permission (all roles), but ensure data is strictly scoped to the user's agency.
    *   `PUT /patients/:id`: Only allow users with `patient:update` permission (e.g., Care Manager, Admin).
  - **Files**:
    - `packages/backend/shared/src/auth/roles.guard.ts`: NestJS Guard to check user roles/permissions from context.
    - `packages/backend/shared/src/auth/roles.decorator.ts`: NestJS Decorator to mark routes with required permissions.
    - `packages/backend/services/patient-service/src/patient.controller.ts`: Apply `@UseGuards(JwtAuthGuard, RolesGuard)` and `@Roles('patient:create')`, `@Roles('patient:read')`, `@Roles('patient:update')` decorators to controller methods.
    - `packages/backend/services/patient-service/src/patient.service.ts`: Add logic in service methods to verify agency ID matches user's agency ID for all operations.
  - **Step Dependencies**: Step 28 (Backend Auth - provides user context with role/agency), Steps 32-34 (Patient APIs implemented).
  - **User Instructions**: Deploy the Patient Service. Obtain JWTs for users with different roles (Admin, Care Manager, Caregiver). Test accessing/modifying patient data using each user. Verify that permissions are correctly enforced (e.g., Caregiver cannot create/update patients, users cannot access patients from other agencies).

- [ ] Step 36: Define Patient Assignment Model and Basic Assignment Logic
  - **Task**: Implement basic logic for assigning users (specifically Caregivers) to patients. This might involve a simple API endpoint or internal service method in the User Service or Patient Service (decide which service owns assignments). For MVP, a simple assignment API might not be needed in the UI, but the underlying data model (`PatientAssignment`) and service logic to create/manage assignments is required for RBAC. Create methods to fetch assignments for a user and fetch users assigned to a patient.
  - **Files**:
    - `packages/backend/shared/src/entities/patient-assignment.entity.ts`: Ensure this entity (defined in Step 13) is complete.
    - `packages/backend/services/user-service/src/user.service.ts`: Add methods like `getPatientAssignmentsForUser(userId: string): Promise<PatientAssignment[]>` and `getUsersAssignedToPatient(patientId: string): Promise<PatientAssignment[]>`.
    - `packages/backend/services/user-service/src/patient-assignment.repository.ts`: Repository for PatientAssignment entity.
    - `packages/backend/services/user-service/src/user.module.ts`: Add PatientAssignment entity/repository.
  - **Step Dependencies**: Step 13 (PatientAssignment DB model), Step 22 (DB migrations run), Step 12 (User DB model).
  - **User Instructions**: Manually add some test data to the `patient_assignments` table in the database, linking test Caregiver users to test patients. Verify the new service methods can retrieve this assignment data correctly.

- [ ] Step 37: Implement Patient Service - RBAC Enforcement (Patient Assignment Scope)
  - **Task**: Enhance the `GET /patients` and `GET /patients/:id` API endpoints in the Patient Service to enforce patient assignment scope for Caregiver users. If the requesting user's role is `caregiver`, modify the database query to only return patients that have an active assignment record linking them to this specific caregiver user. Care Managers and Admins should still see all patients in their agency.
  - **Files**:
    - `packages/backend/services/patient-service/src/patient.service.ts`: Modify `findAll` and `findOne` methods to add assignment filtering based on user role and ID (calling the methods from Step 36).
    - `packages/backend/services/patient-service/src/patient.repository.ts`: Add query logic to join with `patient_assignments` table when filtering by caregiver.
  - **Step Dependencies**: Step 35 (Agency-level RBAC), Step 36 (Patient Assignment logic), Step 28 (Backend Auth - provides user context with role/ID).
  - **User Instructions**: Deploy the Patient Service. Obtain JWTs for a Care Manager and a Caregiver. Ensure the Caregiver is assigned to only a subset of patients in the agency (via manual DB entry from Step 36). Call `GET /patients` and `GET /patients/:id` using both JWTs. Verify the Care Manager sees all agency patients, but the Caregiver only sees their assigned patients. Verify the Caregiver gets 403 Forbidden or 404 Not Found when trying to access a patient they are *not* assigned to.

- [ ] Step 38: Implement Web Frontend - Patient Profile UI (Create, View, Edit Forms)
  - **Task**: In the React frontend, implement the UI components for creating, viewing, and editing patient profiles. Create pages/components for `/dashboard/patients/new` (Create form) and `/dashboard/patients/:id` (View/Edit form). Use design system form components. Structure the view with sections/tabs for demographics, medical history (JSONB editor/form), and care plan (JSONB editor/form). Implement client-side form validation. Connect forms to the `POST /patients` and `PUT /patients/:id` APIs (from Steps 32 and 34). Implement the transition between view and edit modes.
  - **Files**:
    - `packages/frontend/src/features/patient/pages/new-patient.tsx`: Create patient page.
    - `packages/frontend/src/features/patient/pages/view-edit-patient.tsx`: View/Edit patient page.
    - `packages/frontend/src/features/patient/components/patient-form.tsx`: Reusable form component.
    - `packages/frontend/src/features/patient/components/patient-details.tsx`: View component.
    - `packages/frontend/src/features/patient/services/patient.api.ts`: API client calls for patient endpoints.
    - `packages/frontend/src/features/patient/types/patient.ts`: TypeScript types for patient data.
    - `packages/frontend/src/components/design-system/JsonEditor.tsx`: Component for editing JSONB fields (placeholder).
  - **Step Dependencies**: Steps 32, 34 (Patient Create/Update APIs), Step 71 (Design System components - placeholder).
  - **User Instructions**: Log in as a Care Manager or Admin. Navigate to the "Add New Patient" page. Fill the form and submit. Verify the patient is created. Navigate to a patient's detail page. Verify data is displayed. Click "Edit", modify data, and save. Verify changes are saved. Test client-side validation.

- [ ] Step 39: Implement Web Frontend - Patient List UI (List, Search, Filter)
  - **Task**: In the React frontend, implement the Patient List UI for Care Managers/Admins at `/dashboard/patients`. Display a table or list of patients fetched from the `GET /patients` API (from Step 33). Implement search functionality (sending search query param to API). Implement basic filtering (e.g., by status) if supported by the API. Use design system table/list components. Link patient names/rows to the view/edit patient page (Step 38).
  - **Files**:
    - `packages/frontend/src/features/patient/pages/patient-list.tsx`: Patient list page.
    - `packages/frontend/src/features/patient/components/patient-list-table.tsx`: Table/List component.
    - `packages/frontend/src/features/patient/components/patient-search-filter.tsx`: Search/Filter input components.
    - `packages/frontend/src/features/patient/services/patient.api.ts`: Update API client for list with params.
  - **Step Dependencies**: Step 33 (GET /patients API), Step 38 (View/Edit Patient page), Step 71 (Design System components - placeholder).
  - **User Instructions**: Log in as a Care Manager or Admin. Navigate to the Patient List page. Verify the list of patients for your agency is displayed. Test search and filter inputs. Click on a patient to navigate to their detail page.

- [ ] Step 40: Implement Web Frontend - RBAC for Patient UI (Edit/View Restrictions)
  - **Task**: Implement frontend logic to conditionally render or disable UI elements on the Patient Profile and Patient List pages based on the logged-in user's role and patient assignment (for Caregivers).
    *   Patient List (`GET /patients`): The backend already filters by agency/assignment (Step 37), but the frontend should handle displaying the potentially filtered list.
    *   Patient Profile (`GET /patients/:id`): Hide or disable the "Edit" button and make form fields read-only if the user lacks `patient:update` permission (e.g., Caregiver). Display an "Access Denied" message or redirect if a Caregiver tries to access a patient they are not assigned to (backend should enforce this, frontend handles the resulting 403/404).
  - **Files**:
    - `packages/frontend/src/features/patient/pages/view-edit-patient.tsx`: Add conditional rendering/disabling logic based on user role/permissions and patient data (e.g., agency ID match).
    - `packages/frontend/src/features/patient/components/patient-form.tsx`: Make form fields read-only based on a prop.
    - `packages/frontend/src/auth/auth.hooks.ts`: Ensure user role/permissions are accessible.
  - **Step Dependencies**: Step 38 (Patient Profile UI), Step 39 (Patient List UI), Step 35 & 37 (Backend RBAC), Step 29 (Frontend Auth - provides user context).
  - **User Instructions**: Log in as a Caregiver assigned to specific patients. Navigate to the Patient List. Verify only assigned patients appear. Click on an assigned patient. Verify the profile is read-only and the "Edit" button is hidden/disabled. Attempt to manually navigate to the URL of a patient the caregiver is *not* assigned to. Verify the frontend handles the backend's 403/404 response gracefully (e.g., shows an access denied message).

- [ ] Step 41: Implement Mobile Frontend - Patient List UI (Filtered by Assignment)
  - **Task**: In the Flutter mobile app (`packages/mobile`), implement the Patient List UI for Caregivers. This will likely be the main screen after login. Fetch the list of assigned patients from the `GET /patients` API (from Step 33 - backend filters by assignment for caregivers). Display the list using cards or list tiles. Use design system components. Link tapping a patient to the restricted patient profile view (Step 42).
  - **Files**:
    - `packages/mobile/lib/src/features/patient/pages/patient_list_page.dart`: Patient list screen.
    - `packages/mobile/lib/src/features/patient/widgets/patient_list_item.dart`: Widget for displaying a patient in the list.
    - `packages/mobile/lib/src/services/patient_api.dart`: API client calls for patient endpoints.
    - `packages/mobile/lib/src/models/patient.dart`: Dart models for patient data.
    - `packages/mobile/lib/src/design_system/widgets/cards.dart`: Placeholder Card widget.
  - **Step Dependencies**: Step 33 (GET /patients API), Step 29 (Frontend Auth - mobile equivalent), Step 71 (Design System components - placeholder).
  - **User Instructions**: Log in to the mobile app as a Caregiver. Verify that only the patients assigned to this caregiver are displayed in the list.

- [ ] Step 42: Implement Mobile Frontend - Restricted Patient Profile View UI
  - **Task**: In the Flutter mobile app, implement the restricted Patient Profile View for Caregivers. This screen is accessed by tapping a patient in the list (Step 41). Fetch the patient details using the `GET /patients/:id` API (from Step 33 - backend enforces restricted data/access). Display the allowed patient information (demographics, care plan summary, documentation log link). Ensure no editing capabilities are present. Use design system components. Handle the backend's 403/404 response if a caregiver somehow attempts to access an unassigned patient.
  - **Files**:
    - `packages/mobile/lib/src/features/patient/pages/restricted_patient_profile_page.dart`: Restricted patient profile screen.
    - `packages/mobile/lib/src/features/patient/widgets/patient_overview_section.dart`: Widget for displaying demographics.
    - `packages/mobile/lib/src/features/patient/widgets/care_plan_summary.dart`: Widget for displaying care plan summary.
    - `packages/mobile/lib/src/services/patient_api.dart`: Update API client for get single patient.
  - **Step Dependencies**: Step 41 (Mobile Patient List), Step 33 (GET /patients/:id API), Step 37 (Backend RBAC - assignment enforcement).
  - **User Instructions**: Log in to the mobile app as a Caregiver. Tap on an assigned patient. Verify that the restricted profile view is displayed with only allowed information and no edit options.

## 5. Audit Logging Implementation

<thinking>Audit logging is a critical PHIPA requirement. Now that core data (Users, Patients, Documentation - basic) can be created and modified, it's essential to implement the audit trail mechanism. This involves publishing events from services when data changes and having a dedicated Audit Service consume these events and write them to the Audit Database. A basic UI to view these logs is also needed.

**Section 5: Audit Logging Implementation**

*   Step 43: Audit Service - Pub/Sub Subscriber Setup
*   Step 44: Audit Service - Write Audit Log Logic (to Bigtable/PG)
*   Step 45: Backend Services - Publish Audit Events (Patient, User changes)
*   Step 46: Audit Service - Get Audit Logs API
*   Step 47: Web Frontend - View Audit History UI (Basic List)

This section introduces the Audit Service and its interaction with other services via Pub/Sub, writing to the dedicated Audit DB. It also adds the first piece of the audit trail UI.- [ ] Step 43: Set up Audit Service Pub/Sub Subscriber
  - **Task**: In the Audit Service, configure a Pub/Sub subscriber to listen to the `audit.events` topic (created in Step 8). This involves setting up a NestJS controller or service that consumes messages from a Pub/Sub subscription. Create the subscription via IaC or GCP Console, linking it to the `audit.events` topic and the Audit Service deployment (e.g., if using Cloud Run, configure it as a Pub/Sub push subscriber; if GKE, use a pull subscriber or a dedicated Pub/Sub client library).
  - **Files**:
    - `packages/infrastructure/gcp/modules/pubsub/main.tf`: Add subscription definition for `audit.events` topic, linking to Audit Service endpoint/deployment.
    - `packages/backend/services/audit-service/src/audit.controller.ts` (if push subscriber): Add endpoint to receive Pub/Sub messages.
    - `packages/backend/services/audit-service/src/audit.service.ts`: Add method to process incoming audit event messages.
    - `packages/backend/services/audit-service/src/pubsub/pubsub.module.ts`: NestJS module for Pub/Sub integration.
    - `packages/backend/services/audit-service/src/app.module.ts`: Import Pub/Sub module.
  - **Step Dependencies**: Step 18 (Audit Service structure), Step 8 (Pub/Sub topics).
  - **User Instructions**: Update and apply IaC to create the Pub/Sub subscription. Deploy the Audit Service. Publish a test message manually to the `audit.events` topic using the GCP Console or `gcloud` CLI. Verify that the Audit Service receives and logs the message (initial logging only, saving to DB comes next).

- [ ] Step 44: Implement Audit Service - Write Audit Log Logic
  - **Task**: In the Audit Service, implement the logic to process incoming audit event messages (from Step 43) and write them to the Audit Database (Bigtable or Optimized PostgreSQL, configured in Step 18). Parse the message payload, extract relevant details (`entity_type`, `entity_id`, `action`, `user_id`, `timestamp`, `change_details`, `agency_id`). Store this information in the Audit DB according to the schema defined in Step 18. Ensure the write operation is robust and handles potential database errors.
  - **Files**:
    - `packages/backend/services/audit-service/src/audit.service.ts`: Implement `processAuditEvent` method to save to DB.
    - `packages/backend/services/audit-service/src/audit.repository.ts`: Implement method to write to Audit DB (Bigtable client calls or TypeORM/Sequelize save).
    - `packages/backend/shared/src/dtos/audit-event.dto.ts`: Define DTO for the structure of messages published to `audit.events`.
  - **Step Dependencies**: Step 43 (Pub/Sub subscriber), Step 18 (Audit DB setup and model).
  - **User Instructions**: Deploy the Audit Service. Publish a test audit event message (conforming to `AuditEventDto`) manually to the `audit.events` topic. Verify that a new record is created in the Audit Database with the correct details.

- [ ] Step 45: Implement Backend Services - Publish Audit Events (Patient, User changes)
  - **Task**: Modify the User Service and Patient Service to publish audit event messages to the `audit.events` Pub/Sub topic whenever data is created, updated, or deleted. This involves:
    1.  Identifying the specific points in the service logic where data changes occur (e.g., after saving a new user, updating a patient profile).
    2.  Constructing an `AuditEventDto` payload containing the `entity_type`, `entity_id`, `action`, `user_id` (from request context), `timestamp`, `agency_id`, and `change_details` (e.g., diffs for updates, snapshot for create/delete).
    3.  Using a Pub/Sub client library (Node.js SDK) to publish the message asynchronously to the `audit.events` topic.
  - **Files**:
    - `packages/backend/shared/src/pubsub/pubsub.service.ts`: Shared service for publishing Pub/Sub messages.
    - `packages/backend/shared/src/pubsub/pubsub.module.ts`: Shared Pub/Sub module.
    - `packages/backend/services/user-service/src/user.service.ts`: Add Pub/Sub publish calls after DB operations.
    - `packages/backend/services/patient-service/src/patient.service.ts`: Add Pub/Sub publish calls after DB operations.
    - `packages/backend/shared/src/utils/diff.utils.ts`: Utility functions for generating diffs (e.g., for JSONB updates).
  - **Step Dependencies**: Step 44 (Audit Service can receive/write events), Step 8 (Pub/Sub topics), Steps 24-27 (User Service APIs), Steps 32-34 (Patient Service APIs), Step 28 (Backend Auth - provides user context).
  - **User Instructions**: Deploy the User Service and Patient Service. Perform actions that modify user or patient data via their APIs (e.g., invite user, update patient). Verify that new messages appear in the `audit.events` Pub/Sub topic and that the Audit Service successfully consumes them and writes corresponding entries to the Audit Database. Check the `change_details` for updates to ensure diffs are captured.

- [ ] Step 46: Implement Audit Service - Get Audit Logs API
  - **Task**: Implement the `GET /audit-logs/:entityType/:entityId` API endpoint in the Audit Service. This endpoint should accept the type and ID of an entity (e.g., `documentation`, `patient`). Query the Audit Database (Bigtable or Optimized PostgreSQL) to retrieve all audit log entries associated with that entity ID, ordered by timestamp. Implement basic filtering (e.g., by date range) if needed. Ensure the requesting user has permission to view audit logs for this entity (e.g., Care Manager/Admin for agency data, potentially restricted for Caregivers).
  - **Files**:
    - `packages/backend/services/audit-service/src/audit.controller.ts`: Add `GET /audit-logs/:entityType/:entityId` route.
    - `packages/backend/services/audit-service/src/audit.service.ts`: Implement logic to query Audit DB.
    - `packages/backend/services/audit-service/src/dtos/audit-log.dto.ts`: DTO for audit log response data.
    - `packages/backend/services/audit-service/src/audit.repository.ts`: Implement query methods for Audit DB.
    - `packages/backend/services/audit-service/src/auth/audit-rbac.guard.ts`: Custom Guard for audit log access permissions.
  - **Step Dependencies**: Step 44 (Audit Service can write logs), Step 18 (Audit DB setup), Step 28 (Backend Auth - provides user context).
  - **User Instructions**: Deploy the Audit Service. Ensure some audit logs exist for a test patient or user (from Step 45). Obtain a valid JWT for a user with permission to view audit logs (Care Manager/Admin). Use an API client to call the new endpoint, requesting logs for a test entity. Verify that the relevant audit log entries are returned.

- [ ] Step 47: Implement Web Frontend - View Audit History UI (Basic List)
  - **Task**: In the React frontend, implement a basic UI component to display the audit history for an entity. This component will be used within the Patient Profile view (and potentially others later). Add a "View Edit History" button (visible if the entity has been modified). When clicked, display a modal or new section that fetches audit logs using the `GET /audit-logs/:entityType/:entityId` API (from Step 46) and displays them in a chronological list. Initially, just show the timestamp, user, action, and a simplified view of the change details. Character-level diff visualization comes later.
  - **Files**:
    - `packages/frontend/src/features/patient/components/patient-audit-history.tsx`: Component to display audit history.
    - `packages/frontend/src/features/patient/pages/view-edit-patient.tsx`: Integrate the audit history component and button.
    - `packages/frontend/src/features/patient/services/patient.api.ts`: Add API call to fetch audit logs (or create a shared audit API service).
    - `packages/frontend/src/features/audit/services/audit.api.ts`: (Alternative) Shared audit API service.
    - `packages/frontend/src/features/audit/types/audit.ts`: TypeScript types for audit log data.
    - `packages/frontend/src/components/design-system/Modal.tsx`: Use modal component.
  - **Step Dependencies**: Step 46 (GET /audit-logs API), Step 38 (Web Patient Profile UI), Step 40 (Frontend RBAC - ensure button is only visible to authorized users).
  - **User Instructions**: Log in as a Care Manager or Admin. Navigate to a patient profile that has been modified (generating audit logs). Click the "View Edit History" button. Verify that a list of audit entries is displayed in a modal/section.

## 6. Daily Care Documentation Core

<thinking>The core function of the mobile app is daily care documentation. This section focuses on implementing the fundamental ability to create, view, and edit documentation entries via typing, along with the necessary backend APIs and initial RBAC enforcement.

**Section 6: Daily Care Documentation Core**

*   Step 48: Documentation Service - Create Documentation API (Typing)
*   Step 49: Documentation Service - Get/List Documentation API (Log)
*   Step 50: Documentation Service - Get Single Documentation Entry API
*   Step 51: Documentation Service - Update Documentation API (Basic Edit)
*   Step 52: Documentation Service - RBAC Enforcement (Agency, Patient Assignment, Edit Permissions)
*   Step 53: Backend Services - Publish Audit Events (Documentation changes)
*   Step 54: Mobile Frontend - Documentation Entry UI (Typing Mode)
*   Step 55: Mobile Frontend - Documentation Log UI
*   Step 56: Mobile Frontend - View/Edit Documentation Entry UI (Basic Edit)
*   Step 57: Web Frontend - Documentation Log & View Entry UI

This builds on the Documentation Service structure and DB model, integrating backend auth/RBAC and starting the mobile frontend implementation.- [ ] Step 48: Implement Documentation Service - Create Documentation API (Typing)
  - **Task**: Implement the `POST /documentation` API endpoint in the Documentation Service. This endpoint will initially handle documentation entries created by typing. Accept documentation data (`patient_id`, `timestamp`, `text_content`, `structured_data`) via a DTO (`CreateDocumentationDto`). Validate the input. Use TypeORM/Sequelize to save the new entry to the PostgreSQL `documentation_entries` table. Associate the entry with the requesting user (`caregiver_user_id`) and their agency (`agency_id`) from the authenticated user context. Set the initial `version` to 1.
  - **Files**:
    - `packages/backend/services/documentation-service/src/documentation.controller.ts`: Add `POST /documentation` route.
    - `packages/backend/services/documentation-service/src/documentation.service.ts`: Implement create logic.
    - `packages/backend/services/documentation-service/src/dtos/create-documentation.dto.ts`: DTO for documentation creation.
    - `packages/backend/services/documentation-service/src/documentation.repository.ts`: Add method to save documentation entry.
  - **Step Dependencies**: Step 14 (DocumentationEntry DB model), Step 22 (DB migrations run), Step 28 (Backend Auth - need user context).
  - **User Instructions**: Deploy the Documentation Service. Obtain a valid JWT for a Caregiver. Use an API client to send a POST request to `/documentation` with valid data (including a `patient_id` the caregiver is assigned to - assignments still manual for now). Verify a new record is created in the `documentation_entries` table, linked to the correct user, agency, and patient, with `version` 1.

- [ ] Step 49: Implement Documentation Service - Get/List Documentation API (Log)
  - **Task**: Implement the `GET /documentation/:patientId/log` API endpoint in the Documentation Service. This endpoint should return a paginated list of documentation entries for a specific patient, ordered by timestamp descending. Query the `documentation_entries` table, filtering by `patient_id`. Implement pagination and sorting based on query parameters.
  - **Files**:
    - `packages/backend/services/documentation-service/src/documentation.controller.ts`: Add `GET /documentation/:patientId/log` route.
    - `packages/backend/services/documentation-service/src/documentation.service.ts`: Implement list logic.
    - `packages/backend/services/documentation-service/src/dtos/documentation.dto.ts`: DTOs for documentation list items.
    - `packages/backend/services/documentation-service/src/documentation.repository.ts`: Add method to find documentation entries by patient.
  - **Step Dependencies**: Step 14 (DocumentationEntry DB model), Step 22 (DB migrations run).
  - **User Instructions**: Deploy the Documentation Service. Ensure some documentation entries exist for a test patient (from Step 48). Obtain a valid JWT. Use an API client to send a GET request to `/documentation/:patientId/log`. Verify that the list of entries for that patient is returned, sorted correctly.

- [ ] Step 50: Implement Documentation Service - Get Single Documentation Entry API
  - **Task**: Implement the `GET /documentation/:id` API endpoint in the Documentation Service. This endpoint should return the full details of a single documentation entry by its ID. Query the `documentation_entries` table by ID.
  - **Files**:
    - `packages/backend/services/documentation-service/src/documentation.controller.ts`: Add `GET /documentation/:id` route.
    - `packages/backend/services/documentation-service/src/documentation.service.ts`: Implement get single logic.
    - `packages/backend/services/documentation-service/src/dtos/documentation.dto.ts`: Ensure DTO includes full details.
    - `packages/backend/services/documentation-service/src/documentation.repository.ts`: Add method to find documentation entry by ID.
  - **Step Dependencies**: Step 14 (DocumentationEntry DB model), Step 22 (DB migrations run).
  - **User Instructions**: Deploy the Documentation Service. Ensure a documentation entry exists (from Step 48). Obtain a valid JWT. Use an API client to send a GET request to `/documentation/:id`. Verify that the full details of the entry are returned.

- [ ] Step 51: Implement Documentation Service - Update Documentation API (Basic Edit)
  - **Task**: Implement the `PUT /documentation/:id` API endpoint in the Documentation Service. Accept the entry ID and updated data (`text_content`, `structured_data`) via a DTO (`UpdateDocumentationDto`). Validate the input. Use TypeORM/Sequelize to update the existing documentation entry in the `documentation_entries` table. Increment the `version` field.
  - **Files**:
    - `packages/backend/services/documentation-service/src/documentation.controller.ts`: Add `PUT /documentation/:id` route.
    - `packages/backend/services/documentation-service/src/documentation.service.ts`: Implement update logic, including version increment.
    - `packages/backend/services/documentation-service/src/dtos/update-documentation.dto.ts`: DTO for documentation update.
    - `packages/backend/services/documentation-service/src/documentation.repository.ts`: Add method to update documentation entry.
  - **Step Dependencies**: Step 14 (DocumentationEntry DB model), Step 22 (DB migrations run), Step 50 (GET /documentation/:id to verify existence).
  - **User Instructions**: Deploy the Documentation Service. Create a test documentation entry (Step 48). Obtain a valid JWT. Use an API client to send a PUT request to update the entry. Verify the record is updated in the database and the `version` field is incremented.

- [ ] Step 52: Implement Documentation Service - RBAC Enforcement (Agency, Patient Assignment, Edit Permissions)
  - **Task**: Enhance the Documentation Service API endpoints (`POST /documentation`, `GET /documentation/:patientId/log`, `GET /documentation/:id`, `PUT /documentation/:id`) to enforce Role-Based Access Control.
    *   `POST /documentation`: Only allow users with `documentation:create` permission (e.g., Caregiver, Care Manager). Verify the `patient_id` belongs to the user's agency and, if the user is a Caregiver, that they are assigned to the patient.
    *   `GET /documentation/:patientId/log`, `GET /documentation/:id`: Only allow users with `documentation:read` permission (all roles). Verify the patient belongs to the user's agency and, if the user is a Caregiver, that they are assigned to the patient.
    *   `PUT /documentation/:id`: Only allow users with `documentation:update` permission. This permission will be conditional: Caregivers can only update *their own* entries *within a recent time window* (define window, e.g., 24 hours). Care Managers can update *any* entry within their agency. Implement this logic in the service methods after checking the base permission.
  - **Files**:
    - `packages/backend/services/documentation-service/src/documentation.controller.ts`: Apply `@UseGuards(JwtAuthGuard, RolesGuard)` and `@Roles(...)` decorators.
    - `packages/backend/services/documentation-service/src/documentation.service.ts`: Implement detailed permission checks within methods (check user role, agency, patient assignment, entry ownership, entry timestamp for updates).
    - `packages/backend/services/documentation-service/src/auth/documentation-rbac.guard.ts`: Custom Guard for complex documentation permissions.
    - `packages/backend/services/documentation-service/src/documentation.repository.ts`: Add methods to fetch entry with user/patient/agency details for checks.
  - **Step Dependencies**: Step 28 (Backend Auth - provides user context), Step 37 (Patient Assignment logic - need to call User Service or Patient Service to check assignments), Steps 48-51 (Documentation APIs implemented).
  - **User Instructions**: Deploy the Documentation Service. Obtain JWTs for different users (Caregiver assigned to Patient A, Caregiver not assigned to Patient A, Care Manager for Patient A's agency, Admin). Test accessing/modifying documentation for Patient A using each user. Verify permissions are enforced correctly, including the caregiver's time window and ownership restriction for edits.

- [ ] Step 53: Implement Backend Services - Publish Audit Events (Documentation changes)
  - **Task**: Modify the Documentation Service to publish audit event messages to the `audit.events` Pub/Sub topic whenever a documentation entry is created or updated.
    1.  After saving a new entry (`POST /documentation`), publish a `documentation:create` event with a snapshot of the entry.
    2.  After updating an entry (`PUT /documentation/:id`), calculate the character-level diff between the original and updated `text_content` and a key-value diff for `structured_data`. Publish a `documentation:update` event including these diffs in the `change_details`.
  - **Files**:
    - `packages/backend/services/documentation-service/src/documentation.service.ts`: Add Pub/Sub publish calls after create/update DB operations.
    - `packages/backend/shared/src/utils/diff.utils.ts`: Implement/enhance diffing logic for text and JSONB.
    - `packages/backend/shared/src/pubsub/pubsub.service.ts`: Use shared Pub/Sub service.
  - **Step Dependencies**: Step 45 (Audit event publishing mechanism), Step 48, 51 (Documentation Create/Update APIs), Step 44 (Audit Service can receive/write events).
  - **User Instructions**: Deploy the Documentation Service. Create and update test documentation entries via the API. Verify that `documentation:create` and `documentation:update` events appear in the `audit.events` Pub/Sub topic and are written to the Audit Database by the Audit Service. Check the audit logs for updates to ensure diffs are captured correctly.

- [ ] Step 54: Implement Mobile Frontend - Documentation Entry UI (Typing Mode)
  - **Task**: In the Flutter mobile app, implement the UI for creating a new documentation entry via typing. Create the `DocumentationEntryPage`. Include a large text area for `text_content` and dynamic form fields for `structured_data` (initially, hardcode a few common structured fields or use a simple JSON form builder placeholder). Add input validation. Implement "Save" and "Cancel" buttons. Connect the "Save" button to call the `POST /documentation` API (from Step 48). Handle API success/failure feedback.
  - **Files**:
    - `packages/mobile/lib/src/features/documentation/pages/documentation_entry_page.dart`: Main documentation screen.
    - `packages/mobile/lib/src/features/documentation/widgets/text_input_section.dart`: Widget for text area.
    - `packages/mobile/lib/src/features/documentation/widgets/structured_data_form.dart`: Widget for structured fields (placeholder).
    - `packages/mobile/lib/src/services/documentation_api.dart`: API client calls for documentation endpoints.
    - `packages/mobile/lib/src/models/documentation_entry.dart`: Dart model for documentation entry.
    - `packages/mobile/lib/src/design_system/widgets/buttons.dart`: Use design system buttons.
  - **Step Dependencies**: Step 48 (POST /documentation API), Step 41 (Mobile Patient List - navigate from here), Step 42 (Mobile Patient Profile - link from here), Step 29 (Frontend Auth - mobile equivalent), Step 71 (Design System components - placeholder).
  - **User Instructions**: Log in to the mobile app as a Caregiver. Navigate to an assigned patient's profile. Find/Add a button to "Start Documentation". Navigate to the Documentation Entry page. Enter text and structured data. Tap "Save". Verify the entry is created in the backend database.

- [ ] Step 55: Implement Mobile Frontend - Documentation Log UI
  - **Task**: In the Flutter mobile app, implement the Documentation Log UI for a patient. This screen is accessed from the patient profile (Step 42). Fetch the list of documentation entries using the `GET /documentation/:patientId/log` API (from Step 49). Display the entries in a chronological list using cards or list tiles, showing summary information (timestamp, caregiver, first few lines of text). Implement pagination for the list. Use design system components. Link tapping an entry to the view/edit documentation entry screen (Step 56).
  - **Files**:
    - `packages/mobile/lib/src/features/documentation/pages/documentation_log_page.dart`: Documentation log screen.
    - `packages/mobile/lib/src/features/documentation/widgets/documentation_list_item.dart`: Widget for displaying an entry in the list.
    - `packages/mobile/lib/src/services/documentation_api.dart`: Update API client for log endpoint.
  - **Step Dependencies**: Step 49 (GET /documentation/:patientId/log API), Step 42 (Mobile Patient Profile - navigate from here), Step 71 (Design System components - placeholder).
  - **User Instructions**: Log in to the mobile app as a Caregiver. Navigate to an assigned patient's profile. Tap the link/button to view the Documentation Log. Verify the list of entries for that patient is displayed.

- [ ] Step 56: Implement Mobile Frontend - View/Edit Documentation Entry UI (Basic Edit)
  - **Task**: In the Flutter mobile app, implement the UI for viewing and basic editing of a documentation entry. This screen is accessed from the Documentation Log (Step 55). Fetch the full entry details using the `GET /documentation/:id` API (from Step 50). Display the details. Implement an "Edit" button (visible/enabled based on backend permissions - Caregiver's own recent entries). Tapping "Edit" should make the text area and structured fields editable. Implement "Save" and "Cancel" buttons for the edit mode. Connect "Save" to call the `PUT /documentation/:id` API (from Step 51). Handle API success/failure.
  - **Files**:
    - `packages/mobile/lib/src/features/documentation/pages/view_edit_documentation_page.dart`: View/Edit screen.
    - `packages/mobile/lib/src/features/documentation/widgets/documentation_details.dart`: Widget for displaying details.
    - `packages/mobile/lib/src/features/documentation/widgets/documentation_edit_form.dart`: Widget for editing (reusing parts of Step 54).
    - `packages/mobile/lib/src/services/documentation_api.dart`: Update API client for get/put single entry.
  - **Step Dependencies**: Step 50 (GET /documentation/:id API), Step 51 (PUT /documentation/:id API), Step 55 (Mobile Documentation Log), Step 52 (Backend RBAC - edit permissions).
  - **User Instructions**: Log in to the mobile app as a Caregiver. Create a documentation entry (Step 54). View the Documentation Log (Step 55). Tap the entry to view details. Verify the "Edit" button is visible (within the time window). Tap "Edit", make changes, and save. Verify changes are saved in the backend. Log in as a Caregiver and view an entry created by another caregiver or an entry older than the edit window. Verify the "Edit" button is not visible/enabled.

- [ ] Step 57: Implement Web Frontend - Documentation Log & View Entry UI
  - **Task**: In the React frontend (for Care Managers/Admins), implement the Documentation Log and View Entry UI. Add a "Documentation Log" tab to the Patient Profile page (Step 38). Implement a component to display the list of entries fetched from `GET /documentation/:patientId/log` (Step 49), similar to the mobile log (Step 55). Implement a modal or separate page to view the full details of an entry fetched from `GET /documentation/:id` (Step 50). Implement the "Edit" button (visible/enabled based on Care Manager/Admin permissions - Step 52) and connect it to the `PUT /documentation/:id` API (Step 51).
  - **Files**:
    - `packages/frontend/src/features/patient/pages/view-edit-patient.tsx`: Add Documentation Log tab.
    - `packages/frontend/src/features/documentation/components/documentation-log-list.tsx`: Component for the log list.
    - `packages/frontend/src/features/documentation/components/documentation-view-modal.tsx`: Modal for viewing entry details.
    - `packages/frontend/src/features/documentation/components/documentation-edit-form.tsx`: Component for editing (reusing parts of Step 38 forms).
    - `packages/frontend/src/features/documentation/services/documentation.api.ts`: API client calls for documentation endpoints.
    - `packages/frontend/src/features/documentation/types/documentation.ts`: TypeScript types.
  - **Step Dependencies**: Step 49 (GET /documentation/:patientId/log API), Step 50 (GET /documentation/:id API), Step 51 (PUT /documentation/:id API), Step 38 (Web Patient Profile UI), Step 52 (Backend RBAC - edit permissions).
  - **User Instructions**: Log in as a Care Manager. Navigate to a patient profile. Click the "Documentation Log" tab. Verify the list of entries is displayed. Click an entry to view details. Verify the "Edit" button is visible. Click "Edit", make changes, and save. Verify changes are saved.

## 7. Voice-to-Text Implementation

<thinking>Adding voice documentation is a key feature. This involves integrating with Google Speech-to-Text, handling audio uploads to GCS, setting up asynchronous processing via Pub/Sub, and updating the mobile UI to support voice input.

**Section 7: Voice-to-Text Implementation**

*   Step 58: Documentation Service - GCS Pre-signed URL API
*   Step 59: Documentation Service - Pub/Sub Topic for Voice Processing
*   Step 60: Backend Worker - Voice Processing Pub/Sub Subscriber (Cloud Run)
*   Step 61: Backend Worker - Google Speech-to-Text Integration
*   Step 62: Backend Worker - Save Transcription & Publish Audit
*   Step 63: Backend Worker - Speech-to-Text Rate Limiting (Redis/PubSub Queue)
*   Step 64: Mobile Frontend - Voice Recording UI & GCS Upload
*   Step 65: Mobile Frontend - Voice Processing State & Transcription Display

This section introduces a new backend worker service and integrates GCS and Speech-to-Text, building on the core documentation feature and Pub/Sub infrastructure.- [ ] Step 58: Implement Documentation Service - GCS Pre-signed URL API
  - **Task**: Implement the `POST /documentation/upload-audio` API endpoint in the Documentation Service. This endpoint should accept `patientId` and `audioFormat` in the request body. Validate input and permissions (user must be assigned to the patient). Generate a unique GCS object path (e.g., `audio/agencyId/patientId/documentationEntryId/timestamp.format`). Use the Google Cloud Storage Node.js SDK to generate a signed URL with PUT method permissions for this object path, allowing the mobile client to upload the audio file directly to GCS. Return the signed URL and the object path to the client.
  - **Files**:
    - `packages/backend/services/documentation-service/src/documentation.controller.ts`: Add `POST /documentation/upload-audio` route.
    - `packages/backend/services/documentation-service/src/documentation.service.ts`: Implement logic to generate signed URL.
    - `packages/backend/services/documentation-service/src/dtos/upload-audio.dto.ts`: DTO for audio upload request.
    - `packages/backend/services/documentation-service/src/gcs/gcs.service.ts`: Service for GCS interactions (signed URLs).
    - `packages/backend/services/documentation-service/src/gcs/gcs.module.ts`: NestJS module for GCS.
    - `packages/backend/services/documentation-service/src/config/gcs.config.ts`: GCS configuration (bucket name).
  - **Step Dependencies**: Step 7 (GCS buckets setup), Step 52 (Backend RBAC - patient assignment check).
  - **User Instructions**: Deploy the Documentation Service. Obtain a valid JWT for a Caregiver assigned to a patient. Use an API client to send a POST request to `/documentation/upload-audio` with a valid `patientId`. Verify a signed URL and object path are returned.

- [ ] Step 59: Define Pub/Sub Topic for Voice Processing
  - **Task**: Ensure the `voice.recordings` Pub/Sub topic (created in Step 8) is ready. Define the message payload structure for this topic: it should include the GCS object path of the uploaded audio, the associated `documentationEntryId` (if adding audio to an existing draft), `patientId`, `caregiverUserId`, `agencyId`, and `audioFormat`.
  - **Files**:
    - `packages/backend/shared/src/dtos/voice-recording-event.dto.ts`: Define DTO for the Pub/Sub message payload.
  - **Step Dependencies**: Step 8 (Pub/Sub topics).
  - **User Instructions**: No specific user action needed beyond verifying the topic exists (Step 8).

- [ ] Step 60: Implement Backend Worker - Voice Processing Pub/Sub Subscriber (Cloud Run)
  - **Task**: Create a new NestJS application specifically for the voice processing worker (e.g., `voice-processor-worker`). Configure this application to subscribe to the `voice.recordings` Pub/Sub topic (from Step 59). If using Cloud Run, configure the service to be triggered by Pub/Sub messages. If using GKE, implement a Pub/Sub pull subscriber. The worker should receive the message payload and extract the GCS object path and other metadata.
  - **Files**:
    - `packages/backend/services/voice-processor-worker/package.json`: Worker dependencies.
    - `packages/backend/services/voice-processor-worker/src/main.ts`: Worker entry point.
    - `packages/backend/services/voice-processor-worker/src/app.module.ts`: Worker root module.
    - `packages/backend/services/voice-processor-worker/src/voice-processor.module.ts`: Worker logic module.
    - `packages/backend/services/voice-processor-worker/src/voice-processor.controller.ts` (if Cloud Run push): Endpoint to receive messages.
    - `packages/backend/services/voice-processor-worker/src/voice-processor.service.ts`: Service to process messages.
    - `packages/infrastructure/gcp/modules/cloudrun/main.tf` (if Cloud Run): Define Cloud Run service triggered by Pub/Sub.
    - `packages/infrastructure/gcp/modules/gke/main.tf` (if GKE): Define deployment for worker.
    - `packages/infrastructure/gcp/modules/pubsub/main.tf`: Add subscription for `voice.recordings` topic, linking to worker deployment.
  - **Step Dependencies**: Step 11 (Backend structure), Step 59 (Voice Pub/Sub topic), Step 4 (IaC foundation).
  - **User Instructions**: Update and apply IaC to deploy the worker and create its Pub/Sub subscription. Manually publish a test message to the `voice.recordings` topic. Verify that the worker receives the message (check worker logs).

- [ ] Step 61: Implement Backend Worker - Google Speech-to-Text Integration
  - **Task**: In the voice processing worker (from Step 60), install the Google Cloud Speech-to-Text Node.js SDK. Configure the SDK with appropriate GCP credentials (service account with Speech-to-Text permissions, using Workload Identity in GKE or service account key file securely). Implement logic to download the audio file from GCS (using the object path from the Pub/Sub message) and send it to the Google Speech-to-Text API for transcription. Handle different audio formats.
  - **Files**:
    - `packages/backend/services/voice-processor-worker/package.json`: Add Google Cloud Speech-to-Text SDK dependency.
    - `packages/backend/services/voice-processor-worker/src/speech-to-text/speech-to-text.service.ts`: Service for Speech-to-Text API calls.
    - `packages/backend/services/voice-processor-worker/src/speech-to-text/speech-to-text.module.ts`: NestJS module.
    - `packages/backend/services/voice-processor-worker/src/voice-processor.service.ts`: Integrate Speech-to-Text service call.
    - `packages/backend/services/voice-processor-worker/src/gcs/gcs.service.ts`: Service for GCS download.
  - **Step Dependencies**: Step 60 (Voice worker setup), Step 7 (GCS buckets), Step 2 (GCP credentials/IAM).
  - **User Instructions**: Deploy the worker. Upload a test audio file to GCS (e.g., using `gsutil`). Manually publish a Pub/Sub message to `voice.recordings` referencing this file. Verify in the worker logs that the audio is downloaded and sent to the Speech-to-Text API, and that a transcription response is received.

- [ ] Step 62: Implement Backend Worker - Save Transcription and Publish Audit
  - **Task**: In the voice processing worker (from Step 61), after successfully obtaining the transcription text from Speech-to-Text, update the corresponding `DocumentationEntry` in the PostgreSQL database (using the `documentationEntryId` from the Pub/Sub message). Save the transcription text to the `text_content` field. Increment the `version` field of the documentation entry. Publish an audit event (`documentation:transcribed`) to the `audit.events` topic (from Step 45), including the entry ID, user ID, timestamp, and the transcription text.
  - **Files**:
    - `packages/backend/services/voice-processor-worker/src/voice-processor.service.ts`: Add logic to update DB and publish audit event.
    - `packages/backend/services/voice-processor-worker/src/documentation/documentation.service.ts`: Internal service client to call Documentation Service update logic (or directly update DB if worker has access).
    - `packages/backend/services/voice-processor-worker/src/documentation/documentation.module.ts`: NestJS module for Documentation interaction.
    - `packages/backend/services/voice-processor-worker/src/pubsub/pubsub.service.ts`: Use shared Pub/Sub service to publish audit event.
  - **Step Dependencies**: Step 61 (Speech-to-Text integration), Step 51 (Documentation Update API - or direct DB access), Step 45 (Audit event publishing mechanism), Step 14 (DocumentationEntry DB model).
  - **User Instructions**: Deploy the worker. Upload a test audio file to GCS and publish a Pub/Sub message referencing it and a test documentation entry ID. Verify in the worker logs that transcription is successful, the documentation entry in PostgreSQL is updated with the transcription, and a `documentation:transcribed` audit event is published and appears in the Audit DB.

- [ ] Step 63: Implement Backend Worker - Speech-to-Text Rate Limiting
  - **Task**: Implement a mechanism to manage calls to the Google Speech-to-Text API to avoid hitting rate limits. Use Redis (from Step 6) as a distributed counter or a queueing mechanism via Pub/Sub (from Step 8).
    *   **Option A (Redis Counter):** Before calling the Speech-to-Text API in the worker, check/increment a counter in Redis. If the limit is reached, delay processing or move the message to a delayed queue topic.
    *   **Option B (Pub/Sub Queue):** Modify the logic that publishes to `voice.recordings` (or add a new step). Instead of directly processing, publish to a `queue.speech-to-text` topic. The worker subscribes to this queue, but its subscription is configured with a low message delivery rate limit in Pub/Sub, effectively throttling consumption.
  - **Files**:
    - `packages/backend/services/voice-processor-worker/src/voice-processor.service.ts`: Implement rate limiting logic (Option A or B).
    - `packages/backend/services/voice-processor-worker/src/redis/redis.service.ts`: Service for Redis interaction (Option A).
    - `packages/backend/services/voice-processor-worker/src/redis/redis.module.ts`: NestJS module for Redis (Option A).
    - `packages/infrastructure/gcp/modules/pubsub/main.tf`: Configure subscription rate limits for `queue.speech-to-text` (Option B) or add delayed queue topic/subscription (Option A or B).
  - **Step Dependencies**: Step 61 (Speech-to-Text integration), Step 6 (Redis setup), Step 8 (Pub/Sub topics).
  - **User Instructions**: Deploy the worker and update IaC if needed. Simulate high load (e.g., publish many messages to the voice topic quickly). Verify in worker logs or Redis/Pub/Sub monitoring that requests are being throttled or queued according to the implemented mechanism.

- [ ] Step 64: Implement Mobile Frontend - Voice Recording UI and GCS Upload
  - **Task**: In the Flutter mobile app, implement the UI and logic for voice recording. In the Documentation Entry page (Step 54), add the "Voice" input mode UI (microphone icon, recording indicator, timer). Use a Flutter audio recording package. Implement logic to start/stop recording. When recording stops, obtain the audio file path. Call the `POST /documentation/upload-audio` API (from Step 58) to get a signed GCS URL. Upload the recorded audio file directly to GCS using the signed URL (using a Flutter HTTP package). Handle upload progress and errors.
  - **Files**:
    - `packages/mobile/lib/src/features/documentation/pages/documentation_entry_page.dart`: Add Voice mode UI and logic.
    - `packages/mobile/lib/src/features/documentation/widgets/voice_input_section.dart`: Widget for voice recording controls.
    - `packages/mobile/lib/src/services/audio_recorder_service.dart`: Service for audio recording using a package.
    - `packages/mobile/lib/src/services/gcs_upload_service.dart`: Service for uploading to GCS using signed URL.
    - `packages/mobile/lib/src/services/documentation_api.dart`: Add call to get signed URL.
    - `packages/mobile/lib/src/design_system/widgets/icons.dart`: Microphone icon.
  - **Step Dependencies**: Step 54 (Mobile Documentation Entry UI), Step 58 (GCS Pre-signed URL API), Step 7 (GCS buckets).
  - **User Instructions**: Run the mobile app. Log in as a Caregiver. Start a new documentation entry. Switch to Voice mode. Tap the microphone to record. Tap again to stop. Verify the app calls the backend for a signed URL and attempts to upload the audio to GCS. Check GCS bucket to see if the audio file appears.

- [ ] Step 65: Implement Mobile Frontend - Voice Processing State and Transcription Display
  - **Task**: In the Flutter mobile app, update the Documentation Entry UI (from Step 64) to show the "Processing" state after audio upload. Implement a mechanism to receive the transcription result from the backend (this could be via a push notification triggered by the worker, or by polling a status API, or receiving it during the next sync). When the transcription is received, display it in the editable text area, switch the UI mode to "Type", and allow the user to edit it before saving the final entry. Handle transcription errors (e.g., display an error message, keep the raw audio reference).
  - **Files**:
    - `packages/mobile/lib/src/features/documentation/pages/documentation_entry_page.dart`: Add state management for processing/transcribed states.
    - `packages/mobile/lib/src/features/documentation/widgets/voice_input_section.dart`: Add processing indicator UI.
    - `packages/mobile/lib/src/services/sync_status_service.dart`: Service to receive/poll for transcription status (placeholder, links to sync later).
    - `packages/mobile/lib/src/services/fcm_service.dart`: Service to handle incoming FCM notifications (if using push).
  - **Step Dependencies**: Step 64 (Mobile Voice Recording/Upload), Step 62 (Backend Worker saves transcription), Step 73 (FCM Integration - if using push).
  - **User Instructions**: Run the mobile app. Record a voice note. Verify the "Processing" indicator appears. Wait for the backend worker to process. Verify the transcription appears in the text area and the UI switches to Type mode. Edit the transcription and save the entry.

## 8. Templated Entries Implementation

<thinking>Templates are a workflow efficiency feature. This involves creating a Template Service for managing templates and integrating template selection and application into the documentation flow on both web (for admin) and mobile (for caregivers).

**Section 8: Templated Entries Implementation**

*   Step 66: Template Service - CRUD APIs (Admin)
*   Step 67: Template Service - Get Templates API (Filtered by Agency)
*   Step 68: Web Frontend - Template Management UI (Admin)
*   Step 69: Mobile Frontend - Apply Template UI & Logic

This section introduces the Template Service and its associated UI components, building on the core documentation feature.- [ ] Step 66: Implement Template Service - CRUD APIs (Admin)
  - **Task**: Implement the CRUD API endpoints (`POST /templates`, `GET /templates/:id`, `PUT /templates/:id`, `DELETE /templates/:id`) in the Template Service. Accept template data (`agency_id`, `name`, `description`, `free_text_content`, `structured_data_template` JSONB) via DTOs. Validate input. Use TypeORM/Sequelize to save/fetch/update/delete template records in the PostgreSQL `templates` table. Enforce RBAC: restrict these endpoints to users with `template:manage` permission (Agency Admin) and ensure operations are scoped to the user's agency.
  - **Files**:
    - `packages/backend/services/template-service/src/template.controller.ts`: Add CRUD routes.
    - `packages/backend/services/template-service/src/template.service.ts`: Implement CRUD logic.
    - `packages/backend/services/template-service/src/dtos/template.dto.ts`: DTOs for template data.
    - `packages/backend/services/template-service/src/template.repository.ts`: Add CRUD methods.
    - `packages/backend/services/template-service/src/auth/template-rbac.guard.ts`: Custom Guard for template permissions.
  - **Step Dependencies**: Step 16 (Template DB model), Step 22 (DB migrations run), Step 28 (Backend Auth - provides user context), Step 35 (Backend RBAC pattern).
  - **User Instructions**: Deploy the Template Service. Obtain a JWT for an Agency Admin. Use an API client to test creating, getting, updating, and deleting templates. Verify permissions are enforced (e.g., Care Manager cannot access these endpoints).

- [ ] Step 67: Implement Template Service - Get Templates API (Filtered by Agency)
  - **Task**: Implement the `GET /templates` API endpoint in the Template Service. This endpoint should return a list of templates available to the requesting user's agency. Query the `templates` table, filtering by `agency_id` from the user context. This endpoint should be accessible to Caregivers and Care Managers (users who can create documentation).
  - **Files**:
    - `packages/backend/services/template-service/src/template.controller.ts`: Add `GET /templates` route.
    - `packages/backend/services/template-service/src/template.service.ts`: Implement list logic with agency filtering.
    - `packages/backend/services/template-service/src/dtos/template.dto.ts`: DTO for template list items (might be simplified).
    - `packages/backend/services/template-service/src/template.repository.ts`: Add method to find templates by agency.
    - `packages/backend/services/template-service/src/auth/template-rbac.guard.ts`: Update Guard to allow `template:read` for Caregivers/Managers.
  - **Step Dependencies**: Step 16 (Template DB model), Step 22 (DB migrations run), Step 28 (Backend Auth - provides user context).
  - **User Instructions**: Deploy the Template Service. Obtain JWTs for a Caregiver and a Care Manager. Use an API client to call `GET /templates`. Verify that templates belonging to their agency are returned.

- [ ] Step 68: Implement Web Frontend - Template Management UI (Admin)
  - **Task**: In the React frontend, implement the Template Management UI for Agency Administrators at `/dashboard/admin/templates`. Display a table listing templates fetched from the `GET /templates` API (from Step 67). Implement "Create New Template" functionality using a modal/form that calls the `POST /templates` API (Step 66). Implement action menu (kebab icon) for each template row with "Edit" and "Delete" options, calling the `PUT /templates/:id` and `DELETE /templates/:id` APIs (Step 66). Use design system components.
  - **Files**:
    - `packages/frontend/src/features/templates/pages/template-list.tsx`: Template list page.
    - `packages/frontend/src/features/templates/components/template-table.tsx`: Table component.
    - `packages/frontend/src/features/templates/components/template-form-modal.tsx`: Create/Edit template modal.
    - `packages/frontend/src/features/templates/services/template.api.ts`: API client calls for template endpoints.
    - `packages/frontend/src/features/templates/types/template.ts`: TypeScript types.
  - **Step Dependencies**: Step 66 (Template CRUD APIs), Step 67 (GET /templates API), Step 31 (Frontend RBAC pattern), Step 71 (Design System components - placeholder).
  - **User Instructions**: Log in as an Agency Admin. Navigate to the Template Management page. Verify the list of templates is displayed. Test creating, editing, and deleting templates via the UI. Verify changes are reflected in the backend database.

- [ ] Step 69: Implement Mobile Frontend - Apply Template UI and Logic
  - **Task**: In the Flutter mobile app, integrate template selection into the Documentation Entry page (Step 54). Add an "Apply Template" button or selector. When tapped, fetch the list of templates using the `GET /templates` API (from Step 67). Display the list in a modal or dropdown. When a template is selected, populate the `text_content` and `structured_data` fields of the documentation form with the template's content. Ensure the user can still edit the populated fields.
  - **Files**:
    - `packages/mobile/lib/src/features/documentation/pages/documentation_entry_page.dart`: Add "Apply Template" UI element and logic.
    - `packages/mobile/lib/src/features/documentation/widgets/template_selector_modal.dart`: Modal/widget to display template list.
    - `packages/mobile/lib/src/services/template_api.dart`: API client calls for template endpoints.
    - `packages/mobile/lib/src/models/template.dart`: Dart model for template data.
  - **Step Dependencies**: Step 54 (Mobile Documentation Entry UI), Step 67 (GET /templates API), Step 71 (Design System components - placeholder).
  - **User Instructions**: Log in to the mobile app as a Caregiver. Start a new documentation entry. Tap "Apply Template". Select a template. Verify the form fields are populated with the template content. Edit the content and save the entry.

## 9. Secure Messaging (Internal) Implementation

<thinking>Secure internal messaging is another core communication feature. This involves setting up WebSockets for real-time communication, integrating FCM for push notifications, and implementing the backend Messaging Service and frontend UI.

**Section 9: Secure Messaging (Internal) Implementation**

*   Step 70: Messaging Service - WebSocket Gateway Setup
*   Step 71: Messaging Service - Save Message Logic (to DB)
*   Step 72: Messaging Service - Real-time Messaging (WebSocket Broadcast)
*   Step 73: Messaging Service - FCM Integration (Send Push Notifications)
*   Step 74: Messaging Service - Get Conversation History API
*   Step 75: Messaging Service - RBAC Enforcement (Conversation/Patient Assignment)
*   Step 76: Mobile Frontend - Messaging UI (Conversation List, Chat View, Real-time)
*   Step 77: Mobile Frontend - FCM Push Notification Handling
*   Step 78: Web Frontend - Messaging UI (Conversation List, Chat View, Real-time)

This section introduces the Messaging Service, leveraging WebSockets and FCM, and implements the messaging UI on both mobile and web.- [ ] Step 70: Implement Messaging Service - WebSocket Gateway Setup
  - **Task**: In the Messaging Service, set up a WebSocket Gateway using `@nestjs/websockets`. Configure the gateway to listen on a specific port/path. Implement basic connection handling (`@SubscribeMessage('join_conversation')`, `@WebSocketGateway`). Integrate authentication: when a client connects, validate their JWT (passed as a query parameter or in a connection payload) to identify the user and their agency/role. Store active WebSocket connections mapped to user IDs and conversation IDs.
  - **Files**:
    - `packages/backend/services/messaging-service/package.json`: Add `@nestjs/websockets` and WebSocket adapter dependency (e.g., `ws`).
    - `packages/backend/services/messaging-service/src/messaging.gateway.ts`: Implement WebSocket Gateway class.
    - `packages/backend/services/messaging-service/src/messaging.module.ts`: Declare Gateway.
    - `packages/backend/services/messaging-service/src/auth/websocket-auth.guard.ts`: Guard for WebSocket authentication using JWT.
    - `packages/backend/services/messaging-service/src/app.module.ts`: Configure WebSocket adapter.
  - **Step Dependencies**: Step 15 (Messaging Service structure), Step 28 (Backend Auth - JWT validation logic).
  - **User Instructions**: Deploy the Messaging Service. Use a WebSocket client tool (like Postman or a browser console) to attempt connecting to the WebSocket endpoint with and without a valid JWT. Verify that connections are accepted only with valid tokens and the user identity is correctly associated with the connection.

- [ ] Step 71: Implement Messaging Service - Save Message Logic
  - **Task**: In the Messaging Service, implement the logic to save incoming messages. Create a method (e.g., `saveMessage`) that accepts message data (`conversation_id`, `sender_user_id`, `content`). Use TypeORM/Sequelize to save the message to the PostgreSQL `messages` table. This method will be called by the WebSocket gateway when a message is received and potentially by the offline sync process later.
  - **Files**:
    - `packages/backend/services/messaging-service/src/messaging.service.ts`: Implement `saveMessage` method.
    - `packages/backend/services/messaging-service/src/message.repository.ts`: Add method to save message entity.
    - `packages/backend/services/messaging-service/src/dtos/create-message.dto.ts`: DTO for message data.
  - **Step Dependencies**: Step 15 (Message DB model), Step 22 (DB migrations run).
  - **User Instructions**: No direct user instruction for this internal logic step. It will be tested via the WebSocket/API endpoints in subsequent steps.

- [ ] Step 72: Implement Messaging Service - Real-time Messaging (WebSocket Broadcast)
  - **Task**: Enhance the WebSocket Gateway (from Step 70) and Messaging Service (from Step 71) to handle real-time message broadcasting. When a message is received via WebSocket:
    1.  Validate the sender and conversation ID (check if sender is a participant).
    2.  Call the `saveMessage` logic (Step 71).
    3.  Broadcast the new message (using the gateway's server instance) to all *other* connected clients who are currently joined to the same conversation ID.
  - **Files**:
    - `packages/backend/services/messaging-service/src/messaging.gateway.ts`: Add `@SubscribeMessage('send_message')` handler. Implement logic to get connected clients for a conversation and emit the `new_message` event.
    - `packages/backend/services/messaging-service/src/messaging.service.ts`: Add method to get participants for a conversation (might need to call User Service or query `ConversationParticipant`).
  - **Step Dependencies**: Step 70 (WebSocket Gateway setup), Step 71 (Save Message logic), Step 15 (Conversation/Participant DB models).
  - **User Instructions**: Deploy the Messaging Service. Use two separate WebSocket clients (e.g., browser tabs with a simple JS client, or two Postman WebSocket connections) authenticated as different users who are participants in the same test conversation. Have one client send a message. Verify the other client receives the message in real-time via WebSocket.

- [ ] Step 73: Implement Messaging Service - FCM Integration (Send Push Notifications)
  - **Task**: In the Messaging Service, install the Firebase Admin SDK. Configure the SDK with a Firebase service account key (obtained from Firebase Console, stored securely). Implement a service class (`FcmService`) to send push notifications using the SDK. When a message is saved (Step 71), identify recipients who are *not* currently connected via WebSocket to that conversation. Look up their FCM device tokens (need a mechanism to store/retrieve these - add a `fcm_token` column to the `User` table or a separate `Device` table, and an API endpoint for clients to register/update their token). Send a push notification via `FcmService` to these recipients' device tokens. The notification payload should include enough info to identify the message/conversation.
  - **Files**:
    - `packages/backend/services/messaging-service/package.json`: Add `firebase-admin` dependency.
    - `packages/backend/services/messaging-service/src/fcm/fcm.service.ts`: Implement FCM sending logic.
    - `packages/backend/services/messaging-service/src/fcm/fcm.module.ts`: NestJS module for FCM.
    - `packages/backend/services/messaging-service/src/messaging.service.ts`: Add logic to identify offline recipients and call `FcmService`.
    - `packages/backend/shared/src/entities/user.entity.ts` (or new `device.entity.ts`): Add `fcm_token` field or create `Device` entity.
    - `packages/backend/services/user-service/src/user.controller.ts`: Add endpoint `POST /users/me/fcm-token` for clients to register tokens.
    - `packages/backend/services/user-service/src/user.service.ts`: Logic to save FCM token.
  - **Step Dependencies**: Step 71 (Save Message logic), Step 12 (User DB model - or add new Device model), Step 22 (DB migrations run), Firebase Project setup (manual step outside this plan, need service account key).
  - **User Instructions**: Set up a Firebase project and enable FCM. Generate a service account key JSON file and store it securely (placeholder for Secret Manager). Deploy the Messaging Service and User Service. Use an API client to register an FCM token for a test user (requires a real device/emulator to get a token). Send a message via WebSocket from another user. Verify a push notification is received on the device with the registered token when the app is backgrounded.

- [ ] Step 74: Implement Messaging Service - Get Conversation History API
  - **Task**: Implement the `GET /conversations/:patientId/messages` API endpoint in the Messaging Service. This endpoint should return a paginated list of messages for a conversation related to a specific patient, ordered by timestamp ascending (or descending, clarify spec). Query the `messages` table, joining with `conversations` to filter by `patient_id`. Implement pagination (e.g., using a `before` timestamp query parameter).
  - **Files**:
    - `packages/backend/services/messaging-service/src/message.controller.ts`: Add `GET /conversations/:patientId/messages` route.
    - `packages/backend/services/messaging-service/src/message.service.ts`: Implement history retrieval logic.
    - `packages/backend/services/messaging-service/src/dtos/message.dto.ts`: DTO for message history response.
    - `packages/backend/services/messaging-service/src/message.repository.ts`: Add method to find messages by conversation/patient ID.
  - **Step Dependencies**: Step 15 (Message/Conversation DB models), Step 22 (DB migrations run).
  - **User Instructions**: Deploy the Messaging Service. Ensure some messages exist for a test patient conversation. Obtain a valid JWT. Use an API client to call the new endpoint. Verify that message history is returned correctly.

- [ ] Step 75: Implement Messaging Service - RBAC Enforcement (Conversation/Patient Assignment)
  - **Task**: Enhance the Messaging Service (WebSocket Gateway and REST API) to enforce access control based on patient assignment.
    *   WebSocket `join_conversation` and `send_message`: Before allowing a user to join or send a message in a conversation linked to a `patient_id`, verify that the user is assigned to that patient (call User Service or query `PatientAssignment`).
    *   `GET /conversations/:patientId/messages`: Before returning history, verify the requesting user is assigned to the specified `patientId`.
  - **Files**:
    - `packages/backend/services/messaging-service/src/messaging.gateway.ts`: Add assignment checks in handlers.
    - `packages/backend/services/messaging-service/src/message.controller.ts`: Add assignment checks in controller methods.
    - `packages/backend/services/messaging-service/src/auth/messaging-rbac.guard.ts`: Custom Guard for messaging permissions.
    - `packages/backend/services/messaging-service/src/messaging.service.ts`: Add methods to check user assignment for a patient/conversation.
  - **Step Dependencies**: Step 70 (WebSocket Gateway), Step 72 (Real-time messaging), Step 74 (History API), Step 37 (Patient Assignment logic).
  - **User Instructions**: Deploy the Messaging Service. Obtain JWTs for users assigned and not assigned to a test patient. Attempt to join the patient's conversation via WebSocket and fetch history via API using both users. Verify access is denied for the unassigned user.

- [ ] Step 76: Implement Mobile Frontend - Messaging UI (Conversation List, Chat View, Real-time)
  - **Task**: In the Flutter mobile app, implement the Messaging UI. Create a Messaging tab/page. Implement a Conversation List view (e.g., grouped by patient) fetching data from a placeholder API or local data initially. Implement the Chat View page for individual conversations. Connect to the backend WebSocket endpoint (from Step 70), sending the JWT for authentication. Implement sending messages via WebSocket (`send_message` event) and receiving messages in real-time (`new_message` event), updating the UI. Fetch message history on opening a conversation using `GET /conversations/:patientId/messages` (from Step 74). Use design system components for chat bubbles, input area, etc.
  - **Files**:
    - `packages/mobile/lib/src/features/messaging/pages/messaging_page.dart`: Main messaging screen (conversation list).
    - `packages/mobile/lib/src/features/messaging/pages/chat_page.dart`: Individual chat view.
    - `packages/mobile/lib/src/features/messaging/widgets/conversation_list_item.dart`: Widget for conversation list.
    - `packages/mobile/lib/src/features/messaging/widgets/message_bubble.dart`: Widget for chat messages.
    - `packages/mobile/lib/src/services/messaging_api.dart`: API client for history.
    - `packages/mobile/lib/src/services/websocket_service.dart`: Service for WebSocket connection and messaging.
    - `packages/mobile/lib/src/models/conversation.dart`, `packages/mobile/lib/src/models/message.dart`: Dart models.
  - **Step Dependencies**: Step 70 (WebSocket Gateway), Step 74 (History API), Step 75 (Backend RBAC), Step 29 (Frontend Auth - mobile equivalent), Step 71 (Design System components - placeholder).
  - **User Instructions**: Log in to the mobile app. Navigate to the Messaging section. Verify conversation list (placeholder or basic). Open a conversation. Verify history loads. Send a message. Verify it appears in the UI. Have another user send a message (if they are in the same conversation). Verify it appears in real-time.

- [ ] Step 77: Implement Mobile Frontend - FCM Push Notification Handling
  - **Task**: In the Flutter mobile app, integrate Firebase Messaging SDK. Implement logic to obtain the device's FCM token and send it to the backend (User Service `POST /users/me/fcm-token` from Step 73) upon app launch or user login. Implement handlers for receiving FCM notifications (foreground, background, terminated states). When a message notification is received, trigger a UI update (e.g., show a badge on the Messaging tab) or navigate the user to the relevant conversation when the notification is tapped.
  - **Files**:
    - `packages/mobile/lib/src/main.dart`: Initialize Firebase and FCM.
    - `packages/mobile/lib/src/services/fcm_service.dart`: Implement FCM token retrieval and notification handling.
    - `packages/mobile/lib/src/services/user_api.dart`: Add API call to send FCM token to backend.
    - `packages/mobile/lib/src/app.dart`: Add logic for handling notification taps (navigation).
  - **Step Dependencies**: Step 73 (Backend FCM integration), Step 76 (Mobile Messaging UI), Step 29 (Frontend Auth - mobile equivalent).
  - **User Instructions**: Run the mobile app on a real device or emulator with Google Play services. Log in. Verify the app requests/obtains an FCM token and sends it to the backend (check backend logs/DB). Have another user send a message while the app is in the background. Verify a push notification is received. Tap the notification and verify the app opens to the correct conversation.

- [ ] Step 78: Implement Web Frontend - Messaging UI (Conversation List, Chat View, Real-time)
  - **Task**: In the React frontend, implement the Messaging UI for Care Managers/Admins. Create a Messaging page (`/dashboard/messaging`). Implement a Conversation List view (e.g., grouped by patient) fetching data from a placeholder API or local data initially. Implement the Chat View component for individual conversations. Connect to the backend WebSocket endpoint (from Step 70), sending the JWT for authentication. Implement sending messages via WebSocket (`send_message` event) and receiving messages in real-time (`new_message` event), updating the UI. Fetch message history on opening a conversation using `GET /conversations/:patientId/messages` (from Step 74). Use design system components.
  - **Files**:
    - `packages/frontend/src/features/messaging/pages/messaging-page.tsx`: Main messaging screen.
    - `packages/frontend/src/features/messaging/components/conversation-list.tsx`: Conversation list component.
    - `packages/frontend/src/features/messaging/components/chat-view.tsx`: Chat view component.
    - `packages/frontend/src/features/messaging/components/message-bubble.tsx`: Message bubble component.
    - `packages/frontend/src/features/messaging/services/messaging.api.ts`: API client for history.
    - `packages/frontend/src/services/websocket.service.ts`: Shared service for WebSocket connection.
    - `packages/frontend/src/features/messaging/types/messaging.ts`: TypeScript types.
  - **Step Dependencies**: Step 70 (WebSocket Gateway), Step 74 (History API), Step 75 (Backend RBAC), Step 29 (Frontend Auth - web), Step 71 (Design System components - placeholder).
  - **User Instructions**: Log in to the web app as a Care Manager. Navigate to the Messaging section. Verify conversation list (placeholder or basic). Open a conversation. Verify history loads. Send a message. Verify it appears in the UI. Have another user send a message (if they are in the same conversation). Verify it appears in real-time.

## 10. Offline Mode Implementation

<thinking>Offline mode is a critical mobile-specific feature for caregivers. This involves implementing local storage on the mobile device, connectivity detection, background sync logic, and a sophisticated backend sync processor capable of handling conflict resolution.

**Section 10: Offline Mode Implementation**

*   Step 79: Mobile Frontend - Local Storage Setup (Hive/SQLite)
*   Step 80: Mobile Frontend - Connectivity Detection & UI Banners
*   Step 81: Mobile Frontend - Save to Local Storage (Offline/Drafts)
*   Step 82: Mobile Frontend - Background Sync Task Setup (WorkManager/BGTaskScheduler)
*   Step 83: Mobile Frontend - Sync Logic (Read Local, Send to Pub/Sub/API)
*   Step 84: Documentation Service - Pub/Sub Topic for Offline Sync
*   Step 85: Backend Worker - Offline Sync Pub/Sub Subscriber (Cloud Run)
*   Step 86: Backend Worker - Conflict Detection (Versioning/Timestamp)
*   Step 87: Backend Worker - Conflict Resolution (OT/CRDT for Text)
*   Step 88: Backend Worker - Conflict Resolution (Business Rules/Manual Flag for Structured)
*   Step 89: Backend Worker - Save Merged/Resolved Data & Publish Audit
*   Step 90: Backend Worker - Signal Sync Status to Mobile (FCM/API)
*   Step 91: Mobile Frontend - Receive Sync Status & Update Local Data/UI

This section is heavily focused on the mobile app's data layer and background processing, requiring a dedicated backend worker for sync and conflict resolution. It builds on the core documentation feature and Pub/Sub.- [ ] Step 79: Set up Mobile Frontend - Local Storage
  - **Task**: In the Flutter mobile app, integrate a local database solution (Hive or sqflite/SQLite). Choose one based on complexity needs (Hive is simpler for key-value/document, SQLite for more complex queries/relations). Initialize the database. Define local data models mirroring the core server entities (`DocumentationEntry`, potentially `Patient`, `Message`) but adding sync-specific metadata fields (`sync_status`, `local_version`, `pending_ot_ops`, `error_details`).
  - **Files**:
    - `packages/mobile/pubspec.yaml`: Add `hive` / `hive_flutter` or `sqflite` / `path_provider` dependencies.
    - `packages/mobile/lib/src/data/local_database.dart`: Initialize local DB.
    - `packages/mobile/lib/src/data/models/local_documentation_entry.dart`: Define local data model for documentation.
    - `packages/mobile/lib/src/data/repositories/local_documentation_repository.dart`: Repository for local DB operations.
  - **Step Dependencies**: Step 14 (DocumentationEntry DB model - need structure), Step 15 (Message DB model - need structure).
  - **User Instructions**: Run the mobile app. Verify the local database is initialized successfully on the device/emulator.

- [ ] Step 80: Implement Mobile Frontend - Connectivity Detection and UI Banners
  - **Task**: In the Flutter mobile app, integrate a connectivity package (`connectivity_plus`). Implement a service or provider that listens for network status changes. Based on the connectivity status and the app's sync state, display persistent UI banners at the top of relevant screens (e.g., Dashboard, Documentation Entry) as specified in the UI specs ("Offline Mode", "Syncing...", "Sync Complete").
  - **Files**:
    - `packages/mobile/pubspec.yaml`: Add `connectivity_plus` dependency.
    - `packages/mobile/lib/src/services/connectivity_service.dart`: Service to monitor connectivity.
    - `packages/mobile/lib/src/sync/sync_status_service.dart`: Service to manage sync state (placeholder).
    - `packages/mobile/lib/src/common/widgets/status_banner.dart`: Reusable UI widget for banners.
    - `packages/mobile/lib/src/features/dashboard/pages/dashboard_page.dart`: Integrate banner widget.
    - `packages/mobile/lib/src/features/documentation/pages/documentation_entry_page.dart`: Integrate banner widget.
  - **Step Dependencies**: Step 79 (Local Storage - needed for offline saving), Step 71 (Design System components - placeholder).
  - **User Instructions**: Run the mobile app. Toggle network connectivity (Wi-Fi/Cellular, or use emulator network tools). Verify that the "Offline Mode" banner appears when offline.

- [ ] Step 81: Implement Mobile Frontend - Save to Local Storage (Offline/Drafts)
  - **Task**: Modify the save logic in the mobile Documentation Entry page (from Step 54). When the user taps "Save":
    1.  Attempt to save the entry directly to the backend API (`POST /documentation`).
    2.  If the device is offline OR the API call fails (network error), save the entry to the local database (from Step 79) instead. Set its `sync_status` to `pending`.
    3.  If the API call succeeds, save the entry to the local database with `sync_status` as `synced` (this local copy is used for offline viewing/editing later).
    4.  Implement auto-save functionality to local storage periodically while the user is editing, marking the entry as `is_draft = true`.
  - **Files**:
    - `packages/mobile/lib/src/features/documentation/pages/documentation_entry_page.dart`: Modify save button logic and add auto-save timer.
    - `packages/mobile/lib/src/services/documentation_api.dart`: Add error handling for network failures.
    - `packages/mobile/lib/src/data/repositories/local_documentation_repository.dart`: Implement save/update methods for local entries.
    - `packages/mobile/lib/src/sync/sync_status_service.dart`: Update sync status based on save result.
  - **Step Dependencies**: Step 54 (Mobile Documentation Entry UI), Step 79 (Local Storage), Step 80 (Connectivity detection).
  - **User Instructions**: Run the mobile app. Go offline (Step 80). Create a documentation entry and save it. Verify the "Offline Mode" banner is visible and the entry is saved to the local database (check local DB using device tools or logging). Go online. Create an entry and save. Verify it's saved to both backend and local DB. Create an entry, type some text, and leave the page without tapping save. Verify a draft is saved locally.

- [ ] Step 82: Set up Mobile Frontend - Background Sync Task
  - **Task**: Implement background task execution on the mobile app using platform-specific APIs wrapped in a Flutter package (e.g., `workmanager` for Android, `background_fetch` or `bg_tasks` for iOS). Configure a background task that triggers periodically or upon network connectivity changes (detected in Step 80). This task will initiate the sync process.
  - **Files**:
    - `packages/mobile/pubspec.yaml`: Add `workmanager` or `background_fetch` dependency.
    - `packages/mobile/lib/main.dart`: Initialize background task plugin.
    - `packages/mobile/lib/src/sync/background_sync_task.dart`: Define the background task entry point and logic trigger.
    - `packages/mobile/lib/src/services/connectivity_service.dart`: Trigger background task on connectivity change.
  - **Step Dependencies**: Step 80 (Connectivity detection).
  - **User Instructions**: Run the mobile app on a device/emulator. Background the app. Toggle network connectivity. Verify in device logs that the background task is triggered.

- [ ] Step 83: Implement Mobile Frontend - Sync Logic (Read Local, Send to Pub/Sub/API)
  - **Task**: Implement the core sync logic within the background task (from Step 82). This logic should:
    1.  Read all `pending` documentation entries from the local database (Step 79).
    2.  Prepare a batch of these entries, including sync metadata (`local_version`, timestamp, potentially OT operations for text diffs).
    3.  Send this batch to the backend sync endpoint/mechanism. This could be:
        *   Publishing a message to the `offline.sync` Pub/Sub topic (from Step 84) using a Pub/Sub client library for Flutter (if available/suitable for mobile).
        *   Calling a dedicated backend REST API endpoint (`POST /documentation/sync` - defined later).
    4.  Update the status of the entries in the local DB to `syncing`.
    5.  Handle potential network errors during the sync attempt (retry later).
  - **Files**:
    - `packages/mobile/lib/src/sync/sync_service.dart`: Implement the sync logic.
    - `packages/mobile/lib/src/data/repositories/local_documentation_repository.dart`: Add method to get pending entries.
    - `packages/mobile/lib/src/services/documentation_api.dart`: Add `syncDocumentation` API call (if using REST endpoint).
    - `packages/mobile/lib/src/services/pubsub_client.dart`: Pub/Sub client for Flutter (if using Pub/Sub directly).
    - `packages/mobile/lib/src/sync/background_sync_task.dart`: Call `SyncService` from the background task.
    - `packages/mobile/lib/src/models/offline_entry.dart`: Dart model for data sent during sync.
  - **Step Dependencies**: Step 82 (Background task setup), Step 79 (Local Storage), Step 84 (Offline Sync Pub/Sub topic) OR Step 85 (Backend Sync Worker endpoint).
  - **User Instructions**: Run the mobile app. Go offline, create entries, save them locally. Go online. Verify the background task triggers and attempts to send the pending entries to the backend (check backend logs for incoming messages/requests). Verify local entries status changes to `syncing`.

- [ ] Step 84: Define Pub/Sub Topic for Offline Sync
  - **Task**: Ensure the `offline.sync` Pub/Sub topic (created in Step 8) is ready. Define the message payload structure for this topic: it should contain a batch of `OfflineEntryDto` objects, including the entry data, local version information, and potentially OT operations for text diffs. Include a `deviceId` to identify the source device.
  - **Files**:
    - `packages/backend/shared/src/dtos/offline-sync-event.dto.ts`: Define DTO for the Pub/Sub message payload.
    - `packages/backend/shared/src/dtos/offline-entry.dto.ts`: Define DTO for individual entries in the batch.
  - **Step Dependencies**: Step 8 (Pub/Sub topics).
  - **User Instructions**: No specific user action needed beyond verifying the topic exists (Step 8).

- [ ] Step 85: Implement Backend Worker - Offline Sync Pub/Sub Subscriber
  - **Task**: Create a new NestJS application specifically for the offline sync worker (e.g., `offline-sync-worker`). Configure this application to subscribe to the `offline.sync` Pub/Sub topic (from Step 84). Deploy it on Cloud Run triggered by Pub/Sub or as a GKE deployment. The worker should receive the message payload (batch of `OfflineEntryDto`) and iterate through the entries, preparing them for conflict resolution.
  - **Files**:
    - `packages/backend/services/offline-sync-worker/package.json`: Worker dependencies.
    - `packages/backend/services/offline-sync-worker/src/main.ts`: Worker entry point.
    - `packages/backend/services/offline-sync-worker/src/app.module.ts`: Worker root module.
    - `packages/backend/services/offline-sync-worker/src/sync-processor.module.ts`: Worker logic module.
    - `packages/backend/services/offline-sync-worker/src/sync-processor.controller.ts` (if Cloud Run push): Endpoint to receive messages.
    - `packages/backend/services/offline-sync-worker/src/sync-processor.service.ts`: Service to process messages.
    - `packages/infrastructure/gcp/modules/cloudrun/main.tf` (if Cloud Run): Define Cloud Run service triggered by Pub/Sub.
    - `packages/infrastructure/gcp/modules/gke/main.tf` (if GKE): Define deployment for worker.
    - `packages/infrastructure/gcp/modules/pubsub/main.tf`: Add subscription for `offline.sync` topic, linking to worker deployment.
  - **Step Dependencies**: Step 11 (Backend structure), Step 84 (Offline Sync Pub/Sub topic), Step 4 (IaC foundation).
  - **User Instructions**: Update and apply IaC to deploy the worker and create its Pub/Sub subscription. Manually publish a test message to the `offline.sync` topic. Verify that the worker receives the message batch (check worker logs).

- [ ] Step 86: Implement Backend Worker - Conflict Detection (Versioning/Timestamp)
  - **Task**: In the offline sync worker (from Step 85), for each incoming `OfflineEntryDto` that corresponds to an existing entry on the server (check by ID), fetch the current server version of the `DocumentationEntry` from PostgreSQL. Compare the `local_version` from the incoming entry with the server's `version`. If the server version is higher than the local version, a conflict is detected. If the server version is the same or lower, it's a non-conflicting update or a new entry.
  - **Files**:
    - `packages/backend/services/offline-sync-worker/src/sync-processor.service.ts`: Implement conflict detection logic.
    - `packages/backend/services/offline-sync-worker/src/documentation/documentation.service.ts`: Internal service client to fetch server documentation entry by ID and version.
    - `packages/backend/services/offline-sync-worker/src/documentation/documentation.module.ts`: NestJS module for Documentation interaction.
  - **Step Dependencies**: Step 85 (Sync worker setup), Step 14 (DocumentationEntry DB model - needs version field), Step 5 (Cloud SQL setup).
  - **User Instructions**: Deploy the worker. Create a documentation entry via the mobile app (saved locally). Manually update the *same* entry directly in the backend database (incrementing its version). Go online and trigger sync from the mobile app. Verify in the worker logs that the conflict detection logic identifies the entry as conflicted because the server version is higher than the local version sent by the mobile app.

- [ ] Step 87: Implement Backend Worker - Conflict Resolution (OT/CRDT for Text)
  - **Task**: In the offline sync worker (from Step 86), implement conflict resolution specifically for the `text_content` field using Operational Transformation (OT) or Conflict-free Replicated Data Types (CRDTs). If a text conflict is detected (server version > local version), apply the sequence of OT operations (sent from the mobile app, needs to be captured in Step 83) from the local change onto the current server version of the text. Use a suitable library for OT/CRDT. If the transformation is successful, the conflict is resolved automatically for the text field.
  - **Files**:
    - `packages/backend/services/offline-sync-worker/src/sync-processor.service.ts`: Integrate OT/CRDT logic.
    - `packages/backend/services/offline-sync-worker/src/conflict-resolution/text-ot.service.ts`: Service for applying OT operations.
    - `packages/backend/services/offline-sync-worker/src/conflict-resolution/conflict-resolution.module.ts`: NestJS module.
    - `packages/mobile/lib/src/sync/sync_service.dart`: Capture and send OT operations for text edits.
    - `packages/mobile/lib/src/data/models/local_documentation_entry.dart`: Store pending OT operations.
  - **Step Dependencies**: Step 86 (Conflict detection), Step 51 (Documentation Update API), Step 83 (Mobile sync logic - needs to send OT ops).
  - **User Instructions**: Deploy the worker and update mobile app. Create an entry offline. Edit the text offline. Go online. Manually edit the *same* entry's text on the web portal *before* the mobile sync completes. Trigger mobile sync. Verify in worker logs that OT is applied and the text is merged correctly without manual intervention.

- [ ] Step 88: Implement Backend Worker - Conflict Resolution (Business Rules/Manual Flag for Structured)
  - **Task**: In the offline sync worker (from Step 86), implement conflict resolution for the `structured_data` (JSONB) field and other fields (e.g., `is_draft`, `status`). Define business rules for automatic resolution (e.g., latest timestamp wins for simple fields, specific merge logic for structured data based on keys). If automatic resolution is not possible or appropriate for a structured data conflict, mark the entry's status as `conflict` in the main `documentation_entries` table and create a new entry in the `Conflict` table (from Step 92) for manual resolution by a Care Manager.
  - **Files**:
    - `packages/backend/services/offline-sync-worker/src/sync-processor.service.ts`: Implement structured data conflict resolution logic.
    - `packages/backend/services/offline-sync-worker/src/conflict-resolution/structured-data-rules.ts`: Define business rules for structured data merge.
    - `packages/backend/services/offline-sync-worker/src/conflict-resolution/conflict.service.ts`: Service to create `Conflict` entries.
    - `packages/backend/services/offline-sync-worker/src/conflict-resolution/conflict.module.ts`: NestJS module.
  - **Step Dependencies**: Step 86 (Conflict detection), Step 92 (Conflict DB model), Step 51 (Documentation Update API).
  - **User Instructions**: Deploy the worker. Create an entry offline. Edit structured data fields offline. Go online. Manually edit the *same* entry's structured data on the web portal *before* mobile sync. Trigger mobile sync. Verify in worker logs that structured data conflicts are detected and either resolved automatically by rules or flagged for manual resolution (check `documentation_entries` table `status` and `conflicts` table).

- [ ] Step 89: Implement Backend Worker - Save Merged/Resolved Data and Publish Audit
  - **Task**: In the offline sync worker (from Steps 87 and 88), after an entry has been processed (either automatically resolved or flagged as needing manual resolution), save the resulting state to the `documentation_entries` table in PostgreSQL. Increment the `version`. Publish an audit event (`documentation:sync_merge` or `documentation:conflict_detected`) to the `audit.events` topic (from Step 45), including details of the resolution (e.g., final state, diffs, reference to `Conflict` ID if applicable). Acknowledge the Pub/Sub message to prevent redelivery.
  - **Files**:
    - `packages/backend/services/offline-sync-worker/src/sync-processor.service.ts`: Final save and audit publish logic.
    - `packages/backend/services/offline-sync-worker/src/documentation/documentation.service.ts`: Call update method.
    - `packages/backend/services/offline-sync-worker/src/pubsub/pubsub.service.ts`: Publish audit event and acknowledge message.
  - **Step Dependencies**: Steps 87, 88 (Conflict resolution logic), Step 51 (Documentation Update API), Step 45 (Audit event publishing mechanism).
  - **User Instructions**: Deploy the worker. Trigger sync scenarios that result in both automatic resolution and manual conflict flagging. Verify that the `documentation_entries` table is updated correctly, the version is incremented, and corresponding audit events are published and recorded in the Audit DB.

- [ ] Step 90: Implement Backend Worker - Signal Sync Status to Mobile
  - **Task**: In the offline sync worker (from Step 89), after processing a batch of sync entries for a specific device, send a signal back to the mobile client indicating the sync results (which entries succeeded, failed, or conflicted). This can be done by:
    *   Sending an FCM push notification (via Messaging Service or direct FCM call) with a payload summarizing the results for that `deviceId`.
    *   Writing the sync results to a dedicated status table/Redis and having the mobile app poll a status API endpoint.
    *   If the mobile app maintains a WebSocket connection, sending the results back over WS.
    FCM is often preferred for background sync status.
  - **Files**:
    - `packages/backend/services/offline-sync-worker/src/sync-processor.service.ts`: Add logic to send sync results signal.
    - `packages/backend/services/offline-sync-worker/src/messaging/messaging.service.ts`: Internal service client to send FCM (if using Messaging Service).
    - `packages/backend/services/offline-sync-worker/src/fcm/fcm.service.ts`: Direct FCM sending (if not using Messaging Service).
    - `packages/backend/services/offline-sync-worker/src/dtos/sync-result.dto.ts`: DTO for sync results payload.
  - **Step Dependencies**: Step 89 (Worker processing complete), Step 73 (FCM Integration - or alternative signaling mechanism).
  - **User Instructions**: Deploy the worker. Trigger a mobile sync. Verify that the backend worker attempts to send a sync result signal back to the mobile device (check worker logs, FCM logs, or polling endpoint).

- [ ] Step 91: Implement Mobile Frontend - Receive Sync Status and Update Local Data/UI
  - **Task**: In the Flutter mobile app, implement the logic to receive the sync results signal from the backend (from Step 90).
    *   If using FCM: Implement handling for the specific sync result notification payload (from Step 77).
    *   If polling: Implement a background polling mechanism for a sync status API.
    When results are received, update the `sync_status` of the corresponding entries in the local database (Step 79) (`synced`, `conflict`, `error`). Update the UI banners (Step 80) to show "Sync Complete" or "Sync Errors/Conflicts" based on the results. For entries marked `conflict`, update their status and potentially display a visual indicator on the local entry list/view.
  - **Files**:
    - `packages/mobile/lib/src/sync/sync_service.dart`: Implement logic to receive/poll for results and update local DB status.
    - `packages/mobile/lib/src/sync/sync_status_service.dart`: Update sync state and trigger UI banner changes.
    - `packages/mobile/lib/src/data/repositories/local_documentation_repository.dart`: Add method to update entry status.
    - `packages/mobile/lib/src/features/documentation/widgets/documentation_list_item.dart`: Add UI indicator for conflict status.
  - **Step Dependencies**: Step 83 (Mobile sync logic - sends data), Step 90 (Backend signals status), Step 79 (Local Storage), Step 80 (UI Banners).
  - **User Instructions**: Run the mobile app. Trigger sync scenarios (offline saves, manual backend edits causing conflicts). Verify that the app receives the sync results, updates the local database entry statuses, and displays the correct UI banners and conflict indicators.

## 11. Conflict Resolution Dashboard

<thinking>The manual conflict resolution dashboard is a specific UI feature for Care Managers, building on the conflict detection logic implemented in the offline sync process.

**Section 11: Conflict Resolution Dashboard**

*   Step 92: Conflict Model & Storage (PostgreSQL/MDM DB)
*   Step 93: Reporting/Conflict Service - Get Conflicts API
*   Step 94: Reporting/Conflict Service - Resolve Conflict API
*   Step 95: Web Frontend - Conflict Resolution Dashboard UI (List, View, Resolve)

This section introduces the `Conflict` data model and implements the backend APIs and web UI for Care Managers to resolve conflicts flagged during offline sync.- [ ] Step 92: Define Conflict Database Model and Storage
  - **Task**: Define the TypeORM/Sequelize Entity for the `Conflict` table in `packages/backend/shared/src/entities`. Include fields identified in the Data Models section (`id`, `documentation_entry_id`, `patient_id`, `agency_id`, `conflict_timestamp`, `server_version`, `local_version`, `server_data` (JSONB), `local_data` (JSONB), `diff_details` (JSONB), `status`, `resolved_by_user_id`, `resolved_at`, `resolution_type`, `final_data_snapshot` (JSONB)). This table will likely reside in the primary PostgreSQL database or potentially the MDM database if conflict management is considered part of master data governance.
  - **Files**:
    - `packages/backend/shared/src/entities/conflict.entity.ts`: TypeORM/Sequelize Entity definition for `Conflict`.
    - `packages/backend/services/offline-sync-worker/src/conflict-resolution/conflict.repository.ts`: Add repository for `Conflict` entity.
    - `packages/backend/services/offline-sync-worker/src/conflict-resolution/conflict.module.ts`: Add Conflict entity/repository.
    - `packages/backend/services/reporting-service/src/conflict/conflict.repository.ts`: Add repository for `Conflict` entity (if Reporting Service handles conflict APIs).
    - `packages/backend/services/reporting-service/src/conflict/conflict.module.ts`: Add Conflict entity/repository.
  - **Step Dependencies**: Step 88 (Backend Worker flags conflicts), Step 22 (DB migrations setup).
  - **User Instructions**: Update the database migration script (or create a new one) to include the `conflicts` table schema. Run the migration. Verify the table is created in the database.

- [ ] Step 93: Implement Reporting/Conflict Service - Get Conflicts API
  - **Task**: Implement the `GET /conflicts` API endpoint in the Reporting Service (or a dedicated Conflict Service if preferred). This endpoint should return a list of pending conflicts (`status = 'pending_manual'`) for the requesting user's agency. Query the `conflicts` table, filtering by `agency_id` and status. Implement basic filtering (e.g., by patient) and pagination. Enforce RBAC: only allow users with `conflict:resolve` permission (Care Manager, Admin).
  - **Files**:
    - `packages/backend/services/reporting-service/src/conflict/conflict.controller.ts`: Add `GET /conflicts` route.
    - `packages/backend/services/reporting-service/src/conflict/conflict.service.ts`: Implement list logic.
    - `packages/backend/services/reporting-service/src/dtos/conflict.dto.ts`: DTOs for conflict list items and details.
    - `packages/backend/services/reporting-service/src/conflict/conflict.repository.ts`: Add query methods.
    - `packages/backend/services/reporting-service/src/auth/conflict-rbac.guard.ts`: Custom Guard for conflict permissions.
  - **Step Dependencies**: Step 92 (Conflict DB model), Step 22 (DB migrations run), Step 28 (Backend Auth - provides user context), Step 88 (Backend Worker creates conflicts).
  - **User Instructions**: Deploy the Reporting Service. Ensure some conflicts have been flagged by the sync worker (Step 88). Obtain a JWT for a Care Manager. Use an API client to call `GET /conflicts`. Verify that the list of pending conflicts for their agency is returned.

- [ ] Step 94: Implement Reporting/Conflict Service - Resolve Conflict API
  - **Task**: Implement the `POST /conflicts/:id/resolve` API endpoint in the Reporting Service (or dedicated Conflict Service). This endpoint accepts the conflict ID and a resolution payload (`ResolveConflictDto`) specifying the resolution type ('use_server', 'use_local', 'merged') and potentially the final merged data if manual merge was performed in the UI. Validate input. Based on the resolution type:
    1.  Update the original `DocumentationEntry` in PostgreSQL with the chosen data (server, local, or merged). Increment its `version`.
    2.  Update the `Conflict` entry's status to `resolved`, record the `resolved_by_user_id`, `resolved_at`, `resolution_type`, and `final_data_snapshot`.
    3.  Publish an audit event (`documentation:conflict_resolved`) to the `audit.events` topic (from Step 45), detailing the resolution.
    Enforce RBAC: only allow users with `conflict:resolve` permission.
  - **Files**:
    - `packages/backend/services/reporting-service/src/conflict/conflict.controller.ts`: Add `POST /conflicts/:id/resolve` route.
    - `packages/backend/services/reporting-service/src/conflict/conflict.service.ts`: Implement resolution logic (update DocumentationEntry, update Conflict, publish audit).
    - `packages/backend/services/reporting-service/src/dtos/resolve-conflict.dto.ts`: DTO for resolution payload.
    - `packages/backend/services/reporting-service/src/conflict/conflict.repository.ts`: Add update methods.
    - `packages/backend/services/reporting-service/src/documentation/documentation.service.ts`: Internal service client to update DocumentationEntry.
    - `packages/backend/services/reporting-service/src/pubsub/pubsub.service.ts`: Use shared Pub/Sub service.
  - **Step Dependencies**: Step 93 (GET /conflicts API), Step 92 (Conflict DB model), Step 51 (Documentation Update API), Step 45 (Audit event publishing mechanism), Step 28 (Backend Auth - provides user context).
  - **User Instructions**: Deploy the Reporting Service. Ensure some conflicts exist. Obtain a JWT for a Care Manager. Use an API client to call `POST /conflicts/:id/resolve` with different resolution types. Verify that the `Conflict` entry status changes to `resolved`, the original `DocumentationEntry` is updated correctly, and an audit event is published.

- [ ] Step 95: Implement Web Frontend - Conflict Resolution Dashboard UI
  - **Task**: In the React frontend, implement the Care Manager Conflict Resolution Dashboard at `/dashboard/conflicts`. Display a list of pending conflicts fetched from the `GET /conflicts` API (from Step 93). For each conflict, show key information (patient, timestamp, conflicting users). Implement a detailed view (modal or separate page) for a selected conflict, displaying the `server_data`, `local_data`, and `diff_details` (using a diff visualization component - reuse/enhance from Step 47). Provide buttons/controls for the Care Manager to select a resolution type ('Use Server', 'Use Local', 'Manual Merge'). If 'Manual Merge', provide an editable area pre-populated with one version, allowing the manager to create the final version. Connect resolution actions to the `POST /conflicts/:id/resolve` API (from Step 94). Use design system components.
  - **Files**:
    - `packages/frontend/src/features/conflict-resolution/pages/conflict-dashboard.tsx`: Dashboard page.
    - `packages/frontend/src/features/conflict-resolution/components/conflict-list.tsx`: List component.
    - `packages/frontend/src/features/conflict-resolution/components/conflict-details-modal.tsx`: Detailed view modal.
    - `packages/frontend/src/features/conflict-resolution/components/conflict-diff-viewer.tsx`: Component to display diffs (reuse/adapt from audit).
    - `packages/frontend/src/features/conflict-resolution/services/conflict.api.ts`: API client calls.
    - `packages/frontend/src/features/conflict-resolution/types/conflict.ts`: TypeScript types.
    - `packages/frontend/src/components/design-system/DiffViewer.tsx`: Reusable diff viewer component.
  - **Step Dependencies**: Step 93 (GET /conflicts API), Step 94 (POST /conflicts/:id/resolve API), Step 47 (Audit Diff Viewer - can reuse logic), Step 31 (Frontend RBAC - restrict page access), Step 71 (Design System components - placeholder).
  - **User Instructions**: Log in as a Care Manager. Navigate to the Conflict Resolution Dashboard. Verify the list of pending conflicts is displayed. Click on a conflict. Verify the details and diffs are shown. Select a resolution type and submit. Verify the conflict is marked as resolved in the backend and disappears from the list.

## 12. Reporting Implementation

<thinking>Basic activity reports provide oversight for Care Managers and Admins. This involves implementing backend APIs to query and aggregate documentation data and building the corresponding web UI.

**Section 12: Reporting Implementation**

*   Step 96: Reporting Service - Get Caregiver Activity Report API
*   Step 97: Reporting Service - Get Patient Activity Report API
*   Step 98: Reporting Service - RBAC Enforcement (Care Manager/Admin, Agency Scope)
*   Step 99: Web Frontend - Reporting UI (Select Report, Filters, Display Results)

This section introduces the Reporting Service and its web UI, building on the core documentation data and backend auth/RBAC.- [ ] Step 96: Implement Reporting Service - Get Caregiver Activity Report API
  - **Task**: Implement the `GET /reports/caregiver-activity` API endpoint in the Reporting Service. This endpoint should accept query parameters for `startDate`, `endDate`, and optional `caregiverId`. Query the `documentation_entries` table in PostgreSQL. Filter entries by the requesting user's agency, the date range, and the optional caregiver ID. Group the results by caregiver and count the number of entries for each. Return the aggregated data (caregiver name/ID, entry count).
  - **Files**:
    - `packages/backend/services/reporting-service/src/report.controller.ts`: Add `GET /reports/caregiver-activity` route.
    - `packages/backend/services/reporting-service/src/report.service.ts`: Implement query and aggregation logic.
    - `packages/backend/services/reporting-service/src/dtos/report.dto.ts`: DTO for report query parameters and response data.
    - `packages/backend/services/reporting-service/src/report.repository.ts`: Add method for caregiver activity query.
  - **Step Dependencies**: Step 14 (DocumentationEntry DB model), Step 22 (DB migrations run), Step 28 (Backend Auth - provides user context).
  - **User Instructions**: Deploy the Reporting Service. Ensure documentation entries exist for multiple caregivers within an agency. Obtain a JWT for a Care Manager or Admin. Use an API client to call `GET /reports/caregiver-activity` with a date range. Verify that a list of caregivers and their documentation counts is returned for that period within the agency. Test with the optional `caregiverId` filter.

- [ ] Step 97: Implement Reporting Service - Get Patient Activity Report API
  - **Task**: Implement the `GET /reports/patient-activity` API endpoint in the Reporting Service. This endpoint should accept query parameters for `startDate`, `endDate`, and optional `patientId`. Query the `documentation_entries` table in PostgreSQL. Filter entries by the requesting user's agency, the date range, and the optional patient ID. Group the results by patient and count the number of entries for each. Return the aggregated data (patient name/ID, entry count).
  - **Files**:
    - `packages/backend/services/reporting-service/src/report.controller.ts`: Add `GET /reports/patient-activity` route.
    - `packages/backend/services/reporting-service/src/report.service.ts`: Implement query and aggregation logic.
    - `packages/backend/services/reporting-service/src/report.repository.ts`: Add method for patient activity query.
  - **Step Dependencies**: Step 14 (DocumentationEntry DB model), Step 22 (DB migrations run), Step 28 (Backend Auth - provides user context).
  - **User Instructions**: Deploy the Reporting Service. Ensure documentation entries exist for multiple patients within an agency. Obtain a JWT for a Care Manager or Admin. Use an API client to call `GET /reports/patient-activity` with a date range. Verify that a list of patients and their documentation counts is returned for that period within the agency. Test with the optional `patientId` filter.

- [ ] Step 98: Implement Reporting Service - RBAC Enforcement (Care Manager/Admin, Agency Scope)
  - **Task**: Enhance the Reporting Service API endpoints (`GET /reports/*`) to enforce Role-Based Access Control. Only allow users with `report:read` permission (Care Manager, Admin) to access these endpoints. Ensure all queries are strictly scoped to the requesting user's agency.
  - **Files**:
    - `packages/backend/services/reporting-service/src/report.controller.ts`: Apply `@UseGuards(JwtAuthGuard, RolesGuard)` and `@Roles('report:read')` decorators.
    - `packages/backend/services/reporting-service/src/report.service.ts`: Ensure all repository calls include agency ID filtering based on user context.
    - `packages/backend/services/reporting-service/src/auth/report-rbac.guard.ts`: Custom Guard for report permissions.
  - **Step Dependencies**: Steps 96, 97 (Reporting APIs implemented), Step 28 (Backend Auth - provides user context), Step 35 (Backend RBAC pattern).
  - **User Instructions**: Deploy the Reporting Service. Obtain JWTs for a Care Manager, Admin, and Caregiver. Attempt to call the reporting APIs using each user. Verify that only Care Managers and Admins can access the reports and that the data is limited to their agency.

- [ ] Step 99: Implement Web Frontend - Reporting UI
  - **Task**: In the React frontend, implement the Reporting UI for Care Managers/Admins at `/dashboard/reports`. Create a page with a selector for the report type (Caregiver Activity, Patient Activity). Include date range pickers and optional dropdowns/selectors for filtering by specific caregiver or patient (fetching lists from relevant APIs, e.g., `GET /users`, `GET /patients`). Implement a button to generate the report. Display the results in a table or simple chart format. Connect the UI controls to call the appropriate backend reporting API (`GET /reports/caregiver-activity` or `GET /reports/patient-activity` from Steps 96, 97). Use design system components.
  - **Files**:
    - `packages/frontend/src/features/reporting/pages/reporting-dashboard.tsx`: Reporting dashboard page.
    - `packages/frontend/src/features/reporting/components/report-filters.tsx`: Component for report type, date range, filters.
    - `packages/frontend/src/features/reporting/components/report-results-table.tsx`: Component to display results.
    - `packages/frontend/src/features/reporting/services/reporting.api.ts`: API client calls for reporting endpoints.
    - `packages/frontend/src/features/reporting/types/report.ts`: TypeScript types.
    - `packages/frontend/src/components/design-system/DatePicker.tsx`: Placeholder Date Picker component.
    - `packages/frontend/src/components/design-system/Select.tsx`: Placeholder Select component.
  - **Step Dependencies**: Steps 96, 97 (Reporting APIs), Step 31 (Frontend RBAC pattern), Step 71 (Design System components - placeholder).
  - **User Instructions**: Log in as a Care Manager or Admin. Navigate to the Reports page. Select a report type, date range, and optional filters. Generate the report. Verify that the results are displayed correctly based on the data in the backend.

## 13. Data Export Capability

<thinking>Data export is an administrative feature allowing agencies to retrieve their data for archival or migration. This involves asynchronous processing via Pub/Sub and storing the exported files securely in GCS.

**Section 13: Data Export Capability**

*   Step 100: Export Service - Request Export API
*   Step 101: Export Service - Pub/Sub Topic for Export Jobs
*   Step 102: Backend Worker - Export Job Pub/Sub Subscriber (Cloud Run)
*   Step 103: Backend Worker - Data Extraction Logic (PG, Audit DB, GCS Metadata)
*   Step 104: Backend Worker - Data Formatting (CSV, JSON)
*   Step 105: Backend Worker - Upload to GCS (Bucket Lock)
*   Step 106: Backend Worker - Update Job Status & Publish Event
*   Step 107: Export Service - Get/List Export Jobs API
*   Step 108: Export Service - Get Signed Download URL API
*   Step 109: Export Service - Archived Audio Query/Signed URL APIs
*   Step 110: Web Frontend - Data Export UI (Request, List, Download)

This section introduces the Export Service and a dedicated worker, leveraging Pub/Sub and GCS, and implements the web UI for administrators.- [ ] Step 100: Implement Export Service - Request Export API
  - **Task**: Implement the `POST /exports` API endpoint in the Export Service. Accept export parameters (`dataTypes`, `startDate`, `endDate`, `format`) via a DTO (`CreateExportDto`). Validate input. Enforce RBAC: only allow users with `data:export` permission (Agency Admin). Create a new `ExportJob` entry in the PostgreSQL `export_jobs` table (from Step 17) with status `pending`, linking it to the requesting user and their agency. Publish a message to the `data.exports` Pub/Sub topic (from Step 101) containing the `exportJobId` and parameters. Return 202 Accepted with the job ID.
  - **Files**:
    - `packages/backend/services/export-service/src/export.controller.ts`: Add `POST /exports` route.
    - `packages/backend/services/export-service/src/export.service.ts`: Implement request logic (save job, publish Pub/Sub).
    - `packages/backend/services/export-service/src/dtos/create-export.dto.ts`: DTO for export request.
    - `packages/backend/services/export-service/src/export-job.repository.ts`: Add method to save export job.
    - `packages/backend/services/export-service/src/pubsub/pubsub.service.ts`: Use shared Pub/Sub service.
    - `packages/backend/services/export-service/src/auth/export-rbac.guard.ts`: Custom Guard for export permissions.
  - **Step Dependencies**: Step 17 (ExportJob DB model), Step 22 (DB migrations run), Step 28 (Backend Auth - provides user context), Step 101 (Export Pub/Sub topic).
  - **User Instructions**: Deploy the Export Service. Obtain a JWT for an Agency Admin. Use an API client to send a POST request to `/exports` with valid parameters. Verify a new entry is created in the `export_jobs` table with status 'pending' and a message is published to the `data.exports` topic.

- [ ] Step 101: Define Pub/Sub Topic for Export Jobs
  - **Task**: Ensure the `data.exports` Pub/Sub topic (created in Step 8) is ready. Define the message payload structure for this topic: it should contain the `exportJobId` and the export parameters (`dataTypes`, `startDate`, `endDate`, `format`, `agencyId`, `requestedByUserId`).
  - **Files**:
    - `packages/backend/shared/src/dtos/export-job-event.dto.ts`: Define DTO for the Pub/Sub message payload.
  - **Step Dependencies**: Step 8 (Pub/Sub topics).
  - **User Instructions**: No specific user action needed beyond verifying the topic exists (Step 8).

- [ ] Step 102: Implement Backend Worker - Export Job Pub/Sub Subscriber
  - **Task**: Create a new NestJS application specifically for the export worker (e.g., `export-worker`). Configure this application to subscribe to the `data.exports` Pub/Sub topic (from Step 101). Deploy it on Cloud Run triggered by Pub/Sub or as a GKE deployment. The worker should receive the message payload and extract the `exportJobId` and parameters. Fetch the `ExportJob` details from the database and update its status to `processing`.
  - **Files**:
    - `packages/backend/services/export-worker/package.json`: Worker dependencies.
    - `packages/backend/services/export-worker/src/main.ts`: Worker entry point.
    - `packages/backend/services/export-worker/src/app.module.ts`: Worker root module.
    - `packages/backend/services/export-worker/src/export-processor.module.ts`: Worker logic module.
    - `packages/backend/services/export-worker/src/export-processor.controller.ts` (if Cloud Run push): Endpoint to receive messages.
    - `packages/backend/services/export-worker/src/export-processor.service.ts`: Service to process messages.
    - `packages/backend/services/export-worker/src/export-job/export-job.service.ts`: Internal service client to update ExportJob status.
    - `packages/infrastructure/gcp/modules/cloudrun/main.tf` (if Cloud Run): Define Cloud Run service triggered by Pub/Sub.
    - `packages/infrastructure/gcp/modules/gke/main.tf` (if GKE): Define deployment for worker.
    - `packages/infrastructure/gcp/modules/pubsub/main.tf`: Add subscription for `data.exports` topic, linking to worker deployment.
  - **Step Dependencies**: Step 11 (Backend structure), Step 101 (Export Pub/Sub topic), Step 4 (IaC foundation), Step 17 (ExportJob DB model).
  - **User Instructions**: Update and apply IaC to deploy the worker and create its Pub/Sub subscription. Request an export via the API (Step 100). Verify that the worker receives the message and updates the job status in the database to 'processing'.

- [ ] Step 103: Implement Backend Worker - Data Extraction Logic
  - **Task**: In the export worker (from Step 102), implement the logic to extract data based on the requested `dataTypes`, `startDate`, `endDate`, and `agencyId`. Query the primary PostgreSQL database (`Patient`, `DocumentationEntry`, `Message`, etc.). For audit data, query the Audit Database (Step 18). For archived audio metadata, query GCS metadata or a dedicated metadata table if created. Use efficient, potentially streaming database queries to handle large datasets without excessive memory usage.
  - **Files**:
    - `packages/backend/services/export-worker/src/export-processor.service.ts`: Coordinate data extraction.
    - `packages/backend/services/export-worker/src/data-extraction/data-extraction.service.ts`: Service containing extraction methods for different data types.
    - `packages/backend/services/export-worker/src/data-extraction/data-extraction.module.ts`: NestJS module.
    - `packages/backend/services/export-worker/src/data-extraction/patient.extractor.ts`: Logic to query and format patient data.
    - `packages/backend/services/export-worker/src/data-extraction/documentation.extractor.ts`: Logic to query and format documentation data.
    - `packages/backend/services/export-worker/src/data-extraction/audit.extractor.ts`: Logic to query Audit DB.
    - `packages/backend/services/export-worker/src/data-extraction/gcs-metadata.extractor.ts`: Logic to query GCS metadata.
  - **Step Dependencies**: Step 102 (Export worker setup), Step 5 (Cloud SQL), Step 18 (Audit DB), Step 7 (GCS buckets), Steps 12-17, 19, 20 (DB models).
  - **User Instructions**: Deploy the worker. Request an export. Verify in worker logs that the data extraction logic is executed and queries are made to the relevant databases/GCS.

- [ ] Step 104: Implement Backend Worker - Data Formatting (CSV, JSON)
  - **Task**: In the export worker (from Step 103), implement logic to format the extracted data into the requested `format` (CSV or JSON). Use appropriate libraries for CSV and JSON generation. For CSV, ensure proper escaping and headers. For JSON, decide on a structure (e.g., an array of objects per data type, or a single nested JSON object). Implement streaming file writing to avoid loading the entire formatted output into memory for large exports.
  - **Files**:
    - `packages/backend/services/export-worker/src/export-processor.service.ts`: Coordinate formatting.
    - `packages/backend/services/export-worker/src/data-formatting/data-formatter.service.ts`: Service for formatting logic.
    - `packages/backend/services/export-worker/src/data-formatting/data-formatter.module.ts`: NestJS module.
    - `packages/backend/services/export-worker/src/data-formatting/csv-formatter.ts`: CSV formatting logic.
    - `packages/backend/services/export-worker/src/data-formatting/json-formatter.ts`: JSON formatting logic.
  - **Step Dependencies**: Step 103 (Data extraction).
  - **User Instructions**: Deploy the worker. Request exports in both CSV and JSON formats. Verify in worker logs that the formatting logic is executed. Inspect the generated files (before upload) to ensure the format is correct.

- [ ] Step 105: Implement Backend Worker - Upload to GCS (Bucket Lock)
  - **Task**: In the export worker (from Step 104), implement logic to upload the formatted export file(s) to the designated GCS bucket for archives/exports (from Step 7). Use the Google Cloud Storage Node.js SDK. Ensure the upload targets the correct bucket in the Canadian region. Verify that Bucket Lock is enabled on this bucket to make the objects immutable once written. Store the GCS object path(s) in the `ExportJob` entry in the database.
  - **Files**:
    - `packages/backend/services/export-worker/src/export-processor.service.ts`: Coordinate upload.
    - `packages/backend/services/export-worker/src/gcs/gcs.service.ts`: Service for GCS upload.
    - `packages/backend/services/export-worker/src/gcs/gcs.module.ts`: NestJS module.
    - `packages/backend/services/export-worker/src/export-job/export-job.service.ts`: Internal service client to update ExportJob with file paths.
  - **Step Dependencies**: Step 104 (Data formatting), Step 7 (GCS buckets with Bucket Lock).
  - **User Instructions**: Deploy the worker. Request an export. Verify in worker logs that the file is uploaded to the correct GCS bucket. Verify in the GCP Console that the file exists in the bucket and its metadata indicates Bucket Lock is applied.

- [ ] Step 106: Implement Backend Worker - Update Job Status and Publish Event
  - **Task**: In the export worker (from Step 105), after the export file(s) have been successfully uploaded to GCS, update the `ExportJob` entry in the PostgreSQL database (from Step 17) to status `complete`, recording the `completed_at` timestamp and the GCS `file_paths`. If any step in the export process fails, update the status to `failed` and record `error_details`. Publish a Pub/Sub message (`event.export.completed` or `event.export.failed` from Step 8) to notify the system (e.g., trigger a user notification via FCM/WebSocket). Acknowledge the incoming Pub/Sub message (`data.exports`).
  - **Files**:
    - `packages/backend/services/export-worker/src/export-processor.service.ts`: Final status update and event publishing logic.
    - `packages/backend/services/export-worker/src/export-job/export-job.service.ts`: Call update method.
    - `packages/backend/services/export-worker/src/pubsub/pubsub.service.ts`: Publish event and acknowledge message.
  - **Step Dependencies**: Step 105 (GCS upload), Step 17 (ExportJob DB model), Step 8 (Pub/Sub topics), Step 90 (Signal status mechanism - can reuse for export completion).
  - **User Instructions**: Deploy the worker. Request an export. Verify the `export_jobs` table status changes to 'complete' (or 'failed' if you simulate an error) and file paths are recorded. Verify a completion/failure event message is published to Pub/Sub.

- [ ] Step 107: Implement Export Service - Get/List Export Jobs API
  - **Task**: Implement the `GET /exports` API endpoint in the Export Service. This endpoint should return a list of export jobs requested by the requesting user within their agency. Query the `export_jobs` table, filtering by `agency_id` and `requested_by_user_id`. Implement basic pagination and sorting. Implement the `GET /exports/:id` endpoint to get details for a single export job, ensuring the user requested it and it's within their agency. Enforce RBAC (`data:export`).
  - **Files**:
    - `packages/backend/services/export-service/src/export.controller.ts`: Add `GET /exports` and `GET /exports/:id` routes.
    - `packages/backend/services/export-service/src/export.service.ts`: Implement list and get logic.
    - `packages/backend/services/export-service/src/dtos/export-job.dto.ts`: DTOs for export job summary and detail.
    - `packages/backend/services/export-service/src/export-job.repository.ts`: Add query methods.
  - **Step Dependencies**: Step 17 (ExportJob DB model), Step 22 (DB migrations run), Step 28 (Backend Auth - provides user context), Step 100 (POST /exports API).
  - **User Instructions**: Deploy the Export Service. Request several exports (Step 100). Obtain a JWT for the requesting Admin user. Use an API client to call `GET /exports` and `GET /exports/:id`. Verify the list and details of the export jobs are returned correctly.

- [ ] Step 108: Implement Export Service - Get Signed Download URL API
  - **Task**: Implement the `GET /exports/:id/download` API endpoint in the Export Service. This endpoint accepts an `exportJobId`. Fetch the `ExportJob` details from the database. Verify the job exists, is `complete`, belongs to the requesting user's agency, and the user has `data:export` permission. If valid, use the Google Cloud Storage Node.js SDK to generate a signed URL for the GCS object path(s) stored in the job record. Return the signed URL(s) to the client (or redirect the user to the first URL). Configure the signed URL with a limited expiration time (e.g., 15 minutes).
  - **Files**:
    - `packages/backend/services/export-service/src/export.controller.ts`: Add `GET /exports/:id/download` route.
    - `packages/backend/services/export-service/src/export.service.ts`: Implement signed URL generation logic.
    - `packages/backend/services/export-service/src/gcs/gcs.service.ts`: Add method to generate signed URL.
  - **Step Dependencies**: Step 107 (GET /exports/:id API), Step 105 (Backend Worker uploads to GCS), Step 7 (GCS buckets).
  - **User Instructions**: Deploy the Export Service. Request and wait for an export job to complete. Obtain a JWT for the requesting Admin user. Use an API client to call `GET /exports/:id/download` for the completed job. Verify a signed URL is returned. Use the signed URL in a browser or tool to download the file directly from GCS. Verify the URL expires after the configured time.

- [ ] Step 109: Implement Export Service - Archived Audio Query/Signed URL APIs
  - **Task**: Implement API endpoints for querying archived audio recordings and generating signed URLs for them.
    *   `GET /archive/audio`: Query GCS metadata (or a dedicated metadata table) for audio files associated with documentation entries, filtered by patient ID, date range, and agency. Return metadata (GCS path, timestamp, patient ID, caregiver ID). Enforce RBAC (user must be assigned to the patient or be a Care Manager/Admin for the agency).
    *   `GET /archive/audio/:id/download-signed-url`: Generate a signed URL for a specific audio file GCS path (identified by ID, e.g., documentation entry ID or GCS object ID). Verify permissions. Return the signed URL.
  - **Files**:
    - `packages/backend/services/export-service/src/export.controller.ts`: Add audio archive routes.
    - `packages/backend/services/export-service/src/export.service.ts`: Implement query and signed URL logic.
    - `packages/backend/services/export-service/src/gcs/gcs.service.ts`: Add methods to list objects with metadata and generate signed URLs.
    - `packages/backend/services/export-service/src/auth/export-rbac.guard.ts`: Update Guard for audio archive permissions.
  - **Step Dependencies**: Step 62 (Backend Worker saves audio URL), Step 7 (GCS buckets), Step 52 (Backend RBAC - patient assignment).
  - **User Instructions**: Deploy the Export Service. Ensure some documentation entries with audio exist. Obtain JWTs for users with different permissions (assigned caregiver, Care Manager). Use an API client to call `GET /archive/audio` with filters. Verify metadata is returned based on permissions. Call `GET /archive/audio/:id/download-signed-url` and verify a signed URL is returned for authorized requests.

- [ ] Step 110: Implement Web Frontend - Data Export UI (Request, List, Download)
  - **Task**: In the React frontend, implement the Data Export UI for Agency Administrators at `/dashboard/admin/export`. Create a page with controls for selecting data types (checkboxes), date range pickers, and format selector (dropdown). Implement a button to "Request Export" that calls the `POST /exports` API (from Step 100). Display a list of past export jobs fetched from the `GET /exports` API (from Step 107), showing status and timestamps. For completed jobs, display a "Download" button that calls the `GET /exports/:id/download` API (from Step 108) and handles the file download (e.g., by redirecting the browser). Use design system components.
  - **Files**:
    - `packages/frontend/src/features/data-export/pages/export-dashboard.tsx`: Export dashboard page.
    - `packages/frontend/src/features/data-export/components/export-request-form.tsx`: Component for requesting export.
    - `packages/frontend/src/features/data-export/components/export-jobs-list.tsx`: Component to list jobs.
    - `packages/frontend/src/features/data-export/services/export.api.ts`: API client calls.
    - `packages/frontend/src/features/data-export/types/export.ts`: TypeScript types.
  - **Step Dependencies**: Step 100 (POST /exports API), Step 107 (GET /exports API), Step 108 (GET /exports/:id/download API), Step 31 (Frontend RBAC - restrict page access), Step 71 (Design System components - placeholder).
  - **User Instructions**: Log in as an Agency Admin. Navigate to the Data Export page. Request an export. Verify the job appears in the list with status 'pending'. Wait for the job to complete (check backend logs/DB status). Refresh the page. Verify status changes to 'complete'. Click the "Download" button. Verify the file downloads from GCS.

## 14. EHR Interoperability Foundation (MVP)

<thinking>The MVP includes a foundational layer for future EHR interoperability, specifically exposing data via FHIR R4 APIs. This requires implementing MDM and Consent services (even if basic) and the EHR Integration Service, secured via Apigee.

**Section 14: EHR Interoperability Foundation (MVP)**

*   Step 111: MDM Service - Internal APIs (Resolve Patient ID)
*   Step 112: Consent Service - Internal APIs (Check Consent)
*   Step 113: EHR Integration Service - FHIR R4 Resource Mapping (Patient, Observation)
*   Step 114: EHR Integration Service - FHIR API Endpoints (GET Patient, GET Observation)
*   Step 115: EHR Integration Service - Integrate MDM/Consent Checks
*   Step 116: Apigee - Configure FHIR API Proxies & Security

This section introduces the MDM, Consent, and EHR Integration services, focusing on internal communication and external FHIR exposure via Apigee.- [ ] Step 111: Implement MDM Service - Internal APIs (Resolve Patient ID)
  - **Task**: In the MDM Service, implement internal API endpoints (e.g., REST over Istio, or gRPC) to resolve external patient identifiers to internal patient IDs (`internal_patient_id`) and MPI IDs (`mpi_id`). Implement a method like `resolveExternalPatientId(system: string, value: string): Promise<{ internalPatientId: string, mpiId: string }>`. This logic will query the `MdmExternalIdentifier` and `MdmPatientIdentity` tables (from Step 19).
  - **Files**:
    - `packages/backend/services/mdm-service/src/mdm.controller.ts`: Add internal REST/gRPC endpoints (e.g., `GET /internal/mdm/patient/resolve-external`).
    - `packages/backend/services/mdm-service/src/mdm.service.ts`: Implement resolution logic.
    - `packages/backend/services/mdm-service/src/mdm.repository.ts`: Add query methods for MDM entities.
    - `packages/backend/services/mdm-service/src/dtos/mdm.dto.ts`: DTOs for internal API.
  - **Step Dependencies**: Step 19 (MDM DB models), Step 22 (DB migrations run), Step 11 (Backend structure).
  - **User Instructions**: Deploy the MDM Service. Manually add some test data to the `mdm_patient_identities` and `mdm_external_identifiers` tables, linking internal patient IDs to external system IDs. Use an API client (or internal service call) to test the new internal endpoint, verifying that external IDs are resolved correctly to internal IDs.

- [ ] Step 112: Implement Consent Service - Internal APIs (Check Consent)
  - **Task**: In the Consent Service, implement internal API endpoints (e.g., REST over Istio, or gRPC) to act as a Policy Decision Point (PDP). Implement a method like `checkConsent(patientId: string, accessContext: { userId?: string, requestedDataTypes: string[], purpose: string, sourceSystem: string }): Promise<{ decision: 'permit' | 'deny', reason?: string }>`. This logic will query the `ConsentDirective` table (from Step 20) and evaluate policies based on the access context. For MVP, a simple check (e.g., is there *any* active consent directive for this patient?) might suffice, or a placeholder that always permits/denies.
  - **Files**:
    - `packages/backend/services/consent-service/src/consent.controller.ts`: Add internal REST/gRPC endpoints (e.g., `POST /internal/consent/patient/:id/check`).
    - `packages/backend/services/consent-service/src/consent.service.ts`: Implement consent check logic.
    - `packages/backend/services/consent-service/src/consent.repository.ts`: Add query methods for ConsentDirective entity.
    - `packages/backend/services/consent-service/src/dtos/consent.dto.ts`: DTOs for internal API.
  - **Step Dependencies**: Step 20 (Consent DB models), Step 22 (DB migrations run), Step 11 (Backend structure).
  - **User Instructions**: Deploy the Consent Service. Manually add some test data to the `consent_directives` table. Use an API client (or internal service call) to test the new internal endpoint, verifying that consent decisions are returned based on the test data/logic.

- [ ] Step 113: Implement EHR Integration Service - FHIR R4 Resource Mapping
  - **Task**: In the EHR Integration Service, define the data structures (TypeScript interfaces/classes) that represent the required FHIR R4 resources (Patient, Observation). Implement mapping logic that takes internal data models (e.g., `Patient`, `DocumentationEntry` entities) and transforms them into the corresponding FHIR resource structures. Use a FHIR library if available and suitable for Node.js/TS, or implement mapping manually based on the FHIR R4 specification.
  - **Files**:
    - `packages/backend/services/ehr-service/src/fhir/fhir.types.ts`: TypeScript interfaces for FHIR R4 resources (Patient, Observation).
    - `packages/backend/services/ehr-service/src/fhir/mappers/patient.mapper.ts`: Logic to map internal Patient entity to FHIR Patient resource.
    - `packages/backend/services/ehr-service/src/fhir/mappers/observation.mapper.ts`: Logic to map internal DocumentationEntry/structured data to FHIR Observation resources.
    - `packages/backend/services/ehr-service/src/fhir/mappers/mapper.module.ts`: NestJS module for mappers.
  - **Step Dependencies**: Step 21 (EHR Integration Service structure), Steps 13, 14 (Internal DB models - need structure).
  - **User Instructions**: No direct user instruction for this internal logic step. It will be tested via the FHIR API endpoints in subsequent steps.

- [ ] Step 114: Implement EHR Integration Service - FHIR API Endpoints
  - **Task**: In the EHR Integration Service, implement the FHIR R4 RESTful API endpoints for `GET /fhir/Patient/:id` and `GET /fhir/Observation`. These endpoints should:
    1.  Receive the request (authentication handled by Apigee/Istio).
    2.  Extract parameters (e.g., patient ID from path/query).
    3.  Call the MDM Service (Step 111) to resolve the incoming FHIR patient ID to an internal patient ID.
    4.  Query the internal database (PostgreSQL) using the internal patient ID to fetch relevant data (Patient entity, Documentation entries).
    5.  Use the mappers (Step 113) to transform the internal data into FHIR resources.
    6.  Return the FHIR resource(s) in the response body (JSON format).
  - **Files**:
    - `packages/backend/services/ehr-service/src/fhir/fhir.controller.ts`: Add FHIR API routes (`GET /fhir/Patient/:id`, `GET /fhir/Observation`).
    - `packages/backend/services/ehr-service/src/fhir/fhir.service.ts`: Implement endpoint logic (call MDM, query DB, use mappers).
    - `packages/backend/services/ehr-service/src/mdm/mdm.service.ts`: Internal service client for MDM.
    - `packages/backend/services/ehr-service/src/mdm/mdm.module.ts`: NestJS module for MDM interaction.
    - `packages/backend/services/ehr-service/src/documentation/documentation.service.ts`: Internal service client for Documentation data.
    - `packages/backend/services/ehr-service/src/documentation/documentation.module.ts`: NestJS module for Documentation interaction.
    - `packages/backend/services/ehr-service/src/patient/patient.service.ts`: Internal service client for Patient data.
    - `packages/backend/services/ehr-service/src/patient/patient.module.ts`: NestJS module for Patient interaction.
  - **Step Dependencies**: Step 113 (FHIR mapping), Step 111 (MDM Internal API), Steps 13, 14 (Internal DB models), Step 5 (Cloud SQL).
  - **User Instructions**: Deploy the EHR Integration Service. Ensure test data exists in MDM linking an external ID to an internal patient ID, and that documentation/patient data exists for that patient. Use an API client to call the new FHIR endpoints directly (bypassing Apigee for now). Verify that data is retrieved, mapped to FHIR structures, and returned correctly.

- [ ] Step 115: Implement EHR Integration Service - Integrate MDM/Consent Checks
  - **Task**: Enhance the FHIR API endpoints (from Step 114) to integrate calls to the Consent Service (Step 112) before returning data.
    1.  After fetching internal data and mapping to FHIR resources, construct the `accessContext` payload for the consent check (user/system ID, requested data types based on FHIR resource, purpose - e.g., 'treatment', 'reporting', source system - e.g., calling EHR identifier).
    2.  Call the Consent Service (Step 112) `checkConsent` API.
    3.  If the decision is 'deny', return an appropriate FHIR OperationOutcome resource with a 403 Forbidden status code.
    4.  If the decision is 'permit', return the FHIR resource(s).
  - **Files**:
    - `packages/backend/services/ehr-service/src/fhir/fhir.service.ts`: Add logic to call Consent Service and handle decision.
    - `packages/backend/services/ehr-service/src/consent/consent.service.ts`: Internal service client for Consent.
    - `packages/backend/services/ehr-service/src/consent/consent.module.ts`: NestJS module for Consent interaction.
    - `packages/backend/services/ehr-service/src/fhir/fhir.types.ts`: Add FHIR OperationOutcome type.
  - **Step Dependencies**: Step 114 (FHIR API endpoints), Step 112 (Consent Internal API).
  - **User Instructions**: Deploy the EHR Integration Service and Consent Service. Ensure test data exists in Consent directives (e.g., one patient permits sharing, another denies). Use an API client to call the FHIR endpoints for both patients. Verify that access is permitted for the first patient and denied (403 with OperationOutcome) for the second.

- [ ] Step 116: Configure Apigee - Configure FHIR API Proxies and Security
  - **Task**: Update the Apigee configuration (from Step 9) to define API proxies specifically for the FHIR R4 endpoints exposed by the EHR Integration Service (from Step 115). Configure security policies on these proxies:
    *   Require strong authentication (e.g., OAuth 2.0 token validation, potentially linked to Auth0/Okta or a separate client credential flow managed by Apigee).
    *   Configure rate limiting policies.
    *   Route requests to the internal EHR Integration Service endpoint (using Istio Gateway if in GKE, or internal load balancer).
  - **Files**:
    - `packages/infrastructure/gcp/modules/apigee/main.tf`: Update Apigee configuration to add FHIR proxies, target endpoints, security policies (OAuth2/API Key), rate limiting.
  - **Step Dependencies**: Step 9 (Apigee setup), Step 115 (EHR Integration Service FHIR APIs deployed).
  - **User Instructions**: Update and apply IaC for Apigee. Obtain credentials for accessing the FHIR APIs via Apigee (e.g., OAuth2 token). Use an API client to call the FHIR endpoints via the Apigee gateway URL. Verify that authentication, authorization (via Apigee policies), and routing to the backend EHR service work correctly. Test rate limiting.

## 15. Cross-cutting Concerns & Refinement

<thinking>The final section addresses remaining non-functional requirements and refines existing implementations. This includes data retention, comprehensive error handling, monitoring, security hardening, performance tuning, and accessibility review.

**Section 15: Cross-cutting Concerns & Refinement**

*   Step 117: Data Retention Policies (Implementation for Documentation, Messages, Audio, Audit Logs)
*   Step 118: Comprehensive Error Handling & Logging (Across Services)
*   Step 119: Monitoring & Alerting Configuration (Cloud Operations)
*   Step 120: Security Hardening (Network Policies, Secrets Management, Scanning Integration)
*   Step 121: Performance Optimization (Indexing Review, Query Optimization)
*   Step 122: Accessibility Implementation Review (WCAG AA)
*   Step 123: Final Code Review & Documentation

These steps are cross-cutting and apply across multiple services and infrastructure components.- [ ] Step 117: Implement Data Retention Policies
  - **Task**: Define and implement data retention policies for different data types as specified (e.g., raw voice recordings purged after 90 days, potentially policies for messages or older documentation/audit logs if required beyond standard operational needs).
    *   **Raw Voice Recordings:** Configure GCS Lifecycle Management on the archive bucket (from Step 7) to automatically delete objects older than 90 days.
    *   **Database Data (Documentation, Messages):** Implement background jobs (e.g., a scheduled Cloud Run job or GKE CronJob) that query the PostgreSQL database and soft-delete or archive records older than the defined policy. Ensure soft-deleted data is excluded from standard queries but available for export/audit if needed.
    *   **Audit Logs:** Configure retention policies for Google Cloud Bigtable or implement archiving/deletion jobs for the Audit PostgreSQL database based on policy.
  - **Files**:
    - `packages/infrastructure/gcp/modules/gcs/main.tf`: Update Lifecycle Management for archive bucket.
    - `packages/infrastructure/gcp/modules/cloudscheduler/main.tf`: Define Cloud Scheduler job.
    - `packages/infrastructure/gcp/modules/cloudrun/main.tf`: Define Cloud Run service for cleanup job.
    - `packages/backend/services/cleanup-worker/src/main.ts`: New worker service for data cleanup.
    - `packages/backend/services/cleanup-worker/src/cleanup.service.ts`: Implement cleanup logic (query and delete/archive old data).
  - **Step Dependencies**: Step 7 (GCS buckets), Step 5 (Cloud SQL), Step 18 (Audit DB), Steps 14, 15 (Documentation, Message DB models).
  - **User Instructions**: Update and apply IaC for GCS Lifecycle and the cleanup worker. Verify in GCS that lifecycle policies are applied. Monitor the cleanup worker logs to ensure it runs on schedule and processes old data according to the policies. Manually verify data is soft-deleted/archived in the database.

- [ ] Step 118: Implement Comprehensive Error Handling and Logging
  - **Task**: Review and enhance error handling across all backend services and frontend applications.
    *   **Backend:** Implement centralized exception filters in NestJS to catch unhandled errors and return consistent, informative (but not overly detailed/sensitive) error responses (JSON body with `code`, `message`, `details`). Log detailed error information (stack traces, request context) to Cloud Logging (Step 119). Handle specific known errors (e.g., database errors, external API errors, validation errors, permission errors) with appropriate HTTP status codes and error messages.
    *   **Frontend (Web/Mobile):** Implement global error boundaries or handlers to catch unexpected errors gracefully, log them (e.g., to Cloud Logging via a client library or backend endpoint), and display a user-friendly error message or fallback UI. Handle specific API error responses (400, 401, 403, 404, 409, 500) received from the backend, displaying appropriate messages to the user. Avoid exposing raw backend error details.
    *   **Logging:** Ensure all services use a structured logging library (e.g., Winston, Pino) configured to output logs in a format compatible with Cloud Logging (JSON). Include relevant context in logs (user ID, request ID, trace ID, entity ID). Redact or mask sensitive data in logs.
  - **Files**:
    - `packages/backend/shared/src/filters/all-exceptions.filter.ts`: Global exception filter.
    - `packages/backend/shared/src/logging/logger.service.ts`: Structured logging service.
    - `packages/backend/services/*/src/**/*.ts`: Add try-catch blocks and use logger.
    - `packages/frontend/src/utils/api-errors.ts`: API error handling logic.
    - `packages/frontend/src/components/shared/ErrorBoundary.tsx`: React error boundary.
    - `packages/mobile/lib/src/common/error_handling.dart`: Flutter error handling.
    - `packages/mobile/lib/src/services/api_client.dart`: Intercept API errors.
  - **Step Dependencies**: All previous steps implementing services and APIs, Step 119 (Cloud Logging setup).
  - **User Instructions**: Deploy all services. Intentionally trigger various error conditions (e.g., invalid input, unauthorized access, non-existent resource, simulate backend service failure). Verify that consistent error responses are returned to the frontend, user-friendly messages are displayed, and detailed error information is logged to Cloud Logging (without exposing PHI).

- [ ] Step 119: Configure Monitoring and Alerting (Cloud Operations)
  - **Task**: Configure Google Cloud Operations Suite (formerly Stackdriver) for comprehensive monitoring, logging, tracing, and alerting across all GCP services and deployed applications.
    *   **Logging:** Ensure logs from GKE, Cloud Run, Cloud SQL, Pub/Sub, Apigee, etc., are flowing into Cloud Logging. Configure log-based metrics and sinks (e.g., export security logs to BigQuery).
    *   **Monitoring:** Set up dashboards in Cloud Monitoring to visualize key metrics (CPU/memory usage, request latency, error rates, database connections, Pub/Sub message counts/latency, GCS storage size).
    *   **Tracing:** Ensure distributed tracing is enabled and configured (e.g., via Istio integration in GKE, or OpenTelemetry SDKs in services) to trace requests across microservices.
    *   **Alerting:** Define alerting policies based on critical metrics and log errors (e.g., high error rate on any service, increased latency, low disk space, specific security log patterns like repeated failed logins). Configure notification channels.
  - **Files**:
    - `packages/infrastructure/gcp/modules/monitoring/main.tf`: Define monitoring dashboards, alerting policies, log metrics, log sinks.
    - `packages/backend/shared/src/tracing/tracing.module.ts`: OpenTelemetry/Cloud Trace SDK integration (if not using Istio auto-instrumentation).
  - **Step Dependencies**: All previous steps deploying GCP resources and services, Step 118 (Structured logging).
  - **User Instructions**: Update and apply IaC for monitoring. Access the Cloud Operations console. Verify that logs, metrics, and traces are being collected. View dashboards. Intentionally trigger an alert condition (e.g., deploy a service that returns errors). Verify that an alert is triggered and a notification is sent.

- [ ] Step 120: Implement Security Hardening
  - **Task**: Implement additional security hardening measures across the system.
    *   **Secrets Management:** Integrate Google Cloud Secret Manager. Store all sensitive credentials (database passwords, API keys, Auth0/Okta secrets, service account keys) in Secret Manager. Modify backend services and IaC to retrieve secrets from Secret Manager at runtime instead of using environment variables or config files.
    *   **Network Policies:** Define strict Kubernetes Network Policies in GKE to restrict traffic flow between microservices to only the necessary connections, enforcing the principle of least privilege at the network level (complements Istio Authorization Policies).
    *   **IAM:** Refine GCP IAM roles and permissions to follow the principle of least privilege for service accounts used by workers and services, and for human administrators.
    *   **Scanning:** Integrate automated security scanning tools (container scanning, dependency scanning, static code analysis) into the CI/CD pipeline (Step 3). Configure scans to fail builds on high-severity findings.
    *   **Security Headers:** Ensure Apigee or the load balancer is configured to add appropriate security headers (HSTS, CSP, etc.) to all web responses.
  - **Files**:
    - `packages/infrastructure/gcp/modules/secretmanager/main.tf`: Define secrets in Secret Manager.
    - `packages/infrastructure/gcp/modules/gke/main.tf`: Define Kubernetes Network Policies.
    - `packages/infrastructure/gcp/modules/iam/main.tf`: Define custom IAM roles and service account permissions.
    - `packages/backend/services/*/src/config/*.config.ts`: Update config loading to use Secret Manager client.
    - `.github/workflows/build.yml` (or `cloudbuild.yaml`): Add security scanning steps.
    - `packages/infrastructure/gcp/modules/apigee/main.tf`: Configure security headers.
  - **Step Dependencies**: All previous steps deploying services and infrastructure, Step 3 (CI/CD pipeline).
  - **User Instructions**: Update and apply IaC for Secret Manager, Network Policies, and IAM. Store secrets in Secret Manager. Redeploy services configured to use Secret Manager. Verify services start correctly. Verify in the GCP Console that Network Policies are applied. Trigger a CI/CD build and verify security scans run and report findings. Test web application headers using browser developer tools or online scanners.

- [ ] Step 121: Implement Performance Optimization
  - **Task**: Review and implement performance optimizations based on anticipated load and identified bottlenecks.
    *   **Database Indexing:** Review database queries across all services. Add necessary indexes (B-tree, GIN for JSONB) to PostgreSQL tables based on query patterns (e.g., indexes on foreign keys, timestamps, fields used in WHERE clauses or ORDER BY).
    *   **Query Optimization:** Refactor complex or slow database queries identified during development or testing. Use `EXPLAIN` in PostgreSQL to analyze query plans.
    *   **Caching:** Implement caching using Redis (from Step 6) for frequently accessed, read-heavy data that doesn't require real-time consistency (e.g., agency configuration, user permissions per agency). Implement cache-aside or read-through strategy.
    *   **Read Replicas:** Configure and utilize PostgreSQL read replicas (from Step 5) for read-heavy services like Reporting or EHR Integration to offload load from the primary instance.
    *   **Asynchronous Processing:** Ensure all non-critical tasks (audit logging, voice transcription, exports, sync processing) are handled asynchronously via Pub/Sub workers to keep API response times low.
  - **Files**:
    - `packages/backend/shared/src/database/migrations/*.ts`: Add new migration scripts for indexes.
    - `packages/backend/services/*/src/**/*.repository.ts`: Optimize database queries.
    - `packages/backend/services/*/src/**/*.service.ts`: Implement caching logic using Redis service.
    - `packages/backend/shared/src/redis/redis.service.ts`: Shared Redis service.
    - `packages/infrastructure/gcp/modules/cloudsql/main.tf`: Configure read replicas.
  - **Step Dependencies**: All previous steps implementing services and data access, Step 6 (Redis setup), Step 5 (Cloud SQL setup).
  - **User Instructions**: Update and run database migrations for new indexes. Deploy services with caching implemented. Perform load testing (manual or automated) on staging environment. Monitor Cloud Operations metrics (latency, CPU, DB connections) to identify bottlenecks. Analyze database query performance.

- [ ] Step 122: Conduct Accessibility Implementation Review (WCAG AA)
  - **Task**: Conduct a thorough review of the implemented Web and Mobile UIs against WCAG 2.1 AA guidelines.
    *   **Color Contrast:** Verify all text and interactive element color contrasts meet the 4.5:1 (or 3:1 for large text/UI) ratio using accessibility tools.
    *   **Keyboard Navigation:** Ensure the web application is fully navigable using a keyboard (Tab, Shift+Tab, Enter, Space). Verify focus indicators are visible.
    *   **Screen Reader Support:** Add appropriate ARIA attributes (Web) or semantics (Flutter) to convey meaning and structure to screen readers. Test with screen readers (VoiceOver, TalkBack).
    *   **Form Labels:** Ensure all form fields have associated labels.
    *   **Semantic HTML/Widgets:** Use semantic HTML elements (Web) and appropriate Flutter widgets to convey structure and role.
    *   **Text Scaling:** Verify UI adapts gracefully when text size is increased in OS settings.
    *   **Touch Targets:** Ensure interactive elements on mobile have sufficiently large touch targets (minimum 44x44 dp).
  - **Files**:
    - `packages/frontend/src/**/*.tsx`: Add ARIA attributes, semantic elements.
    - `packages/frontend/src/styles/accessibility.css`: Accessibility-specific CSS (e.g., focus styles).
    - `packages/mobile/lib/src/**/*.dart`: Add semantics, ensure large touch targets.
    - `packages/frontend/src/components/design-system/*`: Ensure design system components are built with accessibility in mind.
    - `packages/mobile/lib/src/design_system/widgets/*`: Ensure design system widgets are built with accessibility in mind.
  - **Step Dependencies**: All previous steps implementing Web and Mobile UI.
  - **User Instructions**: Use accessibility testing tools (e.g., Lighthouse, axe DevTools, WebAIM Contrast Checker) and manual testing (keyboard navigation, screen readers, OS accessibility settings) to review the application UIs. Document findings and create tasks for remediation.

- [ ] Step 123: Final Code Review and Documentation
  - **Task**: Conduct a comprehensive final code review across all services and applications, focusing on security, performance, code quality, and adherence to architectural principles and project rules (including Next.js rules). Update technical documentation, including API specifications (using OpenAPI/Swagger), architecture diagrams, deployment procedures, and operational runbooks. Ensure all PHIPA compliance considerations are documented.
  - **Files**:
    - All code files (`packages/**/*`).
    - `docs/api-spec.yaml`: OpenAPI/Swagger specification.
    - `docs/architecture.md`: Updated architecture documentation.
    - `docs/deployment.md`: Deployment procedures.
    - `docs/runbooks/*`: Operational runbooks.
    - `docs/compliance/phipa.md`: PHIPA compliance documentation summary.
  - **Step Dependencies**: All previous implementation steps.
  - **User Instructions**: Perform final code reviews. Generate API documentation from code annotations (e.g., using Swagger/OpenAPI tools). Update all relevant documentation files. Ensure documentation is stored in the repository or a linked documentation platform.

</thinking>