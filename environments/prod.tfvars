# Production Environment Configuration
# Enterprise-grade setup with full security and high availability
prefix      = "azure"
environment = "prod"
location    = "East US"

# Network Configuration - Production network design
address_space = ["10.2.0.0/16"]
subnet_prefixes = {
  aks     = "10.2.1.0/24"
  private = "10.2.2.0/24"
}

# Application Gateway with WAF v2 - Production requirements
enable_app_gateway = true                   
app_gateway_subnet_cidr = "10.2.4.0/24"     
app_gateway_private_ip = "10.2.4.100"
enable_waf = true                           # WAF v2 enabled
waf_mode = "Prevention"                     # Prevention mode for production

# AKS Configuration - Enterprise production setup
kubernetes_version = "1.32.4"
node_count         = 3                      # 3 nodes minimum for HA
vm_size           = "Standard_D4s_v3"       # 4 vCPU, 16GB RAM for production
ssh_public_key    = ""                      # Empty - ops team manages keys

# Auto-scaling - Production scale
enable_auto_scaling = true
min_count          = 3                      # Minimum 3 for HA across zones
max_count          = 10                     # Allow significant scaling

# Security - Maximum security for production
private_cluster_enabled = true             # Private API server (required)
enable_private_endpoints = true            # All services use private endpoints
enable_firewall = true                     # Azure Firewall for network security
firewall_subnet_cidr = "10.2.3.0/26"
enable_firewall_route = true
firewall_private_ip = "10.2.3.4"
enable_defender = true                     # Microsoft Defender for Cloud

# Multiple node pools for workload separation
enable_node_pools = true
node_pools = {
  "system-critical" = {
    vm_size               = "Standard_D4s_v3"
    node_count           = 3
    enable_auto_scaling  = true
    min_count           = 3
    max_count           = 6
    availability_zones   = ["1", "2", "3"]   # Multi-zone for HA
    os_disk_size_gb     = 128
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
      "nodepool-type" = "system"
      "environment"   = "production"
      "criticality"   = "high"
    }
    node_taints         = [
      "CriticalAddonsOnly=true:NoSchedule"
    ]
    tags               = {
      NodePool = "SystemCritical"
    }
  },
  "user-workloads" = {
    vm_size               = "Standard_D8s_v3"  # Larger VMs for user workloads
    node_count           = 2
    enable_auto_scaling  = true
    min_count           = 2
    max_count           = 8
    availability_zones   = ["1", "2", "3"]
    os_disk_size_gb     = 256
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
      "environment"   = "production"
      "workload"      = "general"
    }
    node_taints         = []
    tags               = {
      NodePool = "UserWorkloads"
    }
  },
  "monitoring" = {
    vm_size               = "Standard_D2s_v3"
    node_count           = 2
    enable_auto_scaling  = true
    min_count           = 2
    max_count           = 4
    availability_zones   = ["1", "2"]
    os_disk_size_gb     = 128
    os_disk_type        = "Managed"
    os_type             = "Linux"
    enable_host_encryption = false
    fips_enabled        = false
    kubelet_disk_type   = "OS"
    max_pods            = 50                  # Lower density for monitoring
    priority            = "Regular"
    eviction_policy     = "Delete"
    spot_max_price      = -1
    max_surge           = "33%"
    node_labels         = {
      "nodepool-type" = "monitoring"
      "environment"   = "production"
      "dedicated"     = "observability"
    }
    node_taints         = [
      "dedicated=observability:NoSchedule"
    ]
    tags               = {
      NodePool = "Monitoring"
    }
  }
}

# Helm Charts - Full production suite
enable_helm_charts         = true
deploy_helm_charts         = true
enable_nginx_ingress       = true
enable_cert_manager        = true
enable_azure_key_vault_csi = true
enable_external_dns        = true           # Enable for production DNS management
enable_prometheus_stack    = true
enable_argocd             = true
enable_cluster_autoscaler = true           # Essential for production
enable_keda               = true           # Event-driven scaling
enable_velero             = true           # Backup/DR essential

# Observability Stack - Enterprise monitoring
enable_observability_stack = true
observability_namespace    = "observability"

