include "root" {
  path           = find_in_parent_folders("root.hcl")
  merge_strategy = "deep"
}

include "module" {
  path           = find_in_parent_folders("module.hcl")
  merge_strategy = "deep"
}

include "app" {
  path           = find_in_parent_folders("app.hcl")
  merge_strategy = "deep"
}

include "inputs" {
  path           = "inputs.hcl"
  merge_strategy = "deep"
}