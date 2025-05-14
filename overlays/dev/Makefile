#MARIADB_OPERATOR_CHART_VERSION := 0.30.0

# Used to pull the most recent version of the Helm chart
helm:
	helm repo add mariadb-operator https://helm.mariadb.com/mariadb-operator
	helm repo update mariadb-operator

get-secrets:
	mkdir -p fts3/etc/secrets
	vault kv get --field=hostcert.pem secret/rubin/usdf-fts3-dev/fts3  > fts3/etc/secrets/hostcert.pem
	vault kv get --field=hostkey.pem secret/rubin/usdf-fts3-dev/fts3  > fts3/etc/secrets/hostkey.pem
	vault kv get --field=fts3db-fts3-password secret/rubin/usdf-fts3-dev/fts3db  > fts3/etc/secrets/fts3db-fts3-password
	vault kv get --field=fts3db-username secret/rubin/usdf-fts3-dev/fts3db  > fts3/etc/secrets/fts3db-username
	vault kv get --field=fts3db-connection-string secret/rubin/usdf-fts3-dev/fts3db  > fts3/etc/secrets/fts3db-connection-string
	vault kv get --field=fts3db-name secret/rubin/usdf-fts3-dev/fts3db  > fts3/etc/secrets/fts3db-name
	mkdir -p mariadb/etc/secrets
	vault kv get --field=fts3db-root-password secret/rubin/usdf-fts3-dev/fts3db  > mariadb/etc/secrets/fts3db-root-password
	vault kv get --field=fts3db-fts3-password secret/rubin/usdf-fts3-dev/fts3db  > mariadb/etc/secrets/fts3db-fts3-password
	vault kv get --field=fts3db-username secret/rubin/usdf-fts3-dev/fts3db  > mariadb/etc/secrets/fts3db-username
	vault kv get --field=fts3db-fts3-password secret/rubin/usdf-fts3-dev/fts3db  > mariadb/etc/secrets/fts3db-fts3-password
	vault kv get --field=fts3db-username secret/rubin/usdf-fts3-dev/fts3db  > mariadb/etc/secrets/fts3db-username
	vault kv get --field=fts3db-connection-string secret/rubin/usdf-fts3-dev/fts3db  > mariadb/etc/secrets/fts3db-connection-string
	vault kv get --field=fts3db-name secret/rubin/usdf-fts3-dev/fts3db  > mariadb/etc/secrets/fts3db-name

#cert-manager:
#	kubectl apply -f https://github.com/cert-manager/cert-manager/releases/download/v1.15.0/cert-manager.yaml
#
## Wait for the cert-manager to be operational before the next target!
## There is no timeout by default on macos! Do this manually for now instead of make apply
#wait-cert-manager:
#	timeout 120

#mariadb-operator:
#	helm template mariadb-operator mariadb-operator/mariadb-operator --version=${MARIADB_OPERATOR_CHART_VERSION} --values=mariadb-operator/values-mariadb-operator.yaml > mariadb-operator/helm-mariadb-operator.yaml

clean-secrets:
	rm -rf fts3/etc/secrets mariadb/etc/secrets

#run-dump: 
#	kubectl kustomize .
#
#dump: get-secrets run-dump clean-secrets

run-apply:  
	kubectl apply -k .

#apply: helm get-secrets cert-manager wait-cert-manager mariadb-operator run-apply clean-secrets
apply: get-secrets run-apply clean-secrets


