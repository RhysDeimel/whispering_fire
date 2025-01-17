docker build . -t us-central1-docker.pkg.dev/rhys-test-440700/gcf-artifacts/whispering_fire:latest
docker push us-central1-docker.pkg.dev/rhys-test-440700/gcf-artifacts/whispering_fire:latest

gcloud run deploy hello --image us-central1-docker.pkg.dev/rhys-test-440700/gcf-artifacts/whispering_fire:latest \
  --region us-central1 --project rhys-test-440700