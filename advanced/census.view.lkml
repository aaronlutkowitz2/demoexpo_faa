
explore: acs_zip_codes_2017_5yr {}
view: acs_zip_codes_2017_5yr {
  sql_table_name:
      (
      SELECT
        acs_zip_codes_2017_5yr.*,
        us_zipcode_boundaries.area_land_meters / 2590000 AS square_land_miles,
        us_zipcode_boundaries.state_name as state_name
      FROM `bigquery-public-data.census_bureau_acs.zip_codes_2017_5yr` AS acs_zip_codes_2017_5yr
      LEFT JOIN `bigquery-public-data.geo_us_boundaries.zip_codes` AS us_zipcode_boundaries
        ON acs_zip_codes_2017_5yr.geo_id = us_zipcode_boundaries.zip_code
      )
      ;;

      # sql_table_name: `bigquery-public-data.census_bureau_acs.zip_codes_2017_5yr`;;
    extends: [acs_base_fields]

    dimension: geo_id {
      primary_key: yes
      # hidden: yes
      type: zipcode
    }

    dimension: state_name {}

    dimension: square_land_miles {
      type: number
      sql: ${TABLE}.square_land_miles ;;
    }

    measure: sum_square_land_miles {
      type: sum
      sql: ${square_land_miles} ;;
    }

    dimension: population_density {
      type: number
      sql: ${total_pop_d} / ${square_land_miles}  ;;
      value_format_name: decimal_1
    }

    measure: average_population_density {
      type: number
      sql: 1.0 * ${total_pop} / nullif(${sum_square_land_miles},0) ;;
      value_format_name: decimal_1
    }

#   measure: population_density {
#     description: "Resident per Square Mile"
#     label: "Density (People per Sq Mi)"
#     type: number
#     sql: 1.0*${total_pop}/nullif(${us_zipcode_boundaries.total_area_land_meters}/2590000,0);;
#     value_format_name: decimal_1
#   }

    dimension: is_high_vulnerability_zipcode {
      description: "Zipcode has more than 5000 residents per square mile"
      type: yesno
      sql: ${population_density}>10000 ;;
    }

    measure: residents_in_highvulnerability_zips {
      description: "Number of residents that live in high Vulnerability zipcodes"
      type: sum
      sql: ${acs_zip_codes_2017_5yr.total_pop_d};;
      filters: {
        field: is_high_vulnerability_zipcode
        value: "yes"
      }
    }

    measure: percent_residents_in_highvulnerability_zips {
      description: "Number of residents that live in high Vulnerability zipcodes"
      type: number
      sql: 1.0*${residents_in_highvulnerability_zips}/nullif(${acs_zip_codes_2017_5yr.total_pop},0);;
      value_format_name: percent_2
    }

  }

  view: acs_base_fields {
    extension: required

    dimension: geo_id {
      # hidden: yes
      primary_key: yes
      type: string
      sql: ${TABLE}.geo_id ;;
    }



    ### Ethnicity / Race Populations ###

    dimension: total_pop_d {
      label: "Total Population"
      hidden: yes
      description: "The total number of all people living in a given geographic area. "
      type: number
      sql: ${TABLE}.total_pop ;;
    }

    measure: total_pop {
      label: "Total Population"
      #group_label: "Total Populations"
      description: "The total number of all people living in a given geographic area. "
      type: sum
      sql: ${total_pop_d} ;;
    }

    dimension: male_pop_d {
      hidden: yes
      label: "Male Population"
      type: number
      sql: ${TABLE}.male_pop ;;
    }

    measure: male_pop {
      group_label: "Total Populations"
      label: "Male Population"
      type: sum
      sql: ${male_pop_d} ;;
    }

    measure: percent_of_population_male {
      group_label: "Percent of Total Populations"
      type: number
      sql: 1.0*${male_pop}/nullif(${total_pop},0) ;;
    }

    dimension: female_pop_d {
      hidden: yes
      label: "Female Population"
      type: number
      sql: ${TABLE}.female_pop ;;
    }

    measure: female_pop {
      group_label: "Total Populations"
      label: "Female Population"
      type: sum
      sql: ${female_pop_d} ;;
    }

    measure: percent_of_population_female {
      group_label: "Percent of Total Populations"
      type: number
      sql: 1.0*${female_pop}/nullif(${total_pop},0) ;;
    }

#   dimension: white_pop_d {
#     hidden: yes
#     label: "White Population"
#     type: number
#     sql: ${TABLE}.white_pop ;;
#   }
#
#   measure: white_pop {
#     group_label: "Total Populations"
#     label: "White Population"
#     type: sum
#     sql: ${white_pop_d} ;;
#   }
#
#   measure: percent_of_population_white {
#     group_label: "Percent of Total Populations"
#     type: number
#     sql: 1.0*${white_pop}/nullif(${total_pop},0) ;;
#   }
#
#   dimension: black_pop_d {
#     hidden: yes
#     label: "Black Population"
#     type: number
#     sql: ${TABLE}.black_pop ;;
#   }
#
#   measure: black_pop {
#     group_label: "Total Populations"
#     label: "Black Population"
#     type: sum
#     sql: ${black_pop_d} ;;
#   }
#
#   measure: percent_of_population_black {
#     group_label: "Percent of Total Populations"
#     type: number
#     sql: 1.0*${black_pop}/nullif(${total_pop},0) ;;
#   }
#
#   dimension: asian_pop_d {
#     hidden: yes
#     label: "Asian Population"
#     type: number
#     sql: ${TABLE}.asian_pop ;;
#   }
#
#   measure: asian_pop {
#     group_label: "Total Populations"
#     label: "Asian Population"
#     type: sum
#     sql: ${asian_pop_d} ;;
#   }
#
#   measure: percent_of_population_asian {
#     group_label: "Percent of Total Populations"
#     type: number
#     sql: 1.0*${asian_pop}/nullif(${total_pop},0) ;;
#   }
#
#   dimension: hispanic_pop_d {
#     hidden: yes
#     label: "Hispanic Population"
#     type: number
#     sql: ${TABLE}.hispanic_pop ;;
#   }
#
#   measure: hispanic_pop {
#     group_label: "Total Populations"
#     label: "Hispanic Population"
#     type: sum
#     sql: ${hispanic_pop_d} ;;
#   }
#
#   measure: percent_of_population_hispanic {
#     group_label: "Percent of Total Populations"
#     type: number
#     sql: 1.0*${hispanic_pop}/nullif(${total_pop},0) ;;
#   }
#
#   dimension: amerindian_pop_d {
#     hidden: yes
#     label: "American Indian Population"
#     type: number
#     sql: ${TABLE}.amerindian_pop ;;
#   }
#
#   measure: amerindian_pop {
#     group_label: "Total Populations"
#     label: "American Indian Population"
#     type: sum
#     sql: ${amerindian_pop_d} ;;
#   }
#
#   measure: percent_of_population_american_indian {
#     group_label: "Percent of Total Populations"
#     type: number
#     sql: 1.0*${amerindian_pop}/nullif(${total_pop},0) ;;
#   }
#
#   dimension: other_race_pop_d {
#     hidden: yes
#     label: "Other Race Population"
#     type: number
#     sql: ${TABLE}.other_race_pop ;;
#   }
#
#   measure: other_race_pop {
#     group_label: "Total Populations"
#     label: "Other Race Population"
#     type: sum
#     sql: ${other_race_pop_d} ;;
#   }
#
#   measure: percent_of_population_other {
#     group_label: "Percent of Total Populations"
#     type: number
#     sql: 1.0*${other_race_pop}/nullif(${total_pop},0) ;;
#   }
#
#   dimension: two_or_more_races_pop_d {
#     hidden: yes
#     label: "Two or More Races Population"
#     type: number
#     sql: ${TABLE}.two_or_more_races_pop ;;
#   }
#
#   measure: two_or_more_races_pop {
#     group_label: "Total Populations"
#     label: "Two or More Races Population"
#     type: sum
#     sql: ${two_or_more_races_pop_d} ;;
#   }
#
#   measure: percent_of_population_two_or_more_races {
#     group_label: "Percent of Total Populations"
#     type: number
#     sql: 1.0*${two_or_more_races_pop}/nullif(${total_pop},0) ;;
#   }
#
#   dimension: not_hispanic_pop_d {
#     hidden: yes
#     label: "Non Hispanic Population"
#     type: number
#     sql: ${TABLE}.not_hispanic_pop ;;
#   }
#
#   measure: not_hispanic_pop {
#     group_label: "Total Populations"
#     label: "Non Hispanic Population"
#     type: sum
#     sql: ${not_hispanic_pop_d} ;;
#   }
#
#   measure: percent_of_population_not_hispanic {
#     group_label: "Percent of Total Populations"
#     type: number
#     sql: 1.0*${not_hispanic_pop}/nullif(${total_pop},0) ;;
#   }

#   dimension: white_including_hispanic {
#     type: number
#     sql: ${TABLE}.white_including_hispanic ;;
#   }
#
#   dimension: black_including_hispanic {
#     type: number
#     sql: ${TABLE}.black_including_hispanic ;;
#   }
#
#   dimension: amerindian_including_hispanic {
#     type: number
#     sql: ${TABLE}.amerindian_including_hispanic ;;
#   }
#
#   dimension: asian_including_hispanic {
#     type: number
#     sql: ${TABLE}.asian_including_hispanic ;;
#   }


    ###### Age groups ####


    dimension: median_age {
      hidden: yes
      type: number
      sql: ${TABLE}.median_age ;;
    }

    measure: average_median_age {
      type: average
      sql: ${median_age} ;;
    }

    dimension: male_under_5 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_under_5 ;;
    }

    dimension: male_5_to_9 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_5_to_9 ;;
    }

    dimension: male_10_to_14 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_10_to_14 ;;
    }

    dimension: male_15_to_17 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_15_to_17 ;;
    }

    dimension: male_18_to_19 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_18_to_19 ;;
    }

    dimension: male_20 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_20 ;;
    }

    dimension: male_21 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_21 ;;
    }

    dimension: male_22_to_24 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_22_to_24 ;;
    }

    dimension: male_25_to_29 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_25_to_29 ;;
    }

    dimension: male_30_to_34 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_30_to_34 ;;
    }

    dimension: male_35_to_39 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_35_to_39 ;;
    }

    dimension: male_40_to_44 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_40_to_44 ;;
    }

    dimension: male_45_to_49 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_45_to_49 ;;
    }

    dimension: male_50_to_54 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_50_to_54 ;;
    }

    dimension: male_55_to_59 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_55_to_59 ;;
    }

    dimension: male_60_61 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_60_61 ;;
    }

    dimension: male_62_64 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_62_64 ;;
    }

    dimension: male_65_to_66 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_65_to_66 ;;
    }

    dimension: male_67_to_69 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_67_to_69 ;;
    }

    dimension: male_70_to_74 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_70_to_74 ;;
    }

    dimension: male_75_to_79 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_75_to_79 ;;
    }

    dimension: male_80_to_84 {
      hidden: yes
      type: number
      sql: ${TABLE}.male_80_to_84 ;;
    }

    dimension: male_85_and_over {
      hidden: yes
      type: number
      sql: ${TABLE}.male_85_and_over ;;
    }

    dimension: male_above_50_d {
      hidden: yes
      type: number
      sql: ${male_50_to_54} + ${male_55_to_59} + ${male_60_61}
        + ${male_62_64} + ${male_above_65_d};;
    }

    measure: male_above_50 {
      group_label: "Males"
      type: sum
      sql: ${male_above_50_d} ;;
    }

    dimension: male_above_65_d {
      hidden: yes
      type: number
      sql: ${male_65_to_66} + ${male_67_to_69} + ${male_70_to_74} + ${male_75_to_79} + ${male_above_80_d};;
    }

    measure: male_above_65 {
      group_label: "Males"
      type: sum
      sql: ${male_above_65_d} ;;
    }

    dimension: male_above_80_d {
      type: number
      sql:${male_80_to_84} + ${male_85_and_over}  ;;
    }

    measure: male_above_80 {
      group_label: "Males"
      type: sum
      sql: ${male_above_80_d} ;;
    }

    dimension: female_under_5 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_under_5 ;;
    }

    dimension: female_5_to_9 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_5_to_9 ;;
    }

    dimension: female_10_to_14 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_10_to_14 ;;
    }

    dimension: female_15_to_17 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_15_to_17 ;;
    }

    dimension: female_18_to_19 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_18_to_19 ;;
    }

    dimension: female_20 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_20 ;;
    }

    dimension: female_21 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_21 ;;
    }

    dimension: female_22_to_24 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_22_to_24 ;;
    }

    dimension: female_25_to_29 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_25_to_29 ;;
    }

    dimension: female_30_to_34 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_30_to_34 ;;
    }

    dimension: female_35_to_39 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_35_to_39 ;;
    }

    dimension: female_40_to_44 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_40_to_44 ;;
    }

    dimension: female_45_to_49 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_45_to_49 ;;
    }

    dimension: female_50_to_54 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_50_to_54 ;;
    }

    dimension: female_55_to_59 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_55_to_59 ;;
    }

    dimension: female_60_to_61 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_60_to_61 ;;
    }

    dimension: female_62_to_64 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_62_to_64 ;;
    }

    dimension: female_65_to_66 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_65_to_66 ;;
    }

    dimension: female_67_to_69 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_67_to_69 ;;
    }

    dimension: female_70_to_74 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_70_to_74 ;;
    }

    dimension: female_75_to_79 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_75_to_79 ;;
    }

    dimension: female_80_to_84 {
      hidden: yes
      type: number
      sql: ${TABLE}.female_80_to_84 ;;
    }

    dimension: female_85_and_over {
      hidden: yes
      type: number
      sql: ${TABLE}.female_85_and_over ;;
    }

    dimension: female_above_50_d {
      hidden: yes
      type: number
      sql: ${female_50_to_54} + ${female_55_to_59} + ${female_60_to_61}
        + ${female_62_to_64} + ${female_above_65_d};;
    }

    measure: female_above_50 {
      group_label: "Females"
      type: sum
      sql: ${female_above_50_d} ;;
    }

    dimension: female_above_65_d {
      hidden: yes
      type: number
      sql: ${female_65_to_66} + ${female_67_to_69} + ${female_70_to_74} + ${female_75_to_79} + ${female_above_80_d};;
    }

    dimension: female_above_70_d {
      hidden: yes
      type: number
      sql: ${female_70_to_74} + ${female_75_to_79} + ${female_above_80_d};;
    }

    dimension: male_above_70_d {
      hidden: yes
      type: number
      sql: ${male_70_to_74} + ${male_75_to_79} + ${male_above_80_d};;
    }

    measure: female_above_65 {
      group_label: "Females"
      type: sum
      sql: ${female_above_65_d} ;;
    }

    dimension: female_above_80_d {
      type: number
      sql:${female_80_to_84} + ${female_85_and_over}  ;;
    }

    measure: female_above_80 {
      group_label: "Females"
      type: sum
      sql: ${female_above_80_d} ;;
    }

    measure: population_above_50 {
      type: number
      sql: ${female_above_50} + ${male_above_50} ;;
    }

    measure: population_above_65 {
      type: number
      sql: ${female_above_65} + ${male_above_65} ;;
    }

    measure: population_above_70 {
      type: sum
      sql: ${female_above_70_d} + ${male_above_70_d} ;;
    }

    measure: population_above_80 {
      type: number
      sql: ${female_above_80} + ${male_above_80} ;;
    }

    measure: percent_above_50 {
      type: number
      sql: 1.0*${population_above_50}/nullif(${total_pop},0) ;;
      value_format_name: percent_2
    }

    measure: percent_above_65 {
      type: number
      sql: 1.0*${population_above_65}/nullif(${total_pop},0);;
      value_format_name: percent_2
    }

    measure: percent_above_70 {
      type: number
      sql: 1.0*${population_above_70}/nullif(${total_pop},0);;
      value_format_name: percent_2
    }

    measure: percent_above_80 {
      type: number
      sql: 1.0*${population_above_80}/nullif(${total_pop},0) ;;
      value_format_name: percent_2
    }


    ####### Commuting ######

    dimension: commuters_by_public_transportation_d {
      hidden: yes
      type: number
      sql: ${TABLE}.commuters_by_public_transportation ;;
    }

    measure:commuters_by_public_transportation {
      sql: ${commuters_by_public_transportation_d} ;;
      type: sum
    }

    measure: percent_public_transport_commuters {
      type: number
      sql: 1.0*${commuters_by_public_transportation}/nullif(${total_pop},0) ;;
      value_format_name: percent_2
    }

    dimension: commute_5_9_mins {
      hidden: yes
      type: number
      sql: ${TABLE}.commute_5_9_mins ;;
    }

    dimension: commute_35_39_mins {
      hidden: yes
      type: number
      sql: ${TABLE}.commute_35_39_mins ;;
    }

    dimension: commute_40_44_mins {
      hidden: yes
      type: number
      sql: ${TABLE}.commute_40_44_mins ;;
    }

    dimension: commute_60_89_mins {
      hidden: yes
      type: number
      sql: ${TABLE}.commute_60_89_mins ;;
    }

    dimension: commute_90_more_mins {
      hidden: yes
      type: number
      sql: ${TABLE}.commute_90_more_mins ;;
    }

    dimension: commute_10_14_mins {
      hidden: yes
      type: number
      sql: ${TABLE}.commute_10_14_mins ;;
    }

    dimension: commute_15_19_mins {
      hidden: yes
      type: number
      sql: ${TABLE}.commute_15_19_mins ;;
    }

    dimension: commute_35_44_mins {
      hidden: yes
      type: number
      sql: ${TABLE}.commute_35_44_mins ;;
    }

    dimension: commute_60_more_mins {
      hidden: yes
      type: number
      sql: ${TABLE}.commute_60_more_mins ;;
    }

    dimension: commute_less_10_mins {
      hidden: yes
      type: number
      sql: ${TABLE}.commute_less_10_mins ;;
    }

    dimension: commuters_16_over {
      hidden: yes
      type: number
      sql: ${TABLE}.commuters_16_over ;;
    }

    dimension: commute_20_24_mins {
      hidden: yes
      type: number
      sql: ${TABLE}.commute_20_24_mins ;;
    }

    dimension: commute_25_29_mins {
      hidden: yes
      type: number
      sql: ${TABLE}.commute_25_29_mins ;;
    }

    dimension: commute_30_34_mins {
      hidden: yes
      type: number
      sql: ${TABLE}.commute_30_34_mins ;;
    }

    dimension: commute_45_59_mins {
      hidden: yes
      type: number
      sql: ${TABLE}.commute_45_59_mins ;;
    }

    dimension: aggregate_travel_time_to_work {
      hidden: yes
      type: number
      sql: ${TABLE}.aggregate_travel_time_to_work ;;
    }

    dimension: commuters_by_bus {
      hidden: yes
      type: number
      sql: ${TABLE}.commuters_by_bus ;;
    }

    dimension: commuters_by_car_truck_van {
      hidden: yes
      type: number
      sql: ${TABLE}.commuters_by_car_truck_van ;;
    }

    dimension: commuters_by_carpool {
      hidden: yes
      type: number
      sql: ${TABLE}.commuters_by_carpool ;;
    }

    dimension: commuters_by_subway_or_elevated {
      hidden: yes
      type: number
      sql: ${TABLE}.commuters_by_subway_or_elevated ;;
    }

    dimension: commuters_drove_alone {
      hidden: yes
      type: number
      sql: ${TABLE}.commuters_drove_alone ;;
    }


    dimension: walked_to_work {
      type: number
      sql: ${TABLE}.walked_to_work ;;
    }

    dimension: worked_at_home {
      type: number
      sql: ${TABLE}.worked_at_home ;;
    }


    #### Household Incomes ###

    dimension: households {
      type: number
      sql: ${TABLE}.households ;;
    }




    ### Family Structures ###

    dimension: families_with_young_children {
      hidden: yes
      type: number
      sql: ${TABLE}.families_with_young_children ;;
    }

    dimension: nonfamily_households {
      hidden: yes
      type: number
      sql: ${TABLE}.nonfamily_households ;;
    }

    dimension: family_households {
      hidden: yes
      sql: ${TABLE}.family_households ;;
    }

