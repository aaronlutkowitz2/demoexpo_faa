# connection: "lookerdata"

include: "*.view.lkml"                       # include all views in this project
include: "faa.model.lkml"

label: "FAA - Risk Team"

explore: flights_risk_team {

  extends: [flights]
  view_name: flights_risk_team

  join: values_by_carrier_by_origin {
    relationship: many_to_one
    sql_on:
          ${flights_risk_team.carrier} = ${values_by_carrier_by_origin.carrier}
      AND ${flights_risk_team.origin} = ${values_by_carrier_by_origin.origin}
      ;;
  }








  join: flights {
    # fields: []
    relationship: one_to_one
    sql_on: ${flights.id} = ${flights_risk_team.id} ;;
  }

  ## Security Parameter
  access_filter: {
    field: flights_risk_team.carrier
    user_attribute: allowed_airlines
  }
}
