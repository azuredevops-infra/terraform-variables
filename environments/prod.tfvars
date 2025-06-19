# Production Environment Configuration
prefix      = "oorja"
environment = "prod"
location    = "East US"

# Network - Production-grade networking
address_space = ["10.2.0.0/16"]
subnet_prefixes = {
  aks       = "10.2.1.0/24"
  private   = "10.2.2.0/24"
  pods      = "10.2.3.0/24"
  services  = "10.2.4.0/24"
  appgw     = "10.2.5.0/24"   # Application Gateway subnet
  firewall  = "10.2.6.0/24"   # Azure Firewall subnet
}

# AKS - High Availability Production Configuration
kubernetes_version = "1.32.4"
node_count         = 3  # Minimum 3 nodes for HA
vm_size           = "Standard_D4s_v3"  # Production-grade VMs
ssh_public_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDg7XeZzLrasrn7v5fz8yGpi0/JrJAdsOWb6maCwYRJ6czEncGjy0+UbhRRO0h7m+R6FZ1ZRGIHG62Zqnkn06y/ayJ93c7zekdDTdpAnISm9lJRjp3MeDQOSHI/s+HiNl9kFZI3PHNC7A7TB+3PAiBh1DX4jf1+Zg9H32N0spkvyEl5ah1eRzVCygx5JEO+a/KNLxBToJkxE7nlq9Z055lNqhB6yQ9xOcNcsRI9bRnPENFwz4C79OdqBFHRgGk0kFsq+yxdy7jXd1AtcSzsU2zX5smOxUdjsVp9GoyrisXskCihS8eGqVrd/H8Iog/ndn4PJxUdSy3o7kpqvgD/Xk/PzO+vS8pFyOinLljXCbrkMUj336g0qXnN1vPkqFHTRvrJ9FtW2/b1fTMdpvWE5Xxc31oRPpUqygM6atd1JLvc65CBw30cuW4JZ+3HqCVrdCiBiIGhIhjuoSBeEZN+VP3AREZZoLVTJxhQZwUi0foponoNwsVkjMiCUlJ/+FNBxNoGBcxnk4SGxn2LXhrsQzf4CWvNfYauyMPsQP7GnNuuFLlut3/ULY9jR6mvNskMkP5e8mI8B5A8QzeOmFI7u5pgqZJ1NcsbRs8kESo/fTpiOJe1J+oTA5W1qejwK304FJElwXDsJ/wfQeNPbzMEgOlol5mh+13NaJMmlyvLdIH1Bw== saxenaoorja@gmail.com"

# Production Auto-scaling
enable_auto_scaling = true
min_count          = 3
max_count          = 10

# Production Admin Group (replace with actual AD group)
aad_admin_group_ids = ["299b42cc-b252-4e9e-bef2-f4c5370ebdca"]  

# Helm Charts - Full production stack
enable_helm_charts         = true
deploy_helm_charts         = true
enable_nginx_ingress       = true
enable_cert_manager        = true
enable_azure_key_vault_csi = true
enable_external_dns        = true
enable_prometheus_stack    = true
enable_argocd             = true
enable_cluster_autoscaler = true
enable_keda               = true   # Enable event-driven autoscaling
enable_velero             = true   # Backup solution

# External DNS for production
external_dns_domain_filters = ["d01.hdcss.com"]
external_dns_client_id     = ""  # Set from Azure AD application
external_dns_client_secret = ""  # Set from Azure AD application secret

# Production Security Features
enable_private_endpoints = true   # Enhanced security
enable_firewall         = true    # Azure Firewall
enable_app_gateway      = true    # Application Gateway with WAF
enable_waf              = true    # Web Application Firewall
enable_grafana          = true    # Monitoring dashboard
enable_prometheus       = true    # Metrics collection
enable_defender         = true    # Microsoft Defender for Containers
private_cluster_enabled = true    # Private AKS cluster
enable_bastion          = true    # Secure access via Bastion

# Production SKUs
acr_sku         = "Premium"  # Premium for geo-replication
service_bus_sku = "Premium"
service_bus_capacity = 2     # Higher capacity
alert_email     = "saxenaoorja@gmail.com"

# Certificate Management - Production certificates
certificates_config = {
  "prod-wildcard" = {
    issuer          = "LetsEncrypt"  # Use Let's Encrypt for production
    validity_months = 3
    san_names       = ["A.d01.hdcss.com", "*.B.d01.hdcss.com"]
    create_dns_record = true
  }
  "api-cert" = {
    issuer          = "LetsEncrypt"
    validity_months = 3
    san_names       = ["api.d01.hdcss.com"]
    create_dns_record = true
  }
}

