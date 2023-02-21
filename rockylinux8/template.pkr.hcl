variable "vcenter_username" {
  type    = string
  default = ""
}

variable "vcenter_password" {
  type    = string
  default = ""
}

variable "root_password" {
  type    = string
  default = ""
}

variable "HTTP_IP" {
  type    = string
  default = "10.130.0.250"
}

variable "HTTP_PATH" {
  type    = string
  default = "ks.cfg"
}

variable "version" {
  type    = string
  default = "0.0.X"
}

variable "vcenter" {
  type = map(string)
  default = {
    "cluster_name": "CLUSTER_NAME",
    "datacenter": "DC_NAME",
    "datastore": "DS_NAME",
    "content_lib": "[DS_NAME] contentlib-3e32fd92-9c4c-4da9-98d5-8fd2f95e4e03/ade2c0ee-746c-459a-bf14-0a34a11060df/Rocky-8.6-x86_64-minimal_c24e26b2-9f2a-4663-9e77-b7b7f3465d3e.iso"
  }
}

source "vsphere-iso" "auto_template" {
  CPU_hot_plug         = true
  CPUs                 = 2
  RAM                  = 2048
  RAM_hot_plug         = true
  #boot_command         = ["<up><wait><tab><wait> text ip=10.130.0.30::10.130.0.1:255.255.255.0:template:ens192:none nameserver=8.8.8.8 inst.ks=http://${var.HTTP_IP}/${var.HTTP_PATH}<enter><wait><enter>"]
  boot_command = ["e<down><down><end><bs><bs><bs><bs><bs>inst.text ip=10.130.0.30::10.130.0.1:255.255.255.0:template:ens192:none nameserver=8.8.8.8 inst.ks=http://${ var.HTTP_IP }/${var.HTTP_PATH}<leftCtrlOn>x<leftCtrlOff>"]
  cluster              = "${lookup(var.vcenter, 'cluster_name')}"
  convert_to_template  = true
  create_snapshot      = false
  datacenter           = "${lookup(var.vcenter, 'datacenter')}"
  datastore            = "${lookup(var.vcenter, 'datastore')}"
  disk_controller_type = ["pvscsi"]
  folder               = "Templates/RockyLinux"
  guest_os_type        = "centos8_64Guest"
  host                 = "replace-me.esx.local.lan"
  insecure_connection  = "true"
      # replace this with correct content lib
  iso_paths            = ["${lookup(var.vcenter, 'content_lib')}"]
  network_adapters {
    network      = "VLANDelta3"
    network_card = "vmxnet3"
  }
  notes            = "Template RockyLinux version ${var.version}"
  password         = "${var.vcenter_password}"
  shutdown_command = "/sbin/halt -h -p"
  ssh_password     = "${var.root_password}"
  ssh_username     = "root"
  storage {
    disk_size             = 30720
    disk_thin_provisioned = true
  }
  username       = "${var.vcenter_username}"
  vcenter_server = "replace-me.vcenter.local.lan"
  vm_name        = "template-rockylinux8-${var.version}"
  firmware       = "efi"
}

build {
  sources = ["source.vsphere-iso.auto_template"]

  provisioner "shell" {
    execute_command   = "bash '{{ .Path }}'"
    expect_disconnect = true
    script            = "${path.root}/scripts/requirement.sh"
  }

}