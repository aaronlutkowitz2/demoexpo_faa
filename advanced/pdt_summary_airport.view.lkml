
#
# view: national_delay_rate {
#   derived_table: {
#   sql:
#     SELECT
#       COUNT(*) AS flights_count,
#       COUNT(CASE WHEN flights.dep_delay >= 15  THEN 1 ELSE NULL END) AS flights_count_delayed_flights
#     FROM `lookerdata.faa.flights`
#          AS flights
#
#     WHERE (CAST(TIMESTAMP_DIFF(TIMESTAMP(FORMAT_TIMESTAMP('%F %H:%M:%E*S', flights.arr_time , 'America/Los_Angeles')), TIMESTAMP(FORMAT_TIMESTAMP('%F %H:%M:%E*S', flights.dep_time , 'America/Los_Angeles')), MINUTE) AS INT64)) > 0 and (CAST(TIMESTAMP_DIFF(TIMESTAMP(FORMAT_TIMESTAMP('%F %H:%M:%E*S', flights.arr_time , 'America/Los_Angeles')), TIMESTAMP(FORMAT_TIMESTAMP('%F %H:%M:%E*S', flights.dep_time , 'America/Los_Angeles')), MINUTE) AS INT64)) < 2000
#     LIMIT 500
#     ;;
#   }
#   dimension: count {
#     primary_key: yes
#     type: number
#   }
#   dimension: count_delayed_flights {
#     type: number
#   }
#   measure: sum_flights {
#     type: sum
#     sql: ${count} ;;
#   }
#   measure: sum_delayed_flights {
#     type: sum
#     sql: ${count_delayed_flights} ;;
#   }
#   measure: percent_flights_delayed {
#     type: number
#     sql: 1.0 * ${sum_delayed_flights} / nullif(${sum_flights},0) ;;
#     value_format_name: percent_2
#   }
# }


view: national_delay_rate {
  derived_table: {
    explore_source: flights {
      bind_all_filters: yes
      column: count {}
      column: count_delayed_flights {}
    }
  }
  dimension: count {
    primary_key: yes
    type: number
  }
  dimension: count_delayed_flights {
    type: number
  }
  measure: sum_flights {
    type: sum
    sql: ${count} ;;
  }
  measure: sum_delayed_flights {
    type: sum
    sql: ${count_delayed_flights} ;;
  }
  measure: percent_flights_delayed {
    type: number
    sql: 1.0 * ${sum_delayed_flights} / nullif(${sum_flights},0) ;;
    value_format_name: percent_2
  }
}

view: summary_airport {
  derived_table: {
    explore_source: flights {
      column: origin {}
      column: count_delayed_flights {}
      column: flight_count {}
    }
  }
  dimension: origin {
    hidden: yes
    primary_key: yes
  }
  dimension: count_delayed_flights_dim {
    hidden: yes
    type: number
    sql: ${TABLE}.count_delayed_flights ;;
  }
  dimension: flight_count_dim {
    hidden: yes
    type: number
    sql: ${TABLE}.flight_count ;;
  }
  measure: count_delayed_flights {
    label: "Airport Avg - Delayed Flight Count"
    group_label: "Airport Average"
    type: sum
    sql: ${count_delayed_flights_dim} ;;
  }
  measure: flight_count {
    label: "Airport Avg - Flight Count"
    group_label: "Airport Average"
    type: sum
    sql: ${flight_count_dim} ;;
  }
  measure: percent_delayed_flights {
    label: "Airport Avg - Percent Delayed"
    group_label: "Airport Average"
    type: number
    sql: 1.0*${count_delayed_flights} / nullif(${flight_count},0) ;;
    value_format_name: percent_1
  }
  measure: percent_delayed_difference {
    label: "Percent Delayed - Difference from Airport Average"
    group_label: "Airport Average"
    type: number
    sql: ${flights.percent_flights_delayed} - ${percent_delayed_flights};;
    value_format_name: percent_1
  }
}
