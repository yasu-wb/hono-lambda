# Hono on AWS Lambda with Terraform

This project is a sample implementation of a serverless API using [Hono](https://hono.dev/) on AWS Lambda, deployed with [Terraform](https://www.terraform.io/).

It uses API Gateway (HTTP API) with a catch-all route (`ANY /{proxy+}`) to forward all requests to a single Lambda function, where Hono handles the routing.

## Prerequisites

- Node.js
- AWS CLI
- Terraform

## Setup

1. **Clone the repository**

2. **Install dependencies**
   ```bash
   npm install
   ```

## Deployment

The entire infrastructure (API Gateway, Lambda) and the application code are deployed using Terraform.

1. **Build the Hono application**
   This command transpiles the TypeScript source code in `src/` into JavaScript in `dist/`.

   ```bash
   npm run build
   ```

2. **Initialize Terraform**
   Initializes the working directory, downloading the necessary provider plugins (e.g., for AWS).

   ```bash
   cd terraform
   terraform init
   ```

3. **Plan the deployment**
   Creates an execution plan. This step allows you to preview the changes Terraform will make to your infrastructure before applying them.

   ```bash
   terraform plan
   ```

4. **Apply the changes**
   Applies the changes required to reach the desired state of the configuration. This will create or update your AWS resources and deploy the code.

   ```bash
   terraform apply
   ```

After the `apply` command is complete, Terraform will output the API Gateway endpoint URL. You can use this URL to test your application.

## Project Structure

```
.
├── src/
│   └── index.ts      # Hono application source code
├── terraform/
│   ├── main.tf       # Main Terraform configuration
│   ├── aws_lambda.tf # Lambda function definition
│   └── ...           # Other Terraform files
├── package.json
└── tsconfig.json
```