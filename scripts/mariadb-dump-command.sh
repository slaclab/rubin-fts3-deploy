#!/bin/bash

# Excluded tables are based off of dev recommendations here: https://fts3-docs.web.cern.ch/fts3-docs/docs/install/backup_policy.html#if-backups-are-disabled

mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD fts3db \
  --ignore-table-data=fts3db.t_job \
  --ignore-table-data=fts3db.t_job_backup \
  --ignore-table-data=fts3db.t_file \
  --ignore-table-data=fts3db.t_file_backup \
  --ignore-table-data=fts3db.t_file_retry_errors \
  --ignore-table-data=fts3db.t_dm \
  --ignore-table-data=fts3db.t_dm_backup \
  --ignore-table-data=fts3db.t_gridmap \
  --ignore-table-data=fts3db.t_hosts \
  --ignore-table-data=fts3db.t_schema_vers \
  --ignore-table-data=fts3db.t_stage_req \
  --ignore-table-data=fts3db.t_token \
  --ignore-table-data=fts3db.t_token_provider \
  --ignore-table-data=fts3db.t_webmon_overview_cache \
  --ignore-table-data=fts3db.t_webmon_overview_cache_control \
  --tables t_server_config t_optimizer t_optimizer_evolution t_config_audit t_se \
  t_link_config t_share_config t_activity_share_config t_bad_ses t_bad_dns t_authz_dn t_cloudStorage \
  t_cloudStorageUser t_oauth2_apps t_oauth2_codes t_oauth2_providers t_oauth2_tokens \
  t_job \
  t_job_backup \
  t_file \
  t_file_backup \
  t_file_retry_errors \
  t_dm \
  t_dm_backup \
  t_gridmap \
  t_hosts \
  t_schema_vers \
  t_stage_req \
  t_token \
  t_token_provider \
  t_webmon_overview_cache \
  t_webmon_overview_cache_control \
  > /tmp/backup.$(date -u +"%Y-%m-%dT%H%M%SZ").sql


# only schema
mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD fts3db \
  --no-data \
  > /tmp/backup.$(date -u +"%Y-%m-%dT%H%M%SZ").schema.sql

# selected table data
mariadb-dump -u root -p$MARIADB_ROOT_PASSWORD fts3db \
  --no-create-info \
  --ignore-table-data=fts3db.t_job \
  --ignore-table-data=fts3db.t_job_backup \
  --ignore-table-data=fts3db.t_file \
  --ignore-table-data=fts3db.t_file_backup \
  --ignore-table-data=fts3db.t_file_retry_errors \
  --ignore-table-data=fts3db.t_dm \
  --ignore-table-data=fts3db.t_dm_backup \
  --ignore-table-data=fts3db.t_gridmap \
  --ignore-table-data=fts3db.t_hosts \
  --ignore-table-data=fts3db.t_stage_req \
  --ignore-table-data=fts3db.t_token \
  --ignore-table-data=fts3db.t_token_provider \
  --ignore-table-data=fts3db.t_webmon_overview_cache \
  --ignore-table-data=fts3db.t_webmon_overview_cache_control \
  --tables t_server_config t_optimizer t_optimizer_evolution t_config_audit t_se \
  t_link_config t_share_config t_activity_share_config t_bad_ses t_bad_dns t_authz_dn t_cloudStorage \
  t_cloudStorageUser t_oauth2_apps t_oauth2_codes t_oauth2_providers t_oauth2_tokens \
  t_schema_vers \
  > /tmp/backup.$(date -u +"%Y-%m-%dT%H%M%SZ").data.sql
