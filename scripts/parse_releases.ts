#!/usr/bin/env -S deno run --allow-net

interface Release {
  hash: string;
  channel: string;
  version: string;
  release_date: string;
  archive: string;
  sha256: string;
}

interface ReleaseManifest {
  base_url: string;
  current_release: Record<string, string>;
  releases: Array<Release>;
}

const json = await fetch(
  "https://storage.googleapis.com/flutter_infra_release/releases/releases_linux.json",
);
const data: ReleaseManifest = await json.json();

let dev: number = 0;
let beta: number = 0;
let stable: number = 0;

for (const release of data.releases) {
  switch (release.channel) {
    case "dev":
      dev++;
      break;
    case "beta":
      beta++;
      break;
    case "stable":
      stable++;
      break;
    default:
      throw JSON.stringify(release);
  }
}

console.log(`${dev}\tdev releases.`);
console.log(`${beta}\tbeta releases.`);
console.log(`${stable}\tstable releases.`);
