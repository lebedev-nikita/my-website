import "@std/dotenv/load";
import { $ } from "npm:zx";
import dayjs from "npm:dayjs";
import * as path from "@std/path";

const dockerImageName = Deno.env.get("DOCKER_IMAGE_NAME");
const containerId = Deno.env.get("CONTAINER_ID");
const serviceAccountId = Deno.env.get("SERVICE_ACCOUNT_ID");
const image = dockerImageName + ":" + dayjs().format("YYYY-MM-DDTHH-mm-ss");

if (!(containerId && serviceAccountId && dockerImageName)) {
  throw new Error("bad env");
}

const projectPath = path.fromFileUrl(import.meta.resolve("../"));
const dockerFilePath = path.fromFileUrl(import.meta.resolve("./Dockerfile"));

// Билдим локально, а не в контейнере, иначе вылезает ошибка с @alloc/quick-lru
// в результате всё равно получаются JS-скрипты, так что без разницы, где их билдить
await $`deno task build`;

await $`docker build --platform=x86_64 -f ${dockerFilePath} -t ${image} ${projectPath}`;
await $`docker push ${image}`;

await $`yc serverless container revision deploy \
          --container-id=${containerId} \
          --service-account-id=${serviceAccountId} \
          --image=${image} \
          --cores 1 \
          --memory 128MB \
          --core-fraction 5 \
          --concurrency 16
`;
