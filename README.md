# mysql-standalone-server

# Purpose
- Set up a MySQL instance for regular MySQL usage.

# Setup
- Go to deployment/docker/mysql-standalone-server
- Change environment variable PASSWORD to something more secure.
- Run ./docker_run.sh


# Note
- No automatic backup. Needing to set up a periodic backup batch.
- This is a standalone instance and there are no replication servers.
- Suitable for testing and light usage only.