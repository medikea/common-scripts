import { sleep } from "k6";
import http from "k6/http";

// Define the options for the load test
export let options = {
  stages: [
    // Ramp-up phase: gradually increase the number of virtual users (VUs) to 200 over 2 minutes
    { duration: "2m", target: 200 }, // Ramp up to 200 users over 2 minutes
    // Sustained phase: maintain 200 virtual users for 5 minutes to observe behavior under load
    { duration: "5m", target: 200 }, // Stay there
    // Ramp-down phase: gradually decrease the number of virtual users to 0 over 2 minutes
    { duration: "2m", target: 0 }, // Ramp down
  ],
};

// Default function: this is the code that each virtual user will execute repeatedly
export default function () {
  // Make an HTTP GET request to the specified URL
  http.get("https://engine-dev.mmsengine.cloud/api/doctors/specialities");
  // Pause for 1 second to simulate a user's "think time" between actions
  sleep(1); // simulate user "think time"
}
