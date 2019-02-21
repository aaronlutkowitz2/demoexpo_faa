connection: "lookerdata"

include: "*.view.lkml"         # include all views in this project
# include: "*.dashboard.lookml"  # include all dashboards in this project

### Model

explore: flights {
  view_name: flights
  view_label: "Flights"

  sql_always_where: ${flight_length} > 0 and ${flight_length} < 2000 ;;

  join: origin {
    from: airport
    relationship: many_to_one
    sql_on: ${flights.origin} = ${origin.code} ;;
  }

  join: destination {
    from: airport
    relationship: many_to_one
    sql_on: ${flights.destination} = ${destination.code} ;;
  }

  join: carriers  {
    relationship: many_to_one
    sql_on: ${flights.carrier} = ${carriers.code} ;;
  }











  ## Security Parameter
  access_filter: {
    field: carriers.nickname
    user_attribute: allowed_airlines
  }
}










### Caching Logic

persist_with: once_weekly

### Permission Set

access_grant: can_see_sensitive_data {
  user_attribute: can_see_sensitive_data
  allowed_values: ["yes"]
}

access_grant: only_regular_advanced_users {
  user_attribute: user_type
  allowed_values: ["Regular","Advanced"]
}

access_grant: only_advanced_users {
  user_attribute: user_type
  allowed_values: ["Advanced"]
}

### PDT Timeframes

datagroup: once_daily {
  max_cache_age: "24 hours"
  sql_trigger: SELECT current_date() ;;
}

datagroup: once_weekly {
  max_cache_age: "168 hours"
  sql_trigger: SELECT extract(week from current_date()) ;;
}

datagroup: once_monthly {
  max_cache_age: "720 hours"
  sql_trigger: SELECT extract(month from current_date()) ;;
}

datagroup: once_yearly {
  max_cache_age: "9000 hours"
  sql_trigger: SELECT extract(year from current_date()) ;;
}

label: "FAA"
