import "@std/dotenv/load";
import { $ } from "npm:zx";
import dayjs from "npm:dayjs";

const dockerImageName = Deno.env.get("DOCKER_IMAGE_NAME");
const containerId = Deno.env.get("CONTAINER_ID");
const serviceAccountId = Deno.env.get("SERVICE_ACCOUNT_ID");
const image = dockerImageName + ":" + dayjs().format("YYYY-MM-DDTHH-mm-ss");

if (!(containerId && serviceAccountId && dockerImageName)) {
  throw new Error("bad env");
}

await $`docker build --platform=x86_64 -t ${image} .`;
await $`docker push ${image}`;

await $`yc serverless container revision deploy \
          --container-id=${containerId} \
          --service-account-id=${serviceAccountId} \
          --image=${image} \
          --cores 1 \
          --memory 1GB \
          --concurrency 16
`;
