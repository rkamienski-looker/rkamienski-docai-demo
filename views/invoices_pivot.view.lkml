view: invoices_pivot {
  derived_table: {
    sql: SELECT
      doc_name as id,
      COUNT(*) as doc_count,
      MAX( IF(type_ = 'invoice_id', mention_text, NULL) ) AS invoice_id,
      MAX( IF(type_ = 'invoice_date',mention_text, NULL) ) AS invoice_date,
      MAX( IF(type_ = 'total_amount', mention_text, NULL) ) AS total_amount
      FROM `rkamienski-sandbox.docai_demo.invoices_e2e`
      GROUP BY 1
      ORDER BY 2 DESC
      LIMIT 100
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: id {
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: invoice_id {
    type: string
    sql: ${TABLE}.invoice_id ;;
  }


  dimension: doc_count {
    type: number
    sql: ${TABLE}.doc_count ;;
  }


  dimension: invoice_date {
    type: string
    sql: ${TABLE}.invoice_date ;;
  }

  dimension: total_amount {
    type: string
    sql: ${TABLE}.total_amount ;;
  }

  set: detail {
    fields: [id, doc_count, invoice_id, invoice_date, total_amount]
  }
}
