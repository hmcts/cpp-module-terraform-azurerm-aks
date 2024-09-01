/*
resource "azurerm_monitor_data_collection_endpoint" "main" {
  name                = "example-dcre"
  resource_group_name = var.resource_group_name
  location            = var.location

  lifecycle {
    create_before_destroy = true
  }
}

*/

resource "azurerm_monitor_data_collection_rule" "main" {
  for_each            = var.enable_log_analytics_workspace ? var.dcr : {}
  name                = each.key
  location            = var.location
  resource_group_name = var.resource_group_name
  // Uncomment if you have a data collection endpoint
  // data_collection_endpoint_id = var.data_collection_endpoint_id

  destinations {
    log_analytics {
      name                  = "main-destination-log"
      workspace_resource_id = data.azurerm_log_analytics_workspace.main[0].id
    }
    // Example for additional supported destinations
    // event_hub {
    //   name         = "main-destination-eventhub"
    //   event_hub_id = var.event_hub_id
    // }
  }

  dynamic "data_sources" {
    for_each = each.value.extensions
    content {
      extension {
        name           = data_sources.value.name
        extension_name = data_sources.value.extension_name
        streams        = data_sources.value.streams
        extension_settings = jsonencode({
          interval                 = data_sources.value.data_collection_settings.interval,
          namespace_filtering_mode = data_sources.value.data_collection_settings.namespace_filtering_mode,
          enable_container_log_v2  = data_sources.value.data_collection_settings.enable_container_log_v2
        })
      }
    }
  }

  dynamic "data_flow" {
    for_each = {
      for idx, query in each.value.queries : idx => query if query.enable
    }
    content {
      streams      = data_flow.value.streams
      destinations = data_flow.value.destinations
      transform_kql = data_flow.value.query
    }
  }

  dynamic "data_source" {
    for_each = each.value.static_data_flows
    content {
      streams      = data_source.value.streams
      destinations = data_source.value.destinations
    }
  }

  identity {
    type         = "UserAssigned"
    identity_ids = [var.user_assigned_identity_id]
  }

  description = "Main Data Collection Rule"

  tags = {
    environment = "production"
  }

  depends_on = [
    data.azurerm_log_analytics_workspace.main
  ]
}

