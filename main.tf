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

resource null_resource setup_gitops {
  depends_on = [null_resource.create_yaml]

  provisioner "local-exec" {
    command = "${local.bin_dir}/igc gitops-module '${local.name}' -n '${var.namespace}' --contentDir '${local.yaml_dir}' --serverName '${var.server_name}' -l '${local.layer}' --valueFiles 'values.yaml,${local.values_file}'"

    environment = {
      GIT_CREDENTIALS = nonsensitive(yamlencode(var.git_credentials))
      GITOPS_CONFIG   = yamlencode(var.gitops_config)
    }
  }
}
