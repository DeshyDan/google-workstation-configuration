FROM us-central1-docker.pkg.dev/cloud-workstations-images/predefined/code-oss:latest as code-oss-image
FROM us-central1-docker.pkg.dev/cloud-workstations-images/predefined/jetbrains-intellij:latest
FROM us-central1-docker.pkg.dev/cloud-workstations-images/predefined/goland:latest

# Copy Code OSS for Cloud Workstations and startup scripts into our custom image
COPY --from=code-oss-image /opt/code-oss /opt/code-oss
COPY --from=code-oss-image /etc/workstation-startup.d/110_start-code-oss.sh /etc/workstation-startup.d/110_start-code-oss.sh

# Use the existing entrypoint script which will execute all scripts in /etc/workstation-startup.d/
ENTRYPOINT ["/google/scripts/entrypoint.sh"]