#   dimension: children {
#     type: number
#     sql: ${TABLE}.children ;;
#   }
#
#   dimension: children_in_single_female_hh {
#     type: number
#     sql: ${TABLE}.children_in_single_female_hh ;;
#   }
#
#   dimension: married_households {
#     type: number
#     sql: ${TABLE}.married_households ;;
#   }
#
#   dimension: two_parent_families_with_young_children {
#     type: number
#     sql: ${TABLE}.two_parent_families_with_young_children ;;
#   }
#
#   dimension: two_parents_in_labor_force_families_with_young_children {
#     type: number
#     sql: ${TABLE}.two_parents_in_labor_force_families_with_young_children ;;
#   }
#
#   dimension: two_parents_father_in_labor_force_families_with_young_children {
#     type: number
#     sql: ${TABLE}.two_parents_father_in_labor_force_families_with_young_children ;;
#   }
#
#   dimension: two_parents_mother_in_labor_force_families_with_young_children {
#     type: number
#     sql: ${TABLE}.two_parents_mother_in_labor_force_families_with_young_children ;;
#   }
#
#   dimension: two_parents_not_in_labor_force_families_with_young_children {
#     type: number
#     sql: ${TABLE}.two_parents_not_in_labor_force_families_with_young_children ;;
#   }
#
#   dimension: one_parent_families_with_young_children {
#     type: number
#     sql: ${TABLE}.one_parent_families_with_young_children ;;
#   }
#
#   dimension: father_one_parent_families_with_young_children {
#     type: number
#     sql: ${TABLE}.father_one_parent_families_with_young_children ;;
#   }
#
#   dimension: father_in_labor_force_one_parent_families_with_young_children {
#     type: number
#     sql: ${TABLE}.father_in_labor_force_one_parent_families_with_young_children ;;
#   }


    ### Income ###

    dimension: income_less_10000 {
      hidden: yes
      type: number
      sql: ${TABLE}.income_less_10000 ;;
    }

    dimension: income_10000_14999 {
      hidden: yes
      type: number
      sql: ${TABLE}.income_10000_14999 ;;
    }

    dimension: income_15000_19999 {
      hidden: yes
      type: number
      sql: ${TABLE}.income_15000_19999 ;;
    }

    dimension: income_20000_24999 {
      hidden: yes
      type: number
      sql: ${TABLE}.income_20000_24999 ;;
    }

    dimension: income_25000_29999 {
      hidden: yes
      type: number
      sql: ${TABLE}.income_25000_29999 ;;
    }

    dimension: income_30000_34999 {
      hidden: yes
      type: number
      sql: ${TABLE}.income_30000_34999 ;;
    }

    dimension: income_35000_39999 {
      hidden: yes
      type: number
      sql: ${TABLE}.income_35000_39999 ;;
    }

    dimension: income_40000_44999 {
      hidden: yes
      type: number
      sql: ${TABLE}.income_40000_44999 ;;
    }

    dimension: income_45000_49999 {
      hidden: yes
      type: number
      sql: ${TABLE}.income_45000_49999 ;;
    }

    dimension: income_50000_59999 {
      hidden: yes
      type: number
      sql: ${TABLE}.income_50000_59999 ;;
    }

    dimension: income_60000_74999 {
      hidden: yes
      type: number
      sql: ${TABLE}.income_60000_74999 ;;
    }

    dimension: income_75000_99999 {
      hidden: yes
      type: number
      sql: ${TABLE}.income_75000_99999 ;;
    }

    dimension: income_100000_124999 {
      hidden: yes
      type: number
      sql: ${TABLE}.income_100000_124999 ;;
    }

    dimension: income_125000_149999 {
      hidden: yes
      type: number
      sql: ${TABLE}.income_125000_149999 ;;
    }

    dimension: income_150000_199999 {
      hidden: yes
      type: number
      sql: ${TABLE}.income_150000_199999 ;;
    }

    dimension: income_200000_or_more {
      hidden: yes
      type: number
      sql: ${TABLE}.income_200000_or_more ;;
    }

    dimension: median_income {
      type: number
      sql: ${TABLE}.median_income ;;
    }

    dimension: population_in_poverty_income {
      type: number
      sql:
          ${income_less_10000} + ${income_10000_14999} + ${income_15000_19999} + ${income_20000_24999} + ${income_25000_29999} ;;
    }

    dimension: population_total_income {
      type: number
      sql:
          ${income_less_10000} + ${income_10000_14999} + ${income_15000_19999} + ${income_20000_24999} + ${income_25000_29999} + ${income_30000_34999}
        + ${income_35000_39999} + ${income_40000_44999} + ${income_45000_49999} + ${income_50000_59999} + ${income_60000_74999} + ${income_75000_99999}
        + ${income_100000_124999} + ${income_125000_149999} + ${income_150000_199999} + ${income_200000_or_more} ;;
    }

    measure: count_in_poverty_income {
      type: sum
      sql: ${population_in_poverty_income} ;;
    }

    measure: count_total_income {
      type: sum
      sql: ${population_total_income} ;;
    }

    measure: average_median_income {
      type: number
      sql: 1.0 * ${count_in_poverty_income} / nullif(${count_total_income},0) ;;
      value_format_name: percent_1
    }

    dimension: income_per_capita {
      type: number
      sql: ${TABLE}.income_per_capita ;;
    }

    dimension: poverty {
      type: number
      sql: ${TABLE}.poverty ;;
    }



    #### Housing Units ####

    dimension: occupied_housing_units {
      type: number
      sql: ${TABLE}.occupied_housing_units ;;
    }

    dimension: housing_units_renter_occupied {
      type: number
      sql: ${TABLE}.housing_units_renter_occupied ;;
    }

    dimension: dwellings_1_units_detached {
      hidden: yes
      type: number
      sql: ${TABLE}.dwellings_1_units_detached ;;
    }

    dimension: dwellings_1_units_attached {
      hidden: yes
      type: number
      sql: ${TABLE}.dwellings_1_units_attached ;;
    }

    dimension: dwellings_2_units {
      hidden: yes
      type: number
      sql: ${TABLE}.dwellings_2_units ;;
    }

    dimension: dwellings_3_to_4_units {
      hidden: yes
      type: number
      sql: ${TABLE}.dwellings_3_to_4_units ;;
    }

    dimension: dwellings_5_to_9_units {
      hidden: yes
      type: number
      sql: ${TABLE}.dwellings_5_to_9_units ;;
    }

    dimension: dwellings_10_to_19_units {
      hidden: yes
      type: number
      sql: ${TABLE}.dwellings_10_to_19_units ;;
    }

    dimension: dwellings_20_to_49_units {
      hidden: yes
      type: number
      sql: ${TABLE}.dwellings_20_to_49_units ;;
    }

    dimension: dwellings_50_or_more_units {
      hidden: yes
      type: number
      sql: ${TABLE}.dwellings_50_or_more_units ;;
    }

    dimension: dwellings_5_or_more_units_d {
      hidden: yes
      type: number
      sql:  ${dwellings_5_to_9_units} + ${dwellings_10_to_19_units} + ${dwellings_20_to_49_units} +
        ${dwellings_50_or_more_units};;
    }

    measure: dwellings_5_or_more_units {
      description: "Number of Dwellings with 5 or More Units"
      type: sum
      sql: ${dwellings_5_or_more_units_d} ;;
    }

    measure: total_dwellings {
      type: number
      sql: sum(${dwellings_1_units_detached})+sum(${dwellings_1_units_attached})+
          sum(${dwellings_2_units}) + sum(${dwellings_3_to_4_units}) +  sum(${dwellings_5_to_9_units})
          + sum(${dwellings_10_to_19_units}) + sum(${dwellings_20_to_49_units}) +
          sum(${dwellings_50_or_more_units}) + sum(${mobile_homes});;
    }

    measure: percent_apartment_buildings {
      description: "The percentage of dwellings that have 5 or more units"
      type: number
      sql: 1.0*${dwellings_5_or_more_units}/nullif(${total_dwellings},0) ;;
      value_format_name: percent_2
    }

    dimension: mobile_homes {
      hidden: yes
      type: number
      sql: ${TABLE}.mobile_homes ;;
    }

