prefix      = "oorja"
environment = "staging"
location    = "East US"

# Network - Larger address space for staging
address_space = ["10.1.0.0/16"]
subnet_prefixes = {
  aks     = "10.1.1.0/24"
  private = "10.1.2.0/24"
  pods    = "10.1.3.0/24"  # Dedicated pod subnet
}

# AKS - Multi-node for HA testing
kubernetes_version = "1.32.4"
node_count         = 2  # Multi-node for HA testing
vm_size           = "Standard_D2s_v3"  # Better performance than dev
ssh_public_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDg7XeZzLrasrn7v5fz8yGpi0/JrJAdsOWb6maCwYRJ6czEncGjy0+UbhRRO0h7m+R6FZ1ZRGIHG62Zqnkn06y/ayJ93c7zekdDTdpAnISm9lJRjp3MeDQOSHI/s+HiNl9kFZI3PHNC7A7TB+3PAiBh6czEncGjy0+UbhRRO0h7m+R6FZ1ZRGIHG62Zqnkn06y/ayJ93c7zekdDTdpAnISm9lJRjp3MeDQOSHI/s+HiNl9kFZI3PHNC7A7TB+3PAiBh1DX4jf1+Zg9H32N0spkvyEl5ah1eRzVCygx5JEO+a/KNLxBToJkxE7nlq9Z055lNqhB6yQ9xOcNcsRI9bRnPENFwz4C79OdqBFHRgGk0kFsq+yxdy7jXd1AtcSzsU2zX5smOxUdjsVp9GoyrisXskCihS8eGqVrd/H8Iog/ndn4PJxUdSy3o7kpqvgD/Xk/PzO+vS8pFyOinLljXCbrkMUj336g0qXnN1vPkqFHTRvrJ9FtW2/b1fTMdpvWE5Xxc31oRPpUqygM6atd1JLvc65CBw30cuW4JZ+3HqCVrdCiBiIGhIhjuoSBeEZN+VP3AREZZoLVTJxhQZwUi0foponoNwsVkjMiCUlJ/+FNBxNoGBcxnk4SGxn2LXhrsQzf4CWvNfYauyMPsQP7GnNuuFLlut3/ULY9jR6mvNskMkP5e8mI8B5A8QzeOmFI7u5pgqZJ1NcsbRs8kESo/fTpiOJe1J+oTA5W1qejwK304FJElwXDsJ/wfQeNPbzMEgOlol5mh+13NaJMmlyvLdIH1Bw== saxenaoorja@gmail.com"

# Auto-scaling for staging
enable_auto_scaling = true
min_count          = 2
max_count          = 5

# Helm Charts - Enable more for staging testing
enable_helm_charts         = true
deploy_helm_charts         = true
enable_nginx_ingress       = true
enable_cert_manager        = true
enable_azure_key_vault_csi = true
enable_external_dns        = true  # Enable for staging
enable_prometheus_stack    = true  # Enable monitoring
enable_argocd             = true   # Enable GitOps
enable_cluster_autoscaler = true   # Enable autoscaling
enable_keda               = false  # Can be enabled later
enable_velero             = true   # Enable backup

# External DNS for staging
external_dns_domain_filters = ["d01.hdcss.com"]
external_dns_client_id     = ""  # Set these from Azure AD app
external_dns_client_secret = ""

# Enhanced security for staging
enable_private_endpoints = false  # Keep false for easier access in staging
enable_firewall         = false
enable_app_gateway      = false
enable_waf              = false
enable_grafana          = true   # Enable for monitoring
enable_prometheus       = true   # Enable for monitoring
enable_defender         = true   # Enable security scanning
private_cluster_enabled = false  # Keep public for staging access
enable_bastion = false

# Better SKUs for staging
acr_sku         = "Standard"  # Better than Basic
service_bus_sku = "Standard"
service_bus_capacity = 1
alert_email     = "saxenaoorja@gmail.com"

# Certificate Management
certificates_config = {
  "staging-app" = {
    issuer          = "Self"
    validity_months = 12
    san_names       = ["A.d01.hdcss.com", "*.B.d01.hdcss.com"]
    create_dns_record = true
  }
}

# DNS Configuration for staging
root_domain             = "d01.hdcss.com"
create_dns_zone        = false  # Assume managed elsewhere
dns_zone_resource_group = ""

# Workload Identities for staging
workload_identities = {
  "external-dns" = {
    role_assignments = [
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0/resourceGroups/oorja-staging-rg"
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
  "velero" = {
    role_assignments = [
      {
        scope      = "/subscriptions/3e336171-d512-41a4-8f0d-01790f9543e0/resourceGroups/oorja-staging-rg"
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
}

# Enhanced Node Pools for staging
enable_node_pools = true
node_pools = {
  "user" = {
    vm_size              = "Standard_D2s_v3"
    node_count           = 1
    enable_auto_scaling  = true
    min_count           = 1
    max_count           = 3
    availability_zones  = ["1", "2"]
    os_disk_size_gb     = 128
    os_disk_type        = "Managed"
    os_type             = "Linux"
    fips_enabled        = false
    kubelet_disk_type   = "OS"
    max_pods            = 110
    priority            = "Regular"
    eviction_policy     = null
    spot_max_price      = null
    max_surge           = "33%"
    node_labels = {
      "nodepool-type" = "user"
      "environment"   = "staging"
    }
    node_taints = []
    tags = {}
  }
}

# Custom Storage Classes
custom_storage_classes = {
  "fast-ssd" = {
    provisioner = "kubernetes.io/azure-disk"
    parameters = {
      storageaccounttype = "Premium_LRS"
      kind               = "Managed"
    }
    reclaim_policy = "Retain"
    volume_binding_mode = "WaitForFirstConsumer"
  }
}

# Network Enhancements
enable_nat_gateway = false
nat_gateway_count = 1
nat_gateway_zones = ["1", "2"]
nat_gateway_idle_timeout = 10
associate_nat_gateway_to_aks = false

# Network Security Rules
custom_network_rules = {
  "allow-staging-access" = {
    priority                = 200
    direction               = "Inbound"
    access                  = "Allow"
    protocol                = "Tcp"
    destination_port_ranges = ["443", "80"]
    source_address_prefixes = ["0.0.0.0/0"]  # Restrict this in production
    description            = "Allow staging web access"
  }
}

# Kubernetes RBAC
k8s_cluster_roles = {
  "staging-admin" = {
    labels = {
      environment = "staging"
    }
    rules = [
      {
        api_groups = ["*"]
        resources  = ["*"]
        verbs      = ["*"]
      }
    ]
  }
}

k8s_cluster_role_bindings = {
  "staging-admin-binding" = {
    role_name = "staging-admin"
    labels = {
      environment = "staging"
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
  environment = "staging"
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
    repository       = "oci://registry-1.docker.io/bitnamicharts"
    values_file      = "keycloak.tftpl"
    create_namespace = true                            
  }

}

tags = {
  Environment = "Staging"
  ManagedBy   = "Terraform"
  Owner       = "Shiva/Oorja"
  Project     = "Intern Project"
  Purpose     = "Staging Testing"
  CostCenter  = "IT-Development"
}