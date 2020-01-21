- dashboard: airline_user_dashboard
  title: "*Airline User Dashboard"
  layout: newspaper
  elements:
  - title: "% of Flights Delayed"
    name: "% of Flights Delayed"
    model: faa
    explore: flights
    type: looker_bar
    fields: [flights.flight_count, flights.is_flight_delayed]
    pivots: [flights.is_flight_delayed]
    fill_fields: [flights.is_flight_delayed]
    sorts: [flights.flight_count desc 0, flights.is_flight_delayed]
    limit: 500
    column_limit: 50
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    series_types: {}
    point_style: none
    series_colors:
      No - flights.flight_count: "#72D16D"
      Yes - flights.flight_count: "#B32F37"
    series_labels:
      No - flights.flight_count: On Time
      Yes - flights.flight_count: Delayed
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    listen: {}
    row: 0
    col: 0
    width: 7
    height: 7
  - title: Count Flights
    name: Count Flights
    model: faa
    explore: flights
    type: single_value
    fields: [flights.flight_count]
    filters:
      flights.minutes_delayed: '15'
      origin.city_full: ''
      destination.city_full: ''
      flights.dep_month: ''
      flights.dep_year: ''
      carriers.nickname: ''
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    custom_color_enabled: false
    custom_color: forestgreen
    show_single_value_title: true
    show_comparison: false
    comparison_type: value
    comparison_reverse_colors: false
    show_comparison_label: true
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    row: 7
    col: 7
    width: 5
    height: 7
  - title: Flights by Carrier by Year
    name: Flights by Carrier by Year
    model: faa
    explore: flights
    type: looker_area
    fields: [flights.dep_year, carriers.nickname, flights.flight_count]
    pivots: [carriers.nickname]
    filters:
      carriers.nickname: Southwest,United,American,Delta,USAir
      flights.minutes_delayed: '15'
      origin.city_full: ''
      destination.city_full: ''
      flights.dep_month: ''
      flights.dep_year: ''
    sorts: [flights.dep_year desc, carriers.nickname]
    limit: 500
    column_limit: 50
    stacking: percent
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: false
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    show_null_points: true
    point_style: none
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    ordering: none
    show_null_labels: false
    colors: ['palette: Mixed Dark']
    series_colors: {}
    series_types: {}
    hidden_series: []
    row: 7
    col: 12
    width: 12
    height: 7
  - title: Most Common Routes
    name: Most Common Routes
    model: faa
    explore: flights
    type: looker_map
    fields: [flights.origin_location, flights.destination_location, flights.flight_count]
    filters:
      origin.state: "-PR,-HI,-AK"
      destination.state: "-AK,-PR,-HI"
      flights.minutes_delayed: '15'
      origin.city_full: ''
      destination.city_full: ''
      flights.dep_month: ''
      flights.dep_year: ''
      carriers.nickname: ''
    sorts: [flights.flight_count desc]
    limit: 100
    column_limit: 50
    map_plot_mode: lines
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: true
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    stacking: ''
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    series_types: {}
    row: 7
    col: 0
    width: 7
    height: 7
  - title: Longest Routes
    name: Longest Routes
    model: faa
    explore: flights
    type: looker_map
    fields: [flights.origin_location, flights.destination_location, flights.average_flight_length]
    filters:
      flights.flight_count: ">100"
      origin.state: "-AK,-HI,-PR"
      destination.state: "-AK,-HI,-PR"
      flights.minutes_delayed: '15'
      origin.city_full: ''
      destination.city_full: ''
      flights.dep_month: ''
      flights.dep_year: ''
      carriers.nickname: ''
    sorts: [flights.average_flight_length desc]
    limit: 50
    column_limit: 50
    map_plot_mode: lines
    heatmap_gridlines: false
    heatmap_gridlines_empty: false
    heatmap_opacity: 0.5
    show_region_field: true
    draw_map_labels_above_data: true
    map_tile_provider: light
    map_position: fit_data
    map_scale_indicator: 'off'
    map_pannable: true
    map_zoomable: true
    map_marker_type: circle
    map_marker_icon_name: default
    map_marker_radius_mode: proportional_value
    map_marker_units: meters
    map_marker_proportional_scale_type: linear
    map_marker_color_mode: fixed
    show_view_names: false
    show_legend: true
    quantize_map_value_colors: false
    reverse_map_value_colors: false
    map: usa
    map_projection: ''
    quantize_colors: false
    stacking: normal
    show_value_labels: false
    label_density: 25
    legend_position: center
    x_axis_gridlines: false
    y_axis_gridlines: true
    limit_displayed_rows: false
    y_axis_combined: true
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    x_axis_scale: auto
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    ordering: none
    show_null_labels: false
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    colors: []
    series_colors: {}
    series_labels:
      No - flights.flight_count: On Time
      Yes - flights.flight_count: Delayed
    series_types: {}
    row: 14
    col: 17
    width: 7
    height: 7
  - title: Count of Flights from DC
    name: Count of Flights from DC
    model: faa
    explore: flights
    type: looker_area
    fields: [flights.flight_count, flights.dep_month, carriers.nickname]
    pivots: [carriers.nickname]
    fill_fields: [flights.dep_month]
    filters:
      flights.origin: DCA
    sorts: [flights.dep_month desc, carriers.nickname]
    limit: 500
    column_limit: 50
    color_application:
      collection_id: b43731d5-dc87-4a8e-b807-635bef3948e7
      palette_id: fb7bb53e-b77b-4ab6-8274-9d420d3d73f3
      options:
        steps: 5
    x_axis_gridlines: false
    y_axis_gridlines: true
    show_view_names: false
    show_y_axis_labels: true
    show_y_axis_ticks: true
    y_axis_tick_density: default
    y_axis_tick_density_custom: 5
    show_x_axis_label: true
    show_x_axis_ticks: true
    y_axis_scale_mode: linear
    x_axis_reversed: false
    y_axis_reversed: false
    plot_size_by_field: false
    trellis: ''
    stacking: normal
    limit_displayed_rows: false
    legend_position: center
    series_types: {}
    point_style: none
    show_value_labels: false
    label_density: 25
    x_axis_scale: auto
    y_axis_combined: true
    show_null_points: true
    interpolation: linear
    show_totals_labels: false
    show_silhouette: false
    totals_color: "#808080"
    row: 0
    col: 7
    width: 17
    height: 7
