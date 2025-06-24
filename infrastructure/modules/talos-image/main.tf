locals {
  image_name_template        = "talos-%s-%s-%s.img"
  image_factory_url_template = "https://factory.talos.dev/image/%s/%s/%s-%s.raw.gz"
}



resource "proxmox_virtual_environment_download_file" "current_release_img" {
  content_type            = "iso"
  datastore_id            = "local"
  file_name               = format(local.image_name_template, var.image.schematic_id, var.image.version, var.image.arch)
  node_name               = var.host_node
  url                     = format(local.image_factory_url_template, var.image.schematic_id, var.image.version, var.image.platform, var.image.arch)
  decompression_algorithm = "gz"
  overwrite               = false
  overwrite_unmanaged = true
  lifecycle {
    ignore_changes = [size, ]
  }
}

resource "proxmox_virtual_environment_download_file" "update_release_img" {
  count                   = var.image.update_version != null && (var.image.update_version != var.image.version || var.image.update_schematic_id != var.image.schematic_id) ? 1 : 0
  content_type            = "iso"
  datastore_id            = "local"
  file_name               = format(local.image_name_template, coalesce(var.image.update_schematic_id, var.image.schematic_id), coalesce(var.image.update_version, var.image.version), var.image.arch)
  node_name               = var.host_node
  url                     = format(local.image_factory_url_template, coalesce(var.image.update_schematic_id, var.image.schematic_id), var.image.update_version, var.image.platform, var.image.arch)
  decompression_algorithm = "gz"
  overwrite               = false
  overwrite_unmanaged = true
  lifecycle {
    ignore_changes = [size, ]
  }
}

output "current_release_image_id" {
  value = proxmox_virtual_environment_download_file.current_release_img.id
}
output "update_release_image_id" {
  value       = length(proxmox_virtual_environment_download_file.update_release_img) > 0 ? proxmox_virtual_environment_download_file.update_release_img[0].id : ""
  description = "The name of the update image file if downloaded"
}