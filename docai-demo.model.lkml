connection: "rkamienski-sandbox"

include: "/views/*.view.lkml"                # include all views in the views/ folder in this project
# include: "/**/*.view.lkml"                 # include all views in this project
# include: "my_dashboard.dashboard.lookml"   # include a LookML dashboard called my_dashboard

# # Select the views that should be a part of this model,
# # and define the joins that connect them together.
#
# explore: order_items {
#   join: orders {
#     relationship: many_to_one
#     sql_on: ${orders.id} = ${order_items.order_id} ;;
#   }
#
#   join: users {
#     relationship: many_to_one
#     sql_on: ${users.id} = ${orders.user_id} ;;
#   }
# }

explore: invoices_e2e {
  label: "End-to-end Invoice Summary - Key Value Pairs"
}

explore: invoices_pivot {
  label: "End-to-end Invoice Summary"
  #Filtering out bad data just for demo purposes...
  sql_always_where: ${invoice_date} <> "Sep 24, 2019"
  --AND ${invoice_id} <> "#6000000001"
  --AND ${invoice_id} <> "ATP072"
  ;;
}
