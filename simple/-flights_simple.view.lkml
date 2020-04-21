view: flights_simple {
  sql_table_name: faa.flights ;;

  #####################
  ## Original Columns
  #####################

  dimension_group: dep {
    type: time
    timeframes: [
      raw,
      time,
      hour_of_day,
      day_of_month,
      day_of_week,
      date,
      month,
      month_name,
      month_num,
      week_of_year,
      year
    ]
    sql: ${TABLE}.dep_time ;;
  }

  dimension: dep_delay {
    type: number
    sql: ${TABLE}.dep_delay ;;
  }

  dimension_group: arr {
    type: time
    timeframes: [
      raw,
      date
    ]
    sql: ${TABLE}.arr_time ;;
  }

  dimension: origin {
    type: string
    sql: ${TABLE}.origin ;;
    drill_fields: [carrier, destination]
  }

  dimension: destination {
    type: string
    sql: ${TABLE}.destination ;;
    drill_fields: [carrier, origin]
  }

  dimension: route {
    type: string
    sql: concat(${origin}, '-', ${destination} )  ;;
    drill_fields: [carrier, origin, destination]
  }

  #####################
  ## % Delays
  #####################

  parameter: minutes_delayed {
    type: number
    default_value: "15"
  }

  dimension: is_flight_delayed {
    type: yesno
    sql: ${dep_delay} >= {% parameter minutes_delayed %} ;;
  }

  measure: count_delayed_flights {
    type: count
    filters: {
      field: is_flight_delayed
      value: "Yes"
    }
  }

  measure: percent_flights_delayed {
    type: number
    sql: 1.0 * ${count_delayed_flights} / nullif(${flight_count},0) ;;
    value_format_name: percent_2
  }

  measure: flight_count {
    type: count
  }















  #####################
  ## Other columns
  #####################

  dimension: id {
    hidden: yes
    primary_key: yes
    type: number
    sql: ${TABLE}.id2 ;;
  }

  dimension: carrier {
    hidden: yes
    type: string
    sql: ${TABLE}.carrier ;;
    drill_fields: [origin, destination]
  }

}
