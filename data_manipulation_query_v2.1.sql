----------------------------
--MEGACORPORATIONS:

-- CREATE:
	INSERT INTO Megacorporations (name, industry)
	VALUES (@nameInput, @industryInput)
-- READ:
	SELECT * FROM Megacorporations;
    ORDER BY industry, name;
-- UPDATE:
	SELECT * FROM Megacorporations
	UPDATE Megacorporations
	SET @colname = @nameValInput
	WHERE [condition]
-- DELETE:
	SELECT * FROM Megacorporations
	DELETE FROM Megacorporations
	WHERE name = @nameInput
----------------------------

----------------------------
-- CYBERAGENTS:

-- CREATE:
	INSERT INTO CyberAgents (name, job_title, hired_by_us, Locations_location_id)
	VALUES (@nameInput, @job_titleInput, @hired_by_usInput, @Locations_location_idInput)
-- READ:
	SELECT  CyberAgents.agent_id, 
            CyberAgents.name, 
            CyberAgents.job_title, 
        CASE
            WHEN CyberAgents.hired_by_us = 1 THEN 'Yes'
            ELSE 'No'
        END AS "Hired by Us?", 
        Locations.name AS location
FROM CyberAgents
JOIN Locations ON CyberAgents.Locations_location_id = Locations.location_id;
ORDER BY Locations.name, CyberAgents.job_title, CyberAgents.name;

-- UPDATE:
	SELECT * FROM CyberAgents 
	UPDATE CyberAgents 
	SET @colname = @nameValInput
	WHERE [condition]

-- DELETE:
	SELECT * FROM CyberAgents 
	DELETE FROM CyberAgents
	WHERE name = @nameInput
----------------------------

----------------------------
-- BREACHES:

-- CREATE:
    INSERT INTO Breaches(date_of_breach, ongoing, hack_type, severity_level, success, Megacorporations_megacorp_id)
    VALUES (@date_of_breachInput, @ongoingInput, @hack_typeInput, @severity_levelInput, @successInput, @Megacorporations_megacorp_idInput)
-- READ:
	SELECT  Breaches.breach_id,
            Breaches.date_of_breach,
        CASE
            WHEN Breaches.ongoing = 1 THEN "Ongoing"
            ELSE "Completed"
        END AS "Ongoing?",
        Breaches.hack_type,
        Breaches.severity_level,
        CASE
            WHEN Breaches.success = 1 AND Breaches.ongoing = 0 THEN "succeeded"
            WHEN Breaches.success = 0 AND Breaches.ongoing = 1 THEN "undetermined"
            ELSE "failed"
        END,
        Megacorporations.name AS origin
FROM Breaches
JOIN Megacorporations ON Breaches.Megacorporations_megacorp_id = Megacorporations.megacorp_id;
ORDER BY Megacorporations.name, Breaches.date_of_breach DESC;

-- UPDATE:
	SELECT * FROM Breaches
	UPDATE Breaches
	SET @colname = @nameValInput
	WHERE [condition];
-- DELETE:
	SELECT * FROM Breaches
	DELETE FROM Breaches
	WHERE breach_id = @breach_idInput
----------------------------

----------------------------
-- ASSETS:

-- CREATE:
    INSERT INTO Assets (name, asset_type, status, value)
    VALUES (@nameInput, @asset_typeInput, @statusInput, @valueInput);
-- READ:
	SELECT * FROM Assets
    ORDER BY asset_type, status, name;
-- UPDATE:
	SELECT * FROM Assets
	UPDATE Assets
	SET @colname = @nameValInput
	WHERE [condition];
-- DELETE:
	SELECT * FROM Assets
	DELETE FROM Assets
	WHERE asset_id = @asset_idInput;
----------------------------

----------------------------
-- LOCATIONS:

-- CREATE:
    INSERT INTO Locations (lat, long, name, building_type)
    VALUES (@lat, @long, @name, @building_type)
-- READ:
	SELECT * FROM Locations;
    ORDER BY building_type, name;
-- UPDATE:
	SELECT * FROM Locations
	UPDATE Locations
	SET @colname = @nameValInput
	WHERE [condition];
-- DELETE:
	SELECT * FROM Locations
	DELETE FROM Locations
	WHERE location_id = @location_idInput
----------------------------
