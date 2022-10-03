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
    hidden: yes
    type: string
    sql: ${TABLE}.id ;;
  }

  dimension: invoice_id {
    type: string
    sql: ${TABLE}.invoice_id ;;
  }


  dimension: doc_count {
    hidden: yes
    type: number
    sql: ${TABLE}.doc_count ;;
  }

  dimension: invoice_date {
    label: "Invoice Date"
    type: string
    sql: ${TABLE}.invoice_date ;;
  }

  dimension: invoice_month {
    label: "Invoice Month"
    type: number
    sql:
    CASE  WHEN ${invoice_date} LIKE '%Jun%' THEN 6
          WHEN ${invoice_date} LIKE '%Jul%' THEN 7
          WHEN ${invoice_date} LIKE '%Aug%' THEN 8
          WHEN ${invoice_date} LIKE '%Sep%' THEN 9
          WHEN ${invoice_date} LIKE '%Oct%' THEN 10
          WHEN ${invoice_date} LIKE '%Nov%' THEN 11
          WHEN ${invoice_date} LIKE '%Dec%' THEN 12
          WHEN ${invoice_date} LIKE '%Jan%' THEN 1
          WHEN ${invoice_date} LIKE '%Feb%' THEN 2
          WHEN ${invoice_date} LIKE '%Mar%' THEN 3
          WHEN ${invoice_date} LIKE '%Apr%' THEN 4
          WHEN ${invoice_date} LIKE '%May%' THEN 5
    ELSE 0 END
    ;;
  }

  # dimension_group: invoice {
  #   hidden: yes
  #   type: time
  #   timeframes: [date, week, month]
  #   sql: ${invoice_date} ;;
  # }

  dimension: total_amount_raw {
    hidden: yes
    type: number
    #sql: ${TABLE}.total_amount ;;
    sql: TRIM(REPLACE(${TABLE}.total_amount, ',', ''));;
  }

  measure: total_amount {
    type: sum
    sql: CAST(${total_amount_raw} AS FLOAT64) ;;
    value_format_name: usd
  }

  set: detail {
    fields: [id, doc_count, invoice_id, invoice_date, total_amount]
  }
}
