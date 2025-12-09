// # Citation for this file:
//
// # Date: 11/04/2025
// # Based on: Exploration - Web Application Technology
// # Source URL: https://canvas.oregonstate.edu/courses/2017561/pages/exploration-web-application-technology-2?module_item_id=25645131

// Get an instance of mysql we can use in the app
let mysql = require("mysql2");

// Create a 'connection pool' using the provided credentials
const pool = mysql
  .createPool({
    waitForConnections: true,
    connectionLimit: 10,
    host: "classmysql.engr.oregonstate.edu",
    user: "cs340_[your_onid]",
    password: "[your_db_password]",
    database: "cs340_[your_onid]",
  })
  .promise(); // This makes it so we can use async / await rather than callbacks

// Export it for use in our application
module.exports = pool;