# Production Monitoring Stack
enable_opensource_grafana    = true
enable_opensource_prometheus = true
grafana_domain              = "genesis-azure.d01.hdcss.com"
grafana_admin_password      = ""            # Use Azure Key Vault secret
prometheus_retention        = "90d"         # 90 days retention
prometheus_storage_size     = "500Gi"       # Large storage for production

# Full Observability Suite
enable_loki           = true
enable_tempo          = true
enable_mimir          = true               # Long-term metrics storage
enable_promtail       = true
enable_otel_collector = true

# Production retention periods
loki_retention_period   = "720h"          # 30 days
tempo_retention_period  = "336h"          # 14 days
mimir_retention_period  = "8760h"         # 1 year

# Production storage allocations
loki_storage_size  = "200Gi"
tempo_storage_size = "100Gi"
mimir_storage_size = "1Ti"                 # 1TB for long-term metrics

# Production resource allocations
loki_resources = {
  requests = {
    cpu    = "1000m"
    memory = "2Gi"
  }
  limits = {
    cpu    = "2000m"
    memory = "4Gi"
  }
}

tempo_resources = {
  requests = {
    cpu    = "1000m"
    memory = "2Gi"
  }
  limits = {
    cpu    = "2000m"
    memory = "4Gi"
  }
}

mimir_resources = {
  requests = {
    cpu    = "2000m"
    memory = "4Gi"
  }
  limits = {
    cpu    = "4000m"
    memory = "8Gi"
  }
}

# Grafana production resources
grafana_resources = {
  requests = {
    cpu    = "500m"
    memory = "1Gi"
  }
  limits = {
    cpu    = "1000m"
    memory = "2Gi"
  }
}

# Prometheus production resources  
prometheus_resources = {
  requests = {
    cpu    = "1000m"
    memory = "4Gi"
  }
  limits = {
    cpu    = "2000m"
    memory = "8Gi"
  }
}

# External DNS configuration
external_dns_domain_filters = ["d01.hdcss.com"]
external_dns_client_id     = ""            # Managed by workload identity
external_dns_client_secret = ""

# Security Infrastructure - Maximum security
enable_bastion = true                      # Secure access
bastion_subnet_cidr = "10.2.5.0/27"
create_management_vm = true
management_subnet_cidr = "10.2.6.0/27"

# Premium Azure services
acr_sku         = "Premium"               # Premium with geo-replication
acr_geo_replications = ["West US 2"]     # Disaster recovery
service_bus_sku = "Premium"              # Premium tier
service_bus_capacity = 1                 # 1 messaging unit
alert_email     = "production-alerts@company.com"

# Enterprise Certificate Management
certificates_config = {
  "production-wildcard" = {
    issuer             = "Self"             # Use enterprise CA or Let's Encrypt
    validity_months    = 12
    san_names          = ["*.genesis-azure.d01.hdcss.com", "genesis-azure.d01.hdcss.com", "api.genesis-azure.d01.hdcss.com"]
    create_dns_record  = true
    dns_record_name    = "*"
    dns_ttl            = 300
    dns_records        = ["10.2.4.100"]
  },
  "api-certificate" = {
    issuer             = "Self"
    validity_months    = 12
    san_names          = ["api.genesis-azure.d01.hdcss.com"]
    create_dns_record  = true
    dns_record_name    = "api"
    dns_ttl            = 300
    dns_records        = ["10.2.4.100"]
  }
}

# Restricted network access
key_vault_allowed_ips = [
  "10.2.0.0/16",                          # Internal VNet only
  "203.0.113.0/24"                        # Replace with company office IP range
]

# DNS Configuration - Production domain
root_domain             = "genesis-azure.d01.hdcss.com"
create_dns_zone        = true
dns_zone_resource_group = "azure-prod-rg"

