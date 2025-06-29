# Minimal Development Configuration
prefix      = "oorja"
environment = "dev"
location    = "East US"

# Network
address_space = ["10.0.0.0/16"]
subnet_prefixes = {
  aks     = "10.0.1.0/24"
  private = "10.0.2.0/24"
}

#Application Gateway
enable_app_gateway = true                   
app_gateway_subnet_cidr = "10.0.4.0/24"     
app_gateway_private_ip = "10.0.4.100"       
enable_waf = true                           
waf_mode = "Prevention"  

# AKS - Basic Configuration
kubernetes_version = "1.32.4"
node_count         = 1
vm_size           = "Standard_B2s"
ssh_public_key    = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDg7XeZzLrasrn7v5fz8yGpi0/JrJAdsOWb6maCwYRJ6czEncGjy0+UbhRRO0h7m+R6FZ1ZRGIHG62Zqnkn06y/ayJ93c7zekdDTdpAnISm9lJRjp3MeDQOSHI/s+HiNl9kFZI3PHNC7A7TB+3PAiBh1DX4jf1+Zg9H32N0spkvyEl5ah1eRzVCygx5JEO+a/KNLxBToJkxE7nlq9Z055lNqhB6yQ9xOcNcsRI9bRnPENFwz4C79OdqBFHRgGk0kFsq+yxdy7jXd1AtcSzsU2zX5smOxUdjsVp9GoyrisXskCihS8eGqVrd/H8Iog/ndn4PJxUdSy3o7kpqvgD/Xk/PzO+vS8pFyOinLljXCbrkMUj336g0qXnN1vPkqFHTRvrJ9FtW2/b1fTMdpvWE5Xxc31oRPpUqygM6atd1JLvc65CBw30cuW4JZ+3HqCVrdCiBiIGhIhjuoSBeEZN+VP3AREZZoLVTJxhQZwUi0foponoNwsVkjMiCUlJ/+FNBxNoGBcxnk4SGxn2LXhrsQzf4CWvNfYauyMPsQP7GnNuuFLlut3/ULY9jR6mvNskMkP5e8mI8B5A8QzeOmFI7u5pgqZJ1NcsbRs8kESo/fTpiOJe1J+oTA5W1qejwK304FJElwXDsJ/wfQeNPbzMEgOlol5mh+13NaJMmlyvLdIH1Bw== saxenaoorja@gmail.com"

# Helm Charts - Enable basic ones for development
enable_helm_charts         = true
deploy_helm_charts         = true
enable_nginx_ingress       = true
enable_cert_manager        = true
enable_azure_key_vault_csi = false  #already created

# Disable complex ones for development
enable_external_dns        = false
enable_prometheus_stack    = false
enable_argocd             = true
enable_cluster_autoscaler = false
enable_keda               = false
enable_velero = false

# External DNS (if enabled later)
external_dns_domain_filters = []
external_dns_client_id     = ""
external_dns_client_secret = ""

# Disable all complex features
enable_private_endpoints = false
enable_firewall         = false
enable_grafana          = false
enable_prometheus       = false
enable_defender         = false
private_cluster_enabled = false
enable_bastion = false

# Basic services only
acr_sku         = "Basic"
service_bus_sku = "Standard"
service_bus_capacity = 0
alert_email     = "saxenaoorja@gmail.com"

certificates_config = {
  "test-wildcard" = {
    issuer             = "Self"                          # Self-signed for private zone
    validity_months    = 12
    san_names          = ["*.test.com", "test.com"]
    create_dns_record  = false                           # Don't auto-create DNS records for private zone
    dns_record_name    = ""                              # Not used when create_dns_record = false
    dns_ttl            = 300
    dns_records        = []                              # Not used when create_dns_record = false
  }
} 

key_vault_allowed_ips = ["0.0.0.0/0"]

# DNS Configuration - Disabled for dev
root_domain             = ""   # Keep empty for private DNS zone
create_dns_zone        = false
dns_zone_resource_group = ""

# Workload Identities (in AKS module)
# Minimal setup for development
workload_identities = {
  # Example: Create a simple workload identity for testing
  # "dev-workload" = {
  #   role_assignments = [
  #     {
  #       scope      = "/subscriptions/${data.azurerm_client_config.current.subscription_id}/resourceGroups/${azurerm_resource_group.this.name}"
  #       scope_type = "rg"
  #       role       = "Reader"  # Minimal permissions
  #     }
  #   ]
  #   federated_credentials = []  # Can be added later
  # }
}

# Enhanced Node Pools - Keep default for dev
# The existing node_pools variable will use the default simple configuration
enable_node_pools = false  # Already set to false by default

# Custom Storage Classes
# Simple storage class for development testing
custom_storage_classes = {
  # "dev-storage" = {
  #   provisioner = "kubernetes.io/azure-disk"
  #   parameters = {
  #     storageaccounttype = "Standard_LRS"  # Cheaper for dev
  #     kind               = "Managed"
  #   }
  #   reclaim_policy = "Delete"
  #   volume_binding_mode = "WaitForFirstConsumer"
  # }
}

# Network Enhancements
# NAT Gateway - Usually not needed for dev
enable_nat_gateway = false
nat_gateway_count = 1
nat_gateway_zones = []  # No zones for dev
nat_gateway_idle_timeout = 10
associate_nat_gateway_to_aks = false

# Custom Network Rules - Basic dev rules only
custom_network_rules = {
  # Example: Allow kubectl access
  # "allow-kubectl" = {
  #   priority                = 200
  #   direction               = "Inbound"
  #   access                  = "Allow"
  #   protocol                = "Tcp"
  #   destination_port_ranges = ["443"]
  #   source_address_prefixes = ["YOUR_HOME_IP/32"]  # Replace with your IP
  #   description            = "Allow kubectl from home"
  # }
}

# Kubernetes RBAC - Minimal for development
k8s_cluster_roles = {
  # Example: Simple pod viewer role
  # "dev-pod-viewer" = {
  #   labels = {}
  #   rules = [
  #     {
  #       api_groups = [""]
  #       resources  = ["pods"]
  #       verbs      = ["get", "list"]
  #     }
  #   ]
  # }
}

k8s_roles = {}  # Namespace-specific roles - not needed for basic dev

k8s_cluster_role_bindings = {
  # Bind the role if created
  # "dev-pod-viewer-binding" = {
  #   role_name = "dev-pod-viewer"
  #   labels    = {}
  #   subjects = [
  #     {
  #       kind = "User"
  #       name = "saxenaoorja@gmail.com"  # Your AAD user
  #     }
  #   ]
  # }
}

k8s_role_bindings = {}  # Not needed for basic dev

# Helm Template Variables
helm_template_values = true
helm_template_vars = { 
  domain_name = "test.com"                               # Your private DNS domain
  app_gateway_ip = "10.0.4.100"                        # App Gateway internal IP
}

# Helm releases configuration
helm_releases = {
  "argocd-dev" = {
    chart            = "argo-cd"
    namespace        = "argocd"             
    repository       = "https://argoproj.github.io/argo-helm"
    values_file      = "argocd.tftpl"
    create_namespace = true                               
  }
  "keycloak-dev" = {
    chart            = "keycloak"
    namespace        = "keycloak"            
    repository       = "oci://registry-1.docker.io/bitnamicharts"
    values_file      = "keycloak.tftpl"
    create_namespace = true                            
  }
}

tags = {
  Environment = "Development"
  ManagedBy   = "Terraform"
  Owner       = "Shiva/Oorja"
  Project     = "Intern Project" 
  Purpose     = "Learning"
}
