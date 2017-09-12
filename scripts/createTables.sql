-- Create the table for the raw Gaia Mission data.
CREATE TABLE gaia_source (
    solution_id bigint,
    source_id bigint,
    random_index bigint,
    ref_epoch double precision,
    ra double precision,
    ra_error double precision,
    dec double precision,
    dec_error double precision,
    parallax double precision,
    parallax_error double precision,
    pmra double precision,
    pmra_error double precision,
    pmdec double precision,
    pmdec_error double precision,
    ra_dec_corr double precision,
    ra_parallax_corr double precision,
    ra_pmra_corr double precision,
    ra_pmdec_corr double precision,
    dec_parallax_corr double precision,
    dec_pmra_corr double precision,
    dec_pmdec_corr double precision,
    parallax_pmra_corr double precision,
    parallax_pmdec_corr double precision,
    pmra_pmdec_corr double precision,
    astrometric_n_obs_al double precision,
    astrometric_n_obs_ac double precision,
    astrometric_n_good_obs_al double precision,
    astrometric_n_good_obs_ac double precision,
    astrometric_n_bad_obs_al double precision,
    astrometric_n_bad_obs_ac double precision,
    astrometric_delta_q double precision,
    astrometric_excess_noise double precision,
    astrometric_excess_noise_sig double precision,
    astrometric_primary_flag boolean,
    astrometric_relegation_factor double precision,
    astrometric_weight_al double precision,
    astrometric_weight_ac double precision,
    astrometric_priors_used double precision,
    matched_observations double precision,
    duplicated_source boolean,
    scan_direction_strength_k1 double precision,
    scan_direction_strength_k2 double precision,
    scan_direction_strength_k3 double precision,
    scan_direction_strength_k4 double precision,
    scan_direction_mean_k1 double precision,
    scan_direction_mean_k2 double precision,
    scan_direction_mean_k3 double precision,
    scan_direction_mean_k4 double precision,
    phot_g_n_obs double precision,
    phot_g_mean_flux double precision,
    phot_g_mean_flux_error double precision,
    phot_g_mean_mag double precision,
    phot_variable_flag varchar ,
    l double precision,
    b double precision,
    ecl_lon double precision,
    ecl_lat double precision
)
-- compress the data and make it columnar.
WITH (appendonly=true, compresstype=zlib, compresslevel=5, orientation=column)
DISTRIBUTED RANDOMLY;

-- Build the external web table, which allows us to fetch the data from Azure Blob Storage.
CREATE EXTERNAL WEB TABLE gaia_source_ext (LIKE gaia_source)
-- Execute the doFetch.sh script.
EXECUTE ‘/home/gpadmin/doFetch.sh’ on 16
FORMAT ‘CSV’;

-- Copy the raw data
INSERT INTO gaia_source SELECT * FROM gaia_source_ext;