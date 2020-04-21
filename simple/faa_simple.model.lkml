connection: "lookerdata"

include: "/simple/*.view.lkml"         # include all views in this project

explore: flights_simple {

  join: carriers_simple  {
    relationship: many_to_one
    sql_on: ${flights_simple.carrier} = ${carriers_simple.code} ;;
  }







































    view_label: "Flights"
    label: "Flights (Simple)"
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



label: "FAA"
