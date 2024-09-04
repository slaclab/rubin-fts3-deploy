# rubin-fts3-deploy
## Deployment framework for Rubin USDF FTS3. 

Once you have access to your Kubernetes cluster, you can deploy FTS3 for a given overlay (found in overlays/[dev,prod]) using the Makefile found there with (most simply)

    make apply

This will use kustomizations to create or update `fts3` and `fts3-db` namespaces and the resources to run an FTS3 application in those namespaces. FTS3 application containers will run in the `fts3` namespace, while the `fts3-db` namespace is used for a MariaDB Kubernetes operator managed MySQL-compliant database.

This framework uses `kustomize` to allow modification of YAML templates at deployment time.