#   dimension: renter_occupied_housing_units_paying_cash_median_gross_rent {
#     type: number
#     sql: ${TABLE}.renter_occupied_housing_units_paying_cash_median_gross_rent ;;
#   }
#
#   dimension: owner_occupied_housing_units_lower_value_quartile {
#     type: number
#     sql: ${TABLE}.owner_occupied_housing_units_lower_value_quartile ;;
#   }
#
#   dimension: owner_occupied_housing_units_median_value {
#     type: number
#     sql: ${TABLE}.owner_occupied_housing_units_median_value ;;
#   }
#
#   dimension: owner_occupied_housing_units_upper_value_quartile {
#     type: number
#     sql: ${TABLE}.owner_occupied_housing_units_upper_value_quartile ;;
#   }
#
#   dimension: housing_built_2005_or_later {
#     type: number
#     sql: ${TABLE}.housing_built_2005_or_later ;;
#   }
#
#   dimension: housing_built_2000_to_2004 {
#     type: number
#     sql: ${TABLE}.housing_built_2000_to_2004 ;;
#   }
#
#   dimension: housing_built_1939_or_earlier {
#     type: number
#     sql: ${TABLE}.housing_built_1939_or_earlier ;;
#   }

#   dimension: households_retirement_income {
#     type: number
#     sql: ${TABLE}.households_retirement_income ;;
#   }
#
#   dimension: different_house_year_ago_different_city {
#     type: number
#     sql: ${TABLE}.different_house_year_ago_different_city ;;
#   }
#
#   dimension: different_house_year_ago_same_city {
#     type: number
#     sql: ${TABLE}.different_house_year_ago_same_city ;;
#   }


    #### Occupation & Education ###

    dimension: employed_agriculture_forestry_fishing_hunting_mining {
      type: number
      sql: ${TABLE}.employed_agriculture_forestry_fishing_hunting_mining ;;
    }

    dimension: employed_arts_entertainment_recreation_accommodation_food {
      type: number
      sql: ${TABLE}.employed_arts_entertainment_recreation_accommodation_food ;;
    }

    dimension: employed_construction {
      type: number
      sql: ${TABLE}.employed_construction ;;
    }

    dimension: employed_education_health_social {
      hidden: yes
      type: number
      sql: ${TABLE}.employed_education_health_social ;;
    }

    measure: percent_high_vulnerability_employed {
      type: number
      description: "Percent of population that is employed in healthcare, eduacation and social work"
      sql: 1.0*sum(${employed_education_health_social})/nullif(${total_pop},0) ;;
      value_format_name: percent_2
    }

    dimension: employed_finance_insurance_real_estate {
      hidden: yes
      type: number
      sql: ${TABLE}.employed_finance_insurance_real_estate ;;
    }

    dimension: employed_information {
      hidden: yes
      type: number
      sql: ${TABLE}.employed_information ;;
    }

    dimension: employed_manufacturing {
      hidden: yes
      type: number
      sql: ${TABLE}.employed_manufacturing ;;
    }

    dimension: employed_other_services_not_public_admin {
      hidden: yes
      type: number
      sql: ${TABLE}.employed_other_services_not_public_admin ;;
    }

    dimension: employed_public_administration {
      hidden: yes
      type: number
      sql: ${TABLE}.employed_public_administration ;;
    }

    dimension: employed_retail_trade {
      hidden: yes
      type: number
      sql: ${TABLE}.employed_retail_trade ;;
    }

    dimension: employed_science_management_admin_waste {
      hidden: yes
      type: number
      sql: ${TABLE}.employed_science_management_admin_waste ;;
    }

    dimension: employed_transportation_warehousing_utilities {
      hidden: yes
      type: number
      sql: ${TABLE}.employed_transportation_warehousing_utilities ;;
    }

    dimension: employed_wholesale_trade {
      hidden: yes
      type: number
      sql: ${TABLE}.employed_wholesale_trade ;;
    }

    dimension: female_female_households {
      type: number
      sql: ${TABLE}.female_female_households ;;
    }

    dimension: gini_index {
      type: number
      sql: ${TABLE}.gini_index ;;
    }


    dimension: occupation_management_arts {
      hidden: yes
      type: number
      sql: ${TABLE}.occupation_management_arts ;;
    }

    dimension: occupation_natural_resources_construction_maintenance {
      hidden: yes
      type: number
      sql: ${TABLE}.occupation_natural_resources_construction_maintenance ;;
    }

    dimension: occupation_production_transportation_material {
      hidden: yes
      type: number
      sql: ${TABLE}.occupation_production_transportation_material ;;
    }

    dimension: occupation_sales_office {
      hidden: yes
      type: number
      sql: ${TABLE}.occupation_sales_office ;;
    }

    dimension: occupation_services {
      hidden: yes
      type: number
      sql: ${TABLE}.occupation_services ;;
    }


