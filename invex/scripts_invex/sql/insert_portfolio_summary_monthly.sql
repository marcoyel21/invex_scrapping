INSERT IGNORE INTO invexdb.portfolio_summary_monthly (
  asset_key, 
  publication_date,
  rating, 
  total_portfolio, 
  var_fixed,
  var_avg, 
  id
)


VALUES (
  %s,  
  %s,
  %s,
  %s,
  %s,
  %s,  
  %s
)