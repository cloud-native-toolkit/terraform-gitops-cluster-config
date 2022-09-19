locals {
  name          = "cluster-config"
  bin_dir       = module.setup_clis.bin_dir
  yaml_dir      = "${path.cwd}/.tmp/${local.name}/chart/${local.name}"
  values_file   = "value-${var.server_name}.yaml"
  values_content = {
    ocp-console-notification = {
      backgroundColor = var.banner_background_color
      color = var.banner_text_color
      text = var.banner_text
    }
  }
  layer = "infrastructure"
  application_branch = "main"
  gitops_url = var.gitops_config.boostrap["argocd-config"].url
  layer_config = var.gitops_config[local.layer]
  type = "base"
}

module setup_clis {
  source = "github.com/cloud-native-toolkit/terraform-util-clis.git"
}

resource null_resource create_yaml {
  provisioner "local-exec" {
    command = "${path.module}/scripts/create-yaml.sh '${local.name}' '${local.yaml_dir}' '${local.values_file}' '${local.gitops_url}'"

    environment = {
      VALUES_CONTENT = yamlencode(local.values_content)
      BIN_DIR = local.bin_dir
    }
  }
}

resource gitops_module module {
  depends_on = [null_resource.create_yaml]

  name = local.name
  namespace = var.namespace
  content_dir = local.yaml_dir
  server_name = var.server_name
  layer = local.layer
  type = local.type
  branch = local.application_branch
  config = yamlencode(var.gitops_config)
  credentials = yamlencode(var.git_credentials)
  value_files = "values.yaml,${local.values_file}"
}
