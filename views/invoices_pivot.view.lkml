view: invoices_pivot {
  derived_table: {
    sql: SELECT
      doc_name as id,
      COUNT(*) as doc_count,
      MAX( IF(type_ = 'invoice_id', mention_text, NULL) ) AS invoice_id,
      MAX( IF(type_ = 'invoice_date',mention_text, NULL) ) AS invoice_date,
      MAX( IF(type_ = 'total_amount', mention_text, NULL) ) AS total_amount,
      MAX( IF(type_ = 'line_item', mention_text, NULL) ) AS line_item,
      MAX( IF(type_ = 'line_item/description', mention_text, NULL) ) AS line_item_description,

      MAX( IF(type_ = 'supplier_name', mention_text, NULL) ) AS supplier_name,
      MAX( IF(type_ = 'supplier_address', mention_text, NULL) ) AS supplier_address,
      MAX( IF(type_ = 'supplier_email', mention_text, NULL) ) AS supplier_email,
      MAX( IF(type_ = 'vat', mention_text, NULL) ) AS vat

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

  dimension: line_item {
    type: string
    sql: ${TABLE}.line_item ;;
  }

  dimension: line_item_category {
    type: string
    sql: CASE WHEN ${line_item} LIKE '%Storage%' THEN 'Storage'
              WHEN ${line_item} LIKE '%Network%' THEN 'Networking'
              ELSE 'Hardware' END
    ;;
  }

  dimension: line_item_description  {
    type: string
    sql: ${TABLE}.line_item_description  ;;
  }

  dimension: doc_count {
    hidden: yes
    type: number
    sql: ${TABLE}.doc_count ;;
  }

  dimension: invoice_date {
    label: "Invoice Date"
    type: string
    sql: REPLACE(${TABLE}.invoice_date, "/", "-") ;;
  }

  dimension: invoice_year {
    label: "Invoice Year"
    type: number
    sql: RIGHT(${invoice_date}, 4);;
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

  dimension_group: invoice_date_ymd {
    #hidden: yes
    type: time
    timeframes: [date, week, month]
    sql: CASE WHEN ${invoice_month}=0 THEN DATE(PARSE_DATE("%m-%d-%Y", ${invoice_date}))
              ELSE
              DATE(CAST(${invoice_year} AS INT64), ${invoice_month}, 1)
              END ;;
  }

  dimension: total_amount_raw {
    hidden: yes
    type: number
    #sql: ${TABLE}.total_amount ;;
    sql: TRIM(REPLACE(${TABLE}.total_amount, ',', ''));;
  }

  dimension: supplier_name {
    type: string
    sql: ${TABLE}.supplier_name ;;
  }

  dimension: supplier_category {
    type: string
    sql: CASE WHEN ${supplier_name} LIKE '%Technology%' THEN 'IT Products/Services'
              ELSE 'Other' END;;
  }

  dimension: supplier_address {
    type: string
    sql: ${TABLE}.supplier_address;;
  }

  dimension: supplier_email {
    type: string
    sql: ${TABLE}.supplier_email ;;
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
