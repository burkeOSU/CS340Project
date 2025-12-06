-- #############################
-- MEGACORPORATIONS
-- #############################

-- #############################
-- CREATE Megacorporation
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateMegacorporation;

DELIMITER //
CREATE PROCEDURE sp_CreateMegacorporation(
    IN m_name VARCHAR(60),
    IN m_industry VARCHAR(60),
    OUT m_id INT)
BEGIN
    INSERT INTO Megacorporations (name, industry) 
    VALUES (m_name, m_industry);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into m_id;
    -- Display the ID of the last inserted megacorp.
    SELECT LAST_INSERT_ID() AS 'new_id';

END //
DELIMITER ;

-- #############################
-- UPDATE Megacorporation
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateMegacorporation;

DELIMITER //
CREATE PROCEDURE sp_UpdateMegacorporation(IN m_id INT, IN m_name VARCHAR(60), IN m_industry VARCHAR(60))

BEGIN
    UPDATE Megacorporations SET name = m_name, industry = m_industry WHERE megacorp_id = m_id; 
END //
DELIMITER ;

-- #############################
-- DELETE Megacorporation
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteMegacorporation;

DELIMITER //
CREATE PROCEDURE sp_DeleteMegacorporation(IN m_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both Megacorporations table and 
        --      intersection table to prevent a data anamoly
        -- This can also be accomplished by using an 'ON DELETE CASCADE' constraint
        --      inside the bsg_cert_people table.
        DELETE FROM MegacorporationsHasLocations WHERE Megacorporations_megacorp_id = m_id;
        DELETE FROM Megacorporations WHERE megacorp_id = m_id;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Megacorporations for id: ', m_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;









-- #############################
-- BREACHES
-- #############################

-- #############################
-- CREATE Breach
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateBreach;

DELIMITER //
CREATE PROCEDURE sp_CreateBreach(
    IN b_date_of_breach DATETIME,
    IN b_ongoing TINYINT(4),
    IN b_hack_type VARCHAR(60),
    IN b_severity_level VARCHAR(60),
    IN b_success TINYINT(4),
    IN b_mcorp_target INT(11),
    OUT b_id INT)
BEGIN
    INSERT INTO Breaches (date_of_breach, ongoing, hack_type, severity_level, success, Megacorporations_megacorp_id) 
    VALUES (b_date_of_breach, b_ongoing, b_hack_type, b_severity_level, b_success, b_mcorp_target);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into b_id;
    -- Display the ID of the last inserted megacorp.
    SELECT LAST_INSERT_ID() AS 'new_id';

END //
DELIMITER ;

-- #############################
-- UPDATE Breach
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateBreach;

DELIMITER //
CREATE PROCEDURE sp_UpdateBreach(   IN b_id INT, 
                                    IN b_date_of_breach DATETIME, 
                                    IN b_ongoing TINYINT(4),
                                    IN b_hack_type VARCHAR(60),
                                    IN b_severity_level VARCHAR(60),
                                    IN b_success TINYINT(4),
                                    IN b_mcorp_target INT(11)
)

BEGIN
    UPDATE Breaches SET date_of_breach = b_date_of_breach,
                        ongoing = b_ongoing,
                        hack_type = b_hack_type,
                        severity_level = b_severity_level,
                        success = b_success,
                        Megacorporations_megacorp_id = b_mcorp_target

                        WHERE breach_id = b_id; 
END //
DELIMITER ;



-- #############################
-- DELETE Breach
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteBreach;

DELIMITER //
CREATE PROCEDURE sp_DeleteBreach(IN b_id INT)
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from Breaches table and 
        --      intersection tables:    BreachesHasCyberagents,
        --                              assetshasbreaches 
        --      to prevent a data anamoly
        -- This can also be accomplished by using an 'ON DELETE CASCADE' constraint
        DELETE FROM BreachesHasCyberAgents WHERE Breaches_breach_id = b_id;
        DELETE FROM AssetsHasBreaches WHERE Breaches_breach_id = b_id;
        DELETE FROM Breaches WHERE breach_id = b_id;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in Breaches for id: ', b_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;



















-- #############################
-- DELETE Cyberagents
-- #############################

DROP PROCEDURE IF EXISTS sp_DeleteCyberAgent;

DELIMITER //
CREATE PROCEDURE sp_DeleteCyberAgent(IN c_id INT)
BEGIN
    DECLARE error_message VARCHAR(255);

 -- error handling

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
                
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from the BreachesHasCyberAgents
        DELETE FROM BreachesHasCyberAgents WHERE CyberAgents_agent_id = c_id;
        -- Delete CyberAgent from main table
        DELETE FROM CyberAgents WHERE agent_id = c_id;

        -- ROW_COUNT() returns the number of rows affected by the last DELETE
        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching record found in CyberAgents for id: ', c_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;









-- #############################
-- CREATE Asset
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateAsset;

DELIMITER //
CREATE PROCEDURE sp_CreateAsset(
    IN a_name VARCHAR(60),
    IN a_asset_type VARCHAR(60),
    IN a_status VARCHAR(60),
    IN a_value DECIMAL(10,2),
    OUT a_id INT)

BEGIN
    INSERT INTO Assets (name, asset_type, status, value) 
    VALUES (a_name, a_asset_type, a_status, a_value);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into a_id;
    -- Display the ID of the last inserted Asset.
    SELECT LAST_INSERT_ID() AS 'new_id';

END //
DELIMITER ;


-- #############################
-- UPDATE Asset
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateAsset;

DELIMITER //
CREATE PROCEDURE sp_UpdateAsset(    IN a_id INT, 
                                    IN a_name VARCHAR(60),
                                    IN a_asset_type VARCHAR(60),
                                    IN a_status VARCHAR(60),
                                    IN a_value DECIMAL(10,2)
)

BEGIN
    UPDATE Assets SET   name = a_name,
                        asset_type = a_asset_type,
                        status = a_status,
                        value = a_value

                        WHERE asset_id = a_id; 
END //
DELIMITER ;

-- #############################
-- DELETE Asset
-- #############################

DROP PROCEDURE IF EXISTS sp_DeleteAsset;

DELIMITER //
CREATE PROCEDURE sp_DeleteAsset(IN a_id INT)
BEGIN
    DECLARE error_message VARCHAR(255);

 -- error handling

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
                
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from the BreachesHasCyberAgents
        DELETE FROM AssetsHasBreaches WHERE Assets_asset_id = a_id;
        -- Delete Asset from main table
        DELETE FROM Assets WHERE asset_id = a_id;

        -- ROW_COUNT() returns the number of rows affected by the last DELETE
        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching record found in Assets for id: ', a_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;



-- #############################
-- CREATE Location
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateLocation;

DELIMITER //
CREATE PROCEDURE sp_CreateLocation(
    IN l_lat DECIMAL(10,8),
    IN l_long DECIMAL(11,8),
    IN l_name VARCHAR(60),
    IN l_building_type VARCHAR(60),

    OUT l_id INT)

BEGIN
    INSERT INTO Locations(lat, `long`, name, building_type) 
    VALUES (l_lat, l_long, l_name, l_building_type);

    -- Store the ID of the last inserted row
    SELECT LAST_INSERT_ID() into l_id;
    -- Display the ID of the last inserted Asset.
    SELECT LAST_INSERT_ID() AS 'new_id';

END //
DELIMITER ;

-- #############################
-- UPDATE Location
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateLocation;

DELIMITER //
CREATE PROCEDURE sp_UpdateLocation( IN l_id INT, 
                                    IN l_lat DECIMAL(10,8),
                                    IN l_long DECIMAL(11,8),
                                    IN l_name VARCHAR(60),
                                    IN l_building_type VARCHAR(60)
)

BEGIN
    UPDATE Locations SET   lat = l_lat,
                        `long` = l_long,
                        name = l_name,
                        building_type = l_building_type

                        WHERE location_id = l_id; 
END //
DELIMITER ;

-- #############################
-- DELETE Location
-- #############################

DROP PROCEDURE IF EXISTS sp_DeleteLocation;

DELIMITER //
CREATE PROCEDURE sp_DeleteLocation(IN l_id INT)
BEGIN
    DECLARE error_message VARCHAR(255);

 -- error handling

    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
                
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from the MegacorporationsHasLocations
        DELETE FROM MegacorporationsHasLocations WHERE Locations_location_id = l_id;
        -- Delete Location from main table
        DELETE FROM Locations WHERE location_id = l_id;

        -- ROW_COUNT() returns the number of rows affected by the last DELETE
        IF ROW_COUNT() = 0 THEN
            SET error_message = CONCAT('No matching record found in Locations for id: ', l_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;


















-- #############################
-- MEGACORPORATIONS HAS LOCATIONS
-- #############################

-- Citation for sp_CreateMegacorporationsHasLocations and sp_UpdateMegacorporationsHasLocations:
-- Date: 11/26/2025
-- Based on sp_CreateMegacorporation, sp_UpdateMegacorporation and sp_DeletMegacorporation

-- #############################
-- CREATE MegacorporationsHasLocations
-- #############################
DROP PROCEDURE IF EXISTS sp_CreateMegacorporationsHasLocations;

DELIMITER //
CREATE PROCEDURE sp_CreateMegacorporationsHasLocations(
    IN m_megacorp_id INT,
    IN l_location_id INT
    )
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;

        IF EXISTS(
            SELECT 1
            FROM    MegacorporationsHasLocations
            WHERE   Megacorporations_megacorp_id = m_megacorp_id
                AND Locations_location_id = l_location_id    
        )   THEN
            SET error_message = CONCAT('This megacorporation/location relationship already exists.');
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

        INSERT INTO MegacorporationsHasLocations (Megacorporations_megacorp_id, Locations_location_id) 
        VALUES (m_megacorp_id, l_location_id);

    COMMIT;

END //
DELIMITER ;

-- #############################
-- UPDATE MegacorporationsHasLocations
-- #############################
DROP PROCEDURE IF EXISTS sp_UpdateMegacorporationsHasLocations;

DELIMITER //
CREATE PROCEDURE sp_UpdateMegacorporationsHasLocations(
    IN old_megacorp_id INT,
    IN old_location_id INT,
    IN new_megacorp_id INT,
    IN new_location_id INT
    )

BEGIN
    UPDATE MegacorporationsHasLocations
    SET
        Megacorporations_megacorp_id = new_megacorp_id,
        Locations_location_id = new_location_id
    WHERE
        Megacorporations_megacorp_id = old_megacorp_id AND Locations_location_id = old_location_id;  
END //
DELIMITER ;

-- #############################
-- DELETE MegacorporationsHasLocations
-- #############################
DROP PROCEDURE IF EXISTS sp_DeleteMegacorporationsHasLocations;

DELIMITER //
CREATE PROCEDURE sp_DeleteMegacorporationsHasLocations(
    IN m_megacorp_id INT,
    IN l_location_id INT
    )
BEGIN
    DECLARE error_message VARCHAR(255); 

    -- error handling
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        -- Roll back the transaction on any error
        ROLLBACK;
        -- Propogate the custom error message to the caller
        RESIGNAL;
    END;

    START TRANSACTION;
        -- Deleting corresponding rows from both Megacorporations table and 
        --      intersection table to prevent a data anamoly
        -- This can also be accomplished by using an 'ON DELETE CASCADE' constraint
        --      inside the bsg_cert_people table.
        DELETE FROM MegacorporationsHasLocations
        WHERE Megacorporations_megacorp_id = m_megacorp_id AND Locations_location_id = l_location_id;

        -- ROW_COUNT() returns the number of rows affected by the preceding statement.
        IF ROW_COUNT() = 0 THEN
            set error_message = CONCAT('No matching record found in MegacorporationsHasLocations for Megacorporation ID: ', m_megacorp_id, ' and Location ID: ', l_location_id);
            -- Trigger custom error, invoke EXIT HANDLER
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = error_message;
        END IF;

    COMMIT;

END //
DELIMITER ;