# Enterprise Workload Identities
workload_identities = {
  "genesis-backend-prod" = {
    role_assignments = [
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0/resourceGroups/azure-prod-rg"
        scope_type = "rg"
        role       = "Storage Blob Data Contributor"
      },
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0/resourceGroups/azure-prod-rg"
        scope_type = "rg"
        role       = "Key Vault Secrets User"
      },
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0/resourceGroups/azure-prod-rg"
        scope_type = "rg"
        role       = "Cognitive Services User"
      }
    ]
    federated_credentials = [
      {
        name     = "genesis-backend-prod"
        subject  = "system:serviceaccount:genesis:backend-service-account"
        audience = "api://AzureADTokenExchange"
      }
    ]
  },
  "genesis-frontend-prod" = {
    role_assignments = [
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0/resourceGroups/azure-prod-rg"
        scope_type = "rg"
        role       = "Storage Blob Data Reader"
      }
    ]
    federated_credentials = [
      {
        name     = "genesis-frontend-prod"
        subject  = "system:serviceaccount:genesis:frontend-service-account"
        audience = "api://AzureADTokenExchange"
      }
    ]
  },
  "velero-backup-prod" = {
    role_assignments = [
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0"
        scope_type = "subscription"
        role       = "Storage Blob Data Contributor"
      },
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0"
        scope_type = "subscription"
        role       = "Disk Snapshot Contributor"
      }
    ]
    federated_credentials = [
      {
        name     = "velero-server-prod"
        subject  = "system:serviceaccount:velero:velero-server"
        audience = "api://AzureADTokenExchange"
      }
    ]
  },
  "external-dns-prod" = {
    role_assignments = [
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0/resourceGroups/azure-prod-rg"
        scope_type = "rg"
        role       = "DNS Zone Contributor"
      }
    ]
    federated_credentials = [
      {
        name     = "external-dns-prod"
        subject  = "system:serviceaccount:external-dns:external-dns"
        audience = "api://AzureADTokenExchange"
      }
    ]
  }
}

# Enterprise storage classes
custom_storage_classes = {
  "premium-ssd" = {
    provisioner = "kubernetes.io/azure-disk"
    parameters = {
      storageaccounttype = "Premium_LRS"
      kind               = "Managed"
    }
    reclaim_policy = "Retain"           # Retain for production
    volume_binding_mode = "WaitForFirstConsumer"
    allow_volume_expansion = true
  },
  "ultra-ssd" = {
    provisioner = "kubernetes.io/azure-disk"
    parameters = {
      storageaccounttype = "UltraSSD_LRS"
      kind               = "Managed"
    }
    reclaim_policy = "Retain"
    volume_binding_mode = "WaitForFirstConsumer"
    allow_volume_expansion = true
  },
  "standard-retain" = {
    provisioner = "kubernetes.io/azure-disk"
    parameters = {
      storageaccounttype = "StandardSSD_LRS"
      kind               = "Managed"
    }
    reclaim_policy = "Retain"
    volume_binding_mode = "WaitForFirstConsumer"
    allow_volume_expansion = true
  },
  "shared-storage" = {
    provisioner = "kubernetes.io/azure-file"
    parameters = {
      storageaccounttype = "Premium_LRS"
    }
    reclaim_policy = "Retain"
    volume_binding_mode = "Immediate"
    allow_volume_expansion = true
    mount_options = ["file_mode=0777", "dir_mode=0777", "mfsymlinks"]
  }
}

# Network Infrastructure - Production NAT Gateway
enable_nat_gateway = true
nat_gateway_count = 2                     # 2 NAT Gateways for HA
nat_gateway_zones = ["1", "2"]
nat_gateway_idle_timeout = 30
associate_nat_gateway_to_aks = true

# Production Network Security Rules
custom_network_rules = {
  "allow-bastion-ssh" = {
    priority                = 100
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "Tcp"
    destination_port_ranges = ["22"]
    source_address_prefixes = ["10.2.5.0/27"]  # Bastion subnet only
    description            = "Allow SSH from Bastion subnet"
  },
  "allow-office-kubectl" = {
    priority                = 200
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "Tcp"
    destination_port_ranges = ["443"]
    source_address_prefixes = ["203.0.113.0/24"]  # Company office IP range
    description            = "Allow kubectl from corporate offices"
  },
  "allow-monitoring-ingress" = {
    priority                = 300
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "Tcp"
    destination_port_ranges = ["9090", "3000", "9093"]
    source_address_prefixes = ["10.2.0.0/16"]
    description            = "Allow monitoring traffic within VNet"
  },
  "deny-internet-inbound" = {
    priority                = 4000
    direction               = "Inbound"
    access                  = "Deny"
    protocol                = "*"
    destination_port_ranges = ["*"]
    source_address_prefixes = ["Internet"]
    description            = "Deny all inbound from Internet (except allowed)"
  }
}

