CREATE TABLE IF NOT EXISTS invexdb.portfolio_holdings_weekly (
    asset_key VARCHAR(12), 
    publication_date date,
    value_type VARCHAR(6), 
    issuer VARCHAR(12), 
    serie VARCHAR(12),
    rating VARCHAR(12),
    market_import numeric(16,2),
    percentage numeric(6,3),
    id VARCHAR(60),
    UNIQUE KEY  (`id`)
);