# DNS Configuration
root_domain             = "d01.hdcss.com"
create_dns_zone        = false  # if managed by ops team
dns_zone_resource_group = ""

# Production Workload Identities
workload_identities = {
  "external-dns" = {
    role_assignments = [
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0/resourceGroups/oorja-prod-rg"
        scope_type = "rg"
        role       = "DNS Zone Contributor"
      }
    ]
    federated_credentials = [
      {
        name     = "external-dns"
        subject  = "system:serviceaccount:external-dns:external-dns"
        audience = "api://AzureADTokenExchange"
      }
    ]
  }
  "cert-manager" = {
    role_assignments = [
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0/resourceGroups/oorja-prod-rg"
        scope_type = "rg"
        role       = "DNS Zone Contributor"
      }
    ]
    federated_credentials = [
      {
        name     = "cert-manager"
        subject  = "system:serviceaccount:cert-manager:cert-manager"
        audience = "api://AzureADTokenExchange"
      }
    ]
  }
  "velero" = {
    role_assignments = [
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0/resourceGroups/oorja-prod-rg"
        scope_type = "rg"
        role       = "Contributor"
      }
    ]
    federated_credentials = [
      {
        name     = "velero"
        subject  = "system:serviceaccount:velero:velero"
        audience = "api://AzureADTokenExchange"
      }
    ]
  }
  "keda" = {
    role_assignments = [
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0/resourceGroups/oorja-prod-rg"
        scope_type = "rg"
        role       = "Monitoring Reader"
      }
    ]
    federated_credentials = [
      {
        name     = "keda"
        subject  = "system:serviceaccount:keda:keda-operator"
        audience = "api://AzureADTokenExchange"
      }
    ]
  }
}

# Production Node Pools - Multi-zone HA
enable_node_pools = true
node_pools = {
  "system" = {
    vm_size              = "Standard_D4s_v3"
    node_count           = 3
    enable_auto_scaling  = true
    min_count           = 3
    max_count           = 5
    availability_zones  = ["1", "2", "3"]  # Multi-zone for HA
    os_disk_size_gb     = 256
    os_disk_type        = "Managed"
    os_type             = "Linux"
    fips_enabled        = true   # FIPS compliance
    kubelet_disk_type   = "OS"
    max_pods            = 110
    priority            = "Regular"
    eviction_policy     = null
    spot_max_price      = null
    max_surge           = "33%"
    node_labels = {
      "nodepool-type" = "system"
      "environment"   = "production"
      "kubernetes.io/os" = "linux"
    }
    node_taints = [
      "CriticalAddonsOnly=true:NoSchedule"
    ]
    tags = {
      "nodepool" = "system"
    }
  }
  "user" = {
    vm_size              = "Standard_D8s_v3"  # Larger for production workloads
    node_count           = 3
    enable_auto_scaling  = true
    min_count           = 3
    max_count           = 10
    availability_zones  = ["1", "2", "3"]
    os_disk_size_gb     = 512
    os_disk_type        = "Managed"
    os_type             = "Linux"
    fips_enabled        = true
    kubelet_disk_type   = "OS"
    max_pods            = 110
    priority            = "Regular"
    eviction_policy     = null
    spot_max_price      = null
    max_surge           = "33%"
    node_labels = {
      "nodepool-type" = "user"
      "environment"   = "production"
    }
    node_taints = []
    tags = {
      "nodepool" = "user"
    }
  }
  "spot" = {
    vm_size              = "Standard_D4s_v3"
    node_count           = 0
    enable_auto_scaling  = true
    min_count           = 0
    max_count           = 5
    availability_zones  = ["1", "2", "3"]
    os_disk_size_gb     = 256
    os_disk_type        = "Managed"
    os_type             = "Linux"
    fips_enabled        = false
    kubelet_disk_type   = "OS"
    max_pods            = 110
    priority            = "Spot"           # Spot instances for cost optimization
    eviction_policy     = "Delete"
    spot_max_price      = 0.05            # Max price per hour
    max_surge           = "33%"
    node_labels = {
      "nodepool-type" = "spot"
      "environment"   = "production"
      "kubernetes.azure.com/scalesetpriority" = "spot"
    }
    node_taints = [
      "kubernetes.azure.com/scalesetpriority=spot:NoSchedule"
    ]
    tags = {
      "nodepool" = "spot"
    }
  }
}

