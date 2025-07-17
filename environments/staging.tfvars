# Staging Environment Configuration
# Production-like setup with moderate resource allocation
prefix      = "oorja"
environment = "staging"
location    = "East US"

# Network Configuration - Larger address space for staging
address_space = ["10.1.0.0/16"]
subnet_prefixes = {
  aks     = "10.1.1.0/24"
  private = "10.1.2.0/24"
}

# Application Gateway with WAF enabled
enable_app_gateway = true                   
app_gateway_subnet_cidr = "10.1.4.0/24"     
app_gateway_private_ip = "10.1.4.100"
enable_waf = true                           # WAF enabled for staging
waf_mode = "Detection"                      # Detection mode for staging (less aggressive)

# AKS Configuration - Production-like but smaller scale
kubernetes_version = "1.32.4"
node_count         = 2                      # 2 nodes for HA
vm_size           = "Standard_D2s_v3"       # Larger VMs than dev
ssh_public_key    = ""                      # Empty - let ops team manage

# Auto-scaling enabled
enable_auto_scaling = true
min_count          = 2                      # Minimum 2 for HA
max_count          = 5                      # Allow scaling up

# Security - Enhanced for staging
private_cluster_enabled = true             # Private API server
enable_private_endpoints = true            # Private endpoints for services
enable_defender = true                     # Enable Microsoft Defender

# Additional node pools for workload separation
enable_node_pools = true
node_pools = {
  "user-workloads" = {
    vm_size               = "Standard_D2s_v3"
    node_count           = 1
    enable_auto_scaling  = true
    min_count           = 1
    max_count           = 3
    availability_zones   = ["1", "2"]
    os_disk_size_gb     = 100
    os_disk_type        = "Managed"
    os_type             = "Linux"
    enable_host_encryption = false
    fips_enabled        = false
    kubelet_disk_type   = "OS"
    max_pods            = 110
    priority            = "Regular"
    eviction_policy     = "Delete"
    spot_max_price      = -1
    max_surge           = "33%"
    node_labels         = {
      "nodepool-type" = "user"
      "environment"   = "staging"
    }
    node_taints         = []
    tags               = {}
  }
}

# Helm Charts - Production-like services
enable_helm_charts         = true
deploy_helm_charts         = true
enable_nginx_ingress       = true
enable_cert_manager        = true
enable_azure_key_vault_csi = true
enable_external_dns        = false          # Requires DNS permissions
enable_prometheus_stack    = true
enable_argocd             = true
enable_cluster_autoscaler = true           # Enable for staging
enable_keda               = true           # Event-driven scaling
enable_velero             = true           # Backup enabled

# Observability Stack - Enhanced for staging
enable_observability_stack = true
observability_namespace    = "observability"

# Monitoring Stack
enable_opensource_grafana    = true
enable_opensource_prometheus = true
grafana_domain              = "genesis-azure.d01.hdcss.com"
grafana_admin_password      = ""            # Use Azure Key Vault
prometheus_retention        = "30d"         # Longer retention
prometheus_storage_size     = "100Gi"       # Larger storage

# Observability Components
enable_loki           = true
enable_tempo          = true
enable_mimir          = true               # Enable for staging
enable_promtail       = true
enable_otel_collector = true

# Retention periods - Staging appropriate
loki_retention_period   = "168h"          # 7 days
tempo_retention_period  = "168h"          # 7 days  
mimir_retention_period  = "2160h"         # 90 days

# Storage sizes - Medium for staging
loki_storage_size  = "50Gi"
tempo_storage_size = "30Gi"
mimir_storage_size = "200Gi"

# Resource limits - Higher for staging
loki_resources = {
  requests = {
    cpu    = "500m"
    memory = "1Gi"
  }
  limits = {
    cpu    = "1000m"
    memory = "2Gi"
  }
}

tempo_resources = {
  requests = {
    cpu    = "500m"
    memory = "1Gi"
  }
  limits = {
    cpu    = "1000m"
    memory = "2Gi"
  }
}

mimir_resources = {
  requests = {
    cpu    = "1000m"
    memory = "2Gi"
  }
  limits = {
    cpu    = "2000m"
    memory = "4Gi"
  }
}

# External DNS configuration (if enabled)
external_dns_domain_filters = ["d01.hdcss.com"]
external_dns_client_id     = ""
external_dns_client_secret = ""

# Security features - Enhanced
enable_firewall = false                   # Optional for staging
enable_bastion = true                     # Bastion for secure access
bastion_subnet_cidr = "10.1.5.0/27"
create_management_vm = true
management_subnet_cidr = "10.1.6.0/27"

# Premium services for staging
acr_sku         = "Standard"              # Standard tier
service_bus_sku = "Standard"
service_bus_capacity = 0
alert_email     = "devops-team@company.com"  # Use team email

# Certificate Management - Production-like
certificates_config = {
  "staging-wildcard" = {
    issuer             = "Self"             # Use self-signed or Let's Encrypt
    validity_months    = 12
    san_names          = ["*.genesis-azure.d01.hdcss.com", "genesis-azure.d01.hdcss.com"]
    create_dns_record  = true               # Create DNS records
    dns_record_name    = "*"
    dns_ttl            = 300
    dns_records        = ["10.1.4.100"]     # App Gateway IP
  }
}

