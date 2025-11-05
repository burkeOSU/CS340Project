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
        res.render('Megacorporations', { megacorporations: megacorporations });
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
        const query = `SELECT * FROM Breaches`;
        const [breaches] = await db.query(query);
        // Render the breaches.hbs file, and also send the renderer
        res.render('Breaches', { breaches: breaches });
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
        const query = `SELECT * FROM CyberAgents`;
        const [cyberagents] = await db.query(query);
        // Render the cyberagents.hbs file, and also send the renderer
        res.render('CyberAgents', { cyberagents: cyberagents });
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
        res.render('Assets', { assets: assets });
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
        res.render('Locations', { locations: locations });
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