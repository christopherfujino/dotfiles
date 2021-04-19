#!/usr/bin/env node

const fs = require("fs");

const contents = fs.readFileSync("./releases_linux.json", "utf8");

const releases = JSON.parse(contents);

const perfStart = Date.parse("2020-10-01");

const perfReleases = releases.releases.filter(function(release) {
  const date = Date.parse(release.release_date);
  return (date > perfStart);
});

let dev = 0;
let beta = 0;
let stable = 0;

perfReleases.forEach(function(release) {
  switch(release.channel) {
    case "dev":
      return dev++;
    case "beta":
      return beta++;
    case "stable":
      return stable++;
  }
  throw release.version;
});

console.log(`${dev}\tdev releases.`);
console.log(`${beta}\tbeta releases.`);
console.log(`${stable}\tstable releases.`);
