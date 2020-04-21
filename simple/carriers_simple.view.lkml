view: carriers_simple {
  sql_table_name: faa.carriers ;;

  dimension: code {
    primary_key: yes
    hidden: yes
    type: string
    sql: ${TABLE}.code ;;
  }

  dimension: nickname {
    view_label: "Flights"
    label: "Carrier Name"
    type: string
    sql: ${TABLE}.nickname ;;
  }
}
