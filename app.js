// ########################################
// ########## SETUP

// Express
const express = require('express');
const app = express();
app.use(express.json());
app.use(express.urlencoded({ extended: true }));
app.use(express.static('public'));

const PORT = 29237;

// Database
const db = require('./database/db-connector');

// Handlebars
const { engine } = require('express-handlebars'); // Import express-handlebars engine
app.engine('.hbs', engine({ extname: '.hbs' })); // Create instance of handlebars
app.set('view engine', '.hbs'); // Use handlebars engine for *.hbs files.

// ########################################
// ########## ROUTE HANDLERS

// READ ROUTES
app.get('/', async function (req, res) {
    try {
        res.render('home'); // Render the home.hbs file
    } catch (error) {
        console.error('Error rendering page:', error);
        // Send a generic error message to the browser
        res.status(500).send('An error occurred while rendering the page.');
    }
});

app.get('/megacorporations', async function (req, res) {
    try {
        const query = `SELECT * FROM Megacorporations`;
        const [megacorporations] = await db.query(query);
        // Render the megacorporations.hbs file, and also send the renderer
        res.render('megacorporations', { megacorporations: megacorporations });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/breaches', async function (req, res) {
    try {
        // join megacorp id and name to breaches entity
        // "B.*" = "* FROM Breaches"
        // CASE = returns YES/NO
        const query1 = `
            SELECT
                B.*,
                CASE
                    WHEN B.ongoing = 1 THEN 'YES'
                    ELSE 'NO'
                END AS ongoing,
                CASE
                    WHEN B.success = 1 THEN 'YES'
                    ELSE 'NO'
                END AS success,
                M.name AS megacorp_name
            FROM Breaches B
            JOIN Megacorporations M ON B.Megacorporations_megacorp_id = M.megacorp_id
            ORDER BY B.date_of_breach DESC;`;
        const query2 = `SELECT megacorp_id, name AS megacorp_name FROM Megacorporations`;
        const [breaches] = await db.query(query1);
        const [megacorporations] = await db.query(query2);
        // Render the breaches.hbs file, and also send the renderer
        res.render('breaches', { breaches: breaches, megacorporations: megacorporations });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/cyberagents', async function (req, res) {
    try {
        // join location id and location name to cyberagents entity
        // "C.*" = "* FROM CyberAgents"
        // CASE = returns YES/NO
        const query1 = `
            SELECT
                C.*,
                CASE
                    WHEN C.hired_by_us = 1 THEN 'YES'
                    ELSE 'NO'
                END AS hired_by_us,
                L.name AS location_name
            FROM CyberAgents C
            JOIN Locations L ON C.Locations_location_id = L.location_id
            ORDER BY C.agent_id ASC;`;
        const query2 = `SELECT location_id, name AS location_name FROM Locations`;
        const [cyberagents] = await db.query(query1);
        const [locations] = await db.query(query2);
        // Render the cyberagents.hbs file, and also send the renderer
        res.render('cyberagents', { cyberagents: cyberagents, locations: locations });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/assets', async function (req, res) {
    try {
        const query = `SELECT * FROM Assets`;
        const [assets] = await db.query(query);
        // Render the assets.hbs file, and also send the renderer
        res.render('assets', { assets: assets });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/locations', async function (req, res) {
    try {
        const query = `SELECT * FROM Locations`;
        const [locations] = await db.query(query);
        // Render the locations.hbs file, and also send the renderer
        res.render('locations', { locations: locations });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/megacorporationshaslocations', async function (req, res) {
    try {
        // join megacorp id, megacorp name, location id and location name together
        const query = `
            SELECT
                MHL.Megacorporations_megacorp_id AS megacorp_id,
                M.name AS megacorporation_name,
                MHL.Locations_location_id AS location_id,
                L.name AS location_name
            FROM MegacorporationsHasLocations MHL
            JOIN Megacorporations M ON M.megacorp_id = MHL.Megacorporations_megacorp_id
            JOIN Locations L ON L.location_id = MHL.Locations_location_id
            ORDER BY MHL.Megacorporations_megacorp_id, MHL.Locations_location_id;`;
        const [megacorporationshaslocations] = await db.query(query);
        // Render the megacorporationshaslocations.hbs file, and also send the renderer
        res.render('megacorporationshaslocations', { megacorporationshaslocations: megacorporationshaslocations });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/breacheshascyberagents', async function (req, res) {
    try {
        // join breach id, date of breach, agent id and agent name together
        const query = `
            SELECT
                BHC.Breaches_breach_id AS breach_id,
                B.date_of_breach,
                BHC.CyberAgents_agent_id AS agent_id,
                C.name AS agent_name
            FROM BreachesHasCyberAgents BHC
            JOIN Breaches B ON B.breach_id = BHC.Breaches_breach_id
            JOIN CyberAgents C ON C.agent_id = BHC.CyberAgents_agent_id
            ORDER BY B.date_of_breach DESC;`;
        const [breacheshascyberagents] = await db.query(query);
        // Render the breacheshascyberagents.hbs file, and also send the renderer
        res.render('breacheshascyberagents', { breacheshascyberagents: breacheshascyberagents });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

app.get('/assetshasbreaches', async function (req, res) {
    try {
        // join asset id, asset name, breach id and date of breach together
        const query = `
            SELECT
                AHB.Assets_asset_id AS asset_id,
                A.name AS asset_name,
                AHB.Breaches_breach_id AS breach_id,
                B.date_of_breach
            FROM AssetsHasBreaches AHB
            JOIN Assets A ON A.asset_id = AHB.Assets_asset_id
            JOIN Breaches B ON B.breach_id = AHB.Breaches_breach_id
            ORDER BY B.date_of_breach DESC;`;
        const [assetshasbreaches] = await db.query(query);
        // Render the assetshasbreaches.hbs file, and also send the renderer
        res.render('assetshasbreaches', { assetshasbreaches: assetshasbreaches });
    } catch (error) {
        console.error('Error executing queries:', error);
        // Send a generic error message to the browser
        res.status(500).send(
            'An error occurred while executing the database queries.'
        );
    }
});

// ########################################
// ########## LISTENER

app.listen(PORT, function () {
    console.log(
        'Express started on http://localhost:' +
            PORT +
            '; press Ctrl-C to terminate.'
    );
});