# Production Storage Classes
custom_storage_classes = {
  "ultra-ssd" = {
    provisioner = "kubernetes.io/azure-disk"
    parameters = {
      storageaccounttype = "UltraSSD_LRS"
      kind               = "Managed"
    }
    reclaim_policy = "Retain"
    volume_binding_mode = "WaitForFirstConsumer"
  }
  "premium-ssd" = {
    provisioner = "kubernetes.io/azure-disk"
    parameters = {
      storageaccounttype = "Premium_LRS"
      kind               = "Managed"
    }
    reclaim_policy = "Retain"
    volume_binding_mode = "WaitForFirstConsumer"
  }
  "backup-storage" = {
    provisioner = "kubernetes.io/azure-disk"
    parameters = {
      storageaccounttype = "Standard_LRS"
      kind               = "Managed"
    }
    reclaim_policy = "Retain"
    volume_binding_mode = "WaitForFirstConsumer"
  }
}

# Production Network Enhancements
enable_nat_gateway = true
nat_gateway_count = 3  # One per AZ
nat_gateway_zones = ["1", "2", "3"]
nat_gateway_idle_timeout = 4
associate_nat_gateway_to_aks = true

# Production Network Security Rules
custom_network_rules = {
  "deny-all-inbound" = {
    priority                = 4096
    direction               = "Inbound"
    access                  = "Deny"
    protocol                = "*"
    destination_port_ranges = ["*"]
    source_address_prefixes = ["*"]
    description            = "Deny all inbound traffic (default)"
  }
  "allow-https" = {
    priority                = 200
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "Tcp"
    destination_port_ranges = ["443"]
    source_address_prefixes = ["0.0.0.0/0"]
    description            = "Allow HTTPS traffic"
  }
  "allow-http-redirect" = {
    priority                = 300
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "Tcp"
    destination_port_ranges = ["80"]
    source_address_prefixes = ["0.0.0.0/0"]
    description            = "Allow HTTP for redirect to HTTPS"
  }
}

# Production RBAC - Principle of least privilege
k8s_cluster_roles = {
  "prod-admin" = {
    labels = {
      environment = "production"
      access-level = "admin"
    }
    rules = [
      {
        api_groups = ["*"]
        resources  = ["*"]
        verbs      = ["*"]
      }
    ]
  }
  "prod-developer" = {
    labels = {
      environment = "production"
      access-level = "developer"
    }
    rules = [
      {
        api_groups = ["", "apps", "extensions"]
        resources  = ["pods", "services", "deployments", "replicasets", "configmaps", "secrets"]
        verbs      = ["get", "list", "watch", "create", "update", "patch"]
      }
    ]
  }
  "prod-readonly" = {
    labels = {
      environment = "production"
      access-level = "readonly"
    }
    rules = [
      {
        api_groups = ["*"]
        resources  = ["*"]
        verbs      = ["get", "list", "watch"]
      }
    ]
  }
}

k8s_cluster_role_bindings = {
  "prod-admin-binding" = {
    role_name = "prod-admin"
    labels = {
      environment = "production"
    }
    subjects = [
      {
        kind = "User"
        name = "saxenaoorja@gmail.com"
      }
    ]
  }
}

k8s_roles = {}
k8s_role_bindings = {}

# Helm Templating
helm_template_values = true
helm_template_vars = { 
  domain_name = "d01.hdcss.com"
  environment = "production"
  replica_count = 3
  enable_tls = true
}

# Production Helm releases
helm_releases = {
  "argocd-prod" = {
    chart            = "argo-cd"
    namespace        = "argocd"             
    repository       = "https://argoproj.github.io/argo-helm"
    values_file      = "argocd.tftpl"
    create_namespace = true                               
  }
  "keycloak-prod" = {
    chart            = "keycloak"
    namespace        = "keycloak"            
    repository       = "oci://registry-1.docker.io/bitnamicharts"
    values_file      = "keycloak.tftpl"
    create_namespace = true                            
  }
}

tags = {
  Environment = "Production"
  ManagedBy   = "Terraform"
  Owner       = "Shiva/Oorja"
  Project     = "Intern Project"
  Purpose     = "Production Workloads"
  CostCenter  = "IT-Production"
  Compliance  = "SOC2"
  Backup      = "Required"
  Monitoring  = "24x7"
}