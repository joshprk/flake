# Environment variables

variable tenancy_ocid {}
variable user_ocid {}
variable fingerprint {}
variable private_key_path {}
variable region {}
variable namespace {}
variable vcn_dns_label {}

# Define the Oracle provider

terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = ">=7.0.0"
    }

     tls = {
       source = "hashicorp/tls"
       version = ">=4.0"
     }
  }

  backend "oci" {
    bucket = "flake-storage"
    namespace = "idlexzrxsykf"
  }
}

provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid = var.user_ocid
  fingerprint = var.fingerprint
  private_key_path = var.private_key_path
  region = var.region
}

# Define compartment

resource "oci_identity_compartment" "flake_infra" {
  compartment_id = var.tenancy_ocid
  name = "flake-infrastructure"
  description = "Infrastructure for flake"
}

# Define object storage for state files

resource "oci_objectstorage_bucket" "flake_store" {
  compartment_id = oci_identity_compartment.flake_infra.id
  name = "flake-storage"
  namespace = var.namespace
}

# Define the forge network

resource "oci_core_vcn" "flake_network" {
  compartment_id = oci_identity_compartment.flake_infra.id
  display_name = "flake_network"

  cidr_block = "10.0.0.0/16"
  dns_label = var.vcn_dns_label
}

# Define Internet Gateway for public internet access
resource "oci_core_internet_gateway" "flake_igw" {
  compartment_id = oci_identity_compartment.flake_infra.id
  vcn_id         = oci_core_vcn.flake_network.id
  display_name   = "flake_igw"
  enabled        = true
}

# Define Route Table to route traffic through Internet Gateway
resource "oci_core_route_table" "flake_rt" {
  compartment_id = oci_identity_compartment.flake_infra.id
  vcn_id         = oci_core_vcn.flake_network.id
  display_name   = "flake_rt"

  route_rules {
    cidr_block        = "0.0.0.0/0"
    network_entity_id = oci_core_internet_gateway.flake_igw.id
  }
}

resource "oci_core_security_list" "flake_public_security_list" {
  compartment_id = oci_identity_compartment.flake_infra.id
  vcn_id = oci_core_vcn.flake_network.id
  display_name = "flake_public_security_list"

  ingress_security_rules {
    protocol = "1"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "Allow ICMP traffic for ping"
        
    icmp_options {
      type = 8
      code = 0
    }
  }

  ingress_security_rules {
    protocol = "6"
    source = "0.0.0.0/0"
    source_type = "CIDR_BLOCK"
    description = "SSH access"
    
    tcp_options {
        min = 22
        max = 22
    }
  }

  egress_security_rules {
    protocol = "all"
    destination = "0.0.0.0/0"
    destination_type = "CIDR_BLOCK"
    description = "Allow all outbound traffic"
  }
}

resource "oci_core_subnet" "flake_public_subnet" {
  compartment_id = oci_identity_compartment.flake_infra.id
  vcn_id = oci_core_vcn.flake_network.id
  display_name = "flake_public_subnet"

  cidr_block = "10.0.1.0/24"
  dns_label = "public"
  prohibit_public_ip_on_vnic = false

  security_list_ids = [
    oci_core_security_list.flake_public_security_list.id
  ]

  route_table_id = oci_core_route_table.flake_rt.id
}

# Define data sources and SSH keys
# Extract the private key with:
#
#   terraform output -raw forge_private_key
#

data "oci_identity_availability_domain" "forge_ad" {
  compartment_id = var.tenancy_ocid
  ad_number = 3
}

resource "tls_private_key" "forge_ssh_key" {
  algorithm = "ED25519"
}

output "forge_private_key" {
  value = tls_private_key.forge_ssh_key.private_key_openssh
  sensitive = true
}

# Define the forge node

resource "oci_core_instance" "forge" {
  availability_domain = data.oci_identity_availability_domain.forge_ad.name
  compartment_id = oci_identity_compartment.flake_infra.id
  display_name = "forge"
  shape = "VM.Standard.A1.Flex"

  shape_config {
    ocpus = 4
    memory_in_gbs = 24
  }

  source_details {
    source_type = "image"
    # Canonical Ubuntu 24.04
    source_id = "ocid1.image.oc1.iad.aaaaaaaaxn55sqoqlkl4sucwn6edx45upmu3jpq6vwge536nsm6cwyrontva"
    boot_volume_size_in_gbs = 200
    boot_volume_vpus_per_gb = 120
  }

  create_vnic_details {
    subnet_id = oci_core_subnet.flake_public_subnet.id
    assign_public_ip = true
    hostname_label = "forge"
  }

  agent_config {
    are_all_plugins_disabled = true
    is_management_disabled = true
    is_monitoring_disabled = true
  }

  metadata = {
    ssh_authorized_keys = tls_private_key.forge_ssh_key.public_key_openssh

    user_data = base64encode(
      <<-EOT
      !#/bin/bash
      apt update -y && apt upgrade -y
      EOT
    )
  }
}
