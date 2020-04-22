connection: "lookerdata"

include: "/advanced/*.view.lkml"         # include all views in this project
include: "//weather/*.view.lkml"
include: "//weather/*.explore.lkml"
# include: "*.dashboard.lookml"  # include all dashboards in this project

### Model

# explore: test {
#   extends: [bq_gsod]
#   from: bq_gsod
# }

explore: flights {
  view_name: flights
  view_label: "Flights"

  sql_always_where: ${minutes_flight_length} > 0 and ${minutes_flight_length} < 2000  ;;

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



  join: summary_airport {
    view_label: "Flights"
    relationship: many_to_one
    sql_on: ${flights.origin} = ${summary_airport.origin} ;;
  }

  ## Security Parameter
  access_filter: {
    field: carrier
    user_attribute: allowed_airlines
  }

  query: _preview {
    dimensions: [dep_time,flight_num,carrier,origin,destination,dep_delay]
  }

  query: carrier_by_flights_count {
    description: "Which Carriers are flying?"
    group_label: "Carriers"
    dimensions: [carriers.nickname]
    measures: [flight_count]
    sort: {field:flight_count  desc:yes}
  }
  query: destinations_by_filghts_count_top_5 {
    description: "Where are the planes flying?"
    group_label: "Airports"
    dimensions: [destination]
    measures: [flight_count]
    sort: {field:flight_count  desc:yes}
    limit: 5
  }
  query: timeliness_by_flights_count {
    description: "How often are the flights ontime?"
    group_label: "Timeliness"
    dimensions: [is_flight_delayed]
    measures: [flight_count]
    sort: {field:is_flight_delayed  desc:no}
  }
  query: distance_by_flights_count {
    description: "How many of flights are short, medium or long?"
    group_label: "Routes"
    dimensions: [distance_tiers]
    measures: [flight_count]
    sort: {field:distance_tiers  desc:no}
  }
  query: flight_month_by_flights_count {
    description: "Show flights over time"
    group_label: "Time"
    dimensions: [dep_month]
    measures: [flight_count]
    sort: {field:dep_month  desc:no}
  }

#   ## Weather Block
#   join: by_state_by_date {
#     view_label: "Weather"
#     relationship: many_to_one
#     sql_on:
#         ${origin.state} = ${by_state_by_date.state}
#     AND ${flights.arr_date} = ${by_state_by_date.weather_date}
#     ;;
#   }

}

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













### Caching Logic

persist_with: once_weekly

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


test: test_take_off_before_landing {
  explore_source: flights {
    column: flight_count {}
    column: average_distance {}
    filters: {
      field: flights.minutes_flight_length
      value: "<0"
    }
  }
  assert: no_flights_take_off_after_landing {
    expression: ${flights.flight_count} = 0 ;;
  }
  assert: test_2 {
    expression: coalesce(${flights.average_distance},99) > 1 ;;
  }
}



label: "FAA"