#   dimension: sales_office_employed {
#     type: number
#     sql: ${TABLE}.sales_office_employed ;;
#   }
#
#   dimension: some_college_and_associates_degree {
#     type: number
#     sql: ${TABLE}.some_college_and_associates_degree ;;
#   }

#   dimension: workers_16_and_over {
#     type: number
#     sql: ${TABLE}.workers_16_and_over ;;
#   }
#
#   dimension: associates_degree {
#     type: number
#     sql: ${TABLE}.associates_degree ;;
#   }
#
#   dimension: bachelors_degree {
#     type: number
#     sql: ${TABLE}.bachelors_degree ;;
#   }
#
#   dimension: high_school_diploma {
#     type: number
#     sql: ${TABLE}.high_school_diploma ;;
#   }
#
#   dimension: less_one_year_college {
#     type: number
#     sql: ${TABLE}.less_one_year_college ;;
#   }
#
#   dimension: masters_degree {
#     type: number
#     sql: ${TABLE}.masters_degree ;;
#   }
#
#   dimension: one_year_more_college {
#     type: number
#     sql: ${TABLE}.one_year_more_college ;;
#   }
#
#   dimension: pop_25_years_over {
#     type: number
#     sql: ${TABLE}.pop_25_years_over ;;
#   }
#
#   dimension: hispanic_any_race {
#     type: number
#     sql: ${TABLE}.hispanic_any_race ;;
#   }
#
#   dimension: pop_5_years_over {
#     type: number
#     sql: ${TABLE}.pop_5_years_over ;;
#   }
#
#   dimension: speak_only_english_at_home {
#     type: number
#     sql: ${TABLE}.speak_only_english_at_home ;;
#   }
#
#   dimension: speak_spanish_at_home {
#     type: number
#     sql: ${TABLE}.speak_spanish_at_home ;;
#   }
#
#   dimension: speak_spanish_at_home_low_english {
#     type: number
#     sql: ${TABLE}.speak_spanish_at_home_low_english ;;
#   }
#
#   dimension: pop_15_and_over {
#     type: number
#     sql: ${TABLE}.pop_15_and_over ;;
#   }
#
#   dimension: pop_never_married {
#     type: number
#     sql: ${TABLE}.pop_never_married ;;
#   }
#
#   dimension: pop_now_married {
#     type: number
#     sql: ${TABLE}.pop_now_married ;;
#   }
#
#   dimension: pop_separated {
#     type: number
#     sql: ${TABLE}.pop_separated ;;
#   }
#
#   dimension: pop_widowed {
#     type: number
#     sql: ${TABLE}.pop_widowed ;;
#   }
#
#   dimension: pop_divorced {
#     type: number
#     sql: ${TABLE}.pop_divorced ;;
#   }
#
#   dimension: do_date {
#     type: string
#     sql: ${TABLE}.do_date ;;
#   }
#   dimension: housing_units {
#     type: number
#     sql: ${TABLE}.housing_units ;;
#   }
#
#   dimension: vacant_housing_units {
#     type: number
#     sql: ${TABLE}.vacant_housing_units ;;
#   }
#
#   dimension: vacant_housing_units_for_rent {
#     type: number
#     sql: ${TABLE}.vacant_housing_units_for_rent ;;
#   }
#
#   dimension: vacant_housing_units_for_sale {
#     type: number
#     sql: ${TABLE}.vacant_housing_units_for_sale ;;
#   }
#
#   dimension: median_rent {
#     type: number
#     sql: ${TABLE}.median_rent ;;
#   }
#
#   dimension: percent_income_spent_on_rent {
#     type: number
#     sql: ${TABLE}.percent_income_spent_on_rent ;;
#   }
#
#   dimension: owner_occupied_housing_units {
#     type: number
#     sql: ${TABLE}.owner_occupied_housing_units ;;
#   }
#
#   dimension: million_dollar_housing_units {
#     type: number
#     sql: ${TABLE}.million_dollar_housing_units ;;
#   }
#
#   dimension: mortgaged_housing_units {
#     type: number
#     sql: ${TABLE}.mortgaged_housing_units ;;
#   }
#   dimension: median_year_structure_built {
#     type: number
#     sql: ${TABLE}.median_year_structure_built ;;
#   }


    #### Rent Burdens ###

