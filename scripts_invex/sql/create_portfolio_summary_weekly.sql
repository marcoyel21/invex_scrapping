CREATE TABLE IF NOT EXISTS invexdb.portfolio_summary_weekly (
    asset_key varchar(12), 
    publication_date date,
    rating varchar(12),
    total_portfolio numeric(16,2),
    var_fixed numeric(8,4),
    var_avg numeric(8,4),
    id varchar(60),
    UNIQUE KEY  (`id`)
);


