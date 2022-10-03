# The name of this view in Looker is "Invoices E2e"
view: invoices_e2e {
  sql_table_name: `rkamienski-sandbox.docai_demo.invoices_e2e`;;

  dimension: doc_name {
    label: "Doc ID"
    type: string
    sql: ${TABLE}.doc_name ;;
  }

  dimension: type {
    type: string
    sql: ${TABLE}.type_ ;;
  }

  dimension: confidence {
    hidden: yes
    type: number
    sql: ${TABLE}.confidence ;;
  }

  measure: confidence_score {
    type: sum
    sql: ${confidence} ;;
  }

  measure: average_confidence_score {
    type: average
    sql: ${confidence} ;;
  }

  dimension: mention_text {
    type: string
    sql: ${TABLE}.mention_text ;;
  }

  measure: count {
    type: count
    drill_fields: [doc_name]
  }
}