#   dimension: rent_burden_not_computed {
#     description: "Housing units without rent burden computed. Units for which no rent is paid and units occupied by households
#     that reported no income or a net loss comprise this category"
#     type: number
#     sql: ${TABLE}.rent_burden_not_computed ;;
#   }
#
#   dimension: rent_over_50_percent {
#     type: number
#     sql: ${TABLE}.rent_over_50_percent ;;
#   }
#
#   dimension: rent_40_to_50_percent {
#     hidden: yes
#     type: number
#     sql: ${TABLE}.rent_40_to_50_percent ;;
#   }
#
#   dimension: rent_35_to_40_percent {
#     hidden: yes
#     type: number
#     sql: ${TABLE}.rent_35_to_40_percent ;;
#   }
#
#   dimension: rent_30_to_35_percent {
#     hidden: yes
#     type: number
#     sql: ${TABLE}.rent_30_to_35_percent ;;
#   }
#
#   dimension: rent_25_to_30_percent {
#     hidden: yes
#     type: number
#     sql: ${TABLE}.rent_25_to_30_percent ;;
#   }
#
#   dimension: rent_20_to_25_percent {
#     hidden: yes
#     type: number
#     sql: ${TABLE}.rent_20_to_25_percent ;;
#   }
#
#   dimension: rent_15_to_20_percent {
#     hidden: yes
#     type: number
#     sql: ${TABLE}.rent_15_to_20_percent ;;
#   }
#
#   dimension: rent_10_to_15_percent {
#     hidden: yes
#     type: number
#     sql: ${TABLE}.rent_10_to_15_percent ;;
#   }
#
#   dimension: rent_under_10_percent {
#     hidden: yes
#     type: number
#     sql: ${TABLE}.rent_under_10_percent ;;
#   }

