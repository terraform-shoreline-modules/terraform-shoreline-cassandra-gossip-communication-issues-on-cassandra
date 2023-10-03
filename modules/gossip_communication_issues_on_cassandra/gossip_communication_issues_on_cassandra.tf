resource "shoreline_notebook" "gossip_communication_issues_on_cassandra" {
  name       = "gossip_communication_issues_on_cassandra"
  data       = file("${path.module}/data/gossip_communication_issues_on_cassandra.json")
  depends_on = [shoreline_action.invoke_isolate_and_restart_nodes,shoreline_action.invoke_gossip_interval_and_num_endpoints]
}

resource "shoreline_file" "isolate_and_restart_nodes" {
  name             = "isolate_and_restart_nodes"
  input_file       = "${path.module}/data/isolate_and_restart_nodes.sh"
  md5              = filemd5("${path.module}/data/isolate_and_restart_nodes.sh")
  description      = "Identify and isolate the affected nodes, and then restart them to see if this resolves the issue."
  destination_path = "/agent/scripts/isolate_and_restart_nodes.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "gossip_interval_and_num_endpoints" {
  name             = "gossip_interval_and_num_endpoints"
  input_file       = "${path.module}/data/gossip_interval_and_num_endpoints.sh"
  md5              = filemd5("${path.module}/data/gossip_interval_and_num_endpoints.sh")
  description      = "Consider adjusting the gossip settings, such as adjusting the gossip interval or increasing the number of endpoints the nodes can communicate with."
  destination_path = "/agent/scripts/gossip_interval_and_num_endpoints.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_isolate_and_restart_nodes" {
  name        = "invoke_isolate_and_restart_nodes"
  description = "Identify and isolate the affected nodes, and then restart them to see if this resolves the issue."
  command     = "`chmod +x /agent/scripts/isolate_and_restart_nodes.sh && /agent/scripts/isolate_and_restart_nodes.sh`"
  params      = ["NODE2","NODE3","NODE1"]
  file_deps   = ["isolate_and_restart_nodes"]
  enabled     = true
  depends_on  = [shoreline_file.isolate_and_restart_nodes]
}

resource "shoreline_action" "invoke_gossip_interval_and_num_endpoints" {
  name        = "invoke_gossip_interval_and_num_endpoints"
  description = "Consider adjusting the gossip settings, such as adjusting the gossip interval or increasing the number of endpoints the nodes can communicate with."
  command     = "`chmod +x /agent/scripts/gossip_interval_and_num_endpoints.sh && /agent/scripts/gossip_interval_and_num_endpoints.sh`"
  params      = ["ENDPOINTS","INTERVAL"]
  file_deps   = ["gossip_interval_and_num_endpoints"]
  enabled     = true
  depends_on  = [shoreline_file.gossip_interval_and_num_endpoints]
}

