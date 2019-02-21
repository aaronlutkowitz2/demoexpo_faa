view: carriers {
  sql_table_name: faa.carriers ;;

  required_access_grants: [only_regular_advanced_users]

  dimension: code {
    primary_key: yes
    type: string
    sql: ${TABLE}.code ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: nickname {
    label: "Carrier Name"
    type: string
    sql: ${TABLE}.nickname ;;
    link: {
      label: "Carrier Dashboard"
      url: "https://demoexpo.looker.com/dashboards/62?Carrier={{ value }}&Minutes%20Delayed=15"
      icon_url: "http://looker.com/favicon.ico"
    }
  }

  measure: count_carriers {
    type: count
  }
}
