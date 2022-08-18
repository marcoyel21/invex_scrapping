CREATE TABLE IF NOT EXISTS invexdb.portfolio_summary_monthly (
    asset_key VARCHAR(12), 
    publication_date date,
    rating VARCHAR(12),
    total_portfolio numeric(16,2),
    var_fixed numeric(8,4),
    var_avg numeric(8,4),
    id VARCHAR(60),
    UNIQUE KEY  (`id`)
);


