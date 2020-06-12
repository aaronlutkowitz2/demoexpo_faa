# ########## DO NOT DELETE!!
#
# ####### Demo flow for creating new FAA project
# ####### Uncomment this file @ beginning of meeting, then recomment @ end
#
#
# ## Step 1: Create new project, flights + carriers
#
# ## Step 2: Create model, explore it
#
#   connection: "lookerdata"
#   explore: flights {}
#   # Count of flights
#   # Count of flights by month
#   # Filter on origin
#   # Pivot on origin
#
# ## Step 3: Add in simple dimension - route
#
#   dimension: route {
#     type: string
#     sql: concat(${origin}, '-', ${destination} )  ;;
#   }
#   # Explore
#
# ## Step 4: Add in drill fields
#
#   drill_fields: [carrier]
#   # Drill
#
# ## Step 4B: Join in carriers table
#
#   # code
#   primary_key: yes
#
#   # join
#   explore: flights {
#     join: carriers  {
#       relationship: many_to_one
#       sql_on: ${flights.carrier} = ${carriers.code} ;;
#     }
#   }
#
#   # change drill field on route
#   drill_fields: [carriers.nickname]
#
# ## Step 5: Flight length
#
#   dimension_group: flight_length {
#     type: duration
#     intervals: [minute, hour]
#     sql_start: ${dep_raw} ;;
#     sql_end: ${arr_raw} ;;
#     description: "Time between arrival and departure time (excludes taxi-time)"
#   }
#   # Explore
#
# ## Step 6: add where clause
#   sql_always_where: ${minutes_flight_length} > 0 and ${minutes_flight_length} < 2000  ;;
#
# ## Step 7: Tier flight length
#   dimension: flight_length_tier {
#     label: "Flight Length Tier (Minutes)"
#     type: tier
#     sql: ${minutes_flight_length} ;;
#     tiers: [60,120,180]
#     style: integer
#     drill_fields: [minutes_flight_length]
#   }
#
# ## Step 8: Is flight delayed
#   parameter: minutes_delayed {
#     type: number
#     default_value: "15"
#   }
#
#   dimension: is_flight_delayed {
#     type: yesno
#     sql: ${dep_delay} >= {% parameter minutes_delayed %} ;;
#   }
#   # Explore
#
# ## Step 9: # Count Flights, % Delayed Flights
#
#   measure: count_delayed_flights {
#     type: count
#     filters: {
#       field: is_flight_delayed
#       value: "Yes"
#     }
#   }
#
#   measure: percent_flights_delayed {
#     type: number
#     sql: 1.0 * ${count_delayed_flights} / nullif(${count},0) ;;
#     value_format_name: percent_2
#     drill_fields: [route, carrier, count, count_delayed_flights, percent_flights_delayed]
#   }
#   # Deep dive into 9/11
#   # Filter on August to December 2001
#   # Filter on DC & NY airports - IAD, DCA, BWI, JFK, LGA, EWR
#   # Split by flight length
#   # Show % delays over time
#
# ## Step 10: Compare an airport's delays vs. national average
#
#   ## Step A: Run # flights, # flights delayed
#
#     view: national_delay_rate {
#       derived_table: {
#         sql:
#         SELECT
#           COUNT(*) AS count,
#           COUNT(CASE WHEN flights.dep_delay >= 15  THEN 1 ELSE NULL END) AS count_delayed_flights
#         FROM `lookerdata.faa.flights`
#              AS flights
#
#         WHERE (CAST(TIMESTAMP_DIFF(TIMESTAMP(FORMAT_TIMESTAMP('%F %H:%M:%E*S', flights.arr_time , 'America/Los_Angeles')), TIMESTAMP(FORMAT_TIMESTAMP('%F %H:%M:%E*S', flights.dep_time , 'America/Los_Angeles')), MINUTE) AS INT64)) > 0 and (CAST(TIMESTAMP_DIFF(TIMESTAMP(FORMAT_TIMESTAMP('%F %H:%M:%E*S', flights.arr_time , 'America/Los_Angeles')), TIMESTAMP(FORMAT_TIMESTAMP('%F %H:%M:%E*S', flights.dep_time , 'America/Los_Angeles')), MINUTE) AS INT64)) < 2000
#         LIMIT 500
#         ;;
#       }
#       dimension: count {
#         primary_key: yes
#         type: number
#       }
#       dimension: count_delayed_flights {
#         type: number
#       }
#       measure: sum_flights {
#         type: sum
#         sql: ${count} ;;
#       }
#       measure: sum_delayed_flights {
#         type: sum
#         sql: ${count_delayed_flights} ;;
#       }
#       measure: percent_flights_delayed {
#         type: number
#         sql: 1.0 * ${sum_delayed_flights} / nullif(${sum_flights},0) ;;
#         value_format_name: percent_2
#       }
#     }
#
#     explore: flights {
#       join: national_delay_rate {
#         relationship: one_to_one
#         sql_on: 1 = 1 ;;
#       }
#     }
#
#     measure: percent_delayed_vs_national_average {
#       description: "% Delayed vs. National Average (Absolute Difference)"
#       type: number
#       sql: ${percent_flights_delayed} - ${national_delay_rate.percent_flights_delayed} ;;
#       value_format_name: percent_2
#     }
#
#     measure: percent_delayed_vs_national_average_percent {
#       description: "% Delayed vs. National Average (Percent Difference)"
#       type: number
#       sql: (1.0 * ${percent_delayed_vs_national_average}) / nullif(${national_delay_rate.percent_flights_delayed},0) ;;
#       value_format_name: percent_2
#     }
#     # Explore: problem - you change user parameter
#
#   ## Step B - create same thing with NDT
#     # Explore: problem - you filter to one specific year... now national average is off...
#
#     # update delayed flights to 30
#     dimension: is_flight_delayed {
#       type: yesno
#       sql: ${dep_delay} >= 30 ;;
#     }
#
#     derived_table: {
#       explore_source: flights {
#         column: count {}
#         column: count_delayed_flights {}
#       }
#     }
#
#
#   ## Step C - create same thing with Bind all filters
