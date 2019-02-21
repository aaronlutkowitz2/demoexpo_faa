
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
