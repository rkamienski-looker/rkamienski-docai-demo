# The name of this view in Looker is "Invoices E2e"
view: invoices_e2e {
  # The sql_table_name parameter indicates the underlying database table
  # to be used for all fields in this view.
  sql_table_name: `rkamienski-sandbox.docai_demo.invoices_e2e`
    ;;
  # No primary key is defined for this view. In order to join this view in an Explore,
  # define primary_key: yes on a dimension that has no repeated values.

  # Here's what a typical dimension looks like in LookML.
  # A dimension is a groupable field that can be used to filter query results.
  # This dimension will be called "Confidence" in Explore.

  dimension: confidence {
    type: number
    sql: ${TABLE}.confidence ;;
  }

  # A measure is a field that uses a SQL aggregate function. Here are defined sum and average
  # measures for this dimension, but you can also add measures of many different aggregates.
  # Click on the type parameter to see all the options in the Quick Help panel on the right.

  measure: total_confidence {
    type: sum
    sql: ${confidence} ;;
  }

  measure: average_confidence {
    type: average
    sql: ${confidence} ;;
  }

  dimension: doc_name {
    type: string
    sql: ${TABLE}.doc_name ;;
  }

  dimension: mention_text {
    type: string
    sql: ${TABLE}.mention_text ;;
  }

  dimension: type_ {
    type: string
    sql: ${TABLE}.type_ ;;
  }

  measure: count {
    type: count
    drill_fields: [doc_name]
  }
}
