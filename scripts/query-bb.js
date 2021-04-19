#!/usr/bin/env node

const { spawnSync } = require("child_process");

const repo = 'flutter';
const commit = 'b1395592de68cc8ac4522094ae59956dd21a91db';

const request = `
{
  "requests": [
    {
      "searchBuilds": {
        "predicate": {
            "status": "FAILURE",
            "tags": [
                {
                    "key": "buildset",
                    "value": "commit/gitiles/chromium.googlesource.com/external/github.com/flutter/${repo}/+/${commit}"
                }
            ]
        }
      }
    }
  ]
}`.trim();

const child = spawnSync(
  "bb",
  ["batch"],
  {
    "input": request,
  },
);

responseJson = JSON.parse(child.stdout.toString().trim());

const builds = responseJson.responses[0].searchBuilds.builds;
console.log("<ul>");
builds.forEach((build) => {
  console.log("<li>");
  const link = `https://ci.chromium.org/p/flutter/builders/prod/${build.builder.builder.replace(/ /g, "%20")}/${build.number}`;
  console.log(`<a href=${link} target="_blank">${build.builder.builder}</a>`);
  console.log("</li>");
});

console.log("</ul>");
