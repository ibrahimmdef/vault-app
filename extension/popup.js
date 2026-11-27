// Runs every time you click the Vault icon in Chrome's toolbar.
const message = document.getElementById("message");

/** Turns "https://www.github.com/login" into "github.com". */
function siteOf(url) {
  const { protocol, hostname } = new URL(url);
  if (protocol !== "http:" && protocol !== "https:") return null; // chrome://, file:// ...
  return hostname.replace(/^www\./, "");
}

async function showSite() {
  // The tab you are looking at: active, in this window
  const [tab] = await chrome.tabs.query({ active: true, currentWindow: true });
  const site = tab?.url ? siteOf(tab.url) : null;
  message.textContent = site ? `You are on ${site}` : "Open a website to use Vault.";
}

showSite();