# Enterprise Kubernetes RBAC with Azure AD Integration
k8s_cluster_roles = {
  "production-admin" = {
    labels = {
      environment = "production"
      rbac_type   = "admin"
    }
    rules = [
      {
        api_groups = ["*"]
        resources  = ["*"]
        verbs      = ["*"]
      }
    ]
  },
  "production-developer" = {
    labels = {
      environment = "production"
      rbac_type   = "developer"
    }
    rules = [
      {
        api_groups = ["", "apps", "extensions", "networking.k8s.io"]
        resources  = ["deployments", "services", "ingresses", "configmaps", "secrets", "pods"]
        verbs      = ["get", "list", "watch", "create", "update", "patch"]
      },
      {
        api_groups = [""]
        resources  = ["pods/log", "pods/exec"]
        verbs      = ["get", "list"]
      }
    ]
  },
  "production-viewer" = {
    labels = {
      environment = "production"
      rbac_type   = "viewer"
    }
    rules = [
      {
        api_groups = ["", "apps", "extensions", "networking.k8s.io"]
        resources  = ["*"]
        verbs      = ["get", "list", "watch"]
      }
    ]
  },
  "monitoring-operator" = {
    labels = {
      environment = "production"
      rbac_type   = "monitoring"
    }
    rules = [
      {
        api_groups = ["monitoring.coreos.com"]
        resources  = ["*"]
        verbs      = ["*"]
      },
      {
        api_groups = [""]
        resources  = ["nodes", "nodes/metrics", "services", "endpoints", "pods"]
        verbs      = ["get", "list", "watch"]
      }
    ]
  }
}

k8s_cluster_role_bindings = {
  "production-platform-admins" = {
    role_name = "production-admin"
    labels    = {
      environment = "production"
    }
    subjects = [
      {
        kind = "Group"
        name = "production-platform-admins"  # Azure AD group
      }
    ]
  },
  "production-developers" = {
    role_name = "production-developer"
    labels    = {
      environment = "production"
    }
    subjects = [
      {
        kind = "Group"
        name = "production-developers"       # Azure AD group
      }
    ]
  },
  "production-sre-team" = {
    role_name = "monitoring-operator"
    labels    = {
      environment = "production"
    }
    subjects = [
      {
        kind = "Group"
        name = "production-sre-team"        # Azure AD group
      }
    ]
  }
}

# Namespace-specific roles for sensitive workloads
k8s_roles = {
  "genesis-namespace-admin" = {
    namespace = "genesis"
    labels = {
      environment = "production"
      namespace   = "genesis"
    }
    rules = [
      {
        api_groups = ["", "apps", "extensions"]
        resources  = ["*"]
        verbs      = ["*"]
      }
    ]
  }
}

k8s_role_bindings = {
  "genesis-developers" = {
    namespace = "genesis"
    role_kind = "Role"
    role_name = "genesis-namespace-admin"
    labels = {
      environment = "production"
    }
    subjects = [
      {
        kind = "Group"
        name = "genesis-developers"
      }
    ]
  }
}

# Helm Template Variables - Production
helm_template_values = true
helm_template_vars = { 
  domain_name = "genesis-azure.d01.hdcss.com"
  app_gateway_ip = "10.2.4.100"
  environment = "production"
}

# Production Helm releases
helm_releases = {
  "argocd-production" = {
    chart            = "argo-cd"
    namespace        = "argocd"
    repository       = "https://argoproj.github.io/argo-helm"
    values_file      = "argocd.tftpl"
    create_namespace = true
  }
  "keycloak-production" = {
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
  Environment = "Production"
  ManagedBy   = "Terraform"
  Owner       = "Platform Team"
  Project     = "Genesis Platform"
  Purpose     = "Production Workloads"
  CostCenter  = "Engineering"
  Criticality = "High"
  Compliance  = "Required"
}
