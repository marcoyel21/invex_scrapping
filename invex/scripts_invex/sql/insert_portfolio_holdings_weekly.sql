INSERT IGNORE INTO invexdb.portfolio_holdings_weekly (
  asset_key, 
  publication_date,
  value_type,
  issuer,
  serie,
  rating,
  market_import, 
  percentage,
  id
)


VALUES (
  %s,  
  %s,
  %s,
  %s,
  %s,
  %s,  
  %s,
  %s,  
  %s
)