#   dimension: armed_forces {
#     type: number
#     sql: ${TABLE}.armed_forces ;;
#   }
#
#   dimension: civilian_labor_force {
#     type: number
#     sql: ${TABLE}.civilian_labor_force ;;
#   }
#
#   dimension: employed_pop {
#     type: number
#     sql: ${TABLE}.employed_pop ;;
#   }
#
#   dimension: unemployed_pop {
#     type: number
#     sql: ${TABLE}.unemployed_pop ;;
#   }
#
#   dimension: not_in_labor_force {
#     type: number
#     sql: ${TABLE}.not_in_labor_force ;;
#   }
#
#   dimension: pop_16_over {
#     type: number
#     sql: ${TABLE}.pop_16_over ;;
#   }
#
#   dimension: pop_in_labor_force {
#     type: number
#     sql: ${TABLE}.pop_in_labor_force ;;
#   }
#
#   dimension: asian_male_45_54 {
#     type: number
#     sql: ${TABLE}.asian_male_45_54 ;;
#   }
#
#   dimension: asian_male_55_64 {
#     type: number
#     sql: ${TABLE}.asian_male_55_64 ;;
#   }
#
#   dimension: black_male_45_54 {
#     type: number
#     sql: ${TABLE}.black_male_45_54 ;;
#   }
#
#   dimension: black_male_55_64 {
#     type: number
#     sql: ${TABLE}.black_male_55_64 ;;
#   }
#
#   dimension: hispanic_male_45_54 {
#     type: number
#     sql: ${TABLE}.hispanic_male_45_54 ;;
#   }
#
#   dimension: hispanic_male_55_64 {
#     type: number
#     sql: ${TABLE}.hispanic_male_55_64 ;;
#   }
#
#   dimension: white_male_45_54 {
#     type: number
#     sql: ${TABLE}.white_male_45_54 ;;
#   }
#
#   dimension: white_male_55_64 {
#     type: number
#     sql: ${TABLE}.white_male_55_64 ;;
#   }
#
#   dimension: bachelors_degree_2 {
#     type: number
#     sql: ${TABLE}.bachelors_degree_2 ;;
#   }
#
#   dimension: bachelors_degree_or_higher_25_64 {
#     type: number
#     sql: ${TABLE}.bachelors_degree_or_higher_25_64 ;;
#   }
#   dimension: one_car {
#     type: number
#     sql: ${TABLE}.one_car ;;
#   }
#
#   dimension: two_cars {
#     type: number
#     sql: ${TABLE}.two_cars ;;
#   }
#
#   dimension: three_cars {
#     type: number
#     sql: ${TABLE}.three_cars ;;
#   }
#
#   dimension: pop_25_64 {
#     type: number
#     sql: ${TABLE}.pop_25_64 ;;
#   }
#
#   dimension: pop_determined_poverty_status {
#     type: number
#     sql: ${TABLE}.pop_determined_poverty_status ;;
#   }
#
#   dimension: population_1_year_and_over {
#     type: number
#     sql: ${TABLE}.population_1_year_and_over ;;
#   }
#
#   dimension: population_3_years_over {
#     type: number
#     sql: ${TABLE}.population_3_years_over ;;
#   }

