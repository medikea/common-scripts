import { sleep } from "k6";
import http from "k6/http";

// Read configuration from environment variables or use defaults
const targetUsers = parseInt(__ENV.TARGET_USERS) || 10;
const targetUrl = __ENV.TARGET_URL;

// Define the options for the load test
export let options = {
  stages: [
    // Ramp-up phase: gradually increase the number of virtual users (VUs) over 2 minutes
    { duration: "2m", target: targetUsers }, // Ramp up to targetUsers
    // Sustained phase: maintain targetUsers virtual users for 5 minutes
    { duration: "5m", target: targetUsers }, // Stay there
    // Ramp-down phase: gradually decrease the number of virtual users to 0 over 2 minutes
    { duration: "2m", target: 0 }, // Ramp down
  ],
};

// Default function: this is the code that each virtual user will execute repeatedly
export default function () {
  // Make an HTTP GET request to the specified URL
  http.get(targetUrl);
  // Pause for 1 second to simulate a user's "think time" between actions
  sleep(1); // simulate user "think time"
}