# Network security - Restricted access
key_vault_allowed_ips = [
  "10.1.0.0/16",                          # Internal network
  "203.0.113.0/24"                        # Replace with office IP range
]

# DNS Configuration 
root_domain             = "genesis-azure.d01.hdcss.com"
create_dns_zone        = true
dns_zone_resource_group = "oorja-staging-rg"

# Workload Identities - Production patterns
workload_identities = {
  "genesis-backend" = {
    role_assignments = [
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0/resourceGroups/oorja-staging-rg"
        scope_type = "rg" 
        role       = "Storage Blob Data Contributor"
      },
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0/resourceGroups/oorja-staging-rg"
        scope_type = "rg"
        role       = "Key Vault Secrets User"
      }
    ]
    federated_credentials = [
      {
        name     = "genesis-backend-sa"
        subject  = "system:serviceaccount:genesis:backend-service-account"
        audience = "api://AzureADTokenExchange"
      }
    ]
  },
  "velero-backup" = {
    role_assignments = [
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0/resourceGroups/oorja-staging-rg"
        scope_type = "rg"
        role       = "Storage Blob Data Contributor"
      }
    ]
    federated_credentials = [
      {
        name     = "velero-server"
        subject  = "system:serviceaccount:velero:velero-server"
        audience = "api://AzureADTokenExchange"
      }
    ]
  }
}

# Storage classes for different workloads
custom_storage_classes = {
  "fast-ssd" = {
    provisioner = "kubernetes.io/azure-disk"
    parameters = {
      storageaccounttype = "Premium_LRS"
      kind               = "Managed"
    }
    reclaim_policy = "Retain"
    volume_binding_mode = "WaitForFirstConsumer"
  },
  "standard-storage" = {
    provisioner = "kubernetes.io/azure-disk"
    parameters = {
      storageaccounttype = "StandardSSD_LRS"
      kind               = "Managed"
    }
    reclaim_policy = "Retain"
    volume_binding_mode = "WaitForFirstConsumer"
  }
}

# Network Enhancements - Optional NAT Gateway
enable_nat_gateway = true
nat_gateway_count = 1
nat_gateway_zones = ["1"]
nat_gateway_idle_timeout = 10
associate_nat_gateway_to_aks = true

# Network Security Rules
custom_network_rules = {
  "allow-bastion-ssh" = {
    priority                = 100
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "Tcp"
    destination_port_ranges = ["22"]
    source_address_prefixes = ["10.1.5.0/27"]  # Bastion subnet
    description            = "Allow SSH from Bastion"
  },
  "allow-office-kubectl" = {
    priority                = 200
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "Tcp"
    destination_port_ranges = ["443"]
    source_address_prefixes = ["203.0.113.0/24"]  # Replace with office IP
    description            = "Allow kubectl from office"
  }
}

# Kubernetes RBAC - Staging specific
k8s_cluster_roles = {
  "staging-developer" = {
    labels = {
      environment = "staging"
    }
    rules = [
      {
        api_groups = ["", "apps", "extensions"]
        resources  = ["*"]
        verbs      = ["get", "list", "watch", "create", "update", "patch"]
      }
    ]
  },
  "staging-viewer" = {
    labels = {
      environment = "staging"
    }
    rules = [
      {
        api_groups = ["", "apps", "extensions"]
        resources  = ["*"]
        verbs      = ["get", "list", "watch"]
      }
    ]
  }
}

k8s_cluster_role_bindings = {
  "staging-developers" = {
    role_name = "staging-developer"
    labels    = {}
    subjects = [
      {
        kind = "Group"
        name = "staging-developers"  # Azure AD group
      }
    ]
  }
}

k8s_roles = {}
k8s_role_bindings = {}

# Helm Template Variables
helm_template_values = true
helm_template_vars = { 
  domain_name = "genesis-azure.d01.hdcss.com"
  app_gateway_ip = "10.1.4.100"
}

# Helm releases configuration
helm_releases = {
  "argocd-staging" = {
    chart            = "argo-cd"
    namespace        = "argocd"
    repository       = "https://argoproj.github.io/argo-helm"
    values_file      = "argocd.tftpl"
    create_namespace = true
  }
  "keycloak-staging" = {
    chart            = "keycloak"
    namespace        = "keycloak"
    repository       = "https://codecentric.github.io/helm-charts"
    values_file      = "keycloak.tftpl"
    create_namespace = true
  }
  "observability-ingress" = {
    chart            = "raw"
    namespace        = "observability"
    repository       = "https://bedag.github.io/helm-charts"
    values_file      = "observability.tftpl"
    create_namespace = false
  }
  "monitoring-ingress" = {
    chart            = "raw"
    namespace        = "monitoring"
    repository       = "https://bedag.github.io/helm-charts"
    values_file      = "monitoring.tftpl"
    create_namespace = false
  }
}

tags = {
  Environment = "Staging"
  ManagedBy   = "Terraform"
  Owner       = "DevOps Team"
  Project     = "Genesis Platform"
  Purpose     = "Pre-production Testing"
  CostCenter  = "Engineering"
}