#   dimension: four_more_cars {
#     type: number
#     sql: ${TABLE}.four_more_cars ;;
#   }
#
#   dimension: graduate_professional_degree {
#     type: number
#     sql: ${TABLE}.graduate_professional_degree ;;
#   }
#
#   dimension: group_quarters {
#     type: number
#     sql: ${TABLE}.group_quarters ;;
#   }
#
#   dimension: high_school_including_ged {
#     type: number
#     sql: ${TABLE}.high_school_including_ged ;;
#   }
#
#   dimension: households_public_asst_or_food_stamps {
#     type: number
#     sql: ${TABLE}.households_public_asst_or_food_stamps ;;
#   }
#
#   dimension: in_grades_1_to_4 {
#     type: number
#     sql: ${TABLE}.in_grades_1_to_4 ;;
#   }
#
#   dimension: in_grades_5_to_8 {
#     type: number
#     sql: ${TABLE}.in_grades_5_to_8 ;;
#   }
#
#   dimension: in_grades_9_to_12 {
#     type: number
#     sql: ${TABLE}.in_grades_9_to_12 ;;
#   }
#
#   dimension: in_school {
#     type: number
#     sql: ${TABLE}.in_school ;;
#   }
#
#   dimension: in_undergrad_college {
#     type: number
#     sql: ${TABLE}.in_undergrad_college ;;
#   }
#
#   dimension: less_than_high_school_graduate {
#     type: number
#     sql: ${TABLE}.less_than_high_school_graduate ;;
#   }
#
#   dimension: male_45_64_associates_degree {
#     type: number
#     sql: ${TABLE}.male_45_64_associates_degree ;;
#   }
#
#   dimension: male_45_64_bachelors_degree {
#     type: number
#     sql: ${TABLE}.male_45_64_bachelors_degree ;;
#   }
#
#   dimension: male_45_64_graduate_degree {
#     type: number
#     sql: ${TABLE}.male_45_64_graduate_degree ;;
#   }
#
#   dimension: male_45_64_less_than_9_grade {
#     type: number
#     sql: ${TABLE}.male_45_64_less_than_9_grade ;;
#   }
#
#   dimension: male_45_64_grade_9_12 {
#     type: number
#     sql: ${TABLE}.male_45_64_grade_9_12 ;;
#   }
#
#   dimension: male_45_64_high_school {
#     type: number
#     sql: ${TABLE}.male_45_64_high_school ;;
#   }
#
#   dimension: male_45_64_some_college {
#     type: number
#     sql: ${TABLE}.male_45_64_some_college ;;
#   }
#
#   dimension: male_45_to_64 {
#     type: number
#     sql: ${TABLE}.male_45_to_64 ;;
#   }
#
#   dimension: male_male_households {
#     type: number
#     sql: ${TABLE}.male_male_households ;;
#   }
#
#   dimension: management_business_sci_arts_employed {
#     type: number
#     sql: ${TABLE}.management_business_sci_arts_employed ;;
#   }
#
#   dimension: no_car {
#     type: number
#     sql: ${TABLE}.no_car ;;
#   }
#
#   dimension: no_cars {
#     type: number
#     sql: ${TABLE}.no_cars ;;
#   }
#
#   dimension: not_us_citizen_pop {
#     type: number
#     sql: ${TABLE}.not_us_citizen_pop ;;
#   }
  }
