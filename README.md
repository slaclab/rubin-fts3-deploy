# rubin-fts3-deploy
## Deployment framework for Rubin USDF FTS3. 

Once you have access to your Kubernetes cluster, you can deploy FTS3 for a given overlay (found in overlays/[dev,prod]) using the Makefile found there with (most simply)

    make apply

This will use kustomizations to create or update `fts3` and `fts3-db` namespaces and the resources to run an FTS3 application in those namespaces. FTS3 application containers will run in the `fts3` namespace, while the `fts3-db` namespace is used for a MariaDB Kubernetes operator managed MySQL-compliant database.

This framework uses `kustomize` to allow modification of YAML templates at deployment time.

## Moving from replicated MariaDB to single MariaDB

1. (optional if only backing up configuration) Seet fts3 servers in Drain Mode (done via rest config ui /config)

2. (optional if only backup up configuration) Scale down fts3 deployments to 0

3. Manually back up the database in the primary database replica (with `mariadb-dump`). Copy the resulting .sql file to a local machine
```
kubectl cp -n <namespace> <fts3-db-pod>:/tmp/backup.sql backup.sql --retries=10
```

4. Deploy a new `MariaDB` custom resource defining a database cluster with one replica to the same namespace

5. Deploy a `Backup` custom resource to this new “cluster”. This creates a `PersistentVolumeClaim` containing the backup

6. Deploy a temporary pod that mounts the `Backup` PVC

7. Copy the mariadb-dump .sql file to this temporary pod and into the mounted PVC. Replace the existing .sql file from the Backup with the manually backed up .sql mariadb-dump

8. Delete the temporary pod

9. Deploy a `Restore` custom resource that points to the new MariaDB cluster and the Backup PVC.

10. Switching the database connection string for fts3 to point to the new MariaDB cluster.